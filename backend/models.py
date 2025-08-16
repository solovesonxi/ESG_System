from sqlalchemy import Column, Integer, String, Float
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