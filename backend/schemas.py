from typing import List

from pydantic import BaseModel


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


class CustomEmission(BaseModel):
    name: str
    value: float


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
    revenue: float

    # 计算指标
    categoryThreeTotal: float
    totalEmission: float
    emissionIntensity: float

    # 废气排放数据
    voc: float
    nmhc: float
    benzene: float
    particulate: float
    customEmissions: List[CustomEmission]
    wasteGasTotal: float


class WasteSubmission(BaseModel):
    factory: str  # 当前选中的工厂名称
    year: int

    # 月度数据（12个月）
    epe: List[float]
    plasticPaper: List[float]
    domesticIndustrial: List[float]
    hazardous: List[float]
    wastewater: List[float]

    # 计算指标
    epeTotal: float
    plasticPaperTotal: float
    domesticIndustrialTotal: float
    hazardousTotal: float
    wastewaterTotal: float
    nonHazardousTotal: float
    recyclableTotal: float
    totalWaste: float
    disposalRequiredTotal: float
    recycleRate: float

    # 经营与合规
    revenue: float
    protectiveReuseRate: float
    exceedEvents: int

    # 强度指标
    hazardousIntensity: float
    wastewaterIntensity: float


class InvestmentSubmission(BaseModel):
    factory: str
    year: int

    # 月度数据
    envInvest: List[float]
    cleanTechInvest: List[float]
    climateInvest: List[float]
    greenIncome: List[float]

    # 计算指标
    envInvestTotal: float
    cleanTechInvestTotal: float
    climateInvestTotal: float
    greenIncomeTotal: float
    totalInvestment: float
    greenIncomeRatio: float


class EmploymentSubmission(BaseModel):
    factory: str
    year: int

    # 员工构成数据
    fullTime: int
    partTime: int
    male: int
    female: int
    management: int
    managementFemale: int
    middle: int
    general: int
    mainland: int
    overseas: int
    eduPhd: int
    eduMaster: int
    eduBachelor: int
    eduJunior: int

    # 五险一金数据
    avgSocialFund: float
    incSocialFund: float

    # 年龄分布
    age18_30: int
    age31_45: int
    age46_60: int

    # 新员工与离职数据
    newHires: int
    quitMale: int
    quitFemale: int
    quitMainland: int
    quitOverseas: int
    quit18_30: int
    quit31_45: int
    quit46_60: int
    quitManagement: int
    quitMiddle: int
    quitGeneral: int

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
    annualAverage: float       # 年度平均满意度


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