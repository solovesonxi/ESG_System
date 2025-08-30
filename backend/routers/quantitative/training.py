from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import TrainingData
from core.schemas import TrainingSubmission

router = APIRouter(prefix="/quantitative/training", tags=["定量数据-教育与培训"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(TrainingData).filter(TrainingData.factory == factory, TrainingData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: TrainingSubmission, db: Session = Depends(get_db)):
    try:
        db_record = TrainingData(factory=data.factory, year=data.year, total=data.total, trained=data.trained,
                              male=data.male, female=data.female, mgmt=data.mgmt, middle=data.middle,
                              general=data.general, hours_total=data.hoursTotal, hours_male=data.hoursMale,
                              hours_female=data.hoursFemale, hours_mgmt=data.hoursMgmt, hours_middle=data.hoursMiddle,
                              hours_general=data.hoursGeneral, coverage_rate=data.coverageRate, male_rate=data.maleRate,
                              female_rate=data.femaleRate, mgmt_rate=data.mgmtRate, middle_rate=data.middleRate,
                              general_rate=data.generalRate)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"教育与培训数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(TrainingData).filter(TrainingData.factory == factory, TrainingData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的教育与培训数据")
    return record
