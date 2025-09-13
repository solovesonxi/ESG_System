from sqlalchemy import Column, Integer, String, Float, JSON, Text

from core.dependencies import Base


class User(Base):
    __tablename__ = 'users'
    username = Column(String(50), primary_key=True)
    hashed_password = Column(String(100), nullable=False)
    factory = Column(String(100), nullable=False)
    account_type = Column(String(20), nullable=False, default='factory')  # 'headquarters' 或 'factory'
    phone = Column(String(20), nullable=True)
    email = Column(String(50), nullable=True)
    avatar = Column(String(60), nullable=True)


class MaterialData(Base):
    __tablename__ = 'material'
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    # 按月存储的字段（12个月数据）
    renewable_input = Column(JSON, nullable=False)  # 可再生进料量 (T)
    non_renewable_input = Column(JSON, nullable=False)  # 不可再生进料量 (T)
    renewable_output = Column(JSON, nullable=False)  # 可再生出料量 (T)
    non_renewable_output = Column(JSON, nullable=False)  # 不可再生出料量 (T)
    material_consumption = Column(JSON, nullable=False)  # 物料消耗量 (T)
    wood_fiber = Column(JSON, nullable=False)  # 木质纤维消耗量 (T)
    aluminum = Column(JSON, nullable=False)  # 铝消耗量 (T)
    packaging_material = Column(JSON, nullable=False)  # 包装材料消耗量 (T)
    paper_consumption = Column(JSON, nullable=False)  # 纸张消耗量 (T)

    # 按年计算的字段
    total_revenue = Column(Float, nullable=False)  # 总营收 (万元)
    packaging_intensity = Column(Float, nullable=False)  # 包装材料消耗强度 (T/万元)
    paper_intensity = Column(Float, nullable=False)  # 纸张消耗强度 (T/万元)
    total_input = Column(Float, nullable=False)  # 进料总量 (T)
    total_output = Column(Float, nullable=False)  # 出料总量 (T)
    renewable_input_ratio = Column(Float, nullable=False)  # 可再生进料占比 (%)
    renewable_output_ratio = Column(Float, nullable=False)  # 可再生出料占比 (%)

    reasons = Column(JSON, nullable=True)  # 原因说明



class EnergyData(Base):
    __tablename__ = 'energy'
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    # 月度原始数据
    purchased_power = Column(JSON, nullable=False)  # 外购电量 (kWh)
    renewable_power = Column(JSON, nullable=False)  # 再生能源电量 (kWh)
    gasoline = Column(JSON, nullable=False)  # 汽油用量 (T)
    diesel = Column(JSON, nullable=False)  # 柴油用量 (T)
    natural_gas = Column(JSON, nullable=False)  # 天然气用量 (T)
    other_energy = Column(JSON, nullable=False)  # 其他能源 (Tce)
    water  = Column(JSON, nullable=False)  # 水用量 (m³)
    coal = Column(JSON, nullable=False)  # 煤用量 (Tce)

    # 能源消耗计算结果
    total_energy_consumption = Column(Float)  # Tce
    turnover = Column(Float)  # 万元
    energy_consumption_intensity = Column(Float)
    reasons = Column(JSON, nullable=True)


class WaterData(Base):
    __tablename__ = 'water'
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

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
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

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
    factory = Column(String(100), primary_key=True)  # 工厂名称
    year = Column(Integer, nullable=False)

    # 月度数据（JSON数组存储12个月数据）
    epe = Column(JSON, nullable=False)
    plastic_paper = Column(JSON, nullable=False)
    domestic_industrial = Column(JSON, nullable=False)
    hazardous = Column(JSON, nullable=False)
    wastewater = Column(JSON, nullable=False)

    # 计算指标
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
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    # 月度数据（JSON数组存储12个月数据）
    env_invest = Column(JSON, nullable=False)
    clean_tech_invest = Column(JSON, nullable=False)
    climate_invest = Column(JSON, nullable=False)
    green_income = Column(JSON, nullable=False)

    # 计算指标
    total_investment = Column(Float, nullable=False)
    green_income_ratio = Column(Float, nullable=False)
    total_revenue = Column(Float, nullable=False)
    env_invest_intensity = Column(Float, nullable=False)
    reasons = Column(JSON, nullable=True)


class ManagementData(Base):
    __tablename__ = 'management'
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    national_green_factory = Column(JSON, nullable=False)
    provincial_green_factory = Column(JSON, nullable=False)
    environmental_penalty_intensity = Column(JSON, nullable=False)
    environmental_penalty_amount = Column(JSON, nullable=False)
    environmental_violation = Column(JSON, nullable=False)
    reasons = Column(JSON, nullable=True)

