import json
import logging
import redis

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from urllib.parse import quote_plus
from pathlib import Path

# PostgreSQL 配置
DB_USER = "postgres"
DB_PASSWORD = "000000"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "esg_db"

encoded_password = quote_plus(DB_PASSWORD)

SQLALCHEMY_DATABASE_URL = f"postgresql://{DB_USER}:{encoded_password}@{DB_HOST}:{DB_PORT}/{DB_NAME}?client_encoding=utf8"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    pool_pre_ping=True,
    connect_args={
        "options": "-c client_encoding=utf8"
    }
)

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
    redis_client = redis.Redis(
        host=REDIS_HOST,
        port=REDIS_PORT,
        db=REDIS_DB,
        decode_responses=True
    )
    try:
        yield redis_client
    finally:
        redis_client.close()

config_path = Path(__file__).parent.parent / "static" / "indicators.json"
with open(config_path, "r", encoding="utf-8") as f:
    indicators = json.load(f)