from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import InvestmentData
from core.permissions import get_current_user, require_view
from core.schemas import InvestmentSubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/investment", tags=["定量数据-资金投入"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(InvestmentData).filter(InvestmentData.factory == factory, InvestmentData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"envInvest": data.env_invest, "cleanTechInvest": data.clean_tech_invest,
                     "climateInvest": data.climate_invest, "greenIncome": data.green_income,
                     "totalRevenue": data.total_revenue}

        return {"status": "success", "data": data_dict,
                "review": {"status": data.review_status, "comment": data.review_comment}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_investment_data(data: InvestmentSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, InvestmentData, data, current_user, "investment")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(InvestmentData).filter(InvestmentData.factory == factory, InvestmentData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的资金投入数据")
    return record
