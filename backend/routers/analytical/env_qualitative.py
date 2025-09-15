from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.dependencies import indicators
from core.models import EnvQualData
from core.permissions import require_access, require_factory, get_current_user, check_factory_year

router = APIRouter(prefix="/analytical/env_qualitative", tags=["分析数据-环境定性"])


@router.get("")
async def get_data(factory: str, year: int, db: Session = Depends(get_db),
                   current_user: dict = Depends(get_current_user)):
    require_access(factory, current_user)
    current_data = db.query(EnvQualData).filter_by(factory=factory, year=year).first()
    last_year_data = db.query(EnvQualData).filter_by(factory=factory, year=year - 1).first()
    response_data = {}
    for category, items in indicators["env_qual"].items():
        if category not in response_data:
            response_data[category] = {}
        for key in items:
            current_value = getattr(current_data, key, "") if current_data else ""
            last_year_value = getattr(last_year_data, key, "") if last_year_data else ""
            comparison = current_data.comparison.get(key, "") if current_data and current_data.comparison else ""
            reason = current_data.reasons.get(key, "") if current_data and current_data.reasons else ""
            response_data[category][key] = {"lastYear": last_year_value, "currentYear": current_value,
                                            "comparison": comparison, "reason": reason}
    return response_data


@router.post("")
async def save_data(factory: str = Body(..., description="工厂名称"), year: int = Body(..., description="统计年份"),
                    data: Dict[str, Dict[str, Dict[str, str]]] = Body(...),
                    isSubmitted: bool = Body(..., description="是否提交"), db: Session = Depends(get_db),
                    current_user: dict = Depends(get_current_user)):
    try:
        require_factory(factory, current_user)
        check = check_factory_year(factory, year, db, isSubmitted, 1)
        if check["status"] == "fail":
            return check
        indicator_data = {}
        comparisons = {}
        reasons = {}
        for category, items in data.items():
            for indicator, group in items.items():
                indicator_data[indicator] = group.get("currentYear", "")
                comparisons[indicator] = group.get("comparison", "")
                reasons[indicator] = group.get("reason", "")
        check = check_factory_year(factory, year, db, isSubmitted, 1)
        if check["status"] == "fail":
            return  check
        record = EnvQualData(factory=factory, year=year, **indicator_data, comparison=comparisons,
                               reasons=reasons)
        db.merge(record)
        db.commit()
        return {"status": "success", "message": "数据提交成功"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"提交数据失败: {str(e)}")
