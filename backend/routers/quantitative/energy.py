from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import EnergyData
from core.permissions import get_current_user, require_view
from core.schemas import EnergySubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/energy", tags=["定量数据-能源"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(EnergyData).filter(EnergyData.factory == factory, EnergyData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"purchased_power": data.purchased_power, "renewable_power": data.renewable_power,
                     "gasoline": data.gasoline, "diesel": data.diesel, "natural_gas": data.natural_gas,
                     "other_energy": data.other_energy, "water": data.water, "coal": data.coal,
                     "turnover": data.turnover}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_energy_data(data: EnergySubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, EnergyData, data, current_user, "energy")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EnergyData).filter(EnergyData.factory == factory, EnergyData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的能源数据")
    return record
