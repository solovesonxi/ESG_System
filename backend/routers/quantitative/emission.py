from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import EmissionData
from core.schemas import EmissionSubmission

router = APIRouter(prefix="/quantitative/emission", tags=["定量数据-排放"])


@router.get("")
async def fetch_data(factory: str, year: int, db: Session = Depends(get_db)):
    try:
        data = db.query(EmissionData).filter(EmissionData.factory == factory, EmissionData.year == year).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}
        data_dict = {}

        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("")
async def submit_data(data: EmissionSubmission, db: Session = Depends(get_db)):
    try:
        db_data = EmissionData(factory=data.factory, year=data.year, category_one=data.categoryOne,
                               category_two=data.categoryTwo, category_three=data.categoryThree,
                               category_four=data.categoryFour, category_five=data.categoryFive,
                               category_six=data.categorySix, total_revenue=data.total_revenue,
                               category_three_total=data.categoryThreeTotal, total_emission=data.totalEmission,
                               emission_intensity=data.emissionIntensity, voc=data.voc, nmhc=data.nmhc,
                               benzene=data.benzene, particulate=data.particulate, nox_sox_other=data.nox_sox_other,
                               waste_gas_total=data.wasteGasTotal)
        db.add(db_data)
        db.commit()
        return {"status": "success", "id": db_data.id}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


@router.get("/{factory}/{year}")
async def get_data(factory: str, year: int, db: Session = Depends(get_db)):
    record = db.query(EmissionData).filter(EmissionData.factory == factory, EmissionData.year == year).first()
    if not record:
        raise HTTPException(status_code=404, detail=f"找不到 {factory} {year} 年的排放数据")
    return record
