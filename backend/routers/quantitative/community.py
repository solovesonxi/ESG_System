from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import CommunityData, VolunteerData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import CommunitySubmission

router = APIRouter(prefix="/quantitative/community", tags=["定量数据-社区参与"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        community_data = db.query(CommunityData).filter(CommunityData.factory == factory,
                                                        CommunityData.year == year).first()
        volunteer_data = db.query(VolunteerData).filter(VolunteerData.factory == factory,
                                                        VolunteerData.year == year).first()
        if not community_data and not volunteer_data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        return {"status": "success", "data": {"charityDonations": community_data.charity_donations,
                                              "communityInvestment": community_data.community_investment,
                                              "volunteerParticipants": volunteer_data.volunteer_participants,
                                              "volunteerHours": volunteer_data.volunteer_hours}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: CommunitySubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        # Community Data
        community_record = CommunityData(factory=data.factory, year=data.year, charity_donations=data.charityDonations,
                                         community_investment=data.communityInvestment)
        db.merge(community_record)

        # Volunteer Data
        volunteer_record = VolunteerData(factory=data.factory, year=data.year,
                                         volunteer_participants=data.volunteerParticipants,
                                         volunteer_hours=data.volunteerHours)
        db.merge(volunteer_record)

        db.commit()
        return {"status": "success", "factory": community_record.factory, "year": community_record.year}
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

    return {"community": community_record, "volunteer": volunteer_record}
