from typing import List, Dict, Optional

from pydantic import BaseModel


# 请求数据模型 - 匹配前端提交结构
class MaterialSubmission(BaseModel):
    factory: str
    year: int

    # 按月存储的字段（12个月数据）
    renewableInput: List[float]  # 可再生进料量 (T)
    nonRenewableInput: List[float]  # 不可再生进料量 (T)
    renewableOutput: List[float]  # 可再生出料量 (T)
    nonRenewableOutput: List[float]  # 不可再生出料量 (T)
    materialConsumption: List[float]  # 物料消耗量 (T)
    woodFiber: List[float]  # 木质纤维消耗量 (T)
    aluminum: List[float]  # 铝消耗量 (T)
    packagingMaterial: List[float]  # 包装材料消耗量 (T)
    paper: List[float]  # 纸张消耗量 (T)

    # 按年计算的字段
    total_revenue: float  # 总营收 (万元)
    packagingIntensity: float  # 包装材料消耗强度 (T/万元)
    paperIntensity: float  # 纸张消耗强度 (T/万元)
    totalInput: float  # 进料总量 (T)
    totalOutput: float  # 出料总量 (T)
    renewableInputRatio: float  # 可再生进料占比 (%)
    renewableOutputRatio: float  # 可再生出料占比 (%)



class EnergySubmission(BaseModel):
    factory: str
    year: int
    purchasedPower: List[float]  # 12个月外购电量
    renewableEnergyPower: List[float]  # 12个月再生能源电量
    gasoline: List[float]  # 12个月汽油用量
    diesel: List[float]  # 12个月柴油用量
    naturalGas: List[float]  # 12个月天然气用量
    otherEnergy: List[float]  # 12个月其他能源
    water: List[float]  # 12个月水用量
    coal: List[float]  # 12个月煤炭用量

    totalEnergyConsumption: float
    turnover: float
    energyConsumptionIntensity: float


class WaterSubmission(BaseModel):
    factory: str
    year: int

    # 月度数据
    industrial: List[float]
    domestic: List[float]
    reclaimed: List[float]
    total: List[float]

    # 工业用水指标
    industrialTotal: float
    industrialDrainage: float
    industrialConsumption: float
    industrialRecycled: float

    # 生活用水指标
    domesticTotal: float
    domesticDrainage: float
    domesticConsumption: float
    domesticRecycled: float

    # 中水指标
    reclaimedTotal: float
    totalRevenue: float
    reclaimedIntensity: float

    # 汇总指标
    totalIntake: float
    totalDrainage: float
    totalConsumption: float
    totalRecycled: float
    waterIntensity: float
    waterRecycleRate: float


class EmissionSubmission(BaseModel):
    factory: str
    year: int

    # 温室气体排放数据
    categoryOne: float
    categoryTwo: float
    categoryThree: float
    categoryFour: float
    categoryFive: float
    categorySix: float
    total_revenue: float

    # 计算指标
    categoryThreeTotal: float
    totalEmission: float
    emissionIntensity: float

    # 废气排放数据
    voc: float
    nmhc: float
    benzene: float
    particulate: float
    nox_sox_other: float
    wasteGasTotal: float


class WasteSubmission(BaseModel):
    factory: str
    year: int

    epe: List[float]
    plasticPaper: List[float]
    domesticIndustrial: List[float]
    hazardous: List[float]
    wastewater: List[float]
    nonHazardousTotal: float
    recyclableTotal: float
    totalWaste: float
    disposalRequiredTotal: float
    recycleRate: float
    totalRevenue: float
    protectiveReuseRate: float
    exceedEvents: int
    hazardousIntensity: float
    wastewaterIntensity: float


class InvestmentSubmission(BaseModel):
    factory: str
    year: int

    envInvest: List[float]
    cleanTechInvest: List[float]
    climateInvest: List[float]
    greenIncome: List[float]
    totalInvestment: float
    greenIncomeRatio: float
    totalRevenue: float
    envInvestIntensity: float

class ManagementSubmission(BaseModel):
    factory: str
    year: int
    national_green_factory: List[float]  # 国家级绿色工厂（个）
    provincial_green_factory: List[float]  # 省级绿色工厂（个）
    environmental_penalty_intensity: List[float]  # 环境处罚强度（%）
    environmental_penalty_amount: List[float]  # 环境处罚额（万元）
    environmental_violation: List[int]  # 环境违规（次）


