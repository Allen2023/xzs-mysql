# 学之思考试系统 - 完整部署指南

## 项目架构概览

本项目包含三个需要独立部署的组件：

### 1. 后端服务 (Java Spring Boot)
- **位置**: `source/xzs/`
- **端口**: 8000
- **构建工具**: Maven
- **运行环境**: JDK 8+
- **部署方式**: Docker (Railway/Vercel/其他容器平台)

### 2. 管理员前端 (Vue.js)
- **位置**: `source/vue/xzs-admin/`
- **框架**: Vue 2.x + Element UI
- **构建工具**: Vue CLI
- **部署方式**: 静态站点 (Vercel/Netlify/Nginx)

### 3. 学生端前端 (Vue.js)
- **位置**: `source/vue/xzs-student/`
- **框架**: Vue 2.x + Element UI
- **构建工具**: Vue CLI
- **部署方式**: 静态站点 (Vercel/Netlify/Nginx)

### 4. 微信小程序 (可选)
- **位置**: `source/wx/xzs-student/`
- **平台**: 微信小程序
- **部署方式**: 上传到微信小程序平台

---

## 部署架构图

```
┌─────────────────────────────────────────────────────────────┐
│                        用户访问层                              │
├─────────────────────┬─────────────────────┬──────────────────┤
│   管理员前端         │    学生端前端        │   微信小程序      │
│ (xzs-admin)         │  (xzs-student)      │                 │
│                     │                     │                 │
│ 部署平台: Vercel     │ 部署平台: Vercel    │ 微信平台         │
│ 或 Netlify          │ 或 Netlify          │                 │
└──────────┬──────────┴──────────┬──────────┴──────────────────┘
           │                     │
           │ HTTP/HTTPS          │ HTTP/HTTPS
           │                     │
           ▼                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    后端 API 服务                              │
│                    (xzs-backend)                             │
│                    Spring Boot + MySQL                       │
│                                                              │
│ 部署平台: Railway / 其他容器平台                              │
│ 端口: 8000                                                   │
└──────────┬───────────────────────────────────────────────────┘
           │
           │ JDBC
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│                    MySQL 数据库                              │
│                    (Railway MySQL / 外部)                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 完整部署步骤

### 第一阶段：部署后端服务

#### 1.1 在 Railway 部署后端

**步骤**:

1. **创建 Railway MySQL 数据库**
   - 登录 Railway
   - 新建项目 → Add Database → MySQL
   - Railway 会自动提供数据库连接信息

2. **初始化数据库**
   - 在 Railway MySQL 服务中点击 "Query"
   - 执行 SQL 文件 `source/xzs-mysql.sql` 的内容

3. **部署后端服务**
   - 在同一 Railway 项目中 → New Project → Deploy from GitHub
   - 选择你的代码仓库
   - Railway 会自动检测 `source/Dockerfile` 并开始构建

4. **配置环境变量**（可选）
   ```bash
   SPRING_PROFILES_ACTIVE=prod
   JAVA_OPTS=-Xmx512m -Xms256m
   TZ=Asia/Shanghai
   ```

5. **获取后端 API 地址**
   - 部署成功后，Railway 会生成一个域名
   - 例如: `https://your-backend.railway.app`
   - 记录这个地址，前端需要用到

**验证部署**:
```bash
curl https://your-backend.railway.app/api/admin/user/current
```

应该返回 JSON 响应（可能包含未登录错误，说明服务正常）

---

### 第二阶段：部署前端项目

#### 2.1 准备前端配置文件

前端需要配置后端 API 地址。需要修改环境变量文件：

**管理员前端配置** (`source/vue/xzs-admin/.env.prod`):
```env
NODE_ENV = 'production'
VUE_APP_URL = 'https://your-backend.railway.app'
```

**学生端前端配置** (`source/vue/xzs-student/.env.prod`):
```env
NODE_ENV = 'production'
VUE_APP_URL = 'https://your-backend.railway.app'
```

**注意**: 将 `https://your-backend.railway.app` 替换为你的实际后端地址

#### 2.2 本地构建前端（可选）

如果想在本地构建：

```bash
# 构建管理员前端
cd source/vue/xzs-admin
npm install
npm run build:prod

# 构建学生端前端
cd source/vue/xzs-student
npm install
npm run build:prod
```

构建产物在 `dist/` 目录

#### 2.3 在 Vercel 部署管理员前端

**方式 A: 通过 Vercel CLI**

```bash
# 安装 Vercel CLI
npm install -g vercel

# 部署管理员前端
cd source/vue/xzs-admin
vercel

# 部署学生端前端
cd source/vue/xzs-student
vercel
```

**方式 B: 通过 Vercel 网页界面**

