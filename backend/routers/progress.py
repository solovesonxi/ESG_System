from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from core.dependencies import indicators, get_db
from core.models import EnvQualData, LaborReason, ReviewRecord, OtherReason, OtherQualitative, Governance, \
    LaborQualitative
from core.models import EnvQuantData
from core.utils import QUANT_MODEL_MAP

router = APIRouter(prefix="/progress", tags=["进度查询"])


@router.get("/quantitative")
def calc_quantitative_progress(factory: str, year: int, db: Session = Depends(get_db)):
    data_dict = {}
    for category, model in QUANT_MODEL_MAP.items():
        data_dict[category] = db.query(model).filter_by(factory=factory, year=year).first()

    def is_json_field(model_cls, field):
        column = getattr(model_cls, field, None)
        return column is not None and hasattr(column, 'type') and 'JSON' in str(column.type)

    def count_json_field_progress(value, is_submitted):
        if not isinstance(value, list):
            return 0, 0
        submitted = 0
        for i, v in enumerate(value):
            if v not in [None, "", 0]:
                submitted += 1
            elif is_submitted and isinstance(is_submitted, list) and i < len(is_submitted) and is_submitted[i]:
                submitted += 1
        return len(value), submitted

    def count_submit_fields(c):
        total, submitted = 0, 0
        submit_fields = indicators[c]["submit"].values()
        data = data_dict.get(c)
        model_cls = QUANT_MODEL_MAP.get(c)
        is_submitted = getattr(data, "is_submitted", None) if data else None
        for field in submit_fields:
            if is_json_field(model_cls, field):
                value = getattr(data, field, []) if data else []
                t, s = count_json_field_progress(value, is_submitted)
                total += t if t else 12
                submitted += s if s else 0
            else:
                value = getattr(data, field, None) if data else None
                total += 1
                if value not in [None, "", 0]:
                    submitted += 1
        return round(submitted / total * 100, 2) if total else 0

    progress = {category: count_submit_fields(category) for category in QUANT_MODEL_MAP.keys()}
    return progress


@router.get("/analytical")
def calc_analytical_progress(factory: str, year: int, db: Session = Depends(get_db)):
    result = {}
    total_fields, total_filled = 0, 0
    analytical_types = ["env_quant", "env_qual", "social_quant_labor", "social_qual_labor", "social_quant_other",
        "social_qual_other", "governance"]
    for idx, data_type in enumerate(analytical_types):
        review_record = db.query(ReviewRecord).filter_by(factory=factory, year=year, data_type=data_type).first()
        if review_record and review_record.is_submitted:
            result[data_type] = 100.00
            continue
        # 未提交，统计填写进度
        if data_type == "env_quant":
            all_fields = [field for category in indicators["env_quant"].values() for field in category]
            total = len(all_fields)
            reasons_rows = db.query(EnvQuantData).filter(EnvQuantData.factory == factory,
                                                         EnvQuantData.year == year).all()
            reasons_map = {row.indicator: row.reason for row in reasons_rows}
            filled = sum(1 for field in all_fields if reasons_map.get(field, "").strip())
            result[data_type] = round(filled / total * 100, 2) if total else 0
            total_fields += total
            total_filled += filled
        elif data_type == "env_qual":
            data = db.query(EnvQualData).filter_by(factory=factory, year=year).first()
            if data:
                exclude = {"factory", "year", "comparison", "reasons"}
                fields = [c.name for c in EnvQualData.__table__.columns.values() if c.name not in exclude]
                total = len(fields) * 3
                filled = sum(1 for f in fields if getattr(data, f, None) not in [None, ""])
                comparison = getattr(data, "comparison", None)
                reasons = getattr(data, "reasons", None)
                if comparison and isinstance(comparison, dict):
                    filled += sum(1 for (_, v) in comparison.items() if v not in [None, ""])
                if reasons and isinstance(reasons, dict):
                    filled += sum(1 for (_, v) in reasons.items() if v not in [None, ""])
                result[data_type] = round(filled / total * 100, 2) if total else 0
                total_fields += total
                total_filled += filled
            else:
                result[data_type] = 0
        elif data_type == "social_quant_labor":
            labor_keys = indicators["social_quant_labor"]
            total = len(labor_keys)
            reasons_rows = db.query(LaborReason).filter(LaborReason.factory == factory, LaborReason.year == year).all()
            reasons_map = {row.indicator: row.reason for row in reasons_rows}
            filled = sum(1 for key in labor_keys if reasons_map.get(key, None) not in (None, ""))
            result[data_type] = round(filled / total * 100, 2) if total else 0
            total_fields += total
            total_filled += filled
        elif data_type == "social_qual_labor":
            all_indicators = []
            for category_indicators in indicators["social_qual_labor"].values():
                all_indicators.extend(category_indicators)
            total = len(all_indicators) * 3
            qualitative_rows = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                                 LaborQualitative.year == year).all()
            filled = 0
            for row in qualitative_rows:
                if row.current_text and row.current_text.strip():
                    filled += 1
                if row.comparison_text and row.comparison_text.strip():
                    filled += 1
                if row.reason and row.reason.strip():
                    filled += 1
            result[data_type] = round(filled / total * 100, 2) if total else 0
            total_fields += total
            total_filled += filled
        elif data_type == "social_quant_other":
            all_fields = [field for category in indicators["social_quant_other"].values() for field in category]
            total = len(all_fields)
            reasons_rows = db.query(OtherReason).filter(OtherReason.factory == factory, OtherReason.year == year).all()
            reasons_map = {row.indicator: row.reason for row in reasons_rows}
            filled = sum(1 for field in all_fields if reasons_map.get(field, "").strip())
            result[data_type] = round(filled / total * 100, 2) if total else 0
            total_fields += total
            total_filled += filled
        elif data_type == "social_qual_other":
            all_indicators = [ind for category in indicators["social_qual_other"].values() for ind in category]
            total = len(all_indicators) * 3
            rows = db.query(OtherQualitative).filter(OtherQualitative.factory == factory,
                                                     OtherQualitative.year == year).all()
            filled = 0
            for row in rows:
                if row.current_text and row.current_text.strip():
                    filled += 1
                if row.comparison_text and row.comparison_text.strip():
                    filled += 1
                if row.reason and row.reason.strip():
                    filled += 1
            result[data_type] = round(filled / total * 100, 2) if total else 0
            total_fields += total
            total_filled += filled
        elif data_type == "governance":
            all_indicators = [ind for category in indicators["governance"].values() for ind in category]
            total = len(all_indicators) * 3
            rows = db.query(Governance).filter(Governance.factory == factory, Governance.year == year).all()
            filled = 0
            for row in rows:
                if row.current_text and row.current_text.strip():
                    filled += 1
                if row.comparison_text and row.comparison_text.strip():
                    filled += 1
                if row.reason and row.reason.strip():
                    filled += 1
            result[data_type] = round(filled / total * 100, 2) if total else 0
            total_fields += total
            total_filled += filled
    result["total"] = round(total_filled / total_fields * 100, 2) if total_fields else 0
    return result
