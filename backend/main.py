import logging
from datetime import datetime
from typing import Dict, Any, List

from fastapi import FastAPI, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session
from starlette.middleware.cors import CORSMiddleware

from database import get_db, engine
from models import EnergyData, Base, MaterialData, WaterData, EmissionData, EmploymentData, TrainingData, \
    SatisfactionData, SupplyData, WasteData, InvestmentData, OHSData, LaborReason, \
    ProductResponsibilityData, IPRData, CommunityData, VolunteerData, OtherReason, LaborQualitative, OtherQualitative
from schemas import MaterialSubmission, EnergySubmission, WaterSubmission, EmissionSubmission, EmploymentSubmission, \
    TrainingSubmission, SatisfactionSubmission, SupplySubmission, WasteSubmission, InvestmentSubmission, OHSSubmission

# 配置日志
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)  # 设置日志级别为DEBUG

# 创建一个控制台处理器
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)

# 定义日志格式
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
console_handler.setFormatter(formatter)

# 添加处理器到logger
logger.addHandler(console_handler)

# 创建数据库表
Base.metadata.create_all(bind=engine)

app = FastAPI()
# 添加CORS中间件
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"],
                   allow_headers=["*"], )


@app.post("/submit/material")
async def submit_material_data(data: MaterialSubmission, db: Session = Depends(get_db)):
    try:
        db_item = MaterialData(factory=data.factory, year=data.year, renewable_input=data.renewableInput,
                               non_renewable_input=data.nonRenewableInput, renewable_output=data.renewableOutput,
                               non_renewable_output=data.nonRenewableOutput,
                               material_consumption=data.materialConsumption, wood_fiber=data.woodFiber,
                               aluminum=data.aluminum, revenue=data.revenue, packaging_material=data.packagingMaterial,
                               paper_consumption=data.paper, packaging_intensity=data.packagingIntensity,
                               paper_intensity=data.paperIntensity, total_input=data.totalInput,
                               total_output=data.totalOutput, renewable_input_ratio=data.renewableInputRatio,
                               renewable_output_ratio=data.renewableOutputRatio, reasons=[""] * 15)
        db.add(db_item)
        db.commit()
        return {"status": "success", "id": db_item.id}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))



def fetch_and_process_data(db, model, factory, year, fields):
    current_data = db.query(model).filter(model.factory == factory, model.year == year).first()
    last_year_data = db.query(model).filter(model.factory == factory, model.year == year - 1).first() if year > 1 else None
    result = {}
    if current_data:
        data_reasons = current_data.reasons or []
        for i, field in enumerate(fields):
            current_value = getattr(current_data, field)
            last_value = getattr(last_year_data, field) if last_year_data else None
            comparison= None if (last_value is None or last_value == 0) else round(((current_value - last_value) / last_value) * 100, 2)
            reason = data_reasons[i] if i < len(data_reasons) else ""
            result[field] = {"currentYear": current_value, "lastYear": last_value,
                "comparison": comparison, "reason": reason}
    return result

@app.get("/api/envquant")
async def get_envquant_data(factory: str = Query(..., description="工厂名称"),
        year: int = Query(..., description="统计年份"), db: Session = Depends(get_db)) -> Dict[str, Any]:
    try:
        result = {"material": {}, "energy": {}}
        material_fields = ["renewable_input", "non_renewable_input", "renewable_output", "non_renewable_output",
            "material_consumption", "wood_fiber", "aluminum", "packaging_material", "paper_consumption",
            "packaging_intensity", "paper_intensity", "total_input", "total_output", "renewable_input_ratio",
            "renewable_output_ratio"]
        energy_fields = ["total_purchased_power", "total_renewable_power", "coal_consumption", "total_gasoline",
            "total_diesel", "total_natural_gas", "total_other_energy", "total_energy_consumption",
            "energy_consumption_intensity"]
        result["material"] = fetch_and_process_data(db, MaterialData, factory, year, material_fields)
        result["energy"] = fetch_and_process_data(db, EnergyData, factory, year, energy_fields)
        # 检查是否有数据
        if not result["material"] and not result["energy"]:
            raise HTTPException(status_code=404, detail="未找到环境定量数据")
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取数据失败: {str(e)}")


