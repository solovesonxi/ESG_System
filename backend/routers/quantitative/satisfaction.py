from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import SatisfactionData
from core.permissions import get_current_user, require_view
from core.schemas import SatisfactionSubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/satisfaction", tags=["定量数据-员工满意度"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(SatisfactionData).filter(SatisfactionData.factory == factory,
                                                 SatisfactionData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"satisfaction": data.satisfaction}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_satisfaction_data(data: SatisfactionSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db,SatisfactionData, data, current_user, "satisfaction")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(SatisfactionData).filter(SatisfactionData.factory == factory,
                                               SatisfactionData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的员工满意度数据")
    return record
