from datetime import datetime, timezone, timedelta

import redis
from fastapi import APIRouter, Depends, HTTPException, Body
from jose import jwt
from sqlalchemy.orm import Session

from core.dependencies import get_db, get_redis, SECRET_KEY, ALGORITHM, logger, pwd_context
from core.models import User
from core.permissions import get_current_user

router = APIRouter(prefix="/update", tags=["更改信息"])


@router.patch("/username")
def update_password(new_username: str = Body(..., description="新用户名"), db: Session = Depends(get_db),
                    current_user: dict = Depends(get_current_user)):
    try:
        if not current_user or not current_user["user"]:
            raise HTTPException(status_code=400, detail="用户名不存在")
        user = current_user["user"]
        if db.query(User).filter(User.username == new_username).first():
            raise HTTPException(status_code=400, detail="用户名已存在")
        user.username = new_username
        db.commit()
        payload = {"username": new_username, "account_type": current_user["account_type"],
                   "factory": current_user["factory"], "exp": datetime.now(timezone.utc) + timedelta(minutes=15)}
        new_token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
        return {"status": "success", "new_token": new_token,
                "user": {"username": new_username, "factory": user.factory, "account_type": user.account_type,
                         "phone": user.phone, "email": user.email}}
    except Exception as e:
        db.rollback()
        logger.error(e)
        raise (HTTPException(status_code=500, detail=str(e)))


@router.patch("/phone")
def verify_and_update_phone(new_phone: str = Body(..., description="新邮箱"),
                            code: str = Body(..., description="验证码"), db: Session = Depends(get_db),
                            redis_client: redis.Redis = Depends(get_redis),
                            current_user: dict = Depends(get_current_user)):
    try:
        if not current_user or not current_user["user"]:
            raise HTTPException(status_code=400, detail="用户名不存在")
        stored_code = redis_client.get(f"verification_code:{new_phone}")
        if not stored_code or stored_code != code:
            raise HTTPException(status_code=400, detail="验证码无效或已过期")
        current_user["user"].phone = new_phone
        db.commit()
        redis_client.delete(f"verification_code:{new_phone}")
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        logger.error(e)
        raise HTTPException(status_code=500, detail=str(e))


@router.patch("/email")
def verify_and_update_email(new_email: str = Body(..., description="新邮箱"),
                            code: str = Body(..., description="验证码"), db: Session = Depends(get_db),
                            redis_client: redis.Redis = Depends(get_redis),
                            current_user: dict = Depends(get_current_user)):
    try:
        if not current_user or not current_user["user"]:
            raise HTTPException(status_code=400, detail="用户名不存在")
        stored_code = redis_client.get(f"verification_code:{new_email}")
        if not stored_code or stored_code != code:
            raise HTTPException(status_code=400, detail="验证码无效或已过期")
        current_user["user"].email = new_email
        db.commit()
        logger.info(f"用户{current_user['user'].username}更新了邮箱为{new_email}")
        redis_client.delete(f"verification_code:{new_email}")
        logger.info(f"删除了验证码{new_email}")
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        logger.error(e)
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/password")
def update_password(current_password: str = Body(..., description="当前密码"),
                    new_password: str = Body(..., description="新密码"), db: Session = Depends(get_db),
                    current_user: dict = Depends(get_current_user)):
    try:
        if not current_user or not current_user["user"]:
            raise HTTPException(status_code=400, detail="用户名不存在")
        user = current_user["user"]
        if not pwd_context.verify(current_password, str(user.hashed_password)):
            raise HTTPException(status_code=400, detail="当前密码错误")
        user.hashed_password = pwd_context.hash(new_password)
        db.commit()
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
