from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import InvestmentData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import InvestmentSubmission

router = APIRouter(prefix="/quantitative/investment", tags=["定量数据-资金投入"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        data = db.query(InvestmentData).filter(InvestmentData.factory == factory, InvestmentData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"envInvest": data.env_invest, "cleanTechInvest": data.clean_tech_invest,
                     "climateInvest": data.climate_invest, "greenIncome": data.green_income,
                     "totalRevenue": data.total_revenue}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: InvestmentSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = InvestmentData(factory=data.factory, year=data.year, env_invest=data.envInvest,
                                   clean_tech_invest=data.cleanTechInvest, climate_invest=data.climateInvest,
                                   green_income=data.greenIncome, total_investment=data.totalInvestment,
                                   green_income_ratio=data.greenIncomeRatio, total_revenue=data.totalRevenue,
                                   env_invest_intensity=data.envInvestIntensity)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"资金投入数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(InvestmentData).filter(InvestmentData.factory == factory, InvestmentData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的资金投入数据")
    return record
