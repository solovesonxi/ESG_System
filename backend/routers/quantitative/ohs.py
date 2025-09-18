from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import OHSData
from core.permissions import get_current_user, require_view
from core.schemas import OHSSubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/ohs", tags=["定量数据-职健与安全"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"trainingCount": data.training_count, "trainingParticipants": data.training_participants,
                     "trainingHours": data.training_hours, "injuryCount": data.injury_count,
                     "incidentCount": data.incident_count, "fatalityCount": data.fatality_count,
                     "lostWorkdays": data.lost_workdays, "safetyInvestment": data.safety_investment,
                     "safetyManagers": data.safety_managers, "medicalChecks": data.medical_checks,
                     "coverageRate": data.coverage_rate, "emergencyDrills": data.emergency_drills,
                     "hazardsFound": data.hazards_found, "occupationalChecks": data.occupational_checks}
        return {"status": "success", "data": data_dict,
                "review": {"status": data.review_status, "comment": data.review_comment}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_ohs_data(data: OHSSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, OHSData, data, current_user, "ohs")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的职健与安全数据")
    return record
