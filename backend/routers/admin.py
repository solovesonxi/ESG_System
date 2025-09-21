from fastapi import APIRouter, Depends, Query, HTTPException, Body
from pydantic import BaseModel
from sqlalchemy import and_, or_
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import User
from core.permissions import get_current_user

router = APIRouter(prefix="/admin", tags=["管理控制台"])


class UserUpdateRequest(BaseModel):
    id: int
    username: str = None
    role: str = None
    factory: str = None
    departments: list = None
    email: str = None
    phone: str = None


@router.get("/account")
def get_accounts(role: str = Query(None), factory: str = Query(None), department: str = Query(None),
                 keyword: str = Query(None), db: Session = Depends(get_db)):
    query = db.query(User)
    if role:
        query = query.filter(User.role == role)
    if factory:
        query = query.filter(User.factory == factory)
    if department:
        query = query.filter(and_(User.departments != None, User.departments.contains(department)))
    if keyword:
        query = query.filter(
            or_((User.username.contains(keyword)), (User.email.contains(keyword)), (User.phone.contains(keyword))))
    accounts = query.all()
    return {"accounts": [a.__dict__ for a in accounts]}


@router.post("/account/update")
def update_account(data: UserUpdateRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == data.id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    if data.username is not None:
        user.username = data.username
    if data.role is not None:
        user.role = data.role
    if data.factory is not None:
        user.factory = data.factory
    if data.departments is not None:
        user.departments = data.departments
    if data.email is not None:
        user.email = data.email
    if data.phone is not None:
        user.phone = data.phone
    db.commit()
    return {"status": "success"}


@router.post("/account/delete")
def delete_account(id: int = Body(..., embed=True), db: Session = Depends(get_db),
                   current_user: dict = Depends(get_current_user)):
    user = db.query(User).filter(User.id == id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    if current_user["id"] == id and current_user["role"] == "admin":
        raise HTTPException(status_code=403, detail="管理员不能删除自己账号")
    try:
        db.delete(user)
        db.commit()
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"删除失败: {e}")
