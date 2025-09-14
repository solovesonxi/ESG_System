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


def check_factory_year(factory: str, year: int, db: Session, isSubmitted: bool, index: int):
    year_info = db.query(YearInfo).filter_by(factory=factory, year=year).first()
    logger.info(f"factory: {factory}, year: {year}, isSubmitted: {isSubmitted}, index: {index} year_info: {year_info}")
    if year_info:
        if year_info.is_submitted[index]:
            logger.info(f"已经提交了的值: {year_info.is_submitted[index]} {year_info.is_submitted} {index}")
            return {"status": "fail", "message": "数据已提交过，若需修改请联系管理员"}
        else:
            year_info.is_submitted[index] = isSubmitted
            flag_modified(year_info, "is_submitted")
            db.commit()
    else:
        logger.info("没有创建此年year_info: None")
        is_submitted = [False] * 7
        is_submitted[index] = isSubmitted
        year_info = YearInfo(factory=factory, year=year, is_submitted=is_submitted)
        db.add(year_info)
    logger.info(f"结束检查的year_info.is_submitted: {year_info.is_submitted}")
    return {"status": "success"}