@app.post("/api/envquant/reasons")
async def save_reasons(factory: str = Body(..., description="工厂名称"), year: int = Body(..., description="统计年份"),
        materialReasons: List[str] = Body(..., description="物料原因分析列表"),
        energyReasons: List[str] = Body(..., description="能源原因分析列表"), db: Session = Depends(get_db)):
    try:
        material_data = db.query(MaterialData).filter(MaterialData.factory == factory,
                                                      MaterialData.year == year).first()
        if material_data:
            material_data.reasons = materialReasons
        energy_data = db.query(EnergyData).filter(EnergyData.factory == factory, EnergyData.year == year).first()
        if energy_data:
            energy_data.reasons = energyReasons
        db.commit()
        return {"status": "success", "message": "原因分析提交成功"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"提交原因分析失败: {str(e)}")


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
                               coal_consumption=data.coalConsumption, power_consumption=data.powerConsumption,
                               gasoline_consumption=data.gasolineConsumption, diesel_consumption=data.dieselConsumption,
                               natural_gas_consumption=data.naturalGasConsumption,
                               total_energy_consumption=data.totalEnergyConsumption, turnover=data.turnover,
                               energy_consumption_intensity=data.energyConsumptionIntensity, reasons=[""] * 9)
        db.add(db_record)
        db.commit()
        return {"status": "success", "id": db_record.id, "factory": db_record.factory, "year": db_record.year}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


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


@app.post("/submit/waste")
async def submit_waste_data(data: WasteSubmission, db: Session = Depends(get_db)):
    try:
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


@app.post("/submit/satisfaction")
async def submit_satisfaction_data(data: SatisfactionSubmission, db: Session = Depends(get_db)):
    try:
        record = SatisfactionData(factory=data.factory, year=data.year, satisfaction=data.satisfaction,
                                  annual_average=data.annualAverage)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"满意度数据提交失败: {str(e)}")


@app.post("/submit/supply")
async def submit_supply_data(data: SupplySubmission, db: Session = Depends(get_db)):
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


@app.get("/")
async def health_check():
    return {"status": "running", "timestamp": datetime.now(), "service": "ESG Energy API"}

@app.get("/api/material")
async def get_material_data(factory: str = Query(..., description="工厂名称"),
                            year: int = Query(..., description="统计年份"), db: Session = Depends(get_db)) -> Dict[
    str, Any]:
    try:
        current_year_data = db.query(MaterialData).filter(MaterialData.factory == factory,
                                                          MaterialData.year == year).first()
        if not current_year_data:
            raise HTTPException(status_code=404, detail="未找到当前年物料数据")
        last_year_data = db.query(MaterialData).filter(MaterialData.factory == factory,
                                                       MaterialData.year == year - 1).first()
        indicators = ["renewable_input", "non_renewable_input", "renewable_output", "non_renewable_output",
                      "material_consumption", "wood_fiber", "aluminum", "packaging_material", "paper_consumption",
                      "packaging_intensity", "paper_intensity", "total_input", "total_output", "renewable_input_ratio",
                      "renewable_output_ratio"]
        reasons = current_year_data.reasons if current_year_data.reasons else [""] * len(indicators)
        result = {}
        for idx, indicator in enumerate(indicators):
            current_value = getattr(current_year_data, indicator, None)
            last_value = getattr(last_year_data, indicator, None) if last_year_data else None
            comparison = None
            if last_value is not None and last_value != 0:
                try:
                    comparison = ((current_value - last_value) / last_value) * 100
                    comparison = round(comparison, 2)
                except (TypeError, ZeroDivisionError):
                    comparison = None
            reason = reasons[idx] if idx < len(reasons) else ""
            result[indicator] = {"currentYear": current_value, "lastYear": last_value, "comparison": comparison,
                "reason": reason}
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取物料数据失败: {str(e)}")


