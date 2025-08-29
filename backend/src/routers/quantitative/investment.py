from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from src.core.database import get_db
from src.core.models import InvestmentData
from src.core.schemas import InvestmentSubmission

router = APIRouter(prefix="/quantitative/investment", tags=["定量数据-资金投入"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(InvestmentData).filter(InvestmentData.factory == factory, InvestmentData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: InvestmentSubmission, db: Session = Depends(get_db)):
    try:
        record = InvestmentData(factory=data.factory, year=data.year, env_invest=data.envInvest,
                                clean_tech_invest=data.cleanTechInvest, climate_invest=data.climateInvest,
                                green_income=data.greenIncome, env_invest_total=data.envInvestTotal,
                                clean_tech_invest_total=data.cleanTechInvestTotal,
                                climate_invest_total=data.climateInvestTotal, green_income_total=data.greenIncomeTotal,
                                total_investment=data.totalInvestment, green_income_ratio=data.greenIncomeRatio,
                                total_revenue=data.totalRevenue, env_invest_intensity=data.envInvestIntensity)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"资金投入数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(InvestmentData).filter(InvestmentData.factory == factory, InvestmentData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的资金投入数据")
    return record
