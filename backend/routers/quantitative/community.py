from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import CommunityData, VolunteerData
from core.schemas import CommunitySubmission, VolunteerSubmission

router = APIRouter(prefix="/quantitative/community", tags=["定量数据-社区参与"])

@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        community_data = db.query(CommunityData).filter(CommunityData.factory == factory, 
                                                       CommunityData.year == year).first()
        volunteer_data = db.query(VolunteerData).filter(VolunteerData.factory == factory, 
                                                       VolunteerData.year == year).first()
        
        community_dict = {
            "donation_total": community_data.donation_total,
            "community_investment": community_data.community_investment
        } if community_data else None
        
        volunteer_dict = {
            "participants": volunteer_data.participants,
            "hours_total": volunteer_data.hours_total
        } if volunteer_data else None
        
        if not community_data and not volunteer_data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        
        return {
            "status": "success",
            "data": {
                "community": community_dict,
                "volunteer": volunteer_dict
            }
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("")
async def submit_data(data: CommunitySubmission, db: Session = Depends(get_db)):
    try:
        # Community Data
        community_record = CommunityData(
            factory=data.factory,
            year=data.year,
            donation_total=data.donation_total,
            community_investment=data.community_investment
        )
        db.merge(community_record)

        # Volunteer Data
        volunteer_record = VolunteerData(
            factory=data.factory,
            year=data.year,
            participants=data.participants,
            hours_total=data.hours_total
        )
        db.merge(volunteer_record)

        db.commit()
        return {
            "status": "success",
            "factory": community_record.factory,
            "year": community_record.year
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")

@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    community_record = db.query(CommunityData).filter(CommunityData.factory == factory, 
                                                     CommunityData.year == year).first()
    volunteer_record = db.query(VolunteerData).filter(VolunteerData.factory == factory, 
                                                     VolunteerData.year == year).first()
    
    if not community_record and not volunteer_record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的社区参与数据")
    
    return {
        "community": community_record,
        "volunteer": volunteer_record
    }
