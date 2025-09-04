from typing import Type, Any

from fastapi import HTTPException
from sqlalchemy import and_
from sqlalchemy.orm import Session

def _calc_comparison(current_value, last_value):
    try:
        if last_value is None or last_value == 0 or current_value is None:
            return None
        value = ((current_value - last_value) / last_value) * 100
        return round(value, 2)
    except Exception:
        return None


async def fetch_data(db: Session, model: Type[Any], factory: str, year: int, current_user: dict, field_mapping: dict):
    try:
        if current_user["account_type"] == "factory" and current_user["factory"] != factory:
            raise HTTPException(status_code=403, detail="无权访问其他工厂数据")

        data = db.query(model).filter(
            and_(getattr(model, "factory") == factory, getattr(model, "year") == year)).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}

        data_dict = {key: getattr(data, field) for key, field in field_mapping.items()}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


async def submit_data(db: Session, model: Type[Any], data: Any, current_user: dict, field_mapping: dict):
    try:
        if current_user["account_type"] == "headquarters":
            raise HTTPException(status_code=403, detail="总部账号无权提交数据")
        if current_user["account_type"] == "factory" and current_user["factory"] != data.factory:
            raise HTTPException(status_code=403, detail="无权提交其他工厂数据")

        db_record = model(**{field: getattr(data, key) for key, field in field_mapping.items()})
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

