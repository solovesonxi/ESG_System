from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import TrainingData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import TrainingSubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/training", tags=["定量数据-教育与培训"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        data = db.query(TrainingData).filter(TrainingData.factory == factory, TrainingData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"total": data.total, "trained": data.trained, "male": data.male, "female": data.female,
                     "mgmt": data.mgmt, "middle": data.middle, "general": data.general, "hoursTotal": data.hours_total,
                     "hoursMale": data.hours_male, "hoursFemale": data.hours_female, "hoursMgmt": data.hours_mgmt,
                     "hoursMiddle": data.hours_middle, "hoursGeneral": data.hours_general}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_training_data(data: TrainingSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, TrainingData, data, current_user, "training")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(TrainingData).filter(TrainingData.factory == factory, TrainingData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的教育与培训数据")
    return record
