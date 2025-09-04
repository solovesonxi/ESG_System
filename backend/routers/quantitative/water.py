from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import WaterData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import WaterSubmission

router = APIRouter(prefix="/quantitative/water", tags=["定量数据-水资源"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        data = db.query(WaterData).filter(WaterData.factory == factory, WaterData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"industrial": data.industrial, "domestic": data.domestic, "reclaimed": data.reclaimed,
                     "total": data.total, "industrialDrainage": data.industrial_drainage,
                     "industrialConsumption": data.industrial_consumption,
                     "industrialRecycled": data.industrial_recycled, "domesticDrainage": data.domestic_drainage,
                     "domesticConsumption": data.domestic_consumption, "domesticRecycled": data.domestic_recycled,
                     "totalRevenue": data.total_revenue, "reclaimedTotal": data.reclaimed_total,
                     "industrialTotal": data.industrial_total, "domesticTotal": data.domestic_total,
                     "totalIntake": data.total_intake, "totalDrainage": data.total_drainage,
                     "totalConsumption": data.total_consumption, "totalRecycled": data.total_recycled,
                     "waterIntensity": data.water_intensity, "waterRecycleRate": data.water_recycle_rate,
                     "reclaimedIntensity": data.reclaimed_intensity}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: WaterSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = WaterData(factory=data.factory, year=data.year, industrial=data.industrial, domestic=data.domestic,
                              reclaimed=data.reclaimed, total=data.total, industrial_total=data.industrialTotal,
                              industrial_drainage=data.industrialDrainage,
                              industrial_consumption=data.industrialConsumption,
                              industrial_recycled=data.industrialRecycled, domestic_total=data.domesticTotal,
                              domestic_drainage=data.domesticDrainage, domestic_consumption=data.domesticConsumption,
                              domestic_recycled=data.domesticRecycled, reclaimed_total=data.reclaimedTotal,
                              total_revenue=data.totalRevenue, reclaimed_intensity=data.reclaimedIntensity,
                              total_intake=data.totalIntake, total_drainage=data.totalDrainage,
                              total_consumption=data.totalConsumption, total_recycled=data.totalRecycled,
                              water_intensity=data.waterIntensity, water_recycle_rate=data.waterRecycleRate)

        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")
    finally:
        db.close()


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(WaterData).filter(WaterData.factory == factory, WaterData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的水资源数据")
    return record