@app.post("/api/material/reasons")
async def save_material_reasons(factory: str = Body(...), year: int = Body(...), reasons: Dict[str, str] = Body(...),
        db: Session = Depends(get_db)):
    try:
        indicators = ["renewable_input", "non_renewable_input", "renewable_output", "non_renewable_output",
                      "material_consumption", "wood_fiber", "aluminum", "packaging_material", "paper_consumption",
                      "packaging_intensity", "paper_intensity", "total_input", "total_output", "renewable_input_ratio",
                      "renewable_output_ratio"]
        reasons_list = []
        for indicator in indicators:
            reasons_list.append(reasons.get(indicator, ""))
        material_data = db.query(MaterialData).filter(MaterialData.factory == factory,
                                                      MaterialData.year == year).first()
        if material_data:
            material_data.reasons = reasons_list
            db.commit()
            return {"status": "success", "message": "原因说明已保存"}
        else:
            raise HTTPException(status_code=404, detail="未找到对应的物料数据")

    except Exception as e:
        db.rollback()
        logger.error(f"保存原因说明失败: {str(e)}")
        raise HTTPException(status_code=500, detail=f"保存原因说明失败: {str(e)}")
    
@app.get("/energy/{factory}/{year}")
async def get_energy_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EnergyData).filter(EnergyData.factory == factory, EnergyData.year == year).first()
    if not record: raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的能源数据")
    return record

