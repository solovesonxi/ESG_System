from collections import defaultdict
from datetime import datetime

from fastapi import APIRouter
from fastapi import Depends, HTTPException
from sqlalchemy import and_
from sqlalchemy.orm import Session

from core.calculations import compute_field_value
from core.dependencies import get_db, logger
from core.models import FieldData, ReviewRecord
from core.permission import get_current_user
from core.utils import get_review_info, require_edit, send_message, get_model, calc_comparison

router = APIRouter(prefix="/year", tags=["年度数据"])


@router.get("")
def fetch_data(category_id: int, factory: str, year: int, db: Session = Depends(get_db),
               current_user: dict = Depends(get_current_user)):
    # 访问控制：部门/工厂只能查看自身工厂；总部/管理员可查看所有
    role = current_user.get("role")
    if role in ["headquarter", "admin"]:
        pass
    elif role in ["factory", "department"]:
        if current_user.get("factory") != factory:
            raise HTTPException(status_code=403, detail="无权查看其他工厂数据")
    else:
        raise HTTPException(status_code=403, detail="未知角色无权访问")
    category, model = get_model(category_id, db)
    fields = db.query(FieldData).filter_by(category=category_id, is_active=True).order_by(FieldData.set,
                                                                                          FieldData.id).all()
    grouped = defaultdict(list)
    for f in fields:
        grouped[f.set].append(f)
    result_sets = []
    is_quantitative = '定量' in str(category.name_zh)
    ordered_set_names = sorted(grouped.keys(), key=lambda s: min(f.id for f in grouped[s]))
    for set_name in ordered_set_names:
        field_objs = grouped[set_name]
        fields_out = []
        for fo in field_objs:
            name_en = fo.name_en
            if is_quantitative:
                # 定量指标：计算今年、去年、增长率
                current_row = db.query(model).filter_by(factory=factory, year=year, indicator=name_en).first()
                if fo.calculation:
                    current_value = compute_field_value(fo.calculation, db, factory, year)
                    last_value = compute_field_value(fo.calculation, db, factory, year - 1)
                else:  # 没有计算公式，直接查数据库
                    current_value = getattr(current_row, 'value', None) if current_row else None
                    last_row = db.query(model).filter_by(factory=factory, year=year - 1, indicator=name_en).first()
                    last_value = getattr(last_row, 'value', None) if last_row else None
                comparison = calc_comparison(current_value, last_value)
                reason = getattr(current_row, 'reason', '') if current_row else ''
                fields_out.append(
                    {"name_en": fo.name_en, "name_zh": fo.name_zh, "calculation": fo.calculation or None,"unit": fo.unit, "description": fo.description,
                     "source": fo.source, "lastYear": last_value if last_value else None,
                     "currentYear": current_value if current_value else None, "comparison": comparison,
                     "reason": reason, })
            else:
                # 定性指标：查本年和去年结果
                qual_row = db.query(model).filter_by(factory=factory, year=year, indicator=name_en).first()
                last_row = db.query(model).filter_by(factory=factory, year=year - 1, indicator=name_en).first()
                fields_out.append(
                    {"name_en": fo.name_en, "name_zh": fo.name_zh, "description": fo.description, "source": fo.source,
                     "lastYear": getattr(last_row, 'current_text', None) if last_row else None,
                     "currentYear": getattr(qual_row, 'current_text', None) if qual_row else None,
                     "comparison": getattr(qual_row, 'comparison_text', None) if qual_row else None,
                     "reason": getattr(qual_row, 'reason', None) if qual_row else None, })
        if fields_out:
            result_sets.append({"set": set_name, "fields": fields_out})
    return {"is_quant": is_quantitative, "sets": result_sets, "review": get_review_info(db, factory, year, category_id)}


@router.post("")
def submit_data(payload: dict, db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    category_id = payload.get("category_id")
    factory = payload.get("factory")
    year = payload.get("year")
    sets = payload.get("sets", [])
    isSubmitted = payload.get("isSubmitted", False)
    category_model, model = get_model(category_id, db)
    category = getattr(category_model, "name_en", None)
    is_quantitative = '定量' in str(category_model.name_zh)
    logger.info(f"提交{factory}{year}年的{category}数据")
    # 1. 权限检查
    require_edit(factory, category_id, current_user)
    # 2. 检查是否已提交
    review_record = db.query(ReviewRecord).filter_by(factory=factory, year=year, category=category_id).first()
    if review_record and review_record.is_submitted:
        return {"status": "fail", "message": "数据已提交过，请等待审核"}
    logger.info(f"还未提交，继续处理数据")

    # 3. 解析提交的数据并更新数据库
    model_cols = {name for (name,) in db.query(FieldData.name_en).filter_by(category=category_id, is_active=True).all()}
    values = []
    for s in sets:
        for f in s.get("fields", []):
            key = f.get("name_en")
            if key in model_cols:
                if is_quantitative:
                    values.append({"factory": factory, "year": year, "indicator": key, "value": f.get("currentYear"),"reason": f.get("reason")})
                else:
                    values.append(
                        {"factory": factory, "year": year, "indicator": key, "current_text": f.get("currentYear"),
                         "comparison_text": f.get("comparison"), "reason": f.get("reason")})
    for v in values:
        existing = db.query(model).filter(and_(getattr(model, "factory") == factory, getattr(model, "year") == year,
                                               getattr(model, "indicator") == v.get("indicator", ""))).first()
        if existing is not None:
            if is_quantitative:
                setattr(existing, 'value', v.get('value'))
            else:
                setattr(existing, 'current_text', v.get('current_text'))
                setattr(existing, 'comparison_text', v.get('comparison_text'))
            setattr(existing, 'reason', v.get('reason'))
            db.merge(existing)
            logger.info(f"合并{existing}")
        else:
            existing = model(**v)
            db.add(existing)
            logger.info(f"新增{existing}")

    logger.info(f"解析成功，更新数据库完成")

    # 4. 更新/新建审核记录
    if not review_record:
        review_record = ReviewRecord(factory=factory, year=year, category=category_id)
        db.add(review_record)
    if isSubmitted:
        review_record.is_submitted = True
        review_record.level1_status = "pending"
        review_record.level1_comment = None
        review_record.level1_reviewer = None
        review_record.level1_review_time = None
    db.commit()
    logger.info(f"更新审核记录完成")

    # 5. 推送消息
    now_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    msg_title = f"{"提交" if isSubmitted else "保存"}了{factory}{year}年的{category_model.name_zh}数据"
    if isSubmitted:
        msg_content = f"{current_user['user'].username}于{now_str}{msg_title}，请总部及时审核。"
        send_message(db, "年报", msg_title, msg_content, sender_role='factory', sender_factory=factory,
                     receiver_role='headquarter')
        send_message(db, "年报", msg_title, msg_content, sender_role='factory', sender_factory=factory,
                     receiver_role='admin')
    logger.info(f"消息推送完成")

    return {"status": "success"}
