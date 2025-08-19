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
    year: int
    factories: List[str]

    # 月度矩阵 [工厂][12个月]
    epe: List[List[float]]
    plasticPaper: List[List[float]]
    domesticIndustrial: List[List[float]]
    hazardous: List[List[float]]
    wastewater: List[List[float]]

    # 各行合计
    epeTotals: List[float]
    plasticPaperTotals: List[float]
    domesticIndustrialTotals: List[float]
    hazardousTotals: List[float]
    wastewaterTotals: List[float]

    # 推导指标
    nonHazardousTotals: List[float]
    recyclableTotals: List[float]
    totalWaste: List[float]
    disposalRequiredTotals: List[float]
    recycleRate: List[float]

    # 经营与合规
    revenue: List[float]
    protectiveReuseRate: List[float]
    exceedEvents: List[int]

    # 总览
    overall: dict


class InvestmentSubmission(BaseModel):
    year: int
    factories: List[str]

    envInvest: List[List[float]]
    cleanTechInvest: List[List[float]]
    climateInvest: List[List[float]]
    greenIncome: List[List[float]]

    envInvestTotals: List[float]
    cleanTechInvestTotals: List[float]
    climateInvestTotals: List[float]
    greenIncomeTotals: List[float]


class EmploymentRecord(BaseModel):
    factory: str
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
    avgSocialFund: float
    incSocialFund: float
    age18_30: int
    age31_45: int
    age46_60: int
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
    totalEmployees: int
    quitTotal: int


class EmploymentSubmission(BaseModel):
    year: int
    records: List[EmploymentRecord]
    summary: dict


class TrainingRecord(BaseModel):
    factory: str
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


class TrainingSubmission(BaseModel):
    year: int
    records: List[TrainingRecord]
    summary: dict


class OHSSubmission(BaseModel):
    year: int
    factories: List[str]
    trainingCount: List[List[float]]
    trainingParticipants: List[List[float]]
    trainingHours: List[List[float]]
    injuryCount: List[List[float]]
    incidentCount: List[List[float]]
    fatalityCount: List[List[float]]
    lostWorkdays: List[List[float]]
    safetyInvestment: List[List[float]]
    trainingCountTotals: List[float]
    trainingParticipantsTotals: List[float]
    trainingHoursTotals: List[float]
    injuryCountTotals: List[float]
    incidentCountTotals: List[float]
    fatalityCountTotals: List[float]
    lostWorkdaysTotals: List[float]
    safetyInvestmentTotals: List[float]
    summary: dict


class SatisfactionSubmission(BaseModel):
    year: int
    factories: List[str]
    satisfaction: List[List[float]]
    rowAverages: List[float]
    monthlyAverages: List[float]
    overallAverage: float


class SupplyRecord(BaseModel):
    factory: str
    east: int
    south: int
    other: int
    envScreened: int
    socScreened: int
    localAmount: float
    totalAmount: float
    envPenaltyCount: int
    envPenaltyAmount: float
    cyberIncidents: int
    totalSuppliers: int
    envRatio: float
    socRatio: float
    localPurchaseRatio: float


class SupplySubmission(BaseModel):
    year: int
    records: List[SupplyRecord]
    summary: dict