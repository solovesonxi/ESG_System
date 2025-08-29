from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import SatisfactionData
from core.schemas import SatisfactionSubmission

router = APIRouter(prefix="/quantitative/satisfaction", tags=["定量数据-员工满意度"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(SatisfactionData).filter(SatisfactionData.factory == factory, SatisfactionData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: SatisfactionSubmission, db: Session = Depends(get_db)):
    try:
        record = SatisfactionData(factory=data.factory, year=data.year, satisfaction=data.satisfaction,
                                  annual_average=data.annualAverage)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"满意度数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(SatisfactionData).filter(SatisfactionData.factory == factory, SatisfactionData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的员工满意度数据")
    return record
