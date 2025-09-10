from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import WasteData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import WasteSubmission

router = APIRouter(prefix="/quantitative/waste", tags=["定量数据-废弃物"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        data = db.query(WasteData).filter(WasteData.factory == factory, WasteData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"epe": data.epe, "plasticPaper": data.plastic_paper,
                     "domesticIndustrial": data.domestic_industrial, "hazardous": data.hazardous,
                     "wastewater": data.wastewater, "totalRevenue": data.total_revenue,
                     "protectiveReuseRate": data.protective_reuse_rate, "exceedEvents": data.exceed_events}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: WasteSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = WasteData(factory=data.factory, year=data.year, epe=data.epe, plastic_paper=data.plasticPaper,
                              domestic_industrial=data.domesticIndustrial, hazardous=data.hazardous,
                              wastewater=data.wastewater, non_hazardous_total=data.nonHazardousTotal,
                              recyclable_total=data.recyclableTotal, total_waste=data.totalWaste,
                              disposal_required_total=data.disposalRequiredTotal, recycle_rate=data.recycleRate,
                              total_revenue=data.totalRevenue, protective_reuse_rate=data.protectiveReuseRate,
                              exceed_events=data.exceedEvents, hazardous_intensity=data.hazardousIntensity,
                              wastewater_intensity=data.wastewaterIntensity)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"废弃物数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(WasteData).filter(WasteData.factory == factory, WasteData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的废弃物数据")
    return record
