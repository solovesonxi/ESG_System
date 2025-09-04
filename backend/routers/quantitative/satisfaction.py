from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import SatisfactionData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import SatisfactionSubmission

router = APIRouter(prefix="/quantitative/satisfaction", tags=["定量数据-员工满意度"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        data = db.query(SatisfactionData).filter(SatisfactionData.factory == factory,
                                                 SatisfactionData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: SatisfactionSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = SatisfactionData(factory=data.factory, year=data.year, satisfaction=data.satisfaction,
                                     annual_average=data.annualAverage)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"满意度数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(SatisfactionData).filter(SatisfactionData.factory == factory,
                                               SatisfactionData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的员工满意度数据")
    return record
