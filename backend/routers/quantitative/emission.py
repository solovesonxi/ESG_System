from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import EmissionData
from core.permissions import get_current_user, require_view
from core.schemas import EmissionSubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/emission", tags=["定量数据-排放"])


@router.get("")
async def fetch_emission_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(EmissionData).filter(EmissionData.factory == factory, EmissionData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {"category_one": data.category_one, "category_two": data.category_two,
                     "category_three": data.category_three, "category_four": data.category_four,
                     "category_five": data.category_five, "category_six": data.category_six,
                     "total_revenue": data.total_revenue, "voc": data.voc, "nmhc": data.nmhc, "benzene": data.benzene,
                     "particulate": data.particulate, "nox_sox_other": data.nox_sox_other, }
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_emission_data(data: EmissionSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    return await submit_data(db, EmissionData, data, current_user, "emission")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EmissionData).filter(EmissionData.factory == factory, EmissionData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的排放数据")
    return record
