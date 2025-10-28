import json
from typing import Optional, Union

from fastapi import APIRouter, Depends, Query, HTTPException, Body
from pydantic import BaseModel
from sqlalchemy import or_, func
from sqlalchemy.orm import Session

from core.dependencies import get_db, logger
from core.models import FieldData
from core.permission import admin_required

router = APIRouter(prefix="/field", tags=["字段管理"], dependencies=[Depends(admin_required)])


class FieldRequest(BaseModel):
    # make optional fields explicit with defaults so missing fields are accepted
    id: Optional[int] = None
    category: int
    set: str
    name_en: str
    name_zh: Optional[str] = None
    step: Optional[float] = None
    calculation: Optional[Union[dict, str, None]] = None
    unit: Optional[str] = None
    description: Optional[str] = None
    source: Optional[str] = None
    is_active: Optional[bool] = True


@router.get("")
def get_fields(category: Optional[int] = Query(None), set: Optional[str] = Query(None),
               keyword: Optional[str] = Query(None), page: int = Query(1, ge=1),
               page_size: int = Query(20, ge=1, le=200), db: Session = Depends(get_db)):
    try:
        query = db.query(FieldData)
        sets = (db.query(FieldData.set).group_by(FieldData.set).order_by(func.min(FieldData.id).asc()).all())
        if category is not None and category != "":
            try:
                query = query.filter(FieldData.category == category)
            except ValueError:
                pass
        if set:
            query = query.filter(FieldData.set == set)
        if keyword:
            kw = f"%{keyword}%"
            query = query.filter(or_(FieldData.name_en.ilike(kw), FieldData.name_zh.ilike(kw)))
        total = query.count()
        fields = query.order_by(FieldData.id.asc()).offset((page - 1) * page_size).limit(page_size).all()
        return {"sets": [s[0] for s in sets], "fields": [f.__dict__ for f in fields], "total": total, "page": page,
                "page_size": page_size}
    except Exception as e:
        logger.error(f"查询字段列表失败: {e}")
        raise HTTPException(status_code=500, detail="服务器内部错误")


@router.post("/add")
def add_field(data: FieldRequest, db: Session = Depends(get_db)):
    try:
        calc = data.calculation
        if isinstance(calc, str):
            try:
                calc = json.loads(calc)
            except ValueError:
                pass
        new_field = FieldData(category=data.category, set=data.set, name_en=data.name_en, name_zh=data.name_zh,
                              step=data.step, calculation=calc, unit=data.unit, description=data.description,
                              source=data.source)
        db.add(new_field)
        db.commit()
        db.refresh(new_field)
        return {"status": "success", "id": new_field.id}
    except Exception as e:
        db.rollback()
        logger.error(f"添加字段失败: {e}")
        raise HTTPException(status_code=500, detail=f"添加失败: {e}")


@router.patch("/update")
def update_field(data: FieldRequest, db: Session = Depends(get_db)):
    if not data.id:
        raise HTTPException(status_code=400, detail="缺少字段 id")
    field = db.query(FieldData).filter(FieldData.id == data.id).first()
    if not field:
        raise HTTPException(status_code=404, detail="字段不存在")
    try:
        # update only provided fields
        field.category = data.category
        field.set = data.set
        field.name_en = data.name_en
        field.name_zh = data.name_zh
        field.step = data.step
        calc = data.calculation
        if isinstance(calc, str):
            try:
                calc = json.loads(calc)
            except ValueError:
                pass
        field.calculation = calc
        field.unit = data.unit
        field.description = data.description
        field.source = data.source
        if data.is_active is not None:
            field.is_active = data.is_active
        db.commit()
        db.refresh(field)
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        logger.error(f"更新字段失败: {e}")
        raise HTTPException(status_code=500, detail=f"更新失败: {e}")


@router.delete("/delete")
def delete_field(id: int = Body(..., embed=True), db: Session = Depends(get_db)):
    field = db.query(FieldData).filter(FieldData.id == id).first()
    if not field:
        raise HTTPException(status_code=404, detail="字段不存在")
    try:
        db.delete(field)
        db.commit()
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        logger.error(f"删除字段失败: {e}")
        raise HTTPException(status_code=500, detail=f"删除失败: {e}")


@router.patch("/toggle-status")
def toggle_account_status(id: int = Body(...), is_active: bool = Body(...), db: Session = Depends(get_db)):
    field = db.query(FieldData).filter_by(id = id).first()
    if not field:
        raise HTTPException(status_code=404, detail="字段不存在")
    field.is_active = is_active
    db.commit()
    return {"status": "success"}