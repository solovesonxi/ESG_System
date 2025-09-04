from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import OHSData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import OHSSubmission

router = APIRouter(prefix="/quantitative/ohs", tags=["定量数据-职健与安全"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        data = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: OHSSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = OHSData(factory=data.factory, year=data.year, training_count=data.trainingCount,
                            training_participants=data.trainingParticipants, training_hours=data.trainingHours,
                            injury_count=data.injuryCount, incident_count=data.incidentCount,
                            fatality_count=data.fatalityCount, lost_workdays=data.lostWorkdays,
                            safety_investment=data.safetyInvestment, training_count_total=data.trainingCountTotal,
                            training_participants_total=data.trainingParticipantsTotal,
                            training_hours_total=data.trainingHoursTotal, injury_count_total=data.injuryCountTotal,
                            incident_count_total=data.incidentCountTotal, fatality_count_total=data.fatalityCountTotal,
                            lost_workdays_total=data.lostWorkdaysTotal,
                            safety_investment_total=data.safetyInvestmentTotal, safety_managers=data.safetyManagers,
                            medical_checks=data.medicalChecks, coverage_rate=data.coverageRate,
                            emergency_drills=data.emergencyDrills, hazards_found=data.hazardsFound,
                            occupational_checks=data.occupationalChecks)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的职健与安全数据")
    return record
