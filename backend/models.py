from sqlalchemy import Column, Integer, String, Float, JSON, UniqueConstraint

from database import Base


class MaterialData(Base):
    __tablename__ = 'material'
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_material_factory_year'),)
    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    renewable_input = Column(Float, nullable=False)
    non_renewable_input = Column(Float, nullable=False)
    renewable_output = Column(Float, nullable=False)
    non_renewable_output = Column(Float, nullable=False)
    material_consumption = Column(Float, nullable=False)
    wood_fiber = Column(Float, nullable=False)
    aluminum = Column(Float, nullable=False)
    total_revenue = Column(Float, nullable=False)
    packaging_material = Column(Float, nullable=False)
    paper_consumption = Column(Float, nullable=False)
    packaging_intensity = Column(Float, nullable=False)
    paper_intensity = Column(Float, nullable=False)
    total_input = Column(Float, nullable=False)
    total_output = Column(Float, nullable=False)
    renewable_input_ratio = Column(Float, nullable=False)
    renewable_output_ratio = Column(Float, nullable=False)

    reasons = Column(JSON, nullable=True)


class EnergyData(Base):
    __tablename__ = 'energy'
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_energy_factory_year'),)
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
    coal_consumption = Column(Float)  # Tce
    power_consumption = Column(Float)  # Tce
    gasoline_consumption = Column(Float)  # Tce
    diesel_consumption = Column(Float)  # Tce
    natural_gas_consumption = Column(Float)  # Tce
    total_energy_consumption = Column(Float)  # Tce
    turnover = Column(Float)  # 万元
    energy_consumption_intensity = Column(Float)
    reasons = Column(JSON, nullable=True)


class WaterData(Base):
    __tablename__ = 'water'
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_water_factory_year'),)
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
    reasons = Column(JSON, nullable=True)


class EmissionData(Base):
    __tablename__ = 'emission'
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_emission_factory_year'),)
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
    total_revenue = Column(Float, nullable=False)

    # 计算指标
    category_three_total = Column(Float, nullable=False)
    total_emission = Column(Float, nullable=False)
    emission_intensity = Column(Float, nullable=False)

    # 废气排放字段
    voc = Column(Float, nullable=False)
    nmhc = Column(Float, nullable=False)
    benzene = Column(Float, nullable=False)
    particulate = Column(Float, nullable=False)
    nox_sox_other = Column(Float, nullable=False)
    waste_gas_total = Column(Float, nullable=False)
    reasons = Column(JSON, nullable=True)


class WasteData(Base):
    __tablename__ = 'waste'
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_waste_factory_year'),)
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
    total_revenue = Column(Float, nullable=False)
    protective_reuse_rate = Column(Float, nullable=False)
    exceed_events = Column(Integer, nullable=False)

    # 强度指标
    hazardous_intensity = Column(Float, nullable=False)
    wastewater_intensity = Column(Float, nullable=False)
    reasons = Column(JSON, nullable=True)


class InvestmentData(Base):
    __tablename__ = 'investment'
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_investment_factory_year'),)
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
    total_revenue = Column(Float, nullable=False)
    env_invest_intensity = Column(Float, nullable=False)
    reasons = Column(JSON, nullable=True)


class EmploymentData(Base):
    __tablename__ = "employment"
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_employment_factory_year'),)
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
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_training_factory_year'),)
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
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_ohs_factory_year'),)
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
    __tablename__ = "satisfaction"
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_satisfaction_factory_year'),)
    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)
    satisfaction = Column(JSON, nullable=False)  # 存储12个月份的满意度数据
    annual_average = Column(Float, default=0.0)  # 年度平均值


