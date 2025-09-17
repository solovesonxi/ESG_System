from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import CommunityData
from core.permissions import get_current_user, require_view
from core.schemas import CommunitySubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/community", tags=["定量数据-社区参与"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(CommunityData).filter(CommunityData.factory == factory,
                                                        CommunityData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        return {"status": "success", "data": {"charityDonations": data.charity_donations,
                                              "communityInvestment": data.community_investment,
                                              "volunteerParticipants": data.volunteer_participants,
                                              "volunteerHours": data.volunteer_hours}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_community_data(data: CommunitySubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, CommunityData, data, current_user, "community")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    community_record = db.query(CommunityData).filter(CommunityData.factory == factory,
                                                      CommunityData.year == year).first()
    if not community_record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的社区参与数据")
    return {"community": community_record}
