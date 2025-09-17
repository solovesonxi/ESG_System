from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import ManagementData
from core.permissions import get_current_user, require_view
from core.schemas import ManagementSubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/management", tags=["定量数据-环境管理"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(ManagementData).filter(ManagementData.factory == factory, ManagementData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"national_green_factory": data.national_green_factory,
                     "provincial_green_factory": data.provincial_green_factory,
                     "environmental_penalty_intensity": data.environmental_penalty_intensity,
                     "environmental_penalty_amount": data.environmental_penalty_amount,
                     "environmental_violation": data.environmental_violation}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_management_data(data: ManagementSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, ManagementData, data, current_user, "management")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(ManagementData).filter(ManagementData.factory == factory, ManagementData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的环境管理数据")
    return record
