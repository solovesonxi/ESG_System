# ESG System

## 项目概述
ESG System 是一个用于管理和监控企业环境、社会和治理数据的综合系统，支持工厂填报数据、总部分析汇总，用户还可以通过自然语言查询数据获取智能分析结果。

## 核心功能
- **数据填报**：15类月度定量数据和7类年度数据，支持自定义。
- **数据分析**：工厂级进度跟踪与数据聚合。
- **权限控制**：部门账号、工厂账号、总部账号、管理员账号。
- **图表分析**：动态生成柱状图、折线图等可视化图表。
- **AI 聊天**：通过自然语言交互查询数据。

## 技术栈
- **后端**：Python + FastAPI + SQLAlchemy + Redis
- **前端**：Vue.js 3 + Vite + Pinia
- **数据库**：Postgres（主库） + Redis（缓存）

## 快速启动
### 1. 启动 Redis（Docker）
```sh
docker run --name esg-redis -p 6379:6379 -d redis
```

### 2. 后端启动
#### 开发环境
```sh
cd backend
pip install -r requirements.txt
psql -h localhost -p 5432 -U postgres -d esg_db -f init_database.sql
uvicorn main:app --reload
```
访问：http://localhost:8000/docs

#### 生产环境
```sh
cd backend
pip install -r requirements.txt
psql -h localhost -p 5432 -U postgres -d esg_db -f init_database.sql
gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app
```
访问：http://your-server-ip:8000

### 3. 前端启动
#### 开发环境
```sh
cd frontend
npm install
npm run dev
```
访问：http://localhost:5173

#### 生产环境
```sh
cd frontend
npm install
npm run build
npm run preview
```
访问：http://your-server-ip:4173

## 项目结构
### Backend
- `main.py` - 主入口文件和 API 端点。
- `dump_db.py` - 数据库备份脚本。
- `requirements.txt` - Python 依赖配置。
- `core/` - 核心模块：
  - `calculation.py` - 字段计算函数。
  - `dependencies.py` - 依赖注入配置。
  - `dynamic_mapping.py` - 数据库自动映射配置。
  - `models.py` - 数据库模型定义。
  - `permissions.py` - 权限控制逻辑。
  - `schemas.py` - 数据模型定义。
  - `utils.py` - 核心工具函数。
- `routers/` - API 路由：
  - `account.py` - 账号管理接口。
  - `agent.py` - AI 聊天接口。
  - `auth.py` - 用户认证相关接口。
  - `category.py` - 分类管理接口。
  - `field.py` - 字段管理接口。
  - `message.py` - 消息通知接口。
  - `monthlt_data.py` - 月度数据接口。
  - `progress.py` - 进度跟踪接口。
  - `review.py` - 审核管理接口。
  - `summary_data.py` - 汇总数据接口。
  - `user.py` - 个人信息接口。
  - `yearly_data.py` - 年度数据接口。
- `static/` - 静态资源：
  - `avatars/` - 用户头像。
  - `icons/` - 图标图片。
  - `init_db.sql` - 数据库初始化脚本。

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
  - `views/` - 页面组件：
    - `AIChatView.vue` - AI 聊天界面。
    - `Home.vue` - 主界面（含图表分析）。

## 安全设计
- Access Token（30分钟） + Refresh Token（1小时）
- 输入验证防 SQL 注入

## 许可证
Apache-2.0 License - 详见 `LICENSE` 文件。
