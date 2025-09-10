from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import MaterialData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import MaterialSubmission

router = APIRouter(prefix="/quantitative/material", tags=["定量数据-物料"])


@router.get("")
async def fetch_material_data(factory: str, year: int, db: Session = Depends(get_db),
                              current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
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

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_material_data(data: MaterialSubmission, db: Session = Depends(get_db),
                               current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = MaterialData(factory=data.factory, year=data.year, renewable_input=data.renewableInput,
                                 non_renewable_input=data.nonRenewableInput, renewable_output=data.renewableOutput,
                                 non_renewable_output=data.nonRenewableOutput,
                                 material_consumption=data.materialConsumption, wood_fiber=data.woodFiber,
                                 aluminum=data.aluminum, packaging_material=data.packagingMaterial,
                                 paper_consumption=data.paper, total_revenue=data.total_revenue,
                                 packaging_intensity=data.packagingIntensity, paper_intensity=data.paperIntensity,
                                 total_input=data.totalInput, total_output=data.totalOutput,
                                 renewable_input_ratio=data.renewableInputRatio,
                                 renewable_output_ratio=data.renewableOutputRatio)

        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{factory}/{year}")
async def get_material_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(MaterialData).filter(MaterialData.factory == factory, MaterialData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的物料数据")
    return record
