from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import ProductResponsibilityData
from core.schemas import ProductResponsibilitySubmission

router = APIRouter(prefix="/quantitative/responsibility", tags=["定量数据-产品责任"])

@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(ProductResponsibilityData).filter(ProductResponsibilityData.factory == factory, 
                                                         ProductResponsibilityData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {
            "complaints_total": data.complaints_total,
            "complaints_handled": data.complaints_handled,
            "complaints_handle_rate": data.complaints_handle_rate,
            "customer_satisfaction": data.customer_satisfaction,
            "recall_count": data.recall_count,
            "recall_percent": data.recall_percent,
            "product_quality_issues": data.product_quality_issues,
            "cyber_incidents": data.cyber_incidents
        }
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("")
async def submit_data(data: ProductResponsibilitySubmission, db: Session = Depends(get_db)):
    try:
        db_record = ProductResponsibilityData(
            factory=data.factory,
            year=data.year,
            complaints_total=data.complaints_total,
            complaints_handled=data.complaints_handled,
            complaints_handle_rate=data.complaints_handle_rate,
            customer_satisfaction=data.customer_satisfaction,
            recall_count=data.recall_count,
            recall_percent=data.recall_percent,
            product_quality_issues=data.product_quality_issues,
            cyber_incidents=data.cyber_incidents
        )
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")

@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(ProductResponsibilityData).filter(ProductResponsibilityData.factory == factory, 
                                                       ProductResponsibilityData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的产品责任数据")
    return record