class EmploymentData(Base):
    __tablename__ = "employment"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    # 员工构成数据
    full_time = Column(JSON, nullable=False)
    part_time = Column(JSON, nullable=False)
    male = Column(JSON, nullable=False)
    female = Column(JSON, nullable=False)
    management = Column(JSON, nullable=False)
    management_female = Column(JSON, nullable=False)
    middle = Column(JSON, nullable=False)
    general = Column(JSON, nullable=False)
    mainland = Column(JSON, nullable=False)
    overseas = Column(JSON, nullable=False)
    edu_phd = Column(JSON, nullable=False)
    edu_master = Column(JSON, nullable=False)
    edu_bachelor = Column(JSON, nullable=False)
    edu_junior = Column(JSON, nullable=False)

    # 五险一金数据
    avg_social_fund = Column(JSON, nullable=False)
    inc_social_fund = Column(JSON, nullable=False)

    # 年龄分布
    age18_30 = Column(JSON, nullable=False)
    age31_45 = Column(JSON, nullable=False)
    age46_60 = Column(JSON, nullable=False)

    # 新员工与离职数据
    new_hires = Column(JSON, nullable=False)
    quit_male = Column(JSON, nullable=False)
    quit_female = Column(JSON, nullable=False)
    quit_mainland = Column(JSON, nullable=False)
    quit_overseas = Column(JSON, nullable=False)
    quit18_30 = Column(JSON, nullable=False)
    quit31_45 = Column(JSON, nullable=False)
    quit46_60 = Column(JSON, nullable=False)
    quit_management = Column(JSON, nullable=False)
    quit_middle = Column(JSON, nullable=False)
    quit_general = Column(JSON, nullable=False)

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
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

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
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

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
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    satisfaction = Column(JSON, nullable=False)  # 存储12个月份的满意度数据
    annual_average = Column(Float, default=0.0)  # 年度平均值


class SupplyData(Base):
    __tablename__ = "supply"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

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



class EnvQualData(Base):
    __tablename__ = "env_qual"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

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
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(200), primary_key=True)
    reason = Column(String(2000), nullable=True)


class OtherReason(Base):
    __tablename__ = "other_reasons"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(200), primary_key=True)
    reason = Column(String(2000), nullable=True)


class LaborQualitative(Base):
    __tablename__ = "labor_qualitative"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(200), primary_key=True)

    current_text = Column(String(4000), nullable=True)
    last_text = Column(String(4000), nullable=True)
    comparison_text = Column(String(1000), nullable=True)
    reason = Column(String(2000), nullable=True)


class OtherQualitative(Base):
    __tablename__ = "other_qualitative"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(200), primary_key=True)

    current_text = Column(String(4000), nullable=True)
    last_text = Column(String(4000), nullable=True)
    comparison_text = Column(String(1000), nullable=True)
    reason = Column(String(2000), nullable=True)


class ProductResponsibilityData(Base):
    __tablename__ = "product_responsibility"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    complaints = Column(JSON, nullable=False)  # 客户投诉总数
    handled = Column(JSON, nullable=False)  # 有效处理件数
    quality_issues = Column(JSON, nullable=False)  # 产品质量问题数
    recalls = Column(JSON, nullable=False)  # 发生产品召回的次数
    shipments = Column(JSON, nullable=False)  # 产品出货量
    customer_satisfaction = Column(JSON, nullable=False)  # 客户满意度结果
    cyber_incidents = Column(JSON, nullable=False)  # 网络数据安全事件
    complaints_total = Column(Integer, default=0)  # 客户投诉总数
    handled_total = Column(Integer, default=0)  # 有效处理件数
    handled_rate = Column(Float, default=0.0)  # 客户投诉有效处理率
    customer_satisfaction_average = Column(Float, default=0.0)  # 客户满意度结果
    recall_total = Column(Integer, default=0)  # 发生产品召回的次数
    recall_rate = Column(Float, default=0.0)  # 产品召回百分比
    quality_issues_total = Column(Integer, default=0)  # 产品安全质量问题
    cyber_incidents_total = Column(Integer, default=0)  # 网络数据安全事件


class IPRData(Base):
    __tablename__ = "ip"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    patents=Column(JSON, nullable=False)
    inv_patents= Column(JSON, nullable=False)
    inv_applications= Column(JSON, nullable=False)
    utility_patents= Column(JSON, nullable=False)
    design_patents= Column(JSON, nullable=False)
    granted_patents= Column(JSON, nullable=False)
    software_copyrights= Column(JSON, nullable=False)
    trademarks=Column(JSON, nullable=False)
    new_patents= Column(Integer, default=0)
    patents_total = Column(Integer, default=0)  # 累计获得专利数量
    inv_patents_total = Column(Integer, default=0)  # 累计发明专利数量
    inv_applications_total = Column(Integer, default=0)  # 发明专利申请数量
    utility_patents_total = Column(Integer, default=0)  # 累计实用新型专利数量
    design_patents_total = Column(Integer, default=0)  # 累计外观设计专利数量
    granted_patents_total = Column(Integer, default=0)  # 累计被授权专利数
    software_copyrights_total = Column(Integer, default=0)  # 累计软件著作权数量
    trademarks_total = Column(Integer, default=0)  # 累计商标注册数量


class CommunityData(Base):
    __tablename__ = "community"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    charity_donations = Column(JSON, default=0.0)  # 公益慈善捐赠总额
    community_investment = Column(JSON, default=0.0)  # 社区发展投入金额


class VolunteerData(Base):
    __tablename__ = "volunteer"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    volunteer_participants = Column(JSON, default=0)  # 志愿者活动参与人次
    volunteer_hours = Column(JSON, default=0.0)  # 志愿者服务总时长


class GovernanceQualitative(Base):
    __tablename__ = "governance_qualitative"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(200), primary_key=True)

    explanation = Column(Text)
    source = Column(Text)
    last_text = Column(Text)
    current_text = Column(Text)
    comparison_text = Column(Text)
    reason = Column(Text)
