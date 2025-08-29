import json
import logging
import sys
from datetime import datetime
from pathlib import Path

from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from core.database import engine
from core.models import Base
from routers.analytical import env_quantitative, env_qualitative
from routers.quantitative import material, energy, water, emission, waste, investment, employment, training, ohs, \
    satisfaction, supply
from src.routers.analytical import social_quantitative_labor, social_quantitative_other, social_qualitative_labor, \
    social_qualitative_other, governance
from src.routers.quantitative import ip, responsibility, community

sys.path.append(str(Path(__file__).parent.parent))
# 配置日志
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)  # 设置日志级别为DEBUG

# 创建一个控制台处理器
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)

# 定义日志格式
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
console_handler.setFormatter(formatter)

# 添加处理器到logger
logger.addHandler(console_handler)

# 创建数据库表
Base.metadata.create_all(bind=engine)

config_path = Path(__file__).parent / "static" / "indicators.json"
with open(config_path, "r", encoding="utf-8") as f:
    indicators = json.load(f)
app = FastAPI()
# 添加CORS中间件
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"],
                   allow_headers=["*"], )


@app.get("/")
async def health_check():
    return {"status": "running", "timestamp": datetime.now(), "service": "ESG System API"}


app.include_router(material.router)
app.include_router(energy.router)
app.include_router(water.router)
app.include_router(emission.router)
app.include_router(waste.router)
app.include_router(investment.router)
app.include_router(employment.router)
app.include_router(training.router)
app.include_router(ohs.router)
app.include_router(satisfaction.router)
app.include_router(supply.router)
app.include_router(ip.router)
app.include_router(responsibility.router)
app.include_router(community.router)
app.include_router(env_quantitative.router)
app.include_router(env_qualitative.router)
app.include_router(social_quantitative_labor.router)
app.include_router(social_quantitative_other.router)
app.include_router(social_qualitative_labor.router)
app.include_router(social_qualitative_other.router)
app.include_router(governance.router)
