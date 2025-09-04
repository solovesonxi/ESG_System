from datetime import timedelta, datetime, timezone

import jwt
from fastapi import Depends, HTTPException, status
from jose import JWTError
from sqlalchemy.orm import Session

from core.dependencies import get_db, SECRET_KEY, ALGORITHM, oauth2_scheme
from core.models import User


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
        username: str = payload.get("username")
        if username is None:
            raise credentials_exception
    except jwt.ExpiredSignatureError:
        raise expired_exception
    except JWTError:
        raise credentials_exception
    user = db.query(User).filter(User.username == username).first()
    if user is None:
        raise credentials_exception
    return {"user": user, "account_type": payload.get("account_type"), "factory": payload.get("factory")}


def require_access(factory: str, current_user: dict = Depends(get_current_user)):
    if current_user["account_type"] == "headquarters" or current_user["user"].factory == factory:
        return
    raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权访问其他工厂数据")


def require_factory(factory: str, current_user: dict = Depends(get_current_user)):
    if current_user["account_type"] == "headquarters":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="总部账号无权提交数据")
    elif current_user["factory"] != factory:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交其他工厂数据")
