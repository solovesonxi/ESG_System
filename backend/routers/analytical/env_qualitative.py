from fastapi import APIRouter, Depends, HTTPException, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.dependencies import indicators
from core.models import EnvQualData
from core.permissions import require_access, require_factory, get_current_user
from core.schemas import EnvQualDataRequest

router = APIRouter(prefix="/analytical/env_qualitative", tags=["分析数据-环境定性"])


@router.get("")
async def get_data(factory: str, year: int, db: Session = Depends(get_db),
                   current_user: dict = Depends(get_current_user)):
    require_access(factory, current_user)
    current_data = db.query(EnvQualData).filter_by(factory=factory, year=year).first()
    last_year_data = db.query(EnvQualData).filter_by(factory=factory, year=year - 1).first()
    response_data = {}
    for key in indicators["env_qual"]:
        current_value = getattr(current_data, key, "") if current_data else ""
        last_year_value = getattr(last_year_data, key, "") if last_year_data else ""
        comparison = current_data.comparison.get(key, "") if current_data and current_data.comparison else ""
        reason = current_data.reasons.get(key, "") if current_data and current_data.reasons else ""
        response_data[key] = {"lastYear": last_year_value, "currentYear": current_value, "comparison": comparison,
                              "reason": reason}
    return response_data


@router.post("")
async def save_data(request: EnvQualDataRequest = Body(...), db: Session = Depends(get_db),
                    current_user: dict = Depends(get_current_user)):
    try:
        require_factory(request.factory, current_user)
        existing_data = db.query(EnvQualData).filter_by(factory=request.factory, year=request.year).first()
        comparisons = {}
        reasons = {}
        indicator_data = {}
        for indicator_key, data in request.envQualData.items():
            indicator_data[indicator_key] = data.currentYear
            comparisons[indicator_key] = data.comparison
            reasons[indicator_key] = data.reason
        if existing_data:
            for key, value in indicator_data.items():
                setattr(existing_data, key, value)
            existing_data.comparison = comparisons
            existing_data.reasons = reasons
        else:
            new_data = EnvQualData(factory=request.factory, year=request.year, **indicator_data, comparison=comparisons,
                                   reasons=reasons)
            db.add(new_data)

        db.commit()
        return {"status": "success", "message": "数据提交成功"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"提交数据失败: {str(e)}")
