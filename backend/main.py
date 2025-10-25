import sys
from datetime import datetime
from pathlib import Path

from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
from starlette.staticfiles import StaticFiles

from core.dependencies import engine
from core.models import Base
from routers import auth, user, progress, message, review, admin, monthly_data, yearly_data

sys.path.append(str(Path(__file__).parent.parent))

# 创建数据库表
Base.metadata.create_all(bind=engine)

app = FastAPI(title="ESG System API", description="企业ESG数据管理系统接口文档", version="1.0.0", )
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"],
                   allow_headers=["*"], )
app.mount("/static", StaticFiles(directory="static"), name="static")


@app.get("/")
async def health_check():
    return {"status": "running", "timestamp": datetime.now(), "service": "ESG System API"}


app.include_router(auth.router)
app.include_router(user.router)
app.include_router(monthly_data.router)
app.include_router(yearly_data.router)
app.include_router(progress.router)
app.include_router(message.router)
app.include_router(review.router)
app.include_router(admin.router)
