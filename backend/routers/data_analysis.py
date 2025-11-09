from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import FieldData, Category
from core.permission import get_current_user
from core.utils import get_model

router = APIRouter(prefix="/data-analysis", tags=["数据分析"])


class BatchQuery(BaseModel):
    category_id: int
    factories: Optional[List[str]] = []
    fields: Optional[List[int]] = []  # field ids
    years: Optional[List[int]] = []


@router.post("")
def fetch_batch_data(q: BatchQuery, db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    """Fetch multiple factories/years and multiple metric (field) ids for a given category.

    Request JSON: { category_id, factories: [..], fields: [field_id,..], years: [..] }

    Response: { fields: [ {id, name_en, name_zh, unit, step, values: [ {factory, year, value} ] } ] }
    """
    if not current_user:
        raise HTTPException(status_code=401, detail="未认证用户无权访问分析数据")
    role = current_user.get("role")
    if role not in ["headquarter", "admin"]:
        raise HTTPException(status_code=403, detail="无权访问分析数据")

    if not q.years or len(q.years) == 0:
        raise HTTPException(status_code=400, detail="必须提供要查询的年份列表")
    category, model = get_model(q.category_id, db)
    fields_q = db.query(FieldData).filter_by(category=q.category_id, is_active=True)
    if q.fields:
        fields_q = fields_q.filter(FieldData.id.in_(q.fields))
    fields = fields_q.order_by(FieldData.set, FieldData.id).all()
    data_query = db.query(model).filter(getattr(model, 'year').in_(q.years))
    if q.factories:
        factories = [f for f in q.factories if f and str(f).strip()]
        if factories:
            data_query = data_query.filter(getattr(model, 'factory').in_(factories))
    data_rows = data_query.all()
    fields_out = []
    for fo in fields:
        vals = []
        for row in data_rows:
            try:
                v = getattr(row, str(fo.name_en), None)
            except ValueError:
                v = None
            vals.append({"factory": getattr(row, 'factory', None), "year": getattr(row, 'year', None), "value": v})
        fields_out.append({"id": fo.id, "name_en": fo.name_en, "name_zh": fo.name_zh, "unit": fo.unit, "step": fo.step,
                           "values": vals, })
    return {"fields": fields_out}


# New endpoint: return categories and their fields metadata for frontend caching
@router.get("/categories")
def get_categories_meta(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    if not current_user:
        raise HTTPException(status_code=401, detail="未认证用户无权访问分类元数据")
    categories = db.query(Category).filter_by(period_type="month", is_active=True).order_by(Category.id).all()
    out = []
    for c in categories:
        fields = db.query(FieldData).filter_by(category=c.id, is_active=True).order_by(FieldData.set,
                                                                                       FieldData.id).all()
        fields_list = []
        for f in fields:
            fields_list.append({"id": f.id, "name_en": f.name_en, "name_zh": f.name_zh, "unit": f.unit,
                                "description": f.description, })
        out.append({"id": c.id, "name_en": c.name_en, "name_zh": c.name_zh, "fields": fields_list})
    return {"categories": out}
