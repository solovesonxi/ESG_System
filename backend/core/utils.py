from typing import Type, Any

from fastapi import HTTPException
from sqlalchemy import and_
from sqlalchemy.orm import Session

from core.permissions import require_access, require_factory
from core.dependencies import indicators


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
        require_access(factory, current_user)
        data = db.query(model).filter(
            and_(getattr(model, "factory") == factory, getattr(model, "year") == year)).first()
        if not data:
            return {"status": "success", "data": None, "message": "No data found for the specified factory and year"}

        data_dict = {key: getattr(data, field) for key, field in field_mapping.items()}
        return {"status": "success", "data": data_dict}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


async def submit_data(db: Session, model: Type[Any], data: Any, current_user: dict, field_mapping: str):
    try:
        require_factory(data.factory, current_user)
        existing = db.query(model).filter(
            and_(getattr(model, "factory") == data.factory, getattr(model, "year") == data.year)).first()
        if existing:
            is_submitted = getattr(existing, "is_submitted").copy()
            if is_submitted[data.month - 1]:
                return {"status": "fail", "message": "数据已提交过，若需修改请联系管理员"}
        else:
            is_submitted = [False] * 12
        is_submitted[data.month - 1] = data.isSubmitted
        record_data = {field: getattr(data, key) for key, field in indicators[field_mapping]["submit"].items()}
        record_data["is_submitted"] = is_submitted
        db_record = model(**record_data)
        merged_record = db.merge(db_record)
        db.commit()
        return {"status": "success", "factory": merged_record.factory, "year": merged_record.year}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")