class SupplyData(Base):
    __tablename__ = "supply"
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_supply_factory_year'),)
    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    # 供应商分布数据
    east = Column(Integer, default=0)  # 华东地区供应商
    south = Column(Integer, default=0)  # 华南地区供应商
    other = Column(Integer, default=0)  # 其他地区供应商
    total_suppliers = Column(Integer, default=0)  # 供应商总数

    # 供应商筛选数据
    env_screened = Column(Integer, default=0)  # 环境筛选供应商
    soc_screened = Column(Integer, default=0)  # 社会标准供应商

    # 采购金额数据
    local_amount = Column(Float, default=0.0)  # 当地采购金额
    total_amount = Column(Float, default=0.0)  # 采购总金额

    # 供应商问题数据
    env_penalty_count = Column(Integer, default=0)  # 环境处罚次数
    env_penalty_amount = Column(Float, default=0.0)  # 环境处罚金额
    cyber_incidents = Column(Integer, default=0)  # 数据安全事件

    # 计算指标
    env_ratio = Column(Float, default=0.0)  # 环境维度占比
    soc_ratio = Column(Float, default=0.0)  # 社会标准占比
    local_purchase_ratio = Column(Float, default=0.0)  # 当地采购比例

    # 新增：评估计数
    env_assessment_count = Column(Integer, default=0)  # 开展环境影响评估的供应商数量
    soc_assessment_count = Column(Integer, default=0)


class EnvQuantData(Base):
    __tablename__ = "env_quant"
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_env_quant_factory_year'),)
    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)
    national_green_factory = Column(Integer, default=0)  # 国家级绿色工厂
    provincial_green_factory = Column(Integer, default=0)  # 省级绿色工厂
    env_penalty_intensity = Column(Float, default=0.0)  # 环境处罚强度
    env_penalty_amount = Column(Float, default=0.0)  # 环境处罚金额
    env_violations = Column(Integer, default=0)  # 环境违规
    reasons = Column(JSON, nullable=True)


