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