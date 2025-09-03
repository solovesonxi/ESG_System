from datetime import datetime, timedelta, timezone
from typing import Optional

import jwt
from fastapi import APIRouter, Depends, HTTPException, Body
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import User

router = APIRouter(prefix="", tags=["登录"])

# 密码哈希上下文
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


def verify_password(plain_password: str, hashed_password: str):
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


@router.post("/login")
def login(username: str = Body(..., description="用户名"), password: str = Body(..., description="密码"),
          db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if not user or not verify_password(password, str(user.hashed_password)):
        raise HTTPException(status_code=400, detail="用户名或密码错误")
    # 在token中包含权限信息
    token_data = {"sub": user.username, "account_type": user.account_type, "factory": user.factory}
    access_token = create_access_token(data=token_data, expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    return {"token": access_token, "token_type": "bearer",
            "user": {"username": user.username, "factory": user.factory, "account_type": user.account_type,
                     "phone": user.phone, "email": user.email}}


@router.post("/refresh")
async def refresh_token(input_data: dict = Body(...)):
    try:
        payload = jwt.decode(input_data.get("access_token", ""), SECRET_KEY, algorithms=[ALGORITHM])
        return {"new_token": create_access_token(data=payload)}
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Refresh token 已过期")