class EnvQualData(Base):
    __tablename__ = "env_qual"
    __table_args__ = (UniqueConstraint('factory', 'year', name='uq_env_qual_factory_year'),)
    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)
    board_supervision = Column(String(500), nullable=True)  # 董事会监管
    management_responsibility = Column(String(500), nullable=True)  # 管理层职责
    environment_strategy = Column(String(500), nullable=True)  # 环境战略
    risk_opportunity_identification = Column(String(500), nullable=True)  # 风险与机遇识别以及应对措施
    climate_risk_disclosure = Column(String(500), nullable=True)  # 气候风险应对披露
    risk_matrix = Column(String(500), nullable=True)  # （物理风险、转型风险、短期风险、长期风险）
    risk_impact = Column(String(500), nullable=True)  # 风险影响
    resilience = Column(String(500), nullable=True)  # 能力韧性
    risk_process = Column(String(500), nullable=True)  # （识别、评估风险流程）
    risk_management_process = Column(String(500), nullable=True)  # 管理风险流程
    business_strategy = Column(String(500), nullable=True)  # 纳入业务策略
    ghg_reduction_target = Column(String(500), nullable=True)  # 温室气体排放物减排目标
    ghg_reduction_rate = Column(String(500), nullable=True)  # 温室气体减排目标达成率（%）
    ghg_reduction_action = Column(String(500), nullable=True)  # 温室气体排放物减排行动
    carbon_capture_target = Column(String(500), nullable=True)  # 碳捕捉计划目标
    carbon_capture_rate = Column(String(500), nullable=True)  # 碳捕捉计划目标达成率（%）
    waste_reduction_target = Column(String(500), nullable=True)  # 废弃物减排目标
    waste_reduction_action = Column(String(500), nullable=True)  # 废弃物减排行动
    annual_water_use_target = Column(String(500), nullable=True)  # 年度用水目标
    annual_water_use_target_rate = Column(String(500), nullable=True)  # 年度用水目标达成率
    annual_reclaimed_water_use_target = Column(String(500), nullable=True)  # 年度再生水使用目标
    annual_reclaimed_water_use_target_rate = Column(String(500), nullable=True)  # 年度再生水使用目标达成率
    water_saving_target = Column(String(500), nullable=True)  # 节水目标
    water_saving_target_rate = Column(String(500), nullable=True)  # 节水目标达成率
    water_management_policy = Column(String(500), nullable=True)  # 水资源管理政策
    water_risk_management = Column(String(500), nullable=True)  # 水资源风险管理
    water_saving_action = Column(String(500), nullable=True)  # 节水行动
    clean_technology_strategy = Column(String(500), nullable=True)  # 清洁技术战略
    clean_technology_practice = Column(String(500), nullable=True)  # 清洁技术实践
    biodiversity_impact = Column(String(500), nullable=True)  # 生物多样性影响
    ecological_restoration = Column(String(500), nullable=True)  # 生态修复
    environmental_accident = Column(String(500), nullable=True)  # 环境事故
    environmental_penalty = Column(String(500), nullable=True)  # 环境处罚
    environmental_management_system = Column(String(500), nullable=True)  # 环境管理体系
    environmental_resource_policy = Column(String(500), nullable=True)  # 环境资源政策
    environmental_emergency_plan = Column(String(500), nullable=True)  # 环境应急预案
    green_office = Column(String(500), nullable=True)  # 绿色办公
    green_factory_policy = Column(String(500), nullable=True)  # 绿色工厂政策
    environmental_committee = Column(String(500), nullable=True)  # 环境委员会
    key_pollution_unit = Column(String(500), nullable=True)  # 重点排污单位
    waste_product_recycling = Column(String(500), nullable=True)  # 废弃物产品回收
    hazardous_waste_emission_target = Column(String(500), nullable=True)  # 危险废弃物排放目标
    hazardous_waste_emission_target_rate = Column(String(500), nullable=True)  # 危险废弃物排放目标达成率
    sustainable_product_certification = Column(String(500), nullable=True)  # 可持续产品认证
    material_reduction_target = Column(String(500), nullable=True)  # 材料减量目标
    annual_packaging_material_target = Column(String(500), nullable=True)  # 年度包装材料目标
    annual_packaging_material_target_rate = Column(String(500), nullable=True)  # 年度包装材料目标达成率
    packaging_material_reduction_target = Column(String(500), nullable=True)  # 包装材料减量目标
    packaging_material_reduction_target_rate = Column(String(500), nullable=True)  # 包装材料减量目标达成率
    product_lifecycle_management = Column(String(500), nullable=True)  # 产品生命周期管理
    annual_office_paper_target = Column(String(500), nullable=True)  # 年度办公用纸目标
    annual_office_paper_target_rate = Column(String(500), nullable=True)  # 年度办公用纸目标达成率
    chemical_management = Column(String(500), nullable=True)  # 化学品管理
    chemical_inventory = Column(String(500), nullable=True)  # 化学品清单
    energy_reduction_target = Column(String(500), nullable=True)  # 能源减排目标
    renewable_energy_target = Column(String(500), nullable=True)  # 可再生能源目标
    renewable_energy_use_development = Column(String(500), nullable=True)  # 可再生能源使用发展
    energy_saving_action_results = Column(String(500), nullable=True)  # 节能行动成果
    energy_management_system = Column(String(500), nullable=True)  # 能源管理体系
    product_carbon_footprint = Column(String(500), nullable=True)  # 产品碳足迹
    product_carbon_footprint_plan = Column(String(500), nullable=True)  # 产品碳足迹计划
    carbon_neutrality_target_year = Column(String(500), nullable=True)  # 碳中和目标年份
    carbon_neutrality_plan = Column(String(500), nullable=True)  # 碳中和计划
    carbon_neutrality_target_scheme = Column(String(500), nullable=True)  # 碳中和目标方案
    carbon_neutrality_plan_rate = Column(String(500), nullable=True)  # 碳中和计划达成率
    carbon_reduction_target = Column(String(500), nullable=True)  # 碳减排目标
    joined_sbti = Column(String(500), nullable=True)  # 加入SBTi
    cdp_disclosure = Column(String(500), nullable=True)  # CDP披露
    carbon_inventory_disclosure = Column(String(500), nullable=True)  # 碳清单披露
    carbon_inventory_report_verification = Column(String(500), nullable=True)  # 碳清单报告验证
    greenhouse_gas_verification_system = Column(String(500), nullable=True)  # 温室气体核查体系
    comparison = Column(JSON, nullable=True)
    reasons = Column(JSON, nullable=True)


