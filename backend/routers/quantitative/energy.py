from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import EnergyData
from core.schemas import EnergySubmission

router = APIRouter(prefix="/quantitative/energy", tags=["定量数据-能源"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(EnergyData).filter(EnergyData.factory == factory, EnergyData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: EnergySubmission, db: Session = Depends(get_db)):
    try:
        db_record = EnergyData(factory=data.factory, year=data.year, purchased_power=data.purchasedPower,
                               renewable_power=data.renewableEnergyPower, gasoline=data.gasoline, diesel=data.diesel,
                               natural_gas=data.naturalGas, other_energy=data.otherEnergy,
                               total_purchased_power=data.totalPurchasedPower,
                               total_renewable_power=data.totalRenewablePower, total_gasoline=data.totalGasoline,
                               total_diesel=data.totalDiesel, total_natural_gas=data.totalNaturalGas,
                               total_other_energy=data.totalOtherEnergy, water_consumption=data.waterConsumption,
                               coal_consumption=data.coalConsumption, power_consumption=data.powerConsumption,
                               gasoline_consumption=data.gasolineConsumption, diesel_consumption=data.dieselConsumption,
                               natural_gas_consumption=data.naturalGasConsumption,
                               total_energy_consumption=data.totalEnergyConsumption, turnover=data.turnover,
                               energy_consumption_intensity=data.energyConsumptionIntensity)
        db.add(db_record)
        db.commit()
        return {"status": "success", "id": db_record.id, "factory": db_record.factory, "year": db_record.year}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EnergyData).filter(EnergyData.factory == factory, EnergyData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的能源数据")
    return record