class EmploymentSubmission(BaseModel):
    factory: str
    year: int

    # 员工构成数据
    fullTime: List[int]
    partTime: List[int]
    male: List[int]
    female: List[int]
    management: List[int]
    managementFemale: List[int]
    middle: List[int]
    general: List[int]
    mainland: List[int]
    overseas: List[int]
    eduPhd: List[int]
    eduMaster: List[int]
    eduBachelor: List[int]
    eduJunior: List[int]

    # 五险一金数据
    avgSocialFund: List[float]
    incSocialFund: List[float]

    # 年龄分布
    age18_30: List[int]
    age31_45: List[int]
    age46_60: List[int]

    # 新员工与离职数据
    newHires: List[int]
    quitMale: List[int]
    quitFemale: List[int]
    quitMainland: List[int]
    quitOverseas: List[int]
    quit18_30: List[int]
    quit31_45: List[int]
    quit46_60: List[int]
    quitManagement: List[int]
    quitMiddle: List[int]
    quitGeneral: List[int]

    # 计算指标
    totalEmployees: int
    quitTotal: int
    turnoverRate: float
    maleTurnoverRate: float
    femaleTurnoverRate: float
    mainlandTurnoverRate: float
    overseasTurnoverRate: float
    age18_30TurnoverRate: float
    age31_45TurnoverRate: float
    age46_60TurnoverRate: float
    managementTurnoverRate: float
    middleTurnoverRate: float
    generalTurnoverRate: float


class TrainingSubmission(BaseModel):
    factory: str
    year: int

    # 基础数据
    total: int
    trained: int
    male: int
    female: int
    mgmt: int
    middle: int
    general: int
    hoursTotal: float
    hoursMale: float
    hoursFemale: float
    hoursMgmt: float
    hoursMiddle: float
    hoursGeneral: float

    # 计算指标
    coverageRate: float
    maleRate: float
    femaleRate: float
    mgmtRate: float
    middleRate: float
    generalRate: float


class OHSSubmission(BaseModel):
    factory: str
    year: int

    # 月度数据
    trainingCount: List[float]
    trainingParticipants: List[float]
    trainingHours: List[float]
    injuryCount: List[float]
    incidentCount: List[float]
    fatalityCount: List[float]
    lostWorkdays: List[float]
    safetyInvestment: List[float]

    # 汇总数据
    safetyManagers: int
    medicalChecks: int
    coverageRate: float
    emergencyDrills: int
    hazardsFound: int
    occupationalChecks: int

    # 计算字段（添加类型转换器）
    trainingCountTotal: int
    trainingParticipantsTotal: int
    trainingHoursTotal: float
    injuryCountTotal: int
    incidentCountTotal: int
    fatalityCountTotal: int
    lostWorkdaysTotal: int
    safetyInvestmentTotal: float


class SatisfactionSubmission(BaseModel):
    factory: str
    year: int
    satisfaction: List[float]  # 12个月份的满意度百分比
    annualAverage: float  # 年度平均满意度


class SupplySubmission(BaseModel):
    factory: str
    year: int

    # 供应商分布
    east: int
    south: int
    other: int

    # 供应商筛选
    envScreened: int
    socScreened: int

    # 采购金额
    localAmount: float
    totalAmount: float

    # 供应商问题
    envPenaltyCount: int
    envPenaltyAmount: float
    cyberIncidents: int

    # 计算指标
    totalSuppliers: int
    envRatio: float
    socRatio: float
    localPurchaseRatio: float


class EnvManagementSubmission(BaseModel):
    national_green_factory: int
    provincial_green_factory: int
    env_penalty_intensity: float
    env_penalty_amount: float
    env_violations: int
    reason: str


class IndicatorData(BaseModel):
    currentYear: str
    comparison: str
    reason: str


class EnvQualDataRequest(BaseModel):
    factory: str
    year: int
    envQualData: Dict[str, IndicatorData]
# 产品责任
class ProductResponsibilitySubmission(BaseModel):
    factory: str
    year: int
    complaints_total: int
    complaints_handled: int
    complaints_handle_rate: float
    customer_satisfaction: float
    recall_count: int
    recall_percent: float
    product_quality_issues: int
    cyber_incidents: int

# 知识产权
class IPRSubmission(BaseModel):
    factory: str
    year: int
    patents_total: int
    invention_total: int
    invention_applications: int
    utility_model_total: int
    design_total: int
    authorized_total: int
    new_patents_year: int
    software_copyright_total: int
    trademarks_total: int

# 社区参与
class CommunitySubmission(BaseModel):
    year: int
    factory: str
    charityDonations: List[float]
    communityInvestment: List[float]
    volunteerParticipants: List[int]
    volunteerHours: List[float]


class GovernanceQualitativeItem(BaseModel):
    explanation: Optional[str] = None
    source: Optional[str] = None
    current_text: Optional[str] = None
    last_text: Optional[str] = None
    comparison_text: Optional[str] = None
    reason: Optional[str] = None

class GovernanceQualitativeSubmission(BaseModel):
    factory: str
    year: int
    data: Dict[str, Dict[str, GovernanceQualitativeItem]]
