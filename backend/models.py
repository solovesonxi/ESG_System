from typing import List

from pydantic import BaseModel
from sqlalchemy import Column, Integer, String, Float, JSON

from database import Base


class MaterialData(Base):
    __tablename__ = 'material'

    id = Column(Integer, primary_key=True, index=True)

    # 工厂信息
    factory_name = Column(String(100), nullable=False)
    report_year = Column(Integer, nullable=False)

    # 进料数据
    renewable_input = Column(Float, nullable=False)
    non_renewable_input = Column(Float, nullable=False)
    total_input = Column(Float, nullable=False)

    # 出料数据
    renewable_output = Column(Float, nullable=False)
    non_renewable_output = Column(Float, nullable=False)
    total_output = Column(Float, nullable=False)

    # 消耗数据
    material_consumption = Column(Float, nullable=False)
    packaging_material = Column(Float, nullable=False)
    paper_consumption = Column(Float, nullable=False)
    total_revenue = Column(Float, nullable=False)

    # 计算得出的占比
    renewable_input_ratio = Column(Float, nullable=False)
    renewable_output_ratio = Column(Float, nullable=False)

    # 消耗强度
    packaging_intensity = Column(Float, nullable=False)
    paper_intensity = Column(Float, nullable=False)


class EnergyData(Base):
    __tablename__ = 'energy'

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    # 月度原始数据
    purchased_power = Column(JSON, nullable=False)  # 外购电量 (kWh)
    renewable_power = Column(JSON, nullable=False)  # 再生能源电量 (kWh)
    gasoline = Column(JSON, nullable=False)  # 汽油用量 (T)
    diesel = Column(JSON, nullable=False)  # 柴油用量 (T)
    natural_gas = Column(JSON, nullable=False)  # 天然气用量 (m³)
    other_energy = Column(JSON, nullable=False)  # 其他能源 (Tce)

    # 年度汇总数据
    total_purchased_power = Column(Float)
    total_renewable_power = Column(Float)
    total_gasoline = Column(Float)
    total_diesel = Column(Float)
    total_natural_gas = Column(Float)
    total_other_energy = Column(Float)

    # 能源消耗计算结果
    water_consumption = Column(Float)  # Tce
    power_consumption = Column(Float)  # Tce
    gasoline_consumption = Column(Float)  # Tce
    diesel_consumption = Column(Float)  # Tce
    natural_gas_consumption = Column(Float)  # Tce
    total_energy_consumption = Column(Float)  # Tce
    turnover = Column(Float)  # 万元
    energy_consumption_intensity = Column(Float)



class WaterData(Base):
    __tablename__ = 'water'

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    industrial = Column(JSON, nullable=False)
    domestic = Column(JSON, nullable=False)
    reclaimed = Column(JSON, nullable=False)
    total = Column(JSON, nullable=False)

    industrial_total = Column(Float, nullable=False)
    industrial_drainage = Column(Float, nullable=False)
    industrial_consumption = Column(Float, nullable=False)
    industrial_recycled = Column(Float, nullable=False)

    domestic_total = Column(Float, nullable=False)
    domestic_drainage = Column(Float, nullable=False)
    domestic_consumption = Column(Float, nullable=False)
    domestic_recycled = Column(Float, nullable=False)

    reclaimed_total = Column(Float, nullable=False)
    total_revenue = Column(Float, nullable=False)
    reclaimed_intensity = Column(Float, nullable=False)

    total_intake = Column(Float, nullable=False)
    total_drainage = Column(Float, nullable=False)
    total_consumption = Column(Float, nullable=False)
    total_recycled = Column(Float, nullable=False)
    water_intensity = Column(Float, nullable=False)
    water_recycle_rate = Column(Float, nullable=False)


class EmissionData(Base):
    __tablename__ = 'emission'

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    # 温室气体排放字段
    category_one = Column(Float, nullable=False)
    category_two = Column(Float, nullable=False)
    category_three = Column(Float, nullable=False)
    category_four = Column(Float, nullable=False)
    category_five = Column(Float, nullable=False)
    category_six = Column(Float, nullable=False)
    revenue = Column(Float, nullable=False)

    # 计算指标
    category_three_total = Column(Float, nullable=False)
    total_emission = Column(Float, nullable=False)
    emission_intensity = Column(Float, nullable=False)

    # 废气排放字段
    voc = Column(Float, nullable=False)
    nmhc = Column(Float, nullable=False)
    benzene = Column(Float, nullable=False)
    particulate = Column(Float, nullable=False)
    custom_emissions = Column(JSON, nullable=False)  # 存储为JSON数组
    waste_gas_total = Column(Float, nullable=False)


