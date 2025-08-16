# ESG System 项目说明

## 项目概述

ESG System 是一个用于管理和监控企业环境、社会和治理数据的综合系统。它提供了物料进出统计、资源消耗分析等功能，帮助企业更好地实践可持续发展和 ESG 数据管理。

project-structure.png

## 项目结构

### Backend 

* `database.py` - 数据库连接配置
* `main.py` - 主入口文件和API端点
* `models.py` - 数据库模型定义

### Frontend 

* `public` - 公共资源文件
* `src` - Vue.js 前端源码
* `index.html` - 主页面入口
* `package.json` - Node.js 依赖配置
* `vite.config.js` - Vite 构建配置

## 技术栈

* **后端**：Python + FastAPI + SQLAlchemy
* **前端**：Vue.js 3 + Vite
* **数据库**：Postgres (默认) / 可替换为其他数据库

## 环境要求

* Node.js 16+
* Python 3.7+
* pip 包管理器

## 快速启动指南

### 1. 后端服务器启动

```
# 进入后端目录
cd backend

# 安装Python依赖
pip install -r requirements.txt

# 创建数据库
psql -h localhost -p 5432 -U postgres -d esg_db -f init_database.sql

# 启动后端服务器
uvicorn main:app --reload
```

后端服务将在 `http://localhost:8000` 运行

### 2. 前端客户端启动

```
# 进入前端目录
cd frontend

# 安装前端依赖
npm install

# 启动开发服务器
npm run dev
```

前端应用将在 `http://localhost:5173` 运行

### 3. 验证系统

访问 `http://localhost:5173` 查看物料统计页面

## 功能特性

1. 工厂基本信息管理
2. ESG 指标计算（可再生料占比，消耗强度等）
3. 数据可视化展示（可扩展）

## API 接口

后端提供以下主要接口：

* `POST /submit/` - 提交数据
* `GET /data/` - 获取数据（可扩展）
* `GET /info` - 获取基本信息（可扩展）

API文档访问：`http://localhost:8000/docs`

## 配置文件

* 后端：`schemas.py` 定义数据模型
* 前端：`src/api.js` 配置API请求（若有）
* 数据库：`database.py` 配置数据库连接

## 开发说明

1. 前端开发：
   ```
   cd frontend
   npm run dev # 启动热重载开发服务器
   ```
2. 后端开发：
   ```
   cd backend
   # 使用--reload参数支持热重载
   uvicorn main:app --reload --port 8000
   ```

## 贡献指南

欢迎贡献代码！请遵循以下流程：

1. Fork 项目仓库
2. 创建新分支 (`git checkout -b feature/your-feature`)
3. 提交变更 (`git commit -am '添加新功能'`)
4. 推送到分支 (`git push origin feature/your-feature`)
5. 创建 Pull Request

## 许可证

本项目采用 MIT 许可证 - 详情请参阅项目 LICENSE 文件。

---

*最后更新: 2025年8月*
*项目状态: 开发中*
