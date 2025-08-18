from datetime import datetime
from typing import List

from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session
from starlette.middleware.cors import CORSMiddleware

from database import get_db, engine
from models import EnergyData, Base, MaterialData

# 创建数据库表
Base.metadata.create_all(bind=engine)

app = FastAPI()
# 添加CORS中间件
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"],
                   allow_headers=["*"], )


# 请求数据模型 - 匹配前端提交结构
class MaterialSubmission(BaseModel):
    factory: str
    year: int
    renewableInput: float
    nonRenewableInput: float
    renewableOutput: float
    nonRenewableOutput: float
    materialConsumption: float
    packagingMaterial: float
    paper: float
    revenue: float
    packagingIntensity: float
    paperIntensity: float
    totalInput: float
    totalOutput: float
    renewableInputRatio: float
    renewableOutputRatio: float


@app.post("/submit/material")
async def submit_material_data(data: MaterialSubmission, db: Session = Depends(get_db)):
    try:
        db_item = MaterialData(factory_name=data.factory, report_year=data.year, renewable_input=data.renewableInput,
                               non_renewable_input=data.nonRenewableInput, total_input=data.totalInput,
                               renewable_output=data.renewableOutput, non_renewable_output=data.nonRenewableOutput,
                               total_output=data.totalOutput, material_consumption=data.materialConsumption,
                               packaging_material=data.packagingMaterial, paper_consumption=data.paper,
                               total_revenue=data.revenue, renewable_input_ratio=data.renewableInputRatio,
                               renewable_output_ratio=data.renewableOutputRatio,
                               packaging_intensity=data.packagingIntensity, paper_intensity=data.paperIntensity)
        db.add(db_item)
        db.commit()
        return {"status": "success", "id": db_item.id}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


class EnergySubmission(BaseModel):
    factory: str
    year: int
    purchasedPower: List[float]  # 12个月外购电量
    renewableEnergyPower: List[float]  # 12个月再生能源电量
    gasoline: List[float]  # 12个月汽油用量
    diesel: List[float]  # 12个月柴油用量
    naturalGas: List[float]  # 12个月天然气用量
    otherEnergy: List[float]  # 12个月其他能源

    # 年度汇总
    totalPurchasedPower: float
    totalRenewablePower: float
    totalGasoline: float
    totalDiesel: float
    totalNaturalGas: float
    totalOtherEnergy: float

    # 能源消耗
    waterConsumption: float
    powerConsumption: float
    gasolineConsumption: float
    dieselConsumption: float
    naturalGasConsumption: float
    totalEnergyConsumption: float
    turnover: float
    energyConsumptionIntensity: float


@app.post("/submit/energy")
async def submit_energy_data(data: EnergySubmission, db: Session = Depends(get_db)):
    try:
        # 创建数据库记录
        db_record = EnergyData(factory=data.factory, year=data.year, purchased_power=data.purchasedPower,
                               renewable_power=data.renewableEnergyPower, gasoline=data.gasoline, diesel=data.diesel,
                               natural_gas=data.naturalGas, other_energy=data.otherEnergy,
                               total_purchased_power=data.totalPurchasedPower,
                               total_renewable_power=data.totalRenewablePower, total_gasoline=data.totalGasoline,
                               total_diesel=data.totalDiesel, total_natural_gas=data.totalNaturalGas,
                               total_other_energy=data.totalOtherEnergy,

                               water_consumption=data.waterConsumption, power_consumption=data.powerConsumption,
                               gasoline_consumption=data.gasolineConsumption, diesel_consumption=data.dieselConsumption,
                               natural_gas_consumption=data.naturalGasConsumption,
                               total_energy_consumption=data.totalEnergyConsumption,

                               turnover=data.turnover, energy_consumption_intensity=data.energyConsumptionIntensity)
        db.add(db_record)
        db.commit()
        return {"status": "success", "id": db_record.id, "factory": db_record.factory, "year": db_record.year}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@app.get("/energy/{factory}/{year}")
async def get_energy_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EnergyData).filter(EnergyData.factory == factory, EnergyData.year == year).first()

    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的能源数据")

    return record


@app.get("/")
async def health_check():
    return {"status": "running", "timestamp": datetime.utcnow(), "service": "ESG Energy API"}
