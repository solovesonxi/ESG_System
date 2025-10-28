from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from core.dependencies import get_db, logger
from core.dynamic_mapping import get_quant_map, get_analy_map
from core.models import ReviewRecord, FieldData, Category
from core.permission import get_current_user

router = APIRouter(prefix="/progress", tags=["进度查询"])


@router.get("/month")
def calc_quantitative_progress(factory: str, year: int, db: Session = Depends(get_db),
                               current_user: dict = Depends(get_current_user)):
    def is_json_field(model_cls, f):
        column = getattr(model_cls, f, None)
        return column is not None and hasattr(column, 'type') and 'JSON' in str(column.type)

    def count_json_field_progress(v, months):
        valid = 0
        if isinstance(v, list):
            for month in months:
                if v[month] not in [None, "", 0]:
                    valid += 1
        return valid

    progress = []
    total_fields, total_filled = 0, 0
    quant_map = get_quant_map(db)
    if current_user.get("role", None) == "department":
        quant_map = {k: v for k, v in quant_map.items() if k in current_user.get("departments", {}).get("ids", [])}
    for category_id, model in quant_map.items():
        title_row = db.query(Category.name_zh).filter_by(id=category_id).first()
        title = title_row.name_zh if title_row else ""

        fields = db.query(FieldData.name_en).filter_by(category=category_id, is_active=True).all()
        months_rows = db.query(ReviewRecord.month).filter_by(category=category_id, factory=factory, year=year,
                                                             is_submitted=True).all()
        total, filled = len(fields) * 12, 0
        row = db.query(model).filter_by(factory=factory, year=year).first()
        if row:
            submitted_months = set()
            for r in months_rows:
                submitted_months.add(int(r.month))
            for field in fields:
                field_name = getattr(field, 'name_en', field if isinstance(field, str) else None)
                if field_name is None:
                    try:
                        field_name = field[0]
                    except ValueError:
                        continue
                if is_json_field(model, field_name):
                    value = getattr(row, field_name, []) if row else []
                    if value:
                        filled += len(submitted_months) + count_json_field_progress(value, [i for i in range(12) if
                                                                                      (i + 1) not in submitted_months])
        total_fields += total
        total_filled += filled
        progress.append({"title": title, "percent": round(filled / total * 100, 2) if total else 0})
    progress.append({"title": "总计", "percent": round(total_filled / total_fields * 100, 2) if total_fields else 0})
    logger.info("计算工厂 {} 年度 {} 月度数据填写进度：{}".format(factory, year, progress))
    return progress


@router.get("/year")
def calc_analytical_progress(factory: str, year: int, db: Session = Depends(get_db)):
    def count_field(r, f, cnt):
        value = getattr(r, f, None)
        if value and isinstance(value, str) and value.strip():
            return cnt + 1
        return cnt

    progress = []
    total_fields, total_filled = 0, 0
    analytical_map = get_analy_map(db)
    for category_id, model in analytical_map.items():
        category = db.query(Category).filter_by(id=category_id).first()
        rows = db.query(model).filter_by(factory=factory, year=year).all()
        review_record = db.query(ReviewRecord).filter_by(factory=factory, year=year, category=category_id).first()
        if review_record and getattr(review_record, 'is_submitted', False):
            progress.append({"title": category.domain + category.name_zh, "percent": 100.00})
            continue
        # 未提交，统计填写进度
        fields = db.query(FieldData.name_en).filter_by(category=category_id, is_active=True).all()
        active_fields = set()
        for field in fields:
            field_name = getattr(field, 'name_en', field if isinstance(field, str) else None)
            if field_name is None:
                try:
                    field_name = field[0]
                except ValueError:
                    continue
            active_fields.add(field_name)
        total = len(fields) * 3
        filled = 0
        cname = category.name_zh
        if category and "定量" in cname:
            for row in rows:
                if getattr(row, "indicator", None) in active_fields:
                    filled = count_field(row, "reason", filled)
            title = category.domain + cname if category else cname
            progress.append({"title": title, "percent": round(filled / total * 100, 2) if total else 0})
        else:
            for row in rows:
                if getattr(row, "indicator", None) in active_fields:
                    filled = count_field(row, "current_text", filled)
                    filled = count_field(row, "comparison_text", filled)
                    filled = count_field(row, "reason", filled)
            title = category.domain + cname if category else cname
            progress.append({"title": title, "percent": round(filled / total * 100, 2) if total else 0})
        total_fields += total
        total_filled += filled
    progress.append({"title": "总计", "percent": round(total_filled / total_fields * 100, 2) if total_fields else 0})
    logger.info("计算工厂 {} 年度 {} 年度数据填写进度：{}".format(factory, year, progress))
    return progress
