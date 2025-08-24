from datetime import datetime

from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from starlette.middleware.cors import CORSMiddleware

from database import get_db, engine
from models import EnergyData, Base, MaterialData, WaterData, EmissionData, EmploymentData, TrainingData, \
    SatisfactionData, SupplyData, WasteData, InvestmentData, OHSData
from schemas import MaterialSubmission, EnergySubmission, WaterSubmission, EmissionSubmission, EmploymentSubmission, \
    TrainingSubmission, SatisfactionSubmission, SupplySubmission, WasteSubmission, InvestmentSubmission, OHSSubmission

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


@app.post("/submit/supply")
async def submit_supply_data(data: SupplySubmission, db: Session = Depends(get_db)):
    try:
        # 创建数据库记录
        record = SupplyData(factory=data.factory, year=data.year, east=data.east, south=data.south, other=data.other,
            total_suppliers=data.totalSuppliers, env_screened=data.envScreened, soc_screened=data.socScreened,
            local_amount=data.localAmount, total_amount=data.totalAmount, env_penalty_count=data.envPenaltyCount,
            env_penalty_amount=data.envPenaltyAmount, cyber_incidents=data.cyberIncidents, env_ratio=data.envRatio,
            soc_ratio=data.socRatio, local_purchase_ratio=data.localPurchaseRatio)

        db.add(record)
        db.commit()

        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"供应链数据提交失败: {str(e)}")


@app.post("/submit/satisfaction")
async def submit_satisfaction_data(data: SatisfactionSubmission, db: Session = Depends(get_db)):
    try:
        # 创建数据库记录
        record = SatisfactionData(factory=data.factory, year=data.year, satisfaction=data.satisfaction,
            annual_average=data.annualAverage)

        db.add(record)
        db.commit()

        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"满意度数据提交失败: {str(e)}")


@app.post("/submit/training")
async def submit_training_data(data: TrainingSubmission, db: Session = Depends(get_db)):
    try:
        record = TrainingData(factory=data.factory, year=data.year, total=data.total, trained=data.trained,
                              male=data.male, female=data.female, mgmt=data.mgmt, middle=data.middle,
                              general=data.general, hours_total=data.hoursTotal, hours_male=data.hoursMale,
                              hours_female=data.hoursFemale, hours_mgmt=data.hoursMgmt, hours_middle=data.hoursMiddle,
                              hours_general=data.hoursGeneral, coverage_rate=data.coverageRate, male_rate=data.maleRate,
                              female_rate=data.femaleRate, mgmt_rate=data.mgmtRate, middle_rate=data.middleRate,
                              general_rate=data.generalRate)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"教育与培训数据提交失败: {str(e)}")


@app.post("/submit/ohs")
async def submit_ohs_data(data: OHSSubmission, db: Session = Depends(get_db)):
    try:
        # 创建记录（前端camelCase→后端snake_case）
        record = OHSData(factory=data.factory, year=data.year, training_count=data.trainingCount,
                         training_participants=data.trainingParticipants, training_hours=data.trainingHours,
                         injury_count=data.injuryCount, incident_count=data.incidentCount,
                         fatality_count=data.fatalityCount, lost_workdays=data.lostWorkdays,
                         safety_investment=data.safetyInvestment, training_count_total=data.trainingCountTotal,
                         training_participants_total=data.trainingParticipantsTotal,
                         training_hours_total=data.trainingHoursTotal, injury_count_total=data.injuryCountTotal,
                         incident_count_total=data.incidentCountTotal, fatality_count_total=data.fatalityCountTotal,
                         lost_workdays_total=data.lostWorkdaysTotal, safety_investment_total=data.safetyInvestmentTotal,
                         safety_managers=data.safetyManagers, medical_checks=data.medicalChecks,
                         coverage_rate=data.coverageRate, emergency_drills=data.emergencyDrills,
                         hazards_found=data.hazardsFound, occupational_checks=data.occupationalChecks)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@app.post("/submit/waste")
