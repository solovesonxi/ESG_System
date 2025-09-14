from typing import Any, Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators, logger
from core.models import MaterialData, EnergyData, WaterData, EmissionData, WasteData, InvestmentData, ManagementData
from core.permissions import get_current_user, require_access, require_factory, check_factory_year

router = APIRouter(prefix="/analytical/env_quantitative", tags=["分析数据-环境定量"])


def fix_data(data, field, function: str = "sum"):
    value = getattr(data, field) if data else None
    if isinstance(value, list):
        if function == "avg":
            filtered = [v for v in value if v not in (None, 0)]
            l = len(filtered)
            value = sum(filtered) / l if l > 0 else None
        else:
            value = sum(value)
    if value is not None and isinstance(value, (int, float)):
        value = round(value, 2)
    return value


def fetch_and_process_data(db, model, factory, year, fields, index: list = None):
    current_data = db.query(model).filter(model.factory == factory, model.year == year).first()
    last_year_data = db.query(model).filter(model.factory == factory,
                                            model.year == year - 1).first() if year > 1 else None
    result = {}
    reasons = current_data.reasons if (current_data and current_data.reasons) else []
    for i, field in enumerate(fields):
        function = "avg" if (index and i in index) else "sum"
        current_value = fix_data(current_data, field, function)
        last_value = fix_data(last_year_data, field, function)
        comparison = None if (current_value is None or last_value is None or last_value == 0) else round(
            ((current_value - last_value) / last_value) * 100, 2)
        reason = reasons[i] if i < len(reasons) else ""
        result[field] = {"currentYear": current_value, "lastYear": last_value, "comparison": comparison,
                         "reason": reason}
    return result


@router.get("")
async def get_data(factory: str = Query(..., description="工厂名称"), year: int = Query(..., description="统计年份"),
                   db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)) -> Dict[str, Any]:
    try:
        require_access(factory, current_user)
        result = {}
        envquant_indicators = indicators["env_quant"]
        result["material"] = fetch_and_process_data(db, MaterialData, factory, year, envquant_indicators["material"])
        result["energy"] = fetch_and_process_data(db, EnergyData, factory, year, envquant_indicators["energy"])
        result["water"] = fetch_and_process_data(db, WaterData, factory, year, envquant_indicators["water"])
        result["emission"] = fetch_and_process_data(db, EmissionData, factory, year, envquant_indicators["emission"])
        result["waste"] = fetch_and_process_data(db, WasteData, factory, year, envquant_indicators["waste"])
        result["investment"] = fetch_and_process_data(db, InvestmentData, factory, year,
                                                      envquant_indicators["investment"])
        result["management"] = fetch_and_process_data(db, ManagementData, factory, year,
                                                      envquant_indicators["management"], [0, 1, 2])
        if not any(result.values()):
            raise HTTPException(status_code=404, detail="未找到环境定量数据")
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取数据失败: {str(e)}")


@router.post("")
async def save_reasons(factory: str = Body(..., description="工厂名称"), year: int = Body(..., description="统计年份"),
                       data: Dict[str, Dict[str, str]] = Body(...), isSubmitted: bool = Body(..., description="是否提交"),
                       db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    try:
        require_factory(factory, current_user)
        check = check_factory_year(factory, year, db, isSubmitted, 0)
        if check["status"] == "fail":
            return check
        reason_mapping = {"materialReasons": (MaterialData, data["material"]),
                          "energyReasons": (EnergyData, data["energy"]), "waterReasons": (WaterData, data["water"]),
                          "emissionReasons": (EmissionData, data["emission"]),
                          "wasteReasons": (WasteData, data["waste"]),
                          "investmentReasons": (InvestmentData, data["investment"]),
                          "managementReasons": (ManagementData, data["management"])}
        for model_class, reasons in reason_mapping.values():
            if existing_data := db.query(model_class).filter_by(factory=factory, year=year).first():
                existing_data.reasons = [v for (k, v) in reasons.items()]
                logger.info(f"更新环境定量原因分析: {factory}, {year}, {model_class}, {reasons}")
        db.commit()
        return {"status": "success", "message": "原因分析提交成功"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"提交原因分析失败: {str(e)}")
