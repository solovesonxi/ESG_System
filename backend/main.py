import datetime

from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from starlette.middleware.cors import CORSMiddleware

from database import get_db, engine
from models import MaterialData, Base

app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"],
                   allow_headers=["*"], )

# 创建数据库表
Base.metadata.create_all(bind=engine)


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


@app.post("/submit/material")
async def submit_material_data(data: MaterialSubmission, db: Session = Depends(get_db)):
    try:
        db_item = MaterialData(factory_name=data.factory, report_year=data.year, renewable_input=data.renewableInput,
                               non_renewable_input=data.nonRenewableInput, total_input=data.totalInput,
                               renewable_output=data.renewableOutput, non_renewable_output=data.nonRenewableOutput,
                               total_output=data.totalOutput, material_consumption=data.materialConsumption,
                               packaging_material=data.packagingMaterial, paper_consumption=data.paper, total_revenue=data.revenue,
                               renewable_input_ratio=data.renewableInputRatio, renewable_output_ratio=data.renewableOutputRatio,
                               packaging_intensity=data.packagingIntensity, paper_intensity=data.paperIntensity)
        db.add(db_item)
        db.commit()
        return {"status": "success", "id": db_item.id}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/")
async def health_check():
    return {"status": "running", "timestamp": datetime.datetime.now(), "service": "ESG Material API"}