async def submit_waste_data(data: WasteSubmission, db: Session = Depends(get_db)):
    try:
        # 创建数据库记录（字段名映射）
        record = WasteData(factory=data.factory, year=data.year, epe=data.epe, plastic_paper=data.plasticPaper,
                           domestic_industrial=data.domesticIndustrial, hazardous=data.hazardous,
                           wastewater=data.wastewater, epe_total=data.epeTotal,
                           plastic_paper_total=data.plasticPaperTotal,
                           domestic_industrial_total=data.domesticIndustrialTotal, hazardous_total=data.hazardousTotal,
                           wastewater_total=data.wastewaterTotal, non_hazardous_total=data.nonHazardousTotal,
                           recyclable_total=data.recyclableTotal, total_waste=data.totalWaste,
                           disposal_required_total=data.disposalRequiredTotal, recycle_rate=data.recycleRate,
                           revenue=data.revenue, protective_reuse_rate=data.protectiveReuseRate,
                           exceed_events=data.exceedEvents, hazardous_intensity=data.hazardousIntensity,
                           wastewater_intensity=data.wastewaterIntensity)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"废弃物数据提交失败: {str(e)}")


@app.post("/submit/investment")
async def submit_investment_data(data: InvestmentSubmission, db: Session = Depends(get_db)):
    try:
        # 创建数据库记录（字段名映射）
        record = InvestmentData(factory=data.factory, year=data.year, env_invest=data.envInvest,
                                clean_tech_invest=data.cleanTechInvest, climate_invest=data.climateInvest,
                                green_income=data.greenIncome, env_invest_total=data.envInvestTotal,
                                clean_tech_invest_total=data.cleanTechInvestTotal,
                                climate_invest_total=data.climateInvestTotal, green_income_total=data.greenIncomeTotal,
                                total_investment=data.totalInvestment, green_income_ratio=data.greenIncomeRatio)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"资金投入数据提交失败: {str(e)}")


@app.post("/submit/employment")
async def submit_employment_data(data: EmploymentSubmission, db: Session = Depends(get_db)):
    try:
        record = EmploymentData(factory=data.factory, year=data.year, full_time=data.fullTime, part_time=data.partTime,
                                male=data.male, female=data.female, management=data.management,
                                management_female=data.managementFemale, middle=data.middle, general=data.general,
                                mainland=data.mainland, overseas=data.overseas, edu_phd=data.eduPhd,
                                edu_master=data.eduMaster, edu_bachelor=data.eduBachelor, edu_junior=data.eduJunior,
                                avg_social_fund=data.avgSocialFund, inc_social_fund=data.incSocialFund,
                                age18_30=data.age18_30, age31_45=data.age31_45, age46_60=data.age46_60,
                                new_hires=data.newHires, quit_male=data.quitMale, quit_female=data.quitFemale,
                                quit_mainland=data.quitMainland, quit_overseas=data.quitOverseas,
                                quit18_30=data.quit18_30, quit31_45=data.quit31_45, quit46_60=data.quit46_60,
                                quit_management=data.quitManagement, quit_middle=data.quitMiddle,
                                quit_general=data.quitGeneral, total_employees=data.totalEmployees,
                                quit_total=data.quitTotal, turnover_rate=data.turnoverRate,
                                male_turnover_rate=data.maleTurnoverRate, female_turnover_rate=data.femaleTurnoverRate,
                                mainland_turnover_rate=data.mainlandTurnoverRate,
                                overseas_turnover_rate=data.overseasTurnoverRate,
                                age18_30_turnover_rate=data.age18_30TurnoverRate,
                                age31_45_turnover_rate=data.age31_45TurnoverRate,
                                age46_60_turnover_rate=data.age46_60TurnoverRate,
                                management_turnover_rate=data.managementTurnoverRate,
                                middle_turnover_rate=data.middleTurnoverRate,
                                general_turnover_rate=data.generalTurnoverRate)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"雇佣数据提交失败: {str(e)}")


@app.get("/")
async def health_check():
    return {"status": "running", "timestamp": datetime.now(), "service": "ESG Energy API"}
