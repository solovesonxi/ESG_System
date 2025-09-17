from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import IPData
from core.permissions import get_current_user, require_view
from core.schemas import IPSubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/ip", tags=["定量数据-知识产权"])


def sum_list(lst):
    return sum(x for x in lst if x not in (None, 0))


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(IPData).filter(IPData.factory == factory, IPData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        prev_data = db.query(IPData).filter(IPData.factory == factory, IPData.year < year).all()

        def sum_field(field):
            return sum(sum_list(getattr(d, field)) for d in prev_data) if prev_data else 0

        data_dict = {"patents": data.patents, "invPatents": data.inv_patents, "invApplications": data.inv_applications,
                     "utilityPatents": data.utility_patents, "designPatents": data.design_patents,
                     "grantedPatents": data.granted_patents, "softwareCopyrights": data.software_copyrights,
                     "trademarks": data.trademarks, "prevPatents": sum_field("patents"),
                     "prevInvPatents": sum_field("inv_patents"), "prevInvApplications": sum_field("inv_applications"),
                     "prevUtilityPatents": sum_field("utility_patents"),
                     "prevDesignPatents": sum_field("design_patents"),
                     "prevGrantedPatents": sum_field("granted_patents"),
                     "prevSoftwareCopyrights": sum_field("software_copyrights"),
                     "prevTrademarks": sum_field("trademarks"), }
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_ip_data(data: IPSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, IPData, data, current_user, "ip")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(IPData).filter(IPData.factory == factory, IPData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的知识产权数据")
    return record
