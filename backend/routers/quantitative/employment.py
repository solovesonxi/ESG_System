from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import EmploymentData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import EmploymentSubmission

router = APIRouter(prefix="/quantitative/employment", tags=["定量数据-雇佣"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
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
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: EmploymentSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = EmploymentData(factory=data.factory, year=data.year, full_time=data.fullTime,
                                   part_time=data.partTime, male=data.male, female=data.female,
                                   management=data.management, management_female=data.managementFemale,
                                   middle=data.middle, general=data.general, mainland=data.mainland,
                                   overseas=data.overseas, edu_phd=data.eduPhd, edu_master=data.eduMaster,
                                   edu_bachelor=data.eduBachelor, edu_junior=data.eduJunior,
                                   avg_social_fund=data.avgSocialFund, inc_social_fund=data.incSocialFund,
                                   age18_30=data.age18_30, age31_45=data.age31_45, age46_60=data.age46_60,
                                   new_hires=data.newHires, quit_male=data.quitMale, quit_female=data.quitFemale,
                                   quit_mainland=data.quitMainland, quit_overseas=data.quitOverseas,
                                   quit18_30=data.quit18_30, quit31_45=data.quit31_45, quit46_60=data.quit46_60,
                                   quit_management=data.quitManagement, quit_middle=data.quitMiddle,
                                   quit_general=data.quitGeneral, total_employees=data.totalEmployees,
                                   quit_total=data.quitTotal, turnover_rate=data.turnoverRate,
                                   male_turnover_rate=data.maleTurnoverRate,
                                   female_turnover_rate=data.femaleTurnoverRate,
                                   mainland_turnover_rate=data.mainlandTurnoverRate,
                                   overseas_turnover_rate=data.overseasTurnoverRate,
                                   age18_30_turnover_rate=data.age18_30TurnoverRate,
                                   age31_45_turnover_rate=data.age31_45TurnoverRate,
                                   age46_60_turnover_rate=data.age46_60TurnoverRate,
                                   management_turnover_rate=data.managementTurnoverRate,
                                   middle_turnover_rate=data.middleTurnoverRate,
                                   general_turnover_rate=data.generalTurnoverRate)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"雇佣数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EmploymentData).filter(EmploymentData.factory == factory, EmploymentData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的雇佣数据")
    return record
