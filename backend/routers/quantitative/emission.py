from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import EmissionData
from core.permissions import get_current_user, require_access, require_factory
from core.schemas import EmissionSubmission

router = APIRouter(prefix="/quantitative/emission", tags=["定量数据-排放"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db),
                     current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
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
async def submit_data(data: EmissionSubmission, db: Session = Depends(get_db),
                      current_user: dict = Depends(get_current_user)):
    try:
        require_factory(data.factory, current_user)
        db_record = EmissionData(factory=data.factory, year=data.year, category_one=data.categoryOne,
                                 category_two=data.categoryTwo, category_three=data.categoryThree,
                                 category_four=data.categoryFour, category_five=data.categoryFive,
                                 category_six=data.categorySix, total_revenue=data.total_revenue,
                                 category_three_total=data.categoryThreeTotal, total_emission=data.totalEmission,
                                 emission_intensity=data.emissionIntensity, voc=data.voc, nmhc=data.nmhc,
                                 benzene=data.benzene, particulate=data.particulate, nox_sox_other=data.nox_sox_other,
                                 waste_gas_total=data.wasteGasTotal)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EmissionData).filter(EmissionData.factory == factory, EmissionData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的排放数据")
    return record
