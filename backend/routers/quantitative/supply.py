from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import SupplyData
from core.permissions import get_current_user
from core.schemas import SupplySubmission
from core.utils import submit_data, get_review_info, require_view

router = APIRouter(prefix="/quantitative/supply", tags=["定量数据-供应链"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, "supply", current_user)
        data = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"east": data.east, "south": data.south, "other": data.other, "envScreened": data.env_screened,
                     "socScreened": data.soc_screened, "localAmount": data.local_amount,
                     "totalAmount": data.total_amount, "envPenaltyCount": data.env_penalty_count,
                     "envPenaltyAmount": data.env_penalty_amount, "cyberIncidents": data.cyber_incidents}
        return {"status": "success", "data": data_dict,
                "review": get_review_info(db, factory, year, "supply")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_supply_data(data: SupplySubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, SupplyData, data, current_user, "supply")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的供应链数据")
    return record