@app.get("/employment/{factory}/{year}")
async def get_employment(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EmploymentData).filter(EmploymentData.factory == factory, EmploymentData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的雇佣数据")
    return record


@app.get("/training/{factory}/{year}")
async def get_training(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(TrainingData).filter(TrainingData.factory == factory, TrainingData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的培训数据")
    return record


@app.get("/ohs/{factory}/{year}")
async def get_ohs(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的职业健康安全数据")
    return record


@app.get("/satisfaction/{factory}/{year}")
async def get_satisfaction(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(SatisfactionData).filter(SatisfactionData.factory == factory, SatisfactionData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的满意度数据")
    return record


def _calc_comparison(current_value, last_value):
    try:
        if last_value is None or last_value == 0 or current_value is None:
            return None
        value = ((current_value - last_value) / last_value) * 100
        return round(value, 2)
    except Exception:
        return None


@app.get("/api/labor")
async def get_labor_overview(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db)):
    try:
        # 当前年与去年数据
        emp_cur = db.query(EmploymentData).filter(EmploymentData.factory == factory, EmploymentData.year == year).first()
        emp_prev = db.query(EmploymentData).filter(EmploymentData.factory == factory, EmploymentData.year == year - 1).first()

        trn_cur = db.query(TrainingData).filter(TrainingData.factory == factory, TrainingData.year == year).first()
        trn_prev = db.query(TrainingData).filter(TrainingData.factory == factory, TrainingData.year == year - 1).first()

        ohs_cur = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year).first()
        ohs_prev = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year - 1).first()

        sat_cur = db.query(SatisfactionData).filter(SatisfactionData.factory == factory, SatisfactionData.year == year).first()
        sat_prev = db.query(SatisfactionData).filter(SatisfactionData.factory == factory, SatisfactionData.year == year - 1).first()

        # 读取原因
        reasons_rows = db.query(LaborReason).filter(LaborReason.factory == factory, LaborReason.year == year).all()
        reasons_map = {row.indicator: row.reason for row in reasons_rows}

        def entry(indicator_key, cur, prev):
            return {
                "currentYear": cur,
                "lastYear": prev,
                "comparison": _calc_comparison(cur, prev),
                "reason": reasons_map.get(indicator_key, "")
            }

        data = {
            "雇佣": {},
            "教育和培训": {},
            "职业健康与安全": {},
            "员工满意度": {}
        }

        # 雇佣
        if emp_cur or emp_prev:
            def gv(obj, attr):
                return getattr(obj, attr) if obj is not None else None

            total_employees_cur = gv(emp_cur, 'total_employees')
            total_employees_prev = gv(emp_prev, 'total_employees')
            data["雇佣"]["employment_total_employees"] = entry("employment_total_employees", total_employees_cur, total_employees_prev)

            data["雇佣"]["employment_full_time"] = entry("employment_full_time", gv(emp_cur, 'full_time'), gv(emp_prev, 'full_time'))
            data["雇佣"]["employment_part_time"] = entry("employment_part_time", gv(emp_cur, 'part_time'), gv(emp_prev, 'part_time'))

            data["雇佣"]["employment_gender_male"] = entry("employment_gender_male", gv(emp_cur, 'male'), gv(emp_prev, 'male'))
            data["雇佣"]["employment_gender_female"] = entry("employment_gender_female", gv(emp_cur, 'female'), gv(emp_prev, 'female'))

            data["雇佣"]["employment_category_management"] = entry("employment_category_management", gv(emp_cur, 'management'), gv(emp_prev, 'management'))
            data["雇佣"]["employment_category_middle"] = entry("employment_category_middle", gv(emp_cur, 'middle'), gv(emp_prev, 'middle'))
            data["雇佣"]["employment_category_general"] = entry("employment_category_general", gv(emp_cur, 'general'), gv(emp_prev, 'general'))

            # 管理层女性占比
            mgmt_female_rate_cur = None
            mgmt_female_rate_prev = None
            try:
                if gv(emp_cur, 'management') and gv(emp_cur, 'management') != 0:
                    mgmt_female_rate_cur = round((gv(emp_cur, 'management_female') or 0) / gv(emp_cur, 'management') * 100, 2)
                if gv(emp_prev, 'management') and gv(emp_prev, 'management') != 0:
                    mgmt_female_rate_prev = round((gv(emp_prev, 'management_female') or 0) / gv(emp_prev, 'management') * 100, 2)
            except Exception:
                pass
            data["雇佣"]["employment_mgmt_female_rate"] = entry("employment_mgmt_female_rate", mgmt_female_rate_cur, mgmt_female_rate_prev)

            # 地区
            data["雇佣"]["employment_region_mainland"] = entry("employment_region_mainland", gv(emp_cur, 'mainland'), gv(emp_prev, 'mainland'))
            data["雇佣"]["employment_region_overseas"] = entry("employment_region_overseas", gv(emp_cur, 'overseas'), gv(emp_prev, 'overseas'))

            # 年龄组
            for key in ['age18_30', 'age31_45', 'age46_60']:
                data["雇佣"][f"employment_{key}"] = entry(f"employment_{key}", gv(emp_cur, key), gv(emp_prev, key))

            # 离职、新进
            data["雇佣"]["employment_quit_total"] = entry("employment_quit_total", gv(emp_cur, 'quit_total'), gv(emp_prev, 'quit_total'))
            data["雇佣"]["employment_new_hires"] = entry("employment_new_hires", gv(emp_cur, 'new_hires'), gv(emp_prev, 'new_hires'))

            # 五险一金
            data["雇佣"]["employment_avg_social_fund"] = entry("employment_avg_social_fund", gv(emp_cur, 'avg_social_fund'), gv(emp_prev, 'avg_social_fund'))
            data["雇佣"]["employment_inc_social_fund"] = entry("employment_inc_social_fund", gv(emp_cur, 'inc_social_fund'), gv(emp_prev, 'inc_social_fund'))

            # 学历结构
            for key in ['edu_phd', 'edu_master', 'edu_bachelor', 'edu_junior']:
                data["雇佣"][f"employment_{key}"] = entry(f"employment_{key}", gv(emp_cur, key), gv(emp_prev, key))

            # 流失率总体与分组
            rate_keys = [
                'turnover_rate', 'male_turnover_rate', 'female_turnover_rate',
                'mainland_turnover_rate', 'overseas_turnover_rate',
                'age18_30_turnover_rate', 'age31_45_turnover_rate', 'age46_60_turnover_rate',
                'management_turnover_rate', 'middle_turnover_rate', 'general_turnover_rate'
            ]
            for key in rate_keys:
                data["雇佣"][f"employment_{key}"] = entry(f"employment_{key}", gv(emp_cur, key), gv(emp_prev, key))

        # 教育与培训
        if trn_cur or trn_prev:
            def tv(obj, attr):
                return getattr(obj, attr) if obj is not None else None

            data["教育和培训"]["training_total"] = entry("training_total", tv(trn_cur, 'total'), tv(trn_prev, 'total'))
            data["教育和培训"]["training_coverage_rate"] = entry("training_coverage_rate", tv(trn_cur, 'coverage_rate'), tv(trn_prev, 'coverage_rate'))

            for key in ['male', 'female', 'mgmt', 'middle', 'general']:
                data["教育和培训"][f"training_{key}"] = entry(f"training_{key}", tv(trn_cur, key), tv(trn_prev, key))

            for key in ['male_rate', 'female_rate', 'mgmt_rate', 'middle_rate', 'general_rate']:
                data["教育和培训"][f"training_{key}"] = entry(f"training_{key}", tv(trn_cur, key), tv(trn_prev, key))

            # 学时总量与人均
            hours_total_cur = tv(trn_cur, 'hours_total')
            hours_total_prev = tv(trn_prev, 'hours_total')
            data["教育和培训"]["training_hours_total"] = entry("training_hours_total", hours_total_cur, hours_total_prev)

            avg_hours_cur = None
            avg_hours_prev = None
            try:
                if tv(trn_cur, 'trained') and tv(trn_cur, 'trained') != 0:
                    avg_hours_cur = round((tv(trn_cur, 'hours_total') or 0) / tv(trn_cur, 'trained'), 2)
                if tv(trn_prev, 'trained') and tv(trn_prev, 'trained') != 0:
                    avg_hours_prev = round((tv(trn_prev, 'hours_total') or 0) / tv(trn_prev, 'trained'), 2)
            except Exception:
                pass
            data["教育和培训"]["training_avg_hours_per_person"] = entry("training_avg_hours_per_person", avg_hours_cur, avg_hours_prev)

            # 按性别/层级平均受训时数
            def safe_div(n, d):
                try:
                    if n is None or d in (None, 0):
                        return None
                    return round(n / d, 2)
                except Exception:
                    return None
            data["教育和培训"]["training_avg_hours_male"] = entry(
                "training_avg_hours_male",
                safe_div(tv(trn_cur, 'hours_male'), tv(trn_cur, 'male')),
                safe_div(tv(trn_prev, 'hours_male'), tv(trn_prev, 'male'))
            )
            data["教育和培训"]["training_avg_hours_female"] = entry(
                "training_avg_hours_female",
                safe_div(tv(trn_cur, 'hours_female'), tv(trn_cur, 'female')),
                safe_div(tv(trn_prev, 'hours_female'), tv(trn_prev, 'female'))
            )
            data["教育和培训"]["training_avg_hours_mgmt"] = entry(
                "training_avg_hours_mgmt",
                safe_div(tv(trn_cur, 'hours_mgmt'), tv(trn_cur, 'mgmt')),
                safe_div(tv(trn_prev, 'hours_mgmt'), tv(trn_prev, 'mgmt'))
            )
            data["教育和培训"]["training_avg_hours_middle"] = entry(
                "training_avg_hours_middle",
                safe_div(tv(trn_cur, 'hours_middle'), tv(trn_cur, 'middle')),
                safe_div(tv(trn_prev, 'hours_middle'), tv(trn_prev, 'middle'))
            )
            data["教育和培训"]["training_avg_hours_general"] = entry(
                "training_avg_hours_general",
                safe_div(tv(trn_cur, 'hours_general'), tv(trn_cur, 'general')),
                safe_div(tv(trn_prev, 'hours_general'), tv(trn_prev, 'general'))
            )

        # 职业健康与安全
        if ohs_cur or ohs_prev:
            def ov(obj, attr):
                return getattr(obj, attr) if obj is not None else None

            for key in [
                'training_count_total', 'training_hours_total', 'injury_count_total', 'incident_count_total',
                'fatality_count_total', 'lost_workdays_total', 'safety_investment_total', 'training_participants_total',
                'safety_managers', 'medical_checks', 'coverage_rate', 'emergency_drills', 'hazards_found', 'occupational_checks'
            ]:
                data["职业健康与安全"][f"ohs_{key}"] = entry(f"ohs_{key}", ov(ohs_cur, key), ov(ohs_prev, key))

            # 因工死亡率
            fatality_rate_cur = None
            fatality_rate_prev = None
            try:
                if ov(ohs_cur, 'fatality_count_total') is not None and total_employees_cur:
                    fatality_rate_cur = round(ov(ohs_cur, 'fatality_count_total') / total_employees_cur * 100, 4)
                if ov(ohs_prev, 'fatality_count_total') is not None and total_employees_prev:
                    fatality_rate_prev = round(ov(ohs_prev, 'fatality_count_total') / total_employees_prev * 100, 4)
            except Exception:
                pass
            data["职业健康与安全"]["ohs_fatality_rate"] = entry("ohs_fatality_rate", fatality_rate_cur, fatality_rate_prev)

            # OHS 人均受训学时（使用培训参与人数）
            ohs_avg_hours_cur = None
            ohs_avg_hours_prev = None
            try:
                if ov(ohs_cur, 'training_participants_total') not in (None, 0):
                    ohs_avg_hours_cur = round(ov(ohs_cur, 'training_hours_total') / ov(ohs_cur, 'training_participants_total'), 2)
                if ov(ohs_prev, 'training_participants_total') not in (None, 0):
                    ohs_avg_hours_prev = round(ov(ohs_prev, 'training_hours_total') / ov(ohs_prev, 'training_participants_total'), 2)
            except Exception:
                pass
            data["职业健康与安全"]["ohs_avg_training_hours_per_person"] = entry("ohs_avg_training_hours_per_person", ohs_avg_hours_cur, ohs_avg_hours_prev)

        # 员工满意度
        if sat_cur or sat_prev:
            def sv(obj, attr):
                return getattr(obj, attr) if obj is not None else None
            data["员工满意度"]["satisfaction_annual_average"] = entry("satisfaction_annual_average", sv(sat_cur, 'annual_average'), sv(sat_prev, 'annual_average'))

        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取劳动定量数据失败: {str(e)}")


@app.post("/api/labor/reasons")
async def save_labor_reasons(factory: str = Body(...), year: int = Body(...), reasons: Dict[str, str] = Body(...), db: Session = Depends(get_db)):
    try:
        for indicator, reason in reasons.items():
            existing = db.query(LaborReason).filter(
                LaborReason.factory == factory,
                LaborReason.year == year,
                LaborReason.indicator == indicator
            ).first()
            if existing:
                existing.reason = reason
            else:
                db.add(LaborReason(factory=factory, year=year, indicator=indicator, reason=reason))
        db.commit()
        return {"status": "success", "message": "劳动定量原因说明已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存劳动原因失败: {str(e)}")


@app.get("/api/other")
async def get_other_overview(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db)):
    try:
        supply_cur = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year).first()
        supply_prev = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year - 1).first()

        product_cur = db.query(ProductResponsibilityData).filter(ProductResponsibilityData.factory == factory, ProductResponsibilityData.year == year).first()
        product_prev = db.query(ProductResponsibilityData).filter(ProductResponsibilityData.factory == factory, ProductResponsibilityData.year == year - 1).first()

        ipr_cur = db.query(IPRData).filter(IPRData.factory == factory, IPRData.year == year).first()
        ipr_prev = db.query(IPRData).filter(IPRData.factory == factory, IPRData.year == year - 1).first()

        community_cur = db.query(CommunityData).filter(CommunityData.factory == factory, CommunityData.year == year).first()
        community_prev = db.query(CommunityData).filter(CommunityData.factory == factory, CommunityData.year == year - 1).first()

        volunteer_cur = db.query(VolunteerData).filter(VolunteerData.factory == factory, VolunteerData.year == year).first()
        volunteer_prev = db.query(VolunteerData).filter(VolunteerData.factory == factory, VolunteerData.year == year - 1).first()

        # reasons
        reasons_rows = db.query(OtherReason).filter(OtherReason.factory == factory, OtherReason.year == year).all()
        reasons_map = {row.indicator: row.reason for row in reasons_rows}

        def entry(indicator_key, cur, prev):
            return {
                "currentYear": cur,
                "lastYear": prev,
                "comparison": _calc_comparison(cur, prev),
                "reason": reasons_map.get(indicator_key, "")
            }

        def gv(obj, attr):
            return getattr(obj, attr) if obj is not None else None

        data = {
            "供应链管理": {},
            "产品责任": {},
            "知识产权保护": {},
            "社区参与": {},
            "志愿活动": {}
        }

        # 供应链管理
        if supply_cur or supply_prev:
            for key in [
                'total_suppliers', 'env_screened', 'soc_screened', 'env_assessment_count', 'soc_assessment_count',
                'env_penalty_count', 'env_penalty_amount', 'cyber_incidents', 'local_amount', 'total_amount',
                'local_purchase_ratio'
            ]:
                data["供应链管理"][f"supply_{key}"] = entry(f"supply_{key}", gv(supply_cur, key), gv(supply_prev, key))

        # 产品责任
        if product_cur or product_prev:
            for key in [
                'complaints_total', 'complaints_handled', 'complaints_handle_rate', 'customer_satisfaction',
                'recall_count', 'recall_percent', 'product_quality_issues', 'cyber_incidents'
            ]:
                data["产品责任"][f"product_{key}"] = entry(f"product_{key}", gv(product_cur, key), gv(product_prev, key))

        # 知识产权
        if ipr_cur or ipr_prev:
            for key in [
                'patents_total', 'invention_total', 'invention_applications', 'utility_model_total', 'design_total',
                'authorized_total', 'new_patents_year', 'software_copyright_total', 'trademarks_total'
            ]:
                data["知识产权保护"][f"ipr_{key}"] = entry(f"ipr_{key}", gv(ipr_cur, key), gv(ipr_prev, key))

        # 社区参与
        if community_cur or community_prev:
            for key in ['donation_total', 'community_investment']:
                data["社区参与"][f"community_{key}"] = entry(f"community_{key}", gv(community_cur, key), gv(community_prev, key))

        # 志愿活动
        if volunteer_cur or volunteer_prev:
            for key in ['participants', 'hours_total']:
                data["志愿活动"][f"volunteer_{key}"] = entry(f"volunteer_{key}", gv(volunteer_cur, key), gv(volunteer_prev, key))

        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取其他定量数据失败: {str(e)}")


