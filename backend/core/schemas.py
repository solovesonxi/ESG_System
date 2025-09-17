from typing import List, Dict, Optional

from pydantic import BaseModel


# 请求数据模型 - 匹配前端提交结构
class MaterialSubmission(BaseModel):
    factory: str
    year: int
    month: int

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
    isSubmitted: bool = False


class EnergySubmission(BaseModel):
    factory: str
    year: int
    month: int
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
    isSubmitted: bool = False


class WaterSubmission(BaseModel):
    factory: str
    year: int
    month: int

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
    isSubmitted: bool = False


class EmissionSubmission(BaseModel):
    factory: str
    year: int
    month: int

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
    isSubmitted: bool = False


class WasteSubmission(BaseModel):
    factory: str
    year: int
    month: int

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
    isSubmitted: bool = False


class InvestmentSubmission(BaseModel):
    factory: str
    year: int
    month: int

    envInvest: List[float]
    cleanTechInvest: List[float]
    climateInvest: List[float]
    greenIncome: List[float]
    totalInvestment: float
    greenIncomeRatio: float
    totalRevenue: float
    envInvestIntensity: float
    isSubmitted: bool = False


class ManagementSubmission(BaseModel):
    factory: str
    year: int
    month: int
    nationalGreenFactory: List[float]  # 国家级绿色工厂（个）
    provincialGreenFactory: List[float]  # 省级绿色工厂（个）
    environmentalPenaltyIntensity: List[float]  # 环境处罚强度（%）
    environmentalPenaltyAmount: List[float]  # 环境处罚额（万元）
    environmentalViolation: List[int]  # 环境违规（次）
    isSubmitted: bool = False


class EmploymentSubmission(BaseModel):
    factory: str
    year: int
    month: int

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
    isSubmitted: bool = False


class TrainingSubmission(BaseModel):
    factory: str
    year: int
    month: int

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
    isSubmitted: bool = False


class OHSSubmission(BaseModel):
    factory: str
    year: int
    month: int

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
    isSubmitted: bool = False


class SatisfactionSubmission(BaseModel):
    factory: str
    year: int
    month: int
    satisfaction: List[float]  # 12个月份的满意度百分比
    annualAverage: float  # 年度平均满意度
    isSubmitted: bool = False


class SupplySubmission(BaseModel):
    factory: str
    year: int
    month: int

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
    isSubmitted: bool = False


# 产品责任
class ResponsibilitySubmission(BaseModel):
    factory: str
    year: int
    month: int

    complaints: list[int]
    handled: list[int]
    qualityIssues: list[int]
    recalls: list[int]
    shipments: list[int]
    customerSatisfaction: list[float]
    cyberIncidents: list[int]
    complaintsTotal: int
    handledTotal: int
    handledRate: float
    customerSatisfactionAverage: float
    recallsTotal: int
    recallRate: float
    qualityIssuesTotal: int
    cyberIncidentsTotal: int
    isSubmitted: bool = False


# 知识产权
class IPSubmission(BaseModel):
    factory: str
    year: int
    month: int
    patents: List[int]
    invPatents: List[int]
    invApplications: List[int]
    utilityPatents: List[int]
    designPatents: List[int]
    grantedPatents: List[int]
    softwareCopyrights: List[int]
    trademarks: List[int]
    newPatents: int
    patentsTotal: int
    invPatentsTotal: int
    invApplicationsTotal: int
    utilityPatentsTotal: int
    designPatentsTotal: int
    grantedPatentsTotal: int
    softwareCopyrightsTotal: int
    trademarksTotal: int
    isSubmitted: bool = False


# 社区参与
class CommunitySubmission(BaseModel):
    factory: str
    year: int
    month: int
    charityDonations: List[float]
    communityInvestment: List[float]
    volunteerParticipants: List[int]
    volunteerHours: List[float]
    isSubmitted: bool = False

