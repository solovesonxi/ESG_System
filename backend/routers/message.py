import threading
from datetime import datetime, timezone
from typing import Optional

from fastapi import APIRouter, Depends, Body, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from core.dependencies import get_db, logger, SessionLocal
from core.models import Message, User
from core.permission import get_current_user
from core.utils import send_message

router = APIRouter(prefix="/messages", tags=["消息"])


class AnnouncementRequest(BaseModel):
    title: str
    content: str
    receiver_factory: Optional[str] = None
    receiver_department: Optional[str] = None
    send_time: Optional[str] = None  # ISO string or empty


@router.post("")
async def send_messages(payload: AnnouncementRequest = Body(...), db: Session = Depends(get_db),
                        current_user: dict = Depends(get_current_user)):
    """发布公告：前端会传 title, content, 可选 receiver_factory/receiver_department, 可选 send_time(ISO). 
    后端会根据发送者角色决定 receiver_role：
    - headquarter/admin -> receiver_role='factory'（可选择某个工厂或全部）
    - factory -> receiver_role='department'（可选择某个部门或全部）

    If send_time is in the future, schedule the send using a background Timer (requires server to stay up).
    Otherwise send immediately.
    """
    sender_role = current_user.get("role")
    sender_factory = current_user.get("factory")
    sender_department = None
    if sender_role not in ("admin", "headquarter", "factory"):
        raise HTTPException(status_code=403, detail="没有权限发布公告")

    if sender_role in ("admin", "headquarter"):
        receiver_role = "factory"
        receiver_factory = payload.receiver_factory if payload.receiver_factory and payload.receiver_factory != "" else None
        receiver_department = None
    else:
        receiver_role = "department"
        receiver_factory = sender_factory
        receiver_department = payload.receiver_department if payload.receiver_department and payload.receiver_department != "" else None
    if payload.send_time:
        try:
            created_at = datetime.fromisoformat(payload.send_time)
            if created_at.tzinfo is None:
                created_at = created_at.replace(tzinfo=timezone.utc)
            else:
                created_at = created_at.astimezone(timezone.utc)
        except Exception:
            created_at = datetime.now(timezone.utc)
    else:
        created_at = datetime.now(timezone.utc)

    try:
        now = datetime.now(timezone.utc)
        if created_at > now:
            delay = (created_at - now).total_seconds()

            def _delayed_send():
                db2 = SessionLocal()
                try:
                    send_message(db2, msg_type="公告", title=payload.title, content=payload.content,
                                 sender_role=sender_role, sender_factory=sender_factory,
                                 sender_department=sender_department, receiver_role=receiver_role,
                                 receiver_factory=receiver_factory, receiver_department=receiver_department)
                except Exception as e:
                    logger.error(f"延迟发送公告失败: {e}")
                finally:
                    try:
                        db2.close()
                    except Exception:
                        pass

            t = threading.Timer(delay, _delayed_send)
            t.daemon = True
            t.start()
            return {"status": "scheduled", "message": "定时消息等待发送中", "send_time": created_at.isoformat()}
        else:
            # immediate send using request DB session
            send_message(db, msg_type="公告", title=payload.title, content=payload.content, sender_role=sender_role,
                         sender_factory=sender_factory, sender_department=sender_department,
                         receiver_role=receiver_role, receiver_factory=receiver_factory,
                         receiver_department=receiver_department)
            return {"status": "success", "message": "消息已发送"}

    except Exception as e:
        try:
            db.rollback()
        except Exception:
            pass
        logger.error(f"发送公告失败: {e}")
        raise HTTPException(status_code=500, detail=f"发送公告失败: {e}")


@router.get("")
async def get_messages(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    role = current_user["role"]
    factory = current_user["factory"]
    departments = current_user.get("departments")
    # normalize departments to list of names/ids depending on stored shape
    dep_list = []
    if isinstance(departments, dict):
        ids = departments.get("ids")
        if isinstance(ids, list):
            dep_list = ids
        else:
            name = departments.get("name")
            if name:
                dep_list = [name]
    elif isinstance(departments, list):
        dep_list = departments
    q = db.query(Message).filter(Message.receiver_role == role)
    if factory:
        q = q.filter((Message.receiver_factory == factory) | (Message.receiver_factory == None))
    else:
        q = q.filter(Message.receiver_factory == None)
    q = q.order_by(Message.created_at.desc())
    if role in ("factory", "headquarter", "admin"):
        messages = q.all()
    elif role == "department":
        dept_name = None
        if isinstance(departments, dict):
            dept_name = departments.get("name")
        if not dept_name:
            if dep_list:
                dept_name = dep_list[0]
        if dept_name:
            messages = q.filter(
                (Message.receiver_department == None) | (Message.receiver_department == dept_name)).all()
        else:
            messages = q.filter(Message.receiver_department == None).all()
    else:
        raise HTTPException(status_code=400, detail="未知角色")

    return {"messages": [
        {"id": m.id, "type": m.type, "title": m.title, "content": m.content, "sender_role": m.sender_role,
         "sender_factory": m.sender_factory, "sender_department": m.sender_department, "receiver_role": m.receiver_role,
         "receiver_factory": m.receiver_factory, "receiver_department": m.receiver_department,
         "created_at": m.created_at, "is_read": m.is_read} for m in messages]}


@router.get("/departments")
async def get_departments(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    """返回当前用户工厂的部门列表（name 与 ids）供前端选择。对于总部/管理员，返回全部工厂下的部门去重列表。"""
    role = current_user.get("role")
    factory = current_user.get("factory")
    try:
        query = db.query(User).filter(User.role == "department")
        if role == "factory" and factory:
            query = query.filter(User.factory == factory)
        departments = []
        seen = set()
        for u in query.all():
            dep = u.departments
            if not dep:
                continue
            if isinstance(dep, str):
                try:
                    import json as _json

                    dep = _json.loads(dep)
                except ValueError:
                    continue
            name = None
            if isinstance(dep, dict):
                name = dep.get("name")
            if name and name not in seen:
                seen.add(name)
                departments.append({"name": name, "id": u.id})
        return {"departments": departments}
    except Exception as e:
        logger.error(f"获取部门列表失败: {e}")
        raise HTTPException(status_code=500, detail=f"获取部门列表失败: {e}")


@router.patch("/read")
async def mark_as_read(message_id: int = Body(..., description="消息ID"), db: Session = Depends(get_db),
                       current_user: dict = Depends(get_current_user)):
    try:
        role = current_user["role"]
        msg = db.query(Message).filter_by(id = message_id).first()
        if not msg:
            raise HTTPException(status_code=404, detail="消息不存在")
        if msg.receiver_role != role:
            raise HTTPException(status_code=403, detail="没有权限标记此消息为已读")
        else:
            if msg.receiver_role == "factory" or msg.receiver_role == "department":
                if current_user["factory"] and msg.receiver_factory not in (None, current_user["factory"]):
                    raise HTTPException(status_code=403, detail="没有权限标记此消息为已读")
            if msg.receiver_role == "department":
                departments = current_user.get("departments")
                dep_name = None
                if isinstance(departments, dict):
                    dep_name = departments.get("name")
                if msg.receiver_department not in (None, dep_name):
                    raise HTTPException(status_code=403, detail="没有权限标记此消息为已读")
            msg.is_read = True
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
        query = db.query(Message).filter(
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