@app.post("/api/other/reasons")
async def save_other_reasons(factory: str = Body(...), year: int = Body(...), reasons: Dict[str, str] = Body(...), db: Session = Depends(get_db)):
    try:
        for indicator, reason in reasons.items():
            existing = db.query(OtherReason).filter(
                OtherReason.factory == factory,
                OtherReason.year == year,
                OtherReason.indicator == indicator
            ).first()
            if existing:
                existing.reason = reason
            else:
                db.add(OtherReason(factory=factory, year=year, indicator=indicator, reason=reason))
        db.commit()
        return {"status": "success", "message": "其他定量原因说明已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存其他原因失败: {str(e)}")


# 定性：劳动
QUAL_INDICATORS = {
    "雇佣": [
        "员工聘用及解雇",
        "行业员工流失率",
        "光大同创的员工流失率与行业流失率的对比表",
        "薪酬管理"
    ],
    "职业健康与安全": [
        "职业健康安全管理体系",
        "安全生产政策",
        "保障职业健康与安全目标",
        "保障职业健康与安全目标措施",
        "危害识别、风险评估和事故调查",
        "职业健康安全事务：工作者的参与、意见征询和沟通",
        "工作者职业健康安全培训",
        "促进工作者健康"
    ],
    "员工满意度": [
        "员工满意度调查计划",
        "员工满意度调查覆盖率/覆盖情况",
        "员工满意度项目排名"
    ],
    "员工关爱": [
        "提供给全职员工（不包括临时或兼职员工）的福利",
        "员工关爱"
    ],
    "培训": [
        "年度培训计划小时数目标",
        "年度培训计划小时数目标达成率（%）",
        "年度培训计划",
        "年度培训计划达成率（%）"
    ],
    "多元化与平等机会": [
        "多元化和机会平等",
        "晋升机制"
    ],
    "反歧视": [
        "歧视事件及采取的纠正行动"
    ],
    "童工": [
        "具有重大童工事件风险的运营点和供应商"
    ],
    "强迫或强制劳动": [
        "具有强迫或强制劳动事件重大风险的运营点和供应商"
    ],
    "民主权益": [
        "民主管理"
    ],
    "应急管理": [
        "应急管理体系",
        "安全应急措施"
    ]
}


