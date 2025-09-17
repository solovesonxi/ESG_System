from datetime import datetime
from datetime import timezone
from typing import Type, Any

from fastapi import HTTPException
from sqlalchemy import and_
from sqlalchemy.orm import Session

from core.dependencies import indicators
from core.models import Message
from core.permissions import require_view, require_edit


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
        require_view(factory, current_user)
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
        require_edit(data.factory, current_user)
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
        db.merge(db_record)
        db.commit()
        now_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        msg_title = f"{'提交' if data.isSubmitted else '保存'}了{data.factory}{data.year}年{data.month}月的{indicators["categories"][field_mapping]}数据"
        msg_content = f"{current_user["user"].username}于{now_str}{msg_title}，请管理员及时审核。"
        send_message(db, "月报", msg_title, msg_content, sender_factory=data.factory)
        send_message(db, "最近操作", msg_title, sender_factory=data.factory, receiver_role='factory',
                     receiver_factory=data.factory)
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


def send_message(db: Session, msg_type: str, title: str, content: str = None, sender_role: str = "factory",
                 sender_factory: str = None, receiver_role: str = "admin", receiver_factory: str = None):
    msg = Message(type=msg_type, title=title, content=content, sender_role=sender_role, sender_factory=sender_factory,
                  receiver_role=receiver_role, receiver_factory=receiver_factory, created_at=datetime.now(timezone.utc),
                  is_read=False)
    db.add(msg)
    db.commit()


def send_yearly_message(db, current_user: dict, factory, year, is_submitted, data_type, msg_type="年报",
                        msg_title=None):
    now_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    if not msg_title:
        msg_title = f"{"提交" if is_submitted else "保存"}了{factory}工厂{year}年{data_type}"
    msg_content = f"{current_user["user"].username}于{now_str}{msg_title}，请管理员和总部及时审核。"
    send_message(db, msg_type, msg_title, msg_content, sender_factory=factory)
    send_message(db, msg_type, msg_title, msg_content, sender_factory=factory, receiver_role='headquarter')
    send_message(db, "最近操作", msg_title, sender_factory=factory, receiver_role='factory', receiver_factory=factory)