class WasteData(Base):
    __tablename__ = 'waste'

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)  # 工厂名称
    year = Column(Integer, nullable=False)

    # 月度数据（JSON数组存储12个月数据）
    epe = Column(JSON, nullable=False)
    plastic_paper = Column(JSON, nullable=False)
    domestic_industrial = Column(JSON, nullable=False)
    hazardous = Column(JSON, nullable=False)
    wastewater = Column(JSON, nullable=False)

    # 计算指标
    epe_total = Column(Float, nullable=False)
    plastic_paper_total = Column(Float, nullable=False)
    domestic_industrial_total = Column(Float, nullable=False)
    hazardous_total = Column(Float, nullable=False)
    wastewater_total = Column(Float, nullable=False)
    non_hazardous_total = Column(Float, nullable=False)
    recyclable_total = Column(Float, nullable=False)
    total_waste = Column(Float, nullable=False)
    disposal_required_total = Column(Float, nullable=False)
    recycle_rate = Column(Float, nullable=False)

    # 经营与合规
    revenue = Column(Float, nullable=False)
    protective_reuse_rate = Column(Float, nullable=False)
    exceed_events = Column(Integer, nullable=False)

    # 强度指标
    hazardous_intensity = Column(Float, nullable=False)
    wastewater_intensity = Column(Float, nullable=False)


class InvestmentData(Base):
    __tablename__ = 'investment'

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    # 月度数据（JSON数组存储12个月数据）
    env_invest = Column(JSON, nullable=False)
    clean_tech_invest = Column(JSON, nullable=False)
    climate_invest = Column(JSON, nullable=False)
    green_income = Column(JSON, nullable=False)

    # 计算指标
    env_invest_total = Column(Float, nullable=False)
    clean_tech_invest_total = Column(Float, nullable=False)
    climate_invest_total = Column(Float, nullable=False)
    green_income_total = Column(Float, nullable=False)
    total_investment = Column(Float, nullable=False)
    green_income_ratio = Column(Float, nullable=False)


class EmploymentData(Base):
    __tablename__ = "employment"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    # 员工构成数据
    full_time = Column(Integer, default=0)
    part_time = Column(Integer, default=0)
    male = Column(Integer, default=0)
    female = Column(Integer, default=0)
    management = Column(Integer, default=0)
    management_female = Column(Integer, default=0)
    middle = Column(Integer, default=0)
    general = Column(Integer, default=0)
    mainland = Column(Integer, default=0)
    overseas = Column(Integer, default=0)
    edu_phd = Column(Integer, default=0)
    edu_master = Column(Integer, default=0)
    edu_bachelor = Column(Integer, default=0)
    edu_junior = Column(Integer, default=0)

    # 五险一金数据
    avg_social_fund = Column(Float, default=0.0)
    inc_social_fund = Column(Float, default=0.0)

    # 年龄分布
    age18_30 = Column(Integer, default=0)
    age31_45 = Column(Integer, default=0)
    age46_60 = Column(Integer, default=0)

    # 新员工与离职数据
    new_hires = Column(Integer, default=0)
    quit_male = Column(Integer, default=0)
    quit_female = Column(Integer, default=0)
    quit_mainland = Column(Integer, default=0)
    quit_overseas = Column(Integer, default=0)
    quit18_30 = Column(Integer, default=0)
    quit31_45 = Column(Integer, default=0)
    quit46_60 = Column(Integer, default=0)
    quit_management = Column(Integer, default=0)
    quit_middle = Column(Integer, default=0)
    quit_general = Column(Integer, default=0)

    # 计算指标
    total_employees = Column(Integer, default=0)
    quit_total = Column(Integer, default=0)
    turnover_rate = Column(Float, default=0.0)
    male_turnover_rate = Column(Float, default=0.0)
    female_turnover_rate = Column(Float, default=0.0)
    mainland_turnover_rate = Column(Float, default=0.0)
    overseas_turnover_rate = Column(Float, default=0.0)
    age18_30_turnover_rate = Column(Float, default=0.0)
    age31_45_turnover_rate = Column(Float, default=0.0)
    age46_60_turnover_rate = Column(Float, default=0.0)
    management_turnover_rate = Column(Float, default=0.0)
    middle_turnover_rate = Column(Float, default=0.0)
    general_turnover_rate = Column(Float, default=0.0)


