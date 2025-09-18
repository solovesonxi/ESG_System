import sys
from datetime import datetime
from pathlib import Path

from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
from starlette.staticfiles import StaticFiles

from core.dependencies import engine
from core.models import Base
from routers import auth, user, progress, message, review
from routers.analytical import env_quantitative, env_qualitative, social_qualitative_other, social_quantitative_labor, \
    social_qualitative_labor, social_quantitative_other, governance
from routers.quantitative import material, energy, water, emission, waste, investment, management, employment, training, \
    ohs, satisfaction, supply, community, responsibility, ip

sys.path.append(str(Path(__file__).parent.parent))

# 创建数据库表
Base.metadata.create_all(bind=engine)

app = FastAPI(title="ESG System API", description="企业 ESG 数据管理系统接口文档", version="1.0.0", )
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"],
                   allow_headers=["*"], )
app.mount("/static", StaticFiles(directory="static"), name="static")


@app.get("/")
async def health_check():
    return {"status": "running", "timestamp": datetime.now(), "service": "ESG System API"}


app.include_router(auth.router)
app.include_router(user.router)
app.include_router(progress.router)
app.include_router(message.router)
app.include_router(review.router)
app.include_router(material.router)
app.include_router(energy.router)
app.include_router(water.router)
app.include_router(emission.router)
app.include_router(waste.router)
app.include_router(investment.router)
app.include_router(management.router)
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