@app.get("/api/labor-qualitative")
async def get_labor_qualitative(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db)):
    try:
        rows = db.query(LaborQualitative).filter(LaborQualitative.factory == factory, LaborQualitative.year == year).all()
        existing = {r.indicator: r for r in rows}

        # 组装结构：{类别: {indicatorKey: {currentText, lastText, comparisonText, reason}}}
        result = {}
        for category, indicators in QUAL_INDICATORS.items():
            group = {}
            for ind in indicators:
                r = existing.get(ind)
                group[ind] = {
                    "currentText": r.current_text if r else "",
                    "lastText": r.last_text if r else "",
                    "comparisonText": r.comparison_text if r else "",
                    "reason": r.reason if r else ""
                }
            result[category] = group
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取劳动定性数据失败: {str(e)}")


@app.post("/api/labor-qualitative/save")
async def save_labor_qualitative(factory: str = Body(...), year: int = Body(...), data: Dict[str, Dict[str, Dict[str, str]]] = Body(...), db: Session = Depends(get_db)):
    try:
        # data: {类别: { 指标: {currentText, lastText, comparisonText, reason} }}
        for category, indicators in data.items():
            for indicator, payload in indicators.items():
                r = db.query(LaborQualitative).filter(
                    LaborQualitative.factory == factory,
                    LaborQualitative.year == year,
                    LaborQualitative.indicator == indicator
                ).first()
                if r:
                    r.current_text = payload.get('currentText', r.current_text)
                    r.last_text = payload.get('lastText', r.last_text)
                    r.comparison_text = payload.get('comparisonText', r.comparison_text)
                    r.reason = payload.get('reason', r.reason)
                else:
                    db.add(LaborQualitative(
                        factory=factory,
                        year=year,
                        indicator=indicator,
                        current_text=payload.get('currentText', ''),
                        last_text=payload.get('lastText', ''),
                        comparison_text=payload.get('comparisonText', ''),
                        reason=payload.get('reason', '')
                    ))
        db.commit()
        return {"status": "success", "message": "劳动定性内容已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存劳动定性失败: {str(e)}")