class TrainingData(Base):
    __tablename__ = "training"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    # 基础数据
    total = Column(Integer, default=0)  # 总人数
    trained = Column(Integer, default=0)  # 受训人数
    male = Column(Integer, default=0)  # 男性受训人次
    female = Column(Integer, default=0)  # 女性受训人次
    mgmt = Column(Integer, default=0)  # 管理层受训人次
    middle = Column(Integer, default=0)  # 中层受训人次
    general = Column(Integer, default=0)  # 普通员工受训人次
    hours_total = Column(Float, default=0.0)  # 培训总学时
    hours_male = Column(Float, default=0.0)  # 男性学时
    hours_female = Column(Float, default=0.0)  # 女性学时
    hours_mgmt = Column(Float, default=0.0)  # 管理层学时
    hours_middle = Column(Float, default=0.0)  # 中层学时
    hours_general = Column(Float, default=0.0)  # 普通学时

    # 计算指标
    coverage_rate = Column(Float, default=0.0)  # 培训覆盖率
    male_rate = Column(Float, default=0.0)  # 男性占比
    female_rate = Column(Float, default=0.0)  # 女性占比
    mgmt_rate = Column(Float, default=0.0)  # 管理层占比
    middle_rate = Column(Float, default=0.0)  # 中层占比
    general_rate = Column(Float, default=0.0)


class OHSData(Base):
    __tablename__ = "ohs"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    # 月度数据（JSON存储）
    training_count = Column(JSON, nullable=False)  # 培训次数（次）
    training_participants = Column(JSON, nullable=False)  # 培训参与人次（人次）
    training_hours = Column(JSON, nullable=False)  # 培训学时（小时）
    injury_count = Column(JSON, nullable=False)  # 工伤数量（次）
    incident_count = Column(JSON, nullable=False)  # 安全事故数量（次）
    fatality_count = Column(JSON, nullable=False)  # 工亡人数（人）
    lost_workdays = Column(JSON, nullable=False)  # 工伤损失工作日数（天）
    safety_investment = Column(JSON, nullable=False)  # 安全生产投入（万元）

    # 计算字段（基本类型）
    training_count_total = Column(Integer, default=0)
    training_participants_total = Column(Integer, default=0)
    training_hours_total = Column(Float, default=0.0)
    injury_count_total = Column(Integer, default=0)
    incident_count_total = Column(Integer, default=0)
    fatality_count_total = Column(Integer, default=0)
    lost_workdays_total = Column(Integer, default=0)
    safety_investment_total = Column(Float, default=0.0)

    # 汇总数据
    safety_managers = Column(Integer, default=0)  # 专职安全管理人员(人)
    medical_checks = Column(Integer, default=0)  # 员工体检人数(人)
    coverage_rate = Column(Float, default=0.0)  # 员工体检覆盖率(%)
    emergency_drills = Column(Integer, default=0)  # 安全应急演练次数(次)
    hazards_found = Column(Integer, default=0)  # 安全检查排查隐患数(个)
    occupational_checks = Column(Integer, default=0)  # 职业病体检人数(人)


class SatisfactionData(Base):
    __tablename__ = 'satisfaction'

    id = Column(Integer, primary_key=True, index=True)
    year = Column(Integer, nullable=False)
    factories = Column(JSON, nullable=False)
    satisfaction = Column(JSON, nullable=False)
    row_averages = Column(JSON, nullable=False)
    monthly_averages = Column(JSON, nullable=False)
    overall_average = Column(Float, nullable=False)


class SupplyData(Base):
    __tablename__ = 'supply'

    id = Column(Integer, primary_key=True, index=True)
    year = Column(Integer, nullable=False)
    records = Column(JSON, nullable=False)
    summary = Column(JSON, nullable=False)