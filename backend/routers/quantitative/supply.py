from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import SupplyData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import SupplySubmission

router = APIRouter(prefix="/quantitative/supply", tags=["定量数据-供应链"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        data = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"east": data.east, "south": data.south, "other": data.other, "envScreened": data.env_screened,
                     "socScreened": data.soc_screened, "localAmount": data.local_amount,
                     "totalAmount": data.total_amount, "envPenaltyCount": data.env_penalty_count,
                     "envPenaltyAmount": data.env_penalty_amount, "cyberIncidents": data.cyber_incidents}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: SupplySubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = SupplyData(factory=data.factory, year=data.year, east=data.east, south=data.south, other=data.other,
                               total_suppliers=data.totalSuppliers, env_screened=data.envScreened,
                               soc_screened=data.socScreened, local_amount=data.localAmount,
                               total_amount=data.totalAmount, env_penalty_count=data.envPenaltyCount,
                               env_penalty_amount=data.envPenaltyAmount, cyber_incidents=data.cyberIncidents,
                               env_ratio=data.envRatio, soc_ratio=data.socRatio,
                               local_purchase_ratio=data.localPurchaseRatio)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"供应链数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的供应链数据")
    return record