# 定性：其他
OTHER_QUAL_INDICATORS = {
    "供应商管理": [
        "供应商管理体系",
        "供应商廉洁要求",
        "供应商管理目标及措施",
        "供应商识别",
        "绿色供应链",
        "供应链多元化政策",
        "供应链对环境的负面影响及采取的行动",
        "供应链对社会的负面影响及采取的行动",
        "供应链环境承诺书签署率",
        "供应链环境现场审核完成率",
        "供应链环境现场审核改进情况说明",
        "供应链环境管理目标"
    ],
    "产品安全管理": [
        "产品质量与安全机制"
    ],
    "责任营销": [
        "真实公正的信息与合同签订"
    ],
    "知识产权保护": [
        "知识产权保护政策",
        "维护及保障知识产权有关的惯例"
    ],
    "数据安全与客户隐私保护": [
        "客户隐私保护",
        "数据安全管理",
        "数据安全隐私认证与信披",
        "信息安全管理体系认证"
    ],
    "社区参与": [
        "社区参与",
        "利益相关方社区沟通目标计划",
        "利益相关方社区沟通目标计划完成率（%）",
        "有当地社区参与、影响评估和发展计划的运营点"
    ],
    "绿色金融": [
        "绿色金融产品"
    ],
    "数字化": [
        "数字转型"
    ]
}


