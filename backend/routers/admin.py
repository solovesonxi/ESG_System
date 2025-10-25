import base64
import json
import os
import re
from typing import Optional, Union, List, Dict

from fastapi import APIRouter, Depends, Query, HTTPException, Body
from pydantic import BaseModel
from sqlalchemy import or_
from sqlalchemy.orm import Session

from core.dependencies import get_db, pwd_context, logger
from core.models import User
from core.permission import get_current_user

router = APIRouter(prefix="/admin", tags=["管理控制台"])


class UserUpdateRequest(BaseModel):
    id: Optional[int] = None
    username: Optional[str] = None
    hashed_password: Optional[str] = None
    role: Optional[str] = None
    factory: Optional[str] = None
    departments: Optional[Dict[str, Union[str, List[int]]]] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    avatar: Optional[str] = None
    localAvatar: Optional[str] = None
    is_active: Optional[bool] = None  # 新增：账号启用/禁用


def create_or_update_user(user: User, data: UserUpdateRequest, db: Session, is_new: bool = False):
    if data.username:
        user.username = data.username
    if data.hashed_password and data.hashed_password != "":
        user.hashed_password = pwd_context.hash(data.hashed_password)
    if data.role:
        user.role = data.role
        if data.role in ["headquarter", "admin"]:
            user.factory = None
            user.departments = None
        elif data.role == "factory":
            user.factory = data.factory
            user.departments = None
        elif data.role == "department":
            user.factory = data.factory
            user.departments = data.departments
    if data.email:
        user.email = data.email
    if data.phone:
        user.phone = data.phone
    if data.is_active:
        user.is_active = data.is_active
    AVATAR_DIR = "static/avatars"
    if data.localAvatar:
        try:
            if not is_new and user.avatar:
                old_avatar_path = os.path.join(AVATAR_DIR, os.path.basename(str(user.avatar)))
                if os.path.exists(old_avatar_path):
                    os.remove(old_avatar_path)
            if "," in data.localAvatar:
                header, b64data = data.localAvatar.split(",", 1)
                match = re.search(r'data:(image/[^;]+);base64', header)
                if match:
                    mime_type = match.group(1)
                    ext = {'image/jpeg': '.jpg', 'image/jpg': '.jpg', 'image/png': '.png', 'image/webp': '.webp',
                           'image/gif': '.gif', 'image/bmp': '.bmp', 'image/x-icon': '.ico',
                           'image/svg+xml': '.svg', }.get(mime_type, f'.{mime_type.split("/")[-1]}')
                else:
                    ext = '.png'
            else:
                b64data = data.localAvatar
                ext = '.png'
            img_bytes = base64.b64decode(b64data)
            avatar_filename = f"user_{user.id}{ext}"
            avatar_path = os.path.join(AVATAR_DIR, avatar_filename)
            with open(avatar_path, "wb") as f:
                f.write(img_bytes)
            user.avatar = f"/{AVATAR_DIR}/{avatar_filename}"
        except Exception as e:
            db.rollback()
            raise HTTPException(status_code=500, detail=f"头像保存失败: {e}")
    elif data.avatar:
        user.avatar = data.avatar
    if is_new:
        db.add(user)
    db.commit()
    db.refresh(user)
    return user


@router.get("/account")
def get_accounts(role: str = Query(None), factory: str = Query(None), department: int = Query(None),
                 keyword: str = Query(None), page: int = Query(1, ge=1), page_size: int = Query(10, ge=1, le=100),
                 db: Session = Depends(get_db)):
    try:
        # 基础查询
        query = db.query(User)
        if role:
            query = query.filter(User.role == role)
        if factory:
            query = query.filter(User.factory == factory)
        if keyword:
            query = query.filter(
                or_(User.username.contains(keyword), User.email.contains(keyword), User.phone.contains(keyword)))
        if department and department > 0:
            all_accounts = query.all()
            filtered_accounts = []
            for account in all_accounts:
                if not (account.departments and account.departments["ids"]):
                    continue
                departments = account.departments["ids"]
                if isinstance(departments, str):
                    try:
                        departments = json.loads(departments)
                    except json.JSONDecodeError:
                        continue
                if department in departments:
                    filtered_accounts.append(account)
            # 计算分页
            total = len(filtered_accounts)
            start = (page - 1) * page_size
            end = start + page_size
            accounts = filtered_accounts[start:end]
            return {"accounts": [a.__dict__ for a in accounts], "total": total, "page": page, "page_size": page_size}
        else:
            total = query.count()
            accounts = query.offset((page - 1) * page_size).limit(page_size).all()
            return {"accounts": [a.__dict__ for a in accounts], "total": total, "page": page, "page_size": page_size}
    except Exception as e:
        logger.error(f"查询账号列表失败: {str(e)}")
        raise HTTPException(status_code=500, detail="服务器内部错误")


