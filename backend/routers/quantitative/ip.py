from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import IPRData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import IPSubmission

router = APIRouter(prefix="/quantitative/ip", tags=["定量数据-知识产权"])


def sum_list(lst):
    return sum(x for x in lst if x not in (None, 0))


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        data = db.query(IPRData).filter(IPRData.factory == factory, IPRData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        prev_data = db.query(IPRData).filter(IPRData.factory == factory, IPRData.year < year).all()

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
async def submit_data(data: IPSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = IPRData(factory=data.factory, year=data.year, patents=data.patents, inv_patents=data.invPatents,
                            utility_patents=data.utilityPatents, design_patents=data.designPatents,
                            granted_patents=data.grantedPatents, software_copyrights=data.softwareCopyrights,
                            trademarks=data.trademarks, new_patents=data.newPatents, patents_total=data.patentsTotal,
                            inv_patents_total=data.invPatentsTotal, inv_applications_total=data.invApplicationsTotal,
                            utility_patents_total=data.utilityPatentsTotal,
                            design_patents_total=data.designPatentsTotal,
                            granted_patents_total=data.grantedPatentsTotal,
                            software_copyrights_total=data.softwareCopyrightsTotal,
                            trademarks_total=data.trademarksTotal)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(IPRData).filter(IPRData.factory == factory, IPRData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的知识产权数据")
    return record
