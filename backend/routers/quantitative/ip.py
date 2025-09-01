from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import IPRData
from core.schemas import IPRSubmission

router = APIRouter(prefix="/api/ipData", tags=["定量数据-知识产权"])

@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(IPRData).filter(IPRData.factory == factory, IPRData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {
            "patents_total": data.patents_total,
            "invention_total": data.invention_total,
            "invention_applications": data.invention_applications,
            "utility_model_total": data.utility_model_total,
            "design_total": data.design_total,
            "authorized_total": data.authorized_total,
            "new_patents_year": data.new_patents_year,
            "software_copyright_total": data.software_copyright_total,
            "trademarks_total": data.trademarks_total
        }
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("")
async def submit_data(data: IPRSubmission, factory: str, year: int, db: Session = Depends(get_db)):
    try:
        db_record = IPRData(
            factory=factory,
            year=year,
            patents_total=data.patents_total,
            invention_total=data.invention_total,
            invention_applications=data.invention_applications,
            utility_model_total=data.utility_model_total,
            design_total=data.design_total,
            authorized_total=data.authorized_total,
            new_patents_year=data.new_patents_year,
            software_copyright_total=data.software_copyright_total,
            trademarks_total=data.trademarks_total
        )
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")

@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(IPRData).filter(IPRData.factory == factory, IPRData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的知识产权数据")
    return record
