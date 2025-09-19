from typing import Any, Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators
from core.models import EnvQuantData, MaterialData, EnergyData, WaterData, EmissionData, WasteData, InvestmentData, \
    ManagementData
from core.permissions import get_current_user
from core.utils import send_yearly_message, _calc_comparison, get_review_info, check_review_record, require_view, require_edit

router = APIRouter(prefix="/analytical/env_quantitative", tags=["分析数据-环境定量"])


def get_field_value(data, field, function: str = "sum"):
    if data is None:
        return None
    value = getattr(data, field, None)
    if value is None:
        return None
    if isinstance(value, list):
        if function == "avg":
            filtered = [v for v in value if v not in (None, 0)]
            return round(sum(filtered) / len(filtered), 2) if filtered else None
        else:
            return round(sum(value), 2)
    elif isinstance(value, (int, float)):
        return round(value, 2)
    return value


def process_category_data(db, factory, year, category, fields, model_class, reasons_map, index_list=None):
    current_data = db.query(model_class).filter_by(factory=factory, year=year).first()
    last_year_data = db.query(model_class).filter_by(factory=factory, year=year - 1).first() if year > 1 else None
    result = {}
    for i, field in enumerate(fields):
        function = "avg" if (index_list and i in index_list) else "sum"
        current_value = get_field_value(current_data, field, function)
        last_value = get_field_value(last_year_data, field, function)
        result[field] = {"currentYear": current_value, "lastYear": last_value,
            "comparison": _calc_comparison(current_value, last_value), "reason": reasons_map.get(field, "")}
    return result


@router.get("")
async def get_data(factory: str = Query(..., description="工厂名称"), year: int = Query(..., description="统计年份"),
                   db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)) -> Dict[str, Any]:
    try:
        require_view(factory, "env_quant", current_user)
        reasons_rows = db.query(EnvQuantData).filter_by(factory=factory, year=year).all()
        reasons_map = {row.indicator: row.reason for row in reasons_rows}
        envquant_indicators = indicators["env_quant"]
        result = {}
        result["material"] = process_category_data(db, factory, year, "material", envquant_indicators["material"],
            MaterialData, reasons_map)
        result["energy"] = process_category_data(db, factory, year, "energy", envquant_indicators["energy"], EnergyData,
            reasons_map)
        result["water"] = process_category_data(db, factory, year, "water", envquant_indicators["water"], WaterData,
            reasons_map)
        result["emission"] = process_category_data(db, factory, year, "emission", envquant_indicators["emission"],
            EmissionData, reasons_map)
        result["waste"] = process_category_data(db, factory, year, "waste", envquant_indicators["waste"], WasteData,
            reasons_map)
        result["investment"] = process_category_data(db, factory, year, "investment", envquant_indicators["investment"],
            InvestmentData, reasons_map)
        result["management"] = process_category_data(db, factory, year, "management", envquant_indicators["management"],
            ManagementData, reasons_map, [0, 1, 2])
        return {"data": result,
                "review": get_review_info(db, factory, year, "env_quant")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取环境定量数据失败: {str(e)}")


@router.post("")
async def save_reasons(factory: str = Body(..., description="工厂名称"), year: int = Body(..., description="统计年份"),
                       reasons: Dict[str, str] = Body(...), isSubmitted: bool = Body(..., description="是否提交"),
                       db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    try:
        require_edit(factory, "env_quant", current_user)
        check = check_review_record(db, factory, year, "env_quant", isSubmitted)
        if check["status"] == "fail":
            return check
        for indicator, reason in reasons.items():
            existing = db.query(EnvQuantData).filter_by(factory=factory, year=year, indicator=indicator).first()
            if existing:
                existing.reason = reason
            else:
                db.add(EnvQuantData(factory=factory, year=year, indicator=indicator, reason=reason))
        db.commit()
        send_yearly_message(db, current_user, factory, year, isSubmitted, "env_quant")
        return {"status": "success", "message": "环境定量数据原因分析已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存环境定量数据原因失败: {str(e)}")
