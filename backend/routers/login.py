from datetime import datetime, timedelta, timezone
from typing import Optional

import jwt
from fastapi import APIRouter, Depends, HTTPException, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES, pwd_context
from core.models import User

router = APIRouter(prefix="", tags=["登录"])


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=1)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


@router.post("/login")
def login(username: str = Body(..., description="用户名"), password: str = Body(..., description="密码"),
          db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if not user or not pwd_context.verify(password, str(user.hashed_password)):
        raise HTTPException(status_code=400, detail="用户名或密码错误")
    # 在token中包含权限信息
    token_data = {"username": user.username, "account_type": user.account_type, "factory": user.factory}
    access_token = create_access_token(data=token_data, expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    return {"token": access_token,
            "user": {"username": user.username, "factory": user.factory, "account_type": user.account_type,
                     "phone": user.phone, "email": user.email}}


@router.post("/refresh")
async def refresh_token(input_data: dict = Body(...), db: Session = Depends(get_db)):
    try:
        payload = jwt.decode(input_data.get("access_token", ""), SECRET_KEY, algorithms=[ALGORITHM],
            options={"verify_exp": False})
        username = payload.get("username")
        user = db.query(User).filter(User.username == username).first()
        if not user:
            raise HTTPException(status_code=401, detail="用户无效或已被禁用")
        token_exp = datetime.fromtimestamp(payload["exp"], timezone.utc)
        if datetime.now(timezone.utc) - token_exp > timedelta(minutes=5):
            raise HTTPException(status_code=401, detail="Token 过期时间过长，请重新登录")
        new_payload = {"username": user.username, "account_type": user.account_type}
        new_token = create_access_token(new_payload)
        return {"new_token": new_token}
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="刷新令牌无效")
