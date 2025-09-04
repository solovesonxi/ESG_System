# ESG System 项目说明

## 项目概述

ESG System 是一个用于管理和监控企业环境、社会和治理数据的综合系统。支持工厂填报数据、总部分析汇总，并提供可视化报告。

## 核心功能

1. **数据填报**：
   - 14类定量数据（材料、能源、水、排放等）。
   - 定性数据（环境、社会、管治）。
2. **数据分析**：
   - 工厂级数据聚合。
   - ESG 评分生成。
3. **权限控制**：
   - 工厂账号：填报和查看本厂数据。
   - 总部账号：查看所有工厂数据（不可修改）。

## API 文档

FastAPI 自动生成交互式 API 文档，访问 http://localhost:8000/docs 查看接口详情、请求示例和响应格式。

## 项目结构

### Backend

- `main.py` - 主入口文件和 API 端点。
- `requirements.txt` - Python 依赖配置。
- `utils.py` - 通用工具函数。
- `core/` - 核心模块：
  - `dependencies.py` - 依赖注入配置。
  - `models.py` - 数据库模型定义。
  - `permissions.py` - 权限控制逻辑。
  - `schemas.py` - 数据模型定义。
  - `utils.py` - 核心工具函数。
- `routers/` - API 路由：
  - `login.py` - 登录相关接口。
  - `register.py` - 注册相关接口。
  - `update.py` - 数据更新接口。
  - `verification.py` - 验证相关接口。
  - `analytical/` - 分析类接口。
  - `quantitative/` - 定量数据接口。
- `static/` - 静态资源：
  - `indicators.json` - 指标配置。
  - `init_database.sql` - 数据库初始化脚本。

### Frontend

- `index.html` - 主页面入口。
- `package.json` - Node.js 依赖配置。
- `vite.config.js` - Vite 构建配置。
- `public/` - 公共资源：
  - `favicon.ico` - 网站图标。
- `src/` - 前端源码：
  - `App.vue` - 根组件。
  - `main.js` - 应用入口。
  - `assets/` - 静态资源（图片、样式等）。
  - `components/` - 公共组件。
  - `router/` - 路由配置。
  - `stores/` - 状态管理（Pinia）。
  - `utils/` - 工具函数。
  - `views/` - 页面组件。

## 技术栈

- **后端**：Python + FastAPI + SQLAlchemy + Redis。
- **前端**：Vue.js 3 + Vite + Pinia（状态管理）。
- **数据库**：
  - Postgres：主数据库。
  - Redis：缓存数据库（需 Docker 运行）。

## 环境要求

- **系统**：Windows 10/11（需支持 Docker）。
- **开发工具**：
  - Node.js 16+。
  - Python 3.7+。
  - pip 包管理器。
- **数据库**：
  - Postgres 12+。
  - Redis 6+（通过 Docker 运行）。
- **Docker**：
  - 确保已安装 Docker Desktop 并启动服务。

## 快速启动指南

### 1. 启动 Redis（Docker）

```sh
docker run --name esg-redis -p 6379:6379 -d redis
```

### 2. 后端服务器启动

```sh
# 进入后端目录
cd backend

# 安装Python依赖
pip install -r requirements.txt

# 创建数据库
psql -h localhost -p 5432 -U postgres -d esg_db -f init_database.sql

# 启动后端服务器
uvicorn main:app --reload
```

后端服务将在 http://localhost:8000 运行。

### 3. 前端客户端启动

```sh
# 进入前端目录
cd frontend

# 安装前端依赖
npm install

# 启动开发服务器
npm run dev
```

前端应用将在 http://localhost:5173 运行。

## API 接口

后端提供以下主要接口：

- **定量数据提交/查询**：`/quantitative/{category}`（如 `/quantitative/material`）。
- **分析数据提交/查询**：`/analytical/{category}`（如 `/analytical/env_qualitative`）。
- **基本信息**：`GET POST PATCH/{info}`（如`/login`）。

API文档请启动项目后访问：http://localhost:8000/docs。

## 安全设计

- **令牌管理**：
  - Access Token：30 分钟有效期。
  - Refresh Token：15 分钟有效期（高安全场景）。
- **输入验证**：防止 SQL 注入和数据篡改。

## 贡献指南

欢迎贡献代码！请遵循以下流程：

1. Fork 项目仓库。
2. 创建新分支：`git checkout -b feature/your-feature`。
3. 提交变更：`git commit -m '添加新功能'`。
4. 推送到分支：`git push origin feature/your-feature`。
5. 创建 Pull Request。

## 许可证

本项目采用 MIT 许可证 - 详情请参阅项目 LICENSE 文件。

最后更新: 2025年9月
项目状态: 开发中
