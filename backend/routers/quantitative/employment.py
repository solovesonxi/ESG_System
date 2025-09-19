from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import EmploymentData
from core.permissions import get_current_user
from core.schemas import EmploymentSubmission
from core.utils import submit_data, get_review_info, require_view

router = APIRouter(prefix="/quantitative/employment", tags=["定量数据-雇佣"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, "employment", current_user)
        data = db.query(EmploymentData).filter(EmploymentData.factory == factory, EmploymentData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"fullTime": data.full_time, "partTime": data.part_time, "male": data.male, "female": data.female,
            "management": data.management, "managementFemale": data.management_female, "middle": data.middle,
            "general": data.general, "mainland": data.mainland, "overseas": data.overseas, "eduPhd": data.edu_phd,
            "eduMaster": data.edu_master, "eduBachelor": data.edu_bachelor, "eduJunior": data.edu_junior,
            "avgSocialFund": data.avg_social_fund, "incSocialFund": data.inc_social_fund, "age18_30": data.age18_30,
            "age31_45": data.age31_45, "age46_60": data.age46_60, "newHires": data.new_hires,
            "quitMale": data.quit_male, "quitFemale": data.quit_female, "quitMainland": data.quit_mainland,
            "quitOverseas": data.quit_overseas, "quit18_30": data.quit18_30, "quit31_45": data.quit31_45,
            "quit46_60": data.quit46_60, "quitManagement": data.quit_management, "quitMiddle": data.quit_middle,
            "quitGeneral": data.quit_general}
        return {"status": "success", "data": data_dict,
                "review": get_review_info(db, factory, year, "employment")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_employment_data(data: EmploymentSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, EmploymentData, data, current_user, "employment")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EmploymentData).filter(EmploymentData.factory == factory, EmploymentData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的雇佣数据")
    return record
