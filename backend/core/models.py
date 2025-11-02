from datetime import datetime, timezone

from sqlalchemy import Column, Integer, String, Boolean, JSON
from sqlalchemy import Float, Text, DateTime, ForeignKey

from core.dependencies import Base


# 用户表
class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(50), unique=True, nullable=False)
    hashed_password = Column(String(100), nullable=False)
    factory = Column(String(100))
    departments = Column(JSON)  # 新增：部门权限列表
    role = Column(String(20), nullable=False, default='department')  # 更新：支持4种角色
    phone = Column(String(20))
    email = Column(String(50))
    avatar = Column(String(60))
    is_active = Column(Boolean, default=True, nullable=False)  # 账号启用/禁用

class Revenue(Base):
    __tablename__ = 'revenues'
    id = Column(Integer, primary_key=True, autoincrement=True)
    factory = Column(String(100), nullable=False, unique=True)
    year = Column(Integer, nullable=False)
    amount = Column(Float, nullable=False)

class Factory(Base):
    __tablename__ = 'factories'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), unique=True, nullable=False)
    address = Column(String(100))
    phone = Column(String(20))
    email = Column(String(50))
    is_active = Column(Boolean, default=True, nullable=False)


class Category(Base):
    __tablename__ = "categories"
    id = Column(Integer, primary_key=True, autoincrement=True)
    name_en = Column(String(128), nullable=False)
    name_zh = Column(String(128), nullable=False)
    model_class = Column(String(128), nullable=False)  # 对应的 ORM 类名（如 MaterialData）
    domain = Column(String(64), nullable=False)
    period_type = Column(String(12), nullable=False)  # 推荐值: 'year' / 'month'
    is_active = Column(Boolean, nullable=False, default=True)


class FieldData(Base):
    __tablename__ = "fields"
    id = Column(Integer, primary_key=True, autoincrement=True)
    category = Column(Integer, ForeignKey("categories.id"), nullable=False, index=True)
    set = Column(String(64), nullable=False)  # 字段分组或版本集
    name_en = Column(String(64), nullable=False)  # 字段标识/名称
    name_zh = Column(String(64), nullable=False)  # 字段标识/名称
    step = Column(Float)  # 计算步长
    calculation = Column(JSON)  # 计算公式
    unit = Column(String(32))  # 单位
    description = Column(Text)  # 字段描述
    source = Column(String(32))  # 数据来源
    is_active = Column(Boolean, nullable=False, default=True)


# 审核表
class ReviewRecord(Base):
    __tablename__ = 'review_records'
    id = Column(Integer, primary_key=True, autoincrement=True)
    category = Column(Integer, ForeignKey("categories.id"), nullable=False, index=True)
    factory = Column(String(100), nullable=False, index=True)
    year = Column(Integer, nullable=False, index=True)
    month = Column(Integer, index=True)
    is_submitted = Column(Boolean, default=False)

    # 一级审核（工厂级）
    level1_status = Column(String(20), default='pending')
    level1_comment = Column(Text)
    level1_reviewer = Column(String(50))
    level1_review_time = Column(DateTime)

    # 二级审核（总部级）
    level2_status = Column(String(20))
    level2_comment = Column(Text)
    level2_reviewer = Column(String(50))
    level2_review_time = Column(DateTime)


class Message(Base):
    __tablename__ = 'messages'
    id = Column(Integer, primary_key=True, autoincrement=True)
    type = Column(String(30), nullable=False)  # 消息类型
    title = Column(String(30), nullable=False)  # 消息标题
    content = Column(Text)  # 消息内容
    sender_role = Column(String(20), nullable=False)  # 发送方角色
    sender_factory = Column(String(50))  # 发送方工厂
    sender_department = Column(String(50))  # 发送方部门
    receiver_role = Column(String(20), nullable=False)  # 接收方角色
    receiver_factory = Column(String(50))  # 接收方工厂
    receiver_department = Column(String(50))  # 接收方部门
    created_at = Column(DateTime, default=datetime.now(timezone.utc))  # 发送时间
    is_read = Column(Boolean, nullable=False, default=False)  # 是否已读


# 各类数据表
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
    water = Column(JSON, nullable=False)  # 水用量 (m³)
    coal = Column(JSON, nullable=False)  # 煤用量 (Tce)


class WaterData(Base):
    __tablename__ = 'water'
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    industrial_water_intake = Column(JSON, nullable=False)
    domestic_water_intake = Column(JSON, nullable=False)
    industrial_water_discharge = Column(JSON, nullable=False)
    domestic_water_discharge = Column(JSON, nullable=False)
    industrial_water_consumption = Column(JSON, nullable=False)
    domestic_water_consumption = Column(JSON, nullable=False)
    industrial_water_recycling = Column(JSON, nullable=False)
    domestic_water_recycling = Column(JSON, nullable=False)
    reclaimed_water_use = Column(JSON, nullable=False)


class EmissionData(Base):
    __tablename__ = 'emission'
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    # 温室气体排放字段
    category_one = Column(JSON, nullable=False)
    category_two = Column(JSON, nullable=False)
    category_three = Column(JSON, nullable=False)
    category_four = Column(JSON, nullable=False)
    category_five = Column(JSON, nullable=False)
    category_six = Column(JSON, nullable=False)


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
    exceed_events = Column(JSON, nullable=False)
    recycled_waste = Column(JSON, nullable=False)
    disposal_waste = Column(JSON, nullable=False)
    three_wastes_incidents = Column(JSON, nullable=False)


