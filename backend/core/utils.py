from datetime import datetime, timezone

from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.dynamic_mapping import get_monthly_map, get_yearly_map, get_model_for_category
from core.models import Message, ReviewRecord, Category
from core.permission import get_current_user


def calc_comparison(cur, last):
    try:
        if last in [None, 0] or cur is None:
            return None
        return round(100 * (cur - last) / last, 2)
    except ValueError:
        return None


def require_edit(factory: str, category: int, current_user: dict = Depends(get_current_user),
                 db: Session = Depends(get_db)):
    if current_user["role"] == "headquarter":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="总部账号无权提交数据")
    elif current_user["role"] == "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="管理员账号无权提交数据")
    elif current_user["factory"] != factory:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交其他工厂数据")
    else:
        analy_map = get_yearly_map(db)
        quant_map = get_monthly_map(db)
        if current_user["role"] == "factory":
            # factory 角色只能提交年度类型
            if category not in analy_map:
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交子部门月度数据")
        elif current_user["role"] == "department":
            # department 角色只能提交其部门，并且只能提交月度类型
            if category not in quant_map:
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交工厂年度数据")
            if not (current_user["departments"] and category in current_user["departments"]["ids"]):
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交其他部门数据")
            if category not in quant_map:
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交工厂年度数据")
        else:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="未知类型账号无权提交数据")


def get_model(category_id: int, db: Session):
    category = db.query(Category).filter_by(id=category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="未找到指定分类")
    if not category.is_active:
        raise HTTPException(status_code=400, detail="指定分类未激活")
    model = get_model_for_category(db, category_id)
    return category, model


# 通用单条消息发送函数
def send_message(db: Session, msg_type: str, title: str, content: str = None, sender_role: str = "department",
                 sender_factory: str = None, sender_department: str = None, receiver_role: str = "factory",
                 receiver_factory: str = None, receiver_department: str = None):
    db.add(Message(type=msg_type, title=title, content=content, sender_role=sender_role, sender_factory=sender_factory,
                   sender_department=sender_department, receiver_role=receiver_role, receiver_factory=receiver_factory,
                   receiver_department=receiver_department, created_at=datetime.now(timezone.utc), is_read=False))
    db.commit()


# 获取各类数据审核信息
def get_review_info(db, factory, year, category_id, months=12):
    # 判断类型
    is_quant = category_id in get_monthly_map(db)
    is_analytical = category_id in get_yearly_map(db)
    fields = [("id", "id", -1), ("category", "category", 0), ("is_submitted", "is_submitted", False),
              ("level1_status", "status1", "pending"), ("level1_comment", "comment1", ""),
              ("level2_status", "status2", "pending"), ("level2_comment", "comment2", "")]
    if is_quant:
        # 定量月报，返回数组
        review_records = db.query(ReviewRecord).filter_by(category=category_id, factory=factory, year=year).all()
        result = {name: [default] * months for _, name, default in fields}
        for rec in review_records:
            month_idx = rec.month - 1 if rec.month else 0
            if 0 <= month_idx < months:
                for field, name, default in fields:
                    value = getattr(rec, field)
                    result[name][month_idx] = value if value is not None else default
        return result
    elif is_analytical:
        # 定性年报，返回单值
        review_record = db.query(ReviewRecord).filter_by(category=category_id, factory=factory, year=year).order_by(
            ReviewRecord.month.asc()).first()
        result = {}
        for field, name, default in fields:
            value = getattr(review_record, field) if review_record else default
            result[name] = value if value is not None else default
        return result
    else:
        # 未知类型，返回空
        return {name: None for _, name, _ in fields}
