from datetime import timedelta, datetime, timezone
from typing import Optional

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import User


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login/")
SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"

async def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="无法认证访问令牌",
                                          headers={"WWW-Authenticate": "Bearer"}, )
    expired_exception = HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="访问令牌已过期")
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        expire_timestamp = payload.get("exp")
        if expire_timestamp:
            expire_time = datetime.fromtimestamp(expire_timestamp, timezone.utc)
            if expire_time - datetime.now(timezone.utc) < timedelta(minutes=0):
                raise expired_exception
        username: str = payload.get("sub")
        account_type: str = payload.get("account_type")
        factory: Optional[str] = payload.get("factory")
        if username is None:
            raise credentials_exception
    except jwt.ExpiredSignatureError:
        raise expired_exception
    except JWTError:
        raise credentials_exception
    user = db.query(User).filter(User.username == username).first()
    if user is None:
        raise credentials_exception
    return {"user": user, "account_type": account_type, "factory": factory}


def require_headquarters(current_user: dict = Depends(get_current_user)):
    if current_user["account_type"] != "headquarters":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="需要总部账号权限")
    return current_user


def require_factory_access(factory: str, current_user: dict = Depends(get_current_user)):
    if current_user["account_type"] == "headquarters":
        return current_user
    if current_user["account_type"] == "factory":
        user_factory = current_user["user"].factory
        if user_factory != factory and factory != "headquarters":
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权访问其他工厂数据")
        return current_user

    raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无效的账号类型")
