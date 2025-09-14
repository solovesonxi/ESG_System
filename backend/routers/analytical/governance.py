from typing import Dict

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import GovernanceQualitative
from core.permissions import require_access, get_current_user, require_factory, check_factory_year
from core.schemas import GovernanceQualitativeSubmission

router = APIRouter(prefix="/analytical/governance", tags=["分析数据-管治定性"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        records = db.query(GovernanceQualitative).filter(GovernanceQualitative.factory == factory,
                                                         GovernanceQualitative.year == year).all()
        if not records:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}

        # Transform records into nested dictionary format
        data_dict: Dict = {}
        for record in records:
            category, indicator = record.indicator.split(".", 1) if "." in record.indicator else ("默认",
                                                                                                  record.indicator)
            if category not in data_dict:
                data_dict[category] = {}
            data_dict[category][indicator] = {"explanation": record.explanation, "source": record.source,
                "current_text": record.current_text, "last_text": record.last_text,
                "comparison_text": record.comparison_text, "reason": record.reason}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: GovernanceQualitativeSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        check = check_factory_year(data.factory, data.year, db, data.isSubmitted, 6)
        if check["status"] == "fail":
            return check
        # Delete existing records for the factory and year to avoid duplicates
        db.query(GovernanceQualitative).filter(GovernanceQualitative.factory == data.factory,
                                               GovernanceQualitative.year == data.year).delete()

        # Insert new records
        for category, indicators in data.data.items():
            for indicator, item in indicators.items():
                db_record = GovernanceQualitative(factory=data.factory, year=data.year,
                    indicator=f"{category}.{indicator}" if category != "默认" else indicator,
                    explanation=item.explanation, source=item.source, current_text=item.current_text,
                    last_text=item.last_text, comparison_text=item.comparison_text, reason=item.reason)
                db.merge(db_record)

        db.commit()
        return {"status": "success", "factory": data.factory, "year": data.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    records = db.query(GovernanceQualitative).filter(GovernanceQualitative.factory == factory,
                                                     GovernanceQualitative.year == year).all()
    if not records:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的管治定性数据")
    return records
