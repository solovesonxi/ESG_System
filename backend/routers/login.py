from datetime import datetime, timedelta, timezone
from typing import Optional

import jwt
from fastapi import APIRouter, Depends, HTTPException, Body
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import User

router = APIRouter(prefix="/login", tags=["登录"])

# 密码哈希上下文
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


@router.post("/")
async def login(username: str = Body(..., description="用户名"), password: str = Body(..., description="密码"),
                db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if not user or not verify_password(password, str(user.hashed_password)):
        raise HTTPException(status_code=400, detail="用户名或密码错误")
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    # 在token中包含权限信息
    token_data = {"sub": user.username, "account_type": user.account_type,
                  "factory": user.factory if user.account_type == "factory" else None}

    access_token = create_access_token(data=token_data, expires_delta=access_token_expires)

    return {"token": access_token, "token_type": "bearer",
            "user": {"username": user.username, "factory": user.factory, "account_type": user.account_type,
                     "phone": user.phone, "email": user.email}}


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
