from typing import Optional

from fastapi import APIRouter, Depends, Body, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db, logger
from core.models import Message
from core.permissions import get_current_user
from core.utils import send_message

router = APIRouter(prefix="/messages", tags=["消息"])


@router.post("/send")
async def send_messages(msg_type: str = Body(..., description="消息类型"),
                        title: str = Body(None, description="消息标题"),
                        content: str = Body(..., description="消息内容"),
                        receiver_role: str = Body(..., description="接收方角色"),
                        receiver_factory: Optional[str] = Body(None, description="接收方工厂"),
                        db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    send_message(db, msg_type, title, content, current_user["role"], current_user["factory"], receiver_role,
                 receiver_factory)
    return {"status": "success", "message": "消息已发送"}


@router.get("/get")
async def get_messages(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    role = current_user["role"]
    factory = current_user["factory"]
    messages = db.query(Message).filter(
        Message.receiver_role == role if role != "factory" else Message.receiver_factory == factory).order_by(
        Message.created_at.desc()).all()
    notifications = [msg for msg in messages if msg.type != "最近操作"]
    operations = [msg for msg in messages if msg.type == "最近操作"]

    def to_dict(msg):
        return {"id": msg.id, "type": msg.type, "title": msg.title, "content": msg.content,
                "sender_role": msg.sender_role, "sender_factory": msg.sender_factory,
                "receiver_role": msg.receiver_role, "receiver_factory": msg.receiver_factory,
                "created_at": msg.created_at, "is_read": msg.is_read}

    return {"notifications": [to_dict(m) for m in notifications], "operations": [to_dict(m) for m in operations]}


@router.patch("/read")
async def mark_as_read(message_id: int = Body(..., description="消息ID"), db: Session = Depends(get_db),
                       current_user: dict = Depends(get_current_user)):
    try:
        role = current_user["role"]
        msg = db.query(Message).filter(Message.id == message_id,
                                       Message.receiver_role == role if role != "factory" else Message.receiver_factory ==
                                                                                               current_user[
                                                                                                   "factory"]).first()
        if msg: msg.is_read = True
        db.commit()
        return {"status": "success", "message": "消息已标记为已读"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"标记消息失败: {str(e)}")


@router.patch("/read-all")
async def mark_all_as_read(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    try:
        role = current_user["role"]
        factory = current_user["factory"]
        query = db.query(Message).filter(Message.type != "最近操作",
                                         Message.receiver_role == role if role != "factory" else Message.receiver_factory == factory,
                                         Message.is_read == False)
        messages_to_update = query.all()
        updated_count = len(messages_to_update)
        for msg in messages_to_update:
            msg.is_read = True
        db.commit()
        return {"status": "success", "message": f"已标记{updated_count}条消息为已读"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"一键已读失败: {str(e)}")


@router.delete("/batch-delete")
async def batch_delete_messages(ids: list[int] = Body(..., description="消息ID列表"), db: Session = Depends(get_db),
                                current_user: dict = Depends(get_current_user)):
    try:
        role = current_user["role"]
        factory = current_user["factory"]
        logger.info(f"删除 {ids} for {role} {factory}")
        msgs = db.query(Message).filter(Message.id.in_(ids),
                                        Message.receiver_role == role if role != "factory" else Message.receiver_factory == factory).all()
        deleted_count = 0
        for msg in msgs:
            logger.info(f"删除 {msg.id} {msg.type} {msg.title}")
            db.delete(msg)
            deleted_count += 1
        logger.info(f"删除 {deleted_count} 条数据")
        db.commit()
        return {"status": "success", "message": f"已删除{deleted_count}条消息"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"批量删除消息失败: {str(e)}")


@router.delete("/clear-all")
async def clear_all_operations(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    try:
        role = current_user["role"]
        factory = current_user["factory"]
        query = db.query(Message).filter(Message.type == "最近操作",
                                         Message.receiver_role == role if role != "factory" else Message.receiver_factory == factory)
        messages_to_delete = query.all()
        deleted_count = len(messages_to_delete)
        for msg in messages_to_delete:
            db.delete(msg)
        db.commit()
        return {"status": "success", "message": f"已清空{deleted_count}条最近操作记录"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"清空最近操作失败: {str(e)}")
