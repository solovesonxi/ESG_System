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