@app.get("/api/other-qualitative")
async def get_other_qualitative(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db)):
    try:
        rows = db.query(OtherQualitative).filter(OtherQualitative.factory == factory, OtherQualitative.year == year).all()
        existing = {r.indicator: r for r in rows}
        result = {}
        for category, indicators in OTHER_QUAL_INDICATORS.items():
            group = {}
            for ind in indicators:
                r = existing.get(ind)
                group[ind] = {
                    "currentText": r.current_text if r else "",
                    "lastText": r.last_text if r else "",
                    "comparisonText": r.comparison_text if r else "",
                    "reason": r.reason if r else ""
                }
            result[category] = group
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取其他定性数据失败: {str(e)}")


@app.post("/api/other-qualitative/save")
async def save_other_qualitative(factory: str = Body(...), year: int = Body(...), data: Dict[str, Dict[str, Dict[str, str]]] = Body(...), db: Session = Depends(get_db)):
    try:
        for category, indicators in data.items():
            for indicator, payload in indicators.items():
                r = db.query(OtherQualitative).filter(
                    OtherQualitative.factory == factory,
                    OtherQualitative.year == year,
                    OtherQualitative.indicator == indicator
                ).first()
                if r:
                    r.current_text = payload.get('currentText', r.current_text)
                    r.last_text = payload.get('lastText', r.last_text)
                    r.comparison_text = payload.get('comparisonText', r.comparison_text)
                    r.reason = payload.get('reason', r.reason)
                else:
                    db.add(OtherQualitative(
                        factory=factory,
                        year=year,
                        indicator=indicator,
                        current_text=payload.get('currentText', ''),
                        last_text=payload.get('lastText', ''),
                        comparison_text=payload.get('comparisonText', ''),
                        reason=payload.get('reason', '')
                    ))
        db.commit()
        return {"status": "success", "message": "其他定性内容已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存其他定性失败: {str(e)}")