@router.patch("/account/update")
def update_account(data: UserUpdateRequest, db: Session = Depends(get_db),
                   current_user: dict = Depends(get_current_user)):
    if current_user["role"] != "admin":
        raise HTTPException(status_code=403, detail="非管理员不可修改用户重要信息")
    user = db.query(User).filter(User.id == data.id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    create_or_update_user(user, data, db)
    return {"status": "success"}


@router.delete("/account/delete")
def delete_account(id: int = Body(..., embed=True), db: Session = Depends(get_db),
                   current_user: dict = Depends(get_current_user)):
    user = db.query(User).filter(User.id == id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    if current_user["id"] == id and current_user["role"] == "admin":
        raise HTTPException(status_code=403, detail="管理员不能注销自己账号")
    try:
        db.delete(user)
        db.commit()
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"删除失败: {e}")


@router.post("/account/add")
def add_account(data: UserUpdateRequest, db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    if current_user["role"] != "admin":
        raise HTTPException(status_code=403, detail="非管理员不可添加账号")
    if data.hashed_password is None or data.hashed_password == "":
        raise HTTPException(status_code=400, detail="密码不能为空")
    if data.username and db.query(User).filter(User.username == data.username).first():
        raise HTTPException(status_code=400, detail="用户名已存在")
    # 构建新用户对象
    new_user = User(username=data.username,
                    hashed_password=pwd_context.hash(data.hashed_password) if data.hashed_password else None,
                    role=data.role if data.role else "department", factory=data.factory, departments=data.departments,
                    phone=data.phone, email=data.email)
    create_or_update_user(new_user, data, db, is_new=True)
    return {"status": "success", "id": new_user.id, "avatar": new_user.avatar}


@router.post("/account/import")
def import_accounts(accounts: list[UserUpdateRequest], db: Session = Depends(get_db),
                    current_user: dict = Depends(get_current_user)):
    if current_user["role"] != "admin":
        raise HTTPException(status_code=403, detail="非管理员不可批量导入账号")
    success_count = 0
    failed = []
    for acc in accounts:
        if not acc.username or not acc.hashed_password:
            failed.append({"username": acc.username, "reason": "用户名或密码不能为空"})
            continue
        if db.query(User).filter(User.username == acc.username).first():
            failed.append({"username": acc.username, "reason": "用户名已存在"})
            continue
        try:
            new_user = User(username=acc.username, hashed_password=pwd_context.hash(acc.hashed_password),
                            role=acc.role if acc.role else "department", factory=acc.factory,
                            departments=acc.departments, phone=acc.phone, email=acc.email,
                            is_active=acc.is_active if acc.is_active is not None else True)
            create_or_update_user(new_user, acc, db, is_new=True)
            success_count += 1
        except Exception as e:
            db.rollback()
            failed.append({"username": acc.username, "reason": str(e)})
    logger.info(f"批量导入账号成功，成功导入 {success_count} 个账号，失败 {len(failed)} 个账号")
    return {"status": "success", "imported": success_count, "failed": failed}


@router.post("/account/toggle-status")
def toggle_account_status(id: int = Body(...), is_active: bool = Body(...), db: Session = Depends(get_db),
                          current_user: dict = Depends(get_current_user)):
    if current_user["role"] != "admin":
        raise HTTPException(status_code=403, detail="只有管理员可以切换账号状态")
    user = db.query(User).filter(User.id == id).first()
    if not user:
        raise HTTPException(status_code=404, detail="账号不存在")
    user.is_active = is_active
    db.commit()
    return {"status": "success"}