class LaborReason(Base):
    __tablename__ = "labor_reasons"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)
    indicator = Column(String(200), nullable=False)
    reason = Column(String(2000), nullable=True)

    __table_args__ = (UniqueConstraint('factory', 'year', 'indicator', name='uq_labor_reason_factory_year_indicator'),)


class ProductResponsibilityData(Base):
    __tablename__ = "product_responsibility"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    complaints_total = Column(Integer, default=0)  # 客户投诉总数
    complaints_handled = Column(Integer, default=0)  # 有效处理件数
    complaints_handle_rate = Column(Float, default=0.0)  # 客户投诉有效处理率
    customer_satisfaction = Column(Float, default=0.0)  # 客户满意度结果
    recall_count = Column(Integer, default=0)  # 发生产品召回的次数
    recall_percent = Column(Float, default=0.0)  # 产品召回百分比
    product_quality_issues = Column(Integer, default=0)  # 产品安全质量问题
    cyber_incidents = Column(Integer, default=0)  # 网络数据安全事件


class IPRData(Base):
    __tablename__ = "ipr"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    patents_total = Column(Integer, default=0)  # 累计获得专利数量
    invention_total = Column(Integer, default=0)  # 累计发明专利数量
    invention_applications = Column(Integer, default=0)  # 发明专利申请数量
    utility_model_total = Column(Integer, default=0)  # 累计实用新型专利数量
    design_total = Column(Integer, default=0)  # 累计外观设计专利数量
    authorized_total = Column(Integer, default=0)  # 累计被授权专利数
    new_patents_year = Column(Integer, default=0)  # 本年新增专利数量
    software_copyright_total = Column(Integer, default=0)  # 累计软件著作权数量
    trademarks_total = Column(Integer, default=0)  # 累计商标注册数量


class CommunityData(Base):
    __tablename__ = "community"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    donation_total = Column(Float, default=0.0)  # 公益慈善捐赠总额
    community_investment = Column(Float, default=0.0)  # 社区发展投入金额


class VolunteerData(Base):
    __tablename__ = "volunteer"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)

    participants = Column(Integer, default=0)  # 志愿者活动参与人次
    hours_total = Column(Float, default=0.0)  # 志愿者服务总时长


class OtherReason(Base):
    __tablename__ = "other_reasons"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)
    indicator = Column(String(200), nullable=False)
    reason = Column(String(2000), nullable=True)

    __table_args__ = (UniqueConstraint('factory', 'year', 'indicator', name='uq_other_reason_factory_year_indicator'),)


class LaborQualitative(Base):
    __tablename__ = "labor_qualitative"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)
    indicator = Column(String(200), nullable=False)

    current_text = Column(String(4000), nullable=True)
    last_text = Column(String(4000), nullable=True)
    comparison_text = Column(String(1000), nullable=True)
    reason = Column(String(2000), nullable=True)

    __table_args__ = (UniqueConstraint('factory', 'year', 'indicator', name='uq_labor_qual_factory_year_indicator'),)


class OtherQualitative(Base):
    __tablename__ = "other_qualitative"

    id = Column(Integer, primary_key=True, index=True)
    factory = Column(String(100), nullable=False)
    year = Column(Integer, nullable=False)
    indicator = Column(String(200), nullable=False)

    current_text = Column(String(4000), nullable=True)
    last_text = Column(String(4000), nullable=True)
    comparison_text = Column(String(1000), nullable=True)
    reason = Column(String(2000), nullable=True)

    __table_args__ = (UniqueConstraint('factory', 'year', 'indicator', name='uq_other_qual_factory_year_indicator'),)
