from datetime import timedelta, datetime, timezone

import jwt
from fastapi import Depends, HTTPException, status
from jose import JWTError
from sqlalchemy.orm import Session
from sqlalchemy.orm.attributes import flag_modified

from core.dependencies import get_db, SECRET_KEY, ALGORITHM, oauth2_scheme, logger
from core.models import User, YearInfo


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
    return {"user": user, "role": payload.get("role"), "factory": payload.get("factory")}


def require_view(factory: str, current_user: dict = Depends(get_current_user)):
    if current_user["role"] == "headquarter" or current_user["role"] == "admin" or current_user["user"].factory == factory:
        return
    raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权访问其他工厂数据")


def require_edit(factory: str, current_user: dict = Depends(get_current_user)):
    if current_user["role"] == "admin":
        raise  HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="管理员账号无权提交数据")
    elif current_user["role"] != "headquarter" and current_user["factory"] != factory:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交其他工厂数据")


def check_factory_year(factory: str, year: int, db: Session, isSubmitted: bool, index: int):
    try:
        year_info = db.query(YearInfo).filter_by(factory=factory, year=year).first()
        if year_info:
            if year_info.is_submitted[index]:
                return {"status": "fail", "message": "数据已提交过，请等待管理员或总部审核"}
            else:
                submitted=year_info.is_submitted.copy()
                submitted[index]=isSubmitted
                year_info.is_submitted=submitted
                flag_modified(year_info, "is_submitted")
        else:
            is_submitted = [False] * 7
            is_submitted[index] = isSubmitted
            year_info = YearInfo(factory=factory, year=year, is_submitted=is_submitted)
            db.add(year_info)
        return {"status": "success"}
    except Exception as e:
        logger.error(f"check_factory_year error: {str(e)}")
        raise e
