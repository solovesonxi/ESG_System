from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from src.core.database import get_db
from src.core.models import OHSData
from src.core.schemas import OHSSubmission

router = APIRouter(prefix="/quantitative/ohs", tags=["定量数据-职健与安全"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: OHSSubmission, db: Session = Depends(get_db)):
    try:
        record = OHSData(factory=data.factory, year=data.year, training_count=data.trainingCount,
                         training_participants=data.trainingParticipants, training_hours=data.trainingHours,
                         injury_count=data.injuryCount, incident_count=data.incidentCount,
                         fatality_count=data.fatalityCount, lost_workdays=data.lostWorkdays,
                         safety_investment=data.safetyInvestment, training_count_total=data.trainingCountTotal,
                         training_participants_total=data.trainingParticipantsTotal,
                         training_hours_total=data.trainingHoursTotal, injury_count_total=data.injuryCountTotal,
                         incident_count_total=data.incidentCountTotal, fatality_count_total=data.fatalityCountTotal,
                         lost_workdays_total=data.lostWorkdaysTotal, safety_investment_total=data.safetyInvestmentTotal,
                         safety_managers=data.safetyManagers, medical_checks=data.medicalChecks,
                         coverage_rate=data.coverageRate, emergency_drills=data.emergencyDrills,
                         hazards_found=data.hazardsFound, occupational_checks=data.occupationalChecks)
        db.add(record)
        db.commit()
        return {"status": "success", "id": record.id, "factory": record.factory, "year": record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的职健与安全数据")
    return record
