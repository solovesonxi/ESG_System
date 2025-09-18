from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import MaterialData
from core.permissions import get_current_user, require_view
from core.schemas import MaterialSubmission
from core.utils import submit_data

router = APIRouter(prefix="/quantitative/material", tags=["定量数据-物料"])


@router.get("")
async def fetch_material_data(factory: str, year: int, db: Session = Depends(get_db),
                              current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        data = db.query(MaterialData).filter(MaterialData.factory == factory, MaterialData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}

        data_dict = {"renewableInput": data.renewable_input, "nonRenewableInput": data.non_renewable_input,
                     "renewableOutput": data.renewable_output, "nonRenewableOutput": data.non_renewable_output,
                     "materialConsumption": data.material_consumption, "woodFiber": data.wood_fiber,
                     "aluminum": data.aluminum, "packagingMaterial": data.packaging_material,
                     "paper": data.paper_consumption, "total_revenue": data.total_revenue,
                     "packagingIntensity": data.packaging_intensity, "paperIntensity": data.paper_intensity,
                     "totalInput": data.total_input, "totalOutput": data.total_output,
                     "renewableInputRatio": data.renewable_input_ratio,
                     "renewableOutputRatio": data.renewable_output_ratio}

        return {"status": "success", "data": data_dict,
                "review": {"status": data.review_status, "comment": data.review_comment}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_material_data(data: MaterialSubmission, db: Session = Depends(get_db),
                               current_user: dict = Depends(get_current_user)):
    return await submit_data(db, MaterialData, data, current_user, "material")


@router.get("/{factory}/{year}")
async def get_material_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(MaterialData).filter(MaterialData.factory == factory, MaterialData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的物料数据")
    return record
