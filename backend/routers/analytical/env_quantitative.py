from typing import Any, List, Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators
from core.models import MaterialData, EnergyData, WaterData, EmissionData, WasteData, InvestmentData, ManagementData
from core.permissions import get_current_user, require_access, require_factory

router = APIRouter(prefix="/analytical/env_quantitative", tags=["分析数据-环境定量"])


def fetch_and_process_data(db, model, factory, year, fields):
    current_data = db.query(model).filter(model.factory == factory, model.year == year).first()
    last_year_data = db.query(model).filter(model.factory == factory,
                                            model.year == year - 1).first() if year > 1 else None
    result = {}
    reasons = current_data.reasons if (current_data and current_data.reasons) else []
    for i, field in enumerate(fields):
        current_value = getattr(current_data, field) if current_data else None
        last_value = getattr(last_year_data, field) if last_year_data else None
        if isinstance(current_value, list): current_value = sum(current_value)
        if isinstance(last_value, list): last_value = sum(last_value)
        if current_value is not None and isinstance(current_value, (int, float)):
            current_value = round(current_value, 2)
        if last_value is not None and isinstance(last_value, (int, float)):
            last_value = round(last_value, 2)
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
                                                      envquant_indicators["management"])
        if not any(result.values()):
            raise HTTPException(status_code=404, detail="未找到环境定量数据")
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取数据失败: {str(e)}")


@router.post("")
async def save_reasons(factory: str = Body(..., description="工厂名称"), year: int = Body(..., description="统计年份"),
                       reasonsMap: Dict[str, Dict[str, str]] = Body(...), db: Session = Depends(get_db),
                       current_user: dict = Depends(get_current_user)):
    try:
        require_factory(factory, current_user)
        reason_mapping = {"materialReasons": (MaterialData, reasonsMap["material"]),
                          "energyReasons": (EnergyData, reasonsMap["energy"]), "waterReasons": (WaterData, reasonsMap["water"]),
                          "emissionReasons": (EmissionData, reasonsMap["emission"]), "wasteReasons": (WasteData, reasonsMap["waste"]),
                          "investmentReasons": (InvestmentData, reasonsMap["investment"]),
                          "managementReasons": (ManagementData, reasonsMap["management"])}
        for model_class, reasons in reason_mapping.values():
            if data := db.query(model_class).filter_by(factory=factory, year=year).first():
                data.reasons = [v for (k,v) in reasons.items()]
        db.commit()
        return {"status": "success", "message": "原因分析提交成功"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"提交原因分析失败: {str(e)}")
