from collections import defaultdict
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import and_, JSON
from sqlalchemy.orm import Session

from core.dependencies import get_db, logger
from core.models import FieldData, ReviewRecord
from core.permission import get_current_user
from core.utils import get_review_info, require_edit, send_message, get_model

router = APIRouter(prefix="/month", tags=["月度数据"])


@router.get("")
def fetch_data(category_id: int, factory: str, year: int, db: Session = Depends(get_db),
               current_user: dict = Depends(get_current_user)):
    # 访问控制：部门/工厂只能查看自身数据；总部/管理员可查看所有
    role = current_user.get("role")
    if role in ["headquarter", "admin"]:
        pass
    elif role == "factory":
        if current_user.get("factory") != factory:
            raise HTTPException(status_code=403, detail="无权查看其他工厂数据")
    elif role == "department":
        if current_user.get("factory") != factory:
            raise HTTPException(status_code=403, detail="无权查看其他工厂数据")
        dep_cfg = current_user.get("departments") or {}
        allowed_ids = dep_cfg.get("ids", []) or []
        if category_id not in allowed_ids:
            raise HTTPException(status_code=403, detail="无权查看其他部门数据")
    else:
        raise HTTPException(status_code=403, detail="未知角色无权访问")
    category, model = get_model(category_id, db)
    fields = db.query(FieldData).filter_by(category=category_id, is_active=True).order_by(FieldData.set,
                                                                                          FieldData.id).all()
    grouped = defaultdict(list)
    for f in fields:
        grouped[f.set].append(f)
    row = db.query(model).filter_by(factory=factory, year=year).first()
    monthly_cols = {c.name for c in model.__table__.columns if
                    isinstance(c.type, JSON) or 'json' in str(c.type).lower()}
    result_sets = []
    for set_name, field_objs in grouped.items():
        fields_out = []
        for fo in field_objs:
            name_en = fo.name_en
            unit = fo.unit
            if name_en in monthly_cols:
                val = getattr(row, name_en) if row is not None else None
                fields_out.append(
                    {"name_en": fo.name_en, "name_zh": fo.name_zh, "unit": unit, "value": val, "step": fo.step})
        if fields_out:
            result_sets.append({"set": set_name, "fields": fields_out})
    return {"sets": result_sets, "review": get_review_info(db, factory, year, category_id)}


@router.post("")
def submit_data(payload: dict, db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    category_id = payload.get("category_id")
    factory = payload.get("factory")
    year = payload.get("year")
    month = payload.get("month")
    sets = payload.get("sets", [])
    isSubmitted = payload.get("isSubmitted", False)
    category_model, model = get_model(category_id, db)
    category = getattr(category_model, "name_en", None)

    # 1. 权限检查
    require_edit(factory, category_id, current_user)
    # 2. 检查是否已提交
    review_record = db.query(ReviewRecord).filter_by(factory=factory, year=year, month=month, category=category_id).first()
    if review_record and review_record.is_submitted:
        return {"status": "fail", "message": "数据已提交过，请等待审核"}

    # 3. 解析提交的数据并更新数据库
    model_cols = set(model.__table__.columns.keys())
    values = {"factory": factory, "year": year}
    for s in sets:
        for f in s.get("fields", []):
            key = f.get("name_en")
            if key in model_cols:
                values[key] = f.get("value")
    existing = db.query(model).filter(
        and_(getattr(model, "factory") == factory, getattr(model, "year") == year)).first()
    if existing is not None:
        for k, v in values.items():
            setattr(existing, k, v)
        db.merge(existing)
    else:
        existing = model(**values)
        db.add(existing)

    # 4. 更新/新建审核记录
    if not review_record:
        review_record = ReviewRecord(factory=factory, year=year, month=month, category=category_id)
        db.add(review_record)
    if isSubmitted:
        review_record.is_submitted = True
        review_record.level1_status = "pending"
        review_record.level1_comment = None
        review_record.level1_reviewer = None
        review_record.level1_review_time = None
        review_record.level2_status = "pending"
        review_record.level2_comment = None
        review_record.level2_reviewer = None
        review_record.level2_review_time = None
    db.commit()

    # 5. 推送消息
    now_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    msg_title = f"{"提交" if isSubmitted else "保存"}了{factory}{year}年{month}月的{category_model.name_zh}数据"
    if isSubmitted:
        msg_content = f"{current_user['user'].username}于{now_str}{msg_title}，请工厂及时审核。"
        send_message(db, "月报", msg_title, msg_content, sender_factory=factory, sender_department=category,
                     receiver_factory=factory)
    return {"status": "success"}
