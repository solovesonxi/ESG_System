import json
import logging
from pathlib import Path
from urllib.parse import quote_plus

import redis
from fastapi.security import OAuth2PasswordBearer
from passlib.context import CryptContext
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# PostgresSQL 配置
DB_USER = "postgres"
DB_PASSWORD = "000000"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "esg_db"

encoded_password = quote_plus(DB_PASSWORD)

SQLALCHEMY_DATABASE_URL = f"postgresql://{DB_USER}:{encoded_password}@{DB_HOST}:{DB_PORT}/{DB_NAME}?client_encoding=utf8"

engine = create_engine(SQLALCHEMY_DATABASE_URL, pool_pre_ping=True, connect_args={"options": "-c client_encoding=utf8"})

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Redis 配置
REDIS_HOST = "localhost"
REDIS_PORT = 6379
REDIS_DB = 0


def get_redis():
    redis_client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DB, decode_responses=True)
    try:
        yield redis_client
    finally:
        redis_client.close()


# JWT 和密码哈希配置
SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login/")
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# 配置日志
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", )
logger = logging.getLogger(__name__)

config_path = Path(__file__).parent.parent / "static" / "indicators.json"
with open(config_path, "r", encoding="utf-8") as f:
    indicators = json.load(f)
