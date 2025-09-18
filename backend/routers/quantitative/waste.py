from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import WasteData
from core.permissions import get_current_user, require_view
from core.schemas import WasteSubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/waste", tags=["定量数据-废弃物"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(WasteData).filter(WasteData.factory == factory, WasteData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"epe": data.epe, "plasticPaper": data.plastic_paper,
                     "domesticIndustrial": data.domestic_industrial, "hazardous": data.hazardous,
                     "wastewater": data.wastewater, "totalRevenue": data.total_revenue,
                     "protectiveReuseRate": data.protective_reuse_rate, "exceedEvents": data.exceed_events}
        return {"status": "success", "data": data_dict,
                "review": {"status": data.review_status, "comment": data.review_comment}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_waste_data(data: WasteSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, WasteData, data, current_user, "waste")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(WasteData).filter(WasteData.factory == factory, WasteData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的废弃物数据")
    return record
