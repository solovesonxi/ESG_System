from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import SupplyData
from core.schemas import SupplySubmission

router = APIRouter(prefix="/quantitative/satisfaction", tags=["定量数据-供应链"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: SupplySubmission, db: Session = Depends(get_db)):
    try:
        record = SupplyData(factory=data.factory, year=data.year, east=data.east, south=data.south, other=data.other,
                            total_suppliers=data.totalSuppliers, env_screened=data.envScreened,
                            soc_screened=data.socScreened, local_amount=data.localAmount, total_amount=data.totalAmount,
                            env_penalty_count=data.envPenaltyCount, env_penalty_amount=data.envPenaltyAmount,
                            cyber_incidents=data.cyberIncidents, env_ratio=data.envRatio, soc_ratio=data.socRatio,
                            local_purchase_ratio=data.localPurchaseRatio)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"供应链数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的供应链数据")
    return record