1. 登录 [Vercel](https://vercel.com)
2. 点击 "New Project"
3. 导入你的 GitHub 仓库
4. **重要配置**:
   - **Root Directory**: `source/vue/xzs-admin`（管理端）或 `source/vue/xzs-student`（学生端）
   - **Framework Preset**: Vue.js
   - **Build Command**: `npm run build:prod`
   - **Output Directory**: `dist`
5. 点击 "Deploy"

#### 2.4 在 Netlify 部署（备选方案）

1. 登录 [Netlify](https://netlify.com)
2. 点击 "New site from Git"
3. 选择你的仓库
4. 配置构建设置:
   - **Build command**: `npm run build:prod`
   - **Publish directory**: `dist`
   - **Base directory**: `source/vue/xzs-admin` 或 `source/vue/xzs-student`
5. 部署

---

### 第三阶段：配置路由和域名

#### 3.1 前端路由配置

Vue 项目使用 history 模式，需要配置服务器重定向规则。

**Vercel 配置** - 创建 `vercel.json`:

在 `source/vue/xzs-admin/vercel.json`:
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

在 `source/vue/xzs-student/vercel.json`:
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

**Netlify 配置** - 创建 `netlify.toml`:

在 `source/vue/xzs-admin/netlify.toml`:
```toml
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

---

### 第四阶段：微信小程序部署（可选）

#### 4.1 准备小程序

1. **修改 API 地址**
   - 打开 `source/wx/xzs-student/utils/request.js`
   - 修改 `baseURL` 为你的后端地址

2. **使用微信开发者工具**
   - 打开微信开发者工具
   - 导入项目：选择 `source/wx/xzs-student` 目录
   - 填写 AppID（需要注册小程序）

3. **上传小程序**
   - 开发者工具 → 上传
   - 登录微信小程序平台 → 提交审核
   - 审核通过后发布

---

## 环境变量配置汇总

### 后端环境变量 (Railway)
```bash
# Spring 配置
SPRING_PROFILES_ACTIVE=prod

# 数据库（如果不用默认配置）
SPRING_DATASOURCE_URL=jdbc:mysql://host:port/db?...
SPRING_DATASOURCE_USERNAME=username
SPRING_DATASOURCE_PASSWORD=password

# JVM 参数
JAVA_OPTS=-Xmx512m -Xms256m

# 时区
TZ=Asia/Shanghai
```

### 前端环境变量

**管理员前端** (.env.prod):
```env
NODE_ENV='production'
VUE_APP_URL='https://your-backend.railway.app'
```

**学生端前端** (.env.prod):
```env
NODE_ENV='production'
VUE_APP_URL='https://your-backend.railway.app'
```

---

## 部署检查清单

### 后端服务
- [ ] MySQL 数据库已创建并初始化
- [ ] 后端服务成功部署到 Railway
- [ ] 环境变量已正确配置
- [ ] 后端服务健康检查通过
- [ ] API 接口可正常访问

### 管理员前端
- [ ] .env.prod 文件已配置正确的后端地址
- [ ] 项目成功构建
- [ ] 部署到 Vercel/Netlify
- [ ] 可以访问登录页面
- [ ] 可以正常登录

### 学生端前端
- [ ] .env.prod 文件已配置正确的后端地址
- [ ] 项目成功构建
- [ ] 部署到 Vercel/Netlify
- [ ] 可以访问登录页面
- [ ] 可以正常登录

### 微信小程序（如需要）
- [ ] API 地址已修改
- [ ] 小程序已上传到微信平台
- [ ] 已通过审核并发布

---

## 访问地址示例

部署成功后，你会有以下访问地址：

- **后端 API**: `https://your-backend.railway.app`
- **管理员前端**: `https://xzs-admin.vercel.app`
- **学生端前端**: `https://xzs-student.vercel.app`

**默认登录信息**（数据库初始化后）:
- 管理员: `admin` / `123456`
- 学生: 需要先注册

---

## 故障排查

### 后端无法启动
- 检查数据库连接配置
- 查看 Railway 日志
- 确认环境变量正确

### 前端无法连接后端
- 检查 .env.prod 中的 VUE_APP_URL
- 确认后端服务正常运行
- 检查浏览器控制台的网络请求

### 前端路由 404
- 确认已配置 vercel.json 或 netlify.toml
- 检查服务器重定向规则

---

## 成本估算

使用免费/免费额度的平台：

| 服务 | 平台 | 免费额度 |
|------|------|---------|
| 后端 | Railway | $5/月 免费额度 |
| 数据库 | Railway MySQL | 512MB 存储 |
| 前端 | Vercel | 100GB 带宽/月 |
| 前端 | Netlify | 100GB 带宽/月 |

**注意**: 免费额度有限，生产环境建议升级付费计划。

---

## 下一步

1. **自定义域名**: 为各个服务配置自定义域名
2. **HTTPS 证书**: 所有平台自动提供，无需配置
3. **CDN 加速**: Vercel/Netlify 自动提供全球 CDN
4. **监控告警**: 配置服务监控和错误告警
5. **数据备份**: 定期备份数据库

---

## 相关文档

- [Railway 部署详细指南](RAILWAY_DEPLOY.md)
- [项目 README](README.md)
- [官方文档](https://www.mindskip.net:999)
