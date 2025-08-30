from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import WasteData
from core.schemas import WasteSubmission

router = APIRouter(prefix="/quantitative/waste", tags=["定量数据-废弃物"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(WasteData).filter(WasteData.factory == factory, WasteData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: WasteSubmission, db: Session = Depends(get_db)):
    try:
        db_record = WasteData(factory=data.factory, year=data.year, epe=data.epe, plastic_paper=data.plasticPaper,
                           domestic_industrial=data.domesticIndustrial, hazardous=data.hazardous,
                           wastewater=data.wastewater, epe_total=data.epeTotal,
                           plastic_paper_total=data.plasticPaperTotal,
                           domestic_industrial_total=data.domesticIndustrialTotal, hazardous_total=data.hazardousTotal,
                           wastewater_total=data.wastewaterTotal, non_hazardous_total=data.nonHazardousTotal,
                           recyclable_total=data.recyclableTotal, total_waste=data.totalWaste,
                           disposal_required_total=data.disposalRequiredTotal, recycle_rate=data.recycleRate,
                           total_revenue=data.total_revenue, protective_reuse_rate=data.protectiveReuseRate,
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
