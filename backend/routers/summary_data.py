from collections import defaultdict

from fastapi import APIRouter
from fastapi import Depends, HTTPException
from sqlalchemy import and_
from sqlalchemy.orm import Session

from core.calculations import compute_field_value
from core.dependencies import get_db, logger
from core.models import FieldData
from core.permission import get_current_user
from core.utils import get_model, calc_comparison

router = APIRouter(prefix="/summary", tags=["汇总数据"])


@router.get("")
def fetch_data(category_id: int, year: int, db: Session = Depends(get_db),
               current_user: dict = Depends(get_current_user)):
    role = current_user.get("role")
    if role in ["headquarter", "admin"]:
        pass
    else:
        raise HTTPException(status_code=403, detail="无权访问该页面")
    category, model = get_model(category_id, db)
    fields = db.query(FieldData).filter_by(category=category_id, is_active=True).order_by(FieldData.set,
                                                                                          FieldData.id).all()
    grouped = defaultdict(list)
    for f in fields:
        grouped[f.set].append(f)
    result_sets = []
    is_quantitative = '定量' in str(category.name_zh)
    ordered_set_names = sorted(grouped.keys(), key=lambda s: min(f.id for f in grouped[s]))
    for set_name in ordered_set_names:
        field_objs = grouped[set_name]
        fields_out = []
        for fo in field_objs:
            name_en = fo.name_en
            if is_quantitative:
                # 定量指标：为所有工厂计算今年、去年、增长率（按工厂返回数组）
                current_row = db.query(model).filter_by(factory="所有工厂", year=year, indicator=name_en).first()
                if fo.calculation:
                    current_value = compute_field_value(fo.calculation, db, "", year)
                    last_value = compute_field_value(fo.calculation, db, "", year - 1)
                else:  # 没有计算公式，直接查数据库
                    current_value = getattr(current_row, 'value', None) if current_row else None
                    last_row = db.query(model).filter_by(factory="所有工厂", year=year - 1, indicator=name_en).first()
                    last_value = getattr(last_row, 'value', None) if last_row else None
                comparison = calc_comparison(current_value, last_value)
                reason = getattr(current_row, 'reason', '') if current_row else ''
                fields_out.append({"name_en": fo.name_en, "name_zh": fo.name_zh, "calculation": fo.calculation or None,
                                   "unit": fo.unit, "description": fo.description, "source": fo.source,
                                   "lastYear": last_value if last_value else None,
                                   "currentYear": current_value if current_value else None, "comparison": comparison,
                                   "reason": reason, })
            else:
                # 定性指标：为所有工厂返回本年和去年结果（按工厂返回数组）
                qual_row = db.query(model).filter_by(factory="所有工厂", year=year, indicator=name_en).first()
                last_row = db.query(model).filter_by(factory="所有工厂", year=year - 1, indicator=name_en).first()
                fields_out.append(
                    {"name_en": fo.name_en, "name_zh": fo.name_zh, "description": fo.description, "source": fo.source,
                     "lastYear": getattr(last_row, 'current_text', None) if last_row else None,
                     "currentYear": getattr(qual_row, 'current_text', None) if qual_row else None,
                     "comparison": getattr(qual_row, 'comparison_text', None) if qual_row else None,
                     "reason": getattr(qual_row, 'reason', None) if qual_row else None, })
        if fields_out:
            result_sets.append({"set": set_name, "fields": fields_out})
    return {"is_quant": is_quantitative, "sets": result_sets}


@router.post("")
def submit_data(payload: dict, db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    category_id = payload.get("category_id")
    factory = "所有工厂"
    year = payload.get("year")
    sets = payload.get("sets", [])
    category_model, model = get_model(category_id, db)
    category = getattr(category_model, "name_en", None)
    is_quantitative = '定量' in str(category_model.name_zh)
    logger.info(f"提交总部{year}年的{category}数据")
    # 1. 权限检查
    if current_user["role"] not in ["headquarter", "admin"]:
        raise HTTPException(status_code=403, detail="无权提交汇总数据")

    # 2. 解析提交的数据并更新数据库
    model_cols = {name for (name,) in db.query(FieldData.name_en).filter_by(category=category_id, is_active=True).all()}
    values = []
    for s in sets:
        for f in s.get("fields", []):
            key = f.get("name_en")
            if key in model_cols:
                if is_quantitative:
                    values.append({"factory": factory, "year": year, "indicator": key, "value": f.get("currentYear"),
                                   "reason": f.get("reason")})
                else:
                    values.append(
                        {"factory": factory, "year": year, "indicator": key, "current_text": f.get("currentYear"),
                         "comparison_text": f.get("comparison"), "reason": f.get("reason")})
    for v in values:
        existing = db.query(model).filter(and_(getattr(model, "factory") == factory, getattr(model, "year") == year,
                                               getattr(model, "indicator") == v.get("indicator", ""))).first()
        if existing is not None:
            if is_quantitative:
                setattr(existing, 'value', v.get('value'))
            else:
                setattr(existing, 'current_text', v.get('current_text'))
                setattr(existing, 'comparison_text', v.get('comparison_text'))
            setattr(existing, 'reason', v.get('reason'))
            db.merge(existing)
        else:
            existing = model(**v)
            db.add(existing)
    db.commit()
    return {"status": "success"}
