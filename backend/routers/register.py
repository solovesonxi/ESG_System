import redis
from fastapi import APIRouter, Depends, HTTPException, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, get_redis, pwd_context
from core.models import User

router = APIRouter(prefix="/register", tags=["注册"])


@router.post("")
def register(username: str = Body(..., description="用户名"), password: str = Body(..., description="密码"),
             factory: str = Body(..., description="工厂名称"), phone: str = Body(..., description="电话号码"),
             email: str = Body(..., description="电子邮箱"), verificationCode: str = Body(..., description="验证码"),
             db: Session = Depends(get_db), redis_client: redis.Redis = Depends(get_redis)):
    try:
        contact = phone or email
        stored_code = redis_client.get(f"verification_code:{contact}")
        if not stored_code or stored_code != verificationCode:
            raise HTTPException(status_code=400, detail="验证码无效或已过期")
        existing_user = db.query(User).filter(User.username == username).first()
        if existing_user:
            raise HTTPException(status_code=400, detail="用户名已存在")
        hashed_password = pwd_context.hash(password)
        new_user = User(username=username, hashed_password=hashed_password, factory=factory, account_type="factory",
                        phone=phone, email=email)
        db.add(new_user)
        db.commit()
        redis_client.delete(f"verification_code:{contact}")
        return {"status": "success", "username": new_user.username}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
