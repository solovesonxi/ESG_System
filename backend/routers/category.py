from typing import Optional

from fastapi import APIRouter, Depends, Query, HTTPException, Body
from pydantic import BaseModel
from sqlalchemy import or_, func
from sqlalchemy.orm import Session

from core.dependencies import get_db, logger
from core.models import Category
from core.permission import admin_required


router = APIRouter(prefix="/category", tags=["分类管理"], dependencies=[Depends(admin_required)])


class CategoryRequest(BaseModel):
    id: Optional[int] = None
    name_en: Optional[str] = None
    name_zh: Optional[str] = None
    model_class: Optional[str] = None
    domain: Optional[str] = None
    period_type: Optional[str] = None
    is_active: Optional[bool] = True


@router.get("")
def get_categories(domain: Optional[str] = Query(None), period_type: Optional[str] = Query(None),
                   keyword: Optional[str] = Query(None), page: int = Query(1, ge=1),
                   page_size: int = Query(20, ge=1, le=200), db: Session = Depends(get_db)):
    try:
        query = db.query(Category)
        domains = (db.query(Category.domain).group_by(Category.domain).order_by(func.min(Category.id).asc()).all())
        if domain:
            query = query.filter(Category.domain == domain)
        if period_type:
            query = query.filter(Category.period_type == period_type)
        if keyword:
            kw = f"%{keyword}%"
            query = query.filter(or_(Category.name_en.ilike(kw), Category.name_zh.ilike(kw)))
        total = query.count()
        items = query.order_by(Category.id.asc()).offset((page - 1) * page_size).limit(page_size).all()

        def to_dict(obj):
            return {c.name: getattr(obj, c.name) for c in obj.__table__.columns}

        return {"domains": [s[0] for s in domains], "categories": [to_dict(i) for i in items], "total": total, "page": page, "page_size": page_size}
    except Exception as e:
        logger.error(f"查询分类列表失败: {e}")
        raise HTTPException(status_code=500, detail="服务器内部错误")


@router.post("/add")
def add_category(data: CategoryRequest, db: Session = Depends(get_db)):
    # Required fields are validated by Pydantic if you make them non-optional; here we check manually
    if not data.name_en or not data.name_zh or not data.model_class or not data.domain or not data.period_type:
        raise HTTPException(status_code=400, detail="缺少必要字段: name_en/name_zh/model_class/domain/period_type")
    try:
        # optional: prevent duplicate name_en
        existing = db.query(Category).filter(Category.name_en == data.name_en).first()
        if existing:
            raise HTTPException(status_code=400, detail="英文标识已存在")
        new_cat = Category(name_en=data.name_en, name_zh=data.name_zh, model_class=data.model_class,
                           domain=data.domain, period_type=data.period_type, is_active=(data.is_active is not False))
        db.add(new_cat)
        db.commit()
        db.refresh(new_cat)
        return {"status": "success", "id": new_cat.id}
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"添加分类失败: {e}")
        raise HTTPException(status_code=500, detail=f"添加失败: {e}")


@router.patch("/update")
def update_category(data: CategoryRequest, db: Session = Depends(get_db)):
    if not data.id:
        raise HTTPException(status_code=400, detail="缺少分类 id")
    cat = db.query(Category).filter(Category.id == data.id).first()
    if not cat:
        raise HTTPException(status_code=404, detail="分类不存在")
    try:
        if data.name_en is not None:
            # avoid duplicate name_en
            dup = db.query(Category).filter(Category.name_en == data.name_en, Category.id != data.id).first()
            if dup:
                raise HTTPException(status_code=400, detail="英文标识已存在")
            cat.name_en = data.name_en
        if data.name_zh is not None:
            cat.name_zh = data.name_zh
        if data.model_class is not None:
            cat.model_class = data.model_class
        if data.domain is not None:
            cat.domain = data.domain
        if data.period_type is not None:
            cat.period_type = data.period_type
        if data.is_active is not None:
            cat.is_active = data.is_active
        db.commit()
        db.refresh(cat)
        return {"status": "success"}
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"更新分类失败: {e}")
        raise HTTPException(status_code=500, detail=f"更新失败: {e}")


@router.delete("/delete")
def delete_category(id: int = Body(..., embed=True), db: Session = Depends(get_db)):
    cat = db.query(Category).filter(Category.id == id).first()
    if not cat:
        raise HTTPException(status_code=404, detail="分类不存在")
    try:
        db.delete(cat)
        db.commit()
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        logger.error(f"删除分类失败: {e}")
        raise HTTPException(status_code=500, detail=f"删除失败: {e}")


@router.patch("/toggle-status")
def toggle_category_status(id: int = Body(...), is_active: bool = Body(...), db: Session = Depends(get_db)):
    cat = db.query(Category).filter(Category.id == id).first()
    if not cat:
        raise HTTPException(status_code=404, detail="分类不存在")
    cat.is_active = is_active
    db.commit()
    return {"status": "success"}