class InvestmentData(Base):
    __tablename__ = 'investment'
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    # 月度数据（JSON数组存储12个月数据）
    env_invest = Column(JSON, nullable=False)
    clean_tech_invest = Column(JSON, nullable=False)
    climate_invest = Column(JSON, nullable=False)
    green_income = Column(JSON, nullable=False)


class ManagementData(Base):
    __tablename__ = 'management'
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    national_green_factory = Column(JSON, nullable=False)
    provincial_green_factory = Column(JSON, nullable=False)
    environmental_penalty_intensity = Column(JSON, nullable=False)
    environmental_penalty_amount = Column(JSON, nullable=False)
    environmental_violation = Column(JSON, nullable=False)


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


class TrainingData(Base):
    __tablename__ = "training"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    # 基础数据
    total = Column(JSON, default=0)  # 总人数
    trained = Column(JSON, default=0)  # 受训人数
    male = Column(JSON, default=0)  # 男性受训人次
    female = Column(JSON, default=0)  # 女性受训人次
    mgmt = Column(JSON, default=0)  # 管理层受训人次
    middle = Column(JSON, default=0)  # 中层受训人次
    general = Column(JSON, default=0)  # 普通员工受训人次
    hours_total = Column(JSON, default=0.0)  # 培训总学时
    hours_male = Column(JSON, default=0.0)  # 男性学时
    hours_female = Column(JSON, default=0.0)  # 女性学时
    hours_mgmt = Column(JSON, default=0.0)  # 管理层学时
    hours_middle = Column(JSON, default=0.0)  # 中层学时
    hours_general = Column(JSON, default=0.0)  # 普通学时


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


class SatisfactionData(Base):
    __tablename__ = "satisfaction"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    satisfaction = Column(JSON, nullable=False)  # 存储12个月份的满意度数据


class SupplyData(Base):
    __tablename__ = "supply"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    east = Column(JSON, default=0)  # 华东地区供应商
    south = Column(JSON, default=0)  # 华南地区供应商
    other = Column(JSON, default=0)  # 其他地区供应商
    env_screened = Column(JSON, default=0)  # 环境筛选供应商
    soc_screened = Column(JSON, default=0)  # 社会标准供应商
    local_amount = Column(JSON, default=0.0)  # 当地采购金额
    env_penalty_count = Column(JSON, default=0)  # 环境处罚次数
    env_penalty_amount = Column(JSON, default=0.0)  # 环境处罚金额
    cyber_incidents = Column(JSON, default=0)  # 数据安全事件


class ResponsibilityData(Base):
    __tablename__ = "responsibility"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    complaints = Column(JSON, nullable=False)  # 客户投诉总数
    handled = Column(JSON, nullable=False)  # 有效处理件数
    quality_issues = Column(JSON, nullable=False)  # 产品质量问题数
    recalls = Column(JSON, nullable=False)  # 发生产品召回的次数
    shipments = Column(JSON, nullable=False)  # 产品出货量
    customer_satisfaction = Column(JSON, nullable=False)  # 客户满意度结果
    cyber_incidents = Column(JSON, nullable=False)  # 网络数据安全事件


class IPData(Base):
    __tablename__ = "ip"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    patents = Column(JSON, nullable=False)
    inv_patents = Column(JSON, nullable=False)
    inv_applications = Column(JSON, nullable=False)
    utility_patents = Column(JSON, nullable=False)
    design_patents = Column(JSON, nullable=False)
    granted_patents = Column(JSON, nullable=False)
    software_copyrights = Column(JSON, nullable=False)
    trademarks = Column(JSON, nullable=False)


class CommunityData(Base):
    __tablename__ = "community"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)

    charity_donations = Column(JSON, default=0.0)  # 公益慈善捐赠总额
    community_investment = Column(JSON, default=0.0)  # 社区发展投入金额
    volunteer_participants = Column(JSON, default=0)  # 志愿者活动参与人次
    volunteer_hours = Column(JSON, default=0.0)  # 志愿者服务总时长


class EnvQuantData(Base):
    __tablename__ = "env_quant"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(200), primary_key=True)
    value = Column(Float)
    reason = Column(Text)


class EnvQualData(Base):
    __tablename__ = "env_qual"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(100), primary_key=True)
    current_text = Column(Text)
    comparison_text = Column(Text)
    reason = Column(Text)


class SocialQuantLaborData(Base):
    __tablename__ = "social_quant_labor"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(100), primary_key=True)
    value = Column(Float)
    reason = Column(Text)


class SocialQualLaborData(Base):
    __tablename__ = "social_qual_labor"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(100), primary_key=True)
    current_text = Column(Text)
    comparison_text = Column(Text)
    reason = Column(Text)


class SocialQuantOtherData(Base):
    __tablename__ = "social_quant_other"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(100), primary_key=True)
    value = Column(Float)
    reason = Column(Text)


class SocialQualOtherData(Base):
    __tablename__ = "social_qual_other"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(100), primary_key=True)
    current_text = Column(Text)
    comparison_text = Column(Text)
    reason = Column(Text)


class GovernanceData(Base):
    __tablename__ = "governance"
    factory = Column(String(100), primary_key=True)
    year = Column(Integer, primary_key=True)
    indicator = Column(String(100), primary_key=True)
    current_text = Column(Text)
    comparison_text = Column(Text)
    reason = Column(Text)
