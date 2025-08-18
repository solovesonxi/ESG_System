from datetime import datetime

from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from starlette.middleware.cors import CORSMiddleware

from schemas import MaterialSubmission, EnergySubmission, WaterSubmission, EmissionSubmission
from database import get_db, engine
from models import EnergyData, Base, MaterialData, WaterData, EmissionData

# 创建数据库表
Base.metadata.create_all(bind=engine)

app = FastAPI()
# 添加CORS中间件
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"],
                   allow_headers=["*"], )


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


@app.post("/submit/energy")
async def submit_energy_data(data: EnergySubmission, db: Session = Depends(get_db)):
    try:
        db_record = EnergyData(factory=data.factory, year=data.year, purchased_power=data.purchasedPower,
                               renewable_power=data.renewableEnergyPower, gasoline=data.gasoline, diesel=data.diesel,
                               natural_gas=data.naturalGas, other_energy=data.otherEnergy,
                               total_purchased_power=data.totalPurchasedPower,
                               total_renewable_power=data.totalRenewablePower, total_gasoline=data.totalGasoline,
                               total_diesel=data.totalDiesel, total_natural_gas=data.totalNaturalGas,
                               total_other_energy=data.totalOtherEnergy, water_consumption=data.waterConsumption,
                               power_consumption=data.powerConsumption, gasoline_consumption=data.gasolineConsumption,
                               diesel_consumption=data.dieselConsumption,
                               natural_gas_consumption=data.naturalGasConsumption,
                               total_energy_consumption=data.totalEnergyConsumption, turnover=data.turnover,
                               energy_consumption_intensity=data.energyConsumptionIntensity)
        db.add(db_record)
        db.commit()
        return {"status": "success", "id": db_record.id, "factory": db_record.factory, "year": db_record.year}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@app.get("/energy/{factory}/{year}")
async def get_energy_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EnergyData).filter(EnergyData.factory == factory, EnergyData.year == year).first()
    if not record: raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的能源数据")
    return record


@app.post("/submit/water")
async def submit_water_data(data: WaterSubmission, db: Session = Depends(get_db)):
    try:
        db_data = WaterData(factory=data.factory, year=data.year, industrial=data.industrial, domestic=data.domestic,
                            reclaimed=data.reclaimed, total=data.total, industrial_total=data.industrialTotal,
                            industrial_drainage=data.industrialDrainage,
                            industrial_consumption=data.industrialConsumption,
                            industrial_recycled=data.industrialRecycled, domestic_total=data.domesticTotal,
                            domestic_drainage=data.domesticDrainage, domestic_consumption=data.domesticConsumption,
                            domestic_recycled=data.domesticRecycled, reclaimed_total=data.reclaimedTotal,
                            total_revenue=data.totalRevenue, reclaimed_intensity=data.reclaimedIntensity,
                            total_intake=data.totalIntake, total_drainage=data.totalDrainage,
                            total_consumption=data.totalConsumption, total_recycled=data.totalRecycled,
                            water_intensity=data.waterIntensity, water_recycle_rate=data.waterRecycleRate)

        db.add(db_data)
        db.commit()
        return {"status": "success", "id": db_data.id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")
    finally:
        db.close()


@app.post("/submit/emission")
def submit_emission_data(data: EmissionSubmission, db: Session = Depends(get_db)):
    try:
        # 创建数据库记录
        db_data = EmissionData(factory=data.factory, year=data.year, category_one=data.categoryOne,
                               category_two=data.categoryTwo, category_three=data.categoryThree,
                               category_four=data.categoryFour, category_five=data.categoryFive,
                               category_six=data.categorySix, revenue=data.revenue,
                               category_three_total=data.categoryThreeTotal, total_emission=data.totalEmission,
                               emission_intensity=data.emissionIntensity, voc=data.voc, nmhc=data.nmhc,
                               benzene=data.benzene, particulate=data.particulate,
                               custom_emissions=[item.model_dump() for item in data.customEmissions],
                               waste_gas_total=data.wasteGasTotal)
        db.add(db_data)
        db.commit()
        return {"status": "success", "id": db_data.id}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@app.get("/")
async def health_check():
    return {"status": "running", "timestamp": datetime.now(), "service": "ESG Energy API"}
