from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jwt import PyJWTError
import jwt
from typing import Optional
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import User

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login/")
SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        account_type: str = payload.get("account_type")
        factory: Optional[str] = payload.get("factory")
        
        if username is None:
            raise credentials_exception
    except PyJWTError:
        raise credentials_exception
        
    user = db.query(User).filter(User.username == username).first()
    if user is None:
        raise credentials_exception
        
    return {
        "user": user,
        "account_type": account_type,
        "factory": factory
    }

def require_headquarters(current_user: dict = Depends(get_current_user)):
    if current_user["account_type"] != "headquarters":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="需要总部账号权限"
        )
    return current_user

def require_factory_access(factory: str, current_user: dict = Depends(get_current_user)):
    if current_user["account_type"] == "headquarters":
        return current_user
        
    if current_user["account_type"] == "factory":
        # 工厂账号只能访问自己绑定的工厂数据
        user_factory = current_user["user"].factory
        if user_factory != factory and factory != "总部":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="无权访问其他工厂数据"
            )
        return current_user
        
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="无效的账号类型"
    )