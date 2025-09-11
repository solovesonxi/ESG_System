from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import ProductResponsibilityData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import ProductResponsibilitySubmission

router = APIRouter(prefix="/quantitative/responsibility", tags=["定量数据-产品责任"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        data = db.query(ProductResponsibilityData).filter(ProductResponsibilityData.factory == factory,
                                                          ProductResponsibilityData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"complaints": data.complaints, "handled": data.handled, "qualityIssues": data.quality_issues,
                     "recalls": data.recalls, "shipments": data.shipments,
                     "customerSatisfaction": data.customer_satisfaction, "cyberIncidents": data.cyber_incidents}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: ProductResponsibilitySubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = ProductResponsibilityData(factory=data.factory, year=data.year, complaints=data.complaints,
                                              handled=data.handled, quality_issues=data.qualityIssues,
                                              recalls=data.recalls, shipments=data.shipments,
                                              customer_satisfaction=data.customerSatisfaction,
                                              cyber_incidents=data.cyberIncidents,
                                              complaints_total=data.complaintsTotal, handled_total=data.handledTotal,
                                              handled_rate=data.handledRate,
                                              customer_satisfaction_average=data.customerSatisfactionAverage,
                                              recall_total=data.recallsTotal, recall_rate=data.recallRate,
                                              quality_issues_total=data.qualityIssuesTotal,
                                              cyber_incidents_total=data.cyberIncidentsTotal)
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
