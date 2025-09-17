from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import ResponsibilityData
from core.permissions import get_current_user, require_view
from core.schemas import ResponsibilitySubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/responsibility", tags=["定量数据-产品责任"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(ResponsibilityData).filter(ResponsibilityData.factory == factory,
                                                          ResponsibilityData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"complaints": data.complaints, "handled": data.handled, "qualityIssues": data.quality_issues,
                     "recalls": data.recalls, "shipments": data.shipments,
                     "customerSatisfaction": data.customer_satisfaction, "cyberIncidents": data.cyber_incidents}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_responsibility_data(data: ResponsibilitySubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, ResponsibilityData, data, current_user, "responsibility")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(ResponsibilityData).filter(ResponsibilityData.factory == factory,
                                                        ResponsibilityData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的产品责任数据")
    return record
