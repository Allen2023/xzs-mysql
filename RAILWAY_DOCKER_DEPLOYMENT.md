# 🚀 Railway 全栈 Docker 部署完整指南

在 Railway 上使用 Docker 完整部署学之思考试系统（后端 + 管理端 + 学生端）

---

## 📋 部署架构

```
Railway Project
├── MySQL Database        (数据库服务)
├── Backend Service       (后端 API - Spring Boot - Docker)
├── Admin Frontend        (管理员前端 - Vue + Nginx - Docker)
└── Student Frontend      (学生端前端 - Vue + Nginx - Docker)
```

---

## 🎯 核心特性

✅ **全 Docker 部署** - 所有服务都使用 Docker 容器
✅ **自动环境变量注入** - 前端通过 Railway 环境变量配置后端地址
✅ **Nginx 反向代理** - 前端自动代理 API 请求到后端
✅ **国内镜像加速** - Maven 和 npm 使用国内镜像源
✅ **健康检查** - 自动监控服务状态
✅ **CORS 支持** - 前端后端跨域问题自动解决

---

## 📂 项目文件结构

```
xzs-mysql/
├── source/
│   ├── Dockerfile                    ✅ 后端 Docker 配置
│   ├── xzs-mysql.sql                 ✅ 数据库初始化文件
│   ├── xzs/                          📦 后端源码
│   │   └── src/main/resources/
│   │       └── application-prod.yml  ✅ 生产环境配置
│   └── vue/
│       ├── xzs-admin/                📦 管理员前端
│       │   ├── Dockerfile            ✅ Docker 配置
│       │   ├── nginx.conf.template   ✅ Nginx 配置模板
│       │   ├── docker-entrypoint.sh  ✅ 启动脚本
│       │   ├── .dockerignore         ✅ Docker 忽略文件
│       │   └── .env.production       ⚠️ 需配置后端地址（可选）
│       └── xzs-student/              📦 学生端前端
│           ├── Dockerfile            ✅ Docker 配置
│           ├── nginx.conf.template   ✅ Nginx 配置模板
│           ├── docker-entrypoint.sh  ✅ 启动脚本
│           ├── .dockerignore         ✅ Docker 忽略文件
│           └── .env.production       ⚠️ 需配置后端地址（可选）
└── railway.json                      ✅ Railway 配置
```

---

## 🚀 部署步骤

### 准备工作

1. ✅ GitHub 账号
2. ✅ Railway 账号 ([https://railway.app](https://railway.app))
3. ✅ 代码已推送到 GitHub

---

### 第一步：创建 Railway 项目并部署数据库

#### 1.1 创建项目

1. 登录 [Railway](https://railway.app)
2. 点击 **"New Project"**
3. 选择 **"Deploy from GitHub repo"**
4. 选择你的代码仓库（暂时不点击 Deploy）

#### 1.2 创建 MySQL 数据库

1. 在项目页面，点击 **"New"** → **"Database"**
2. 选择 **"MySQL"**
3. 等待数据库创建完成（约 1-2 分钟）

#### 1.3 初始化数据库

1. 点击创建的 MySQL 数据库服务
2. 进入 **"Query"** 标签
3. 复制以下文件的全部内容：
   - 文件位置：`source/xzs-mysql.sql`
4. 粘贴到 Query 编辑器
5. 点击 **"Run"** 执行 SQL

✅ **数据库初始化完成！**

---

### 第二步：部署后端 API 服务

#### 2.1 创建后端服务

1. 在 Railway 项目中，点击 **"New"** → **"Deploy from GitHub repo"**
2. 选择同一个仓库
3. 点击 **"Deploy"**

#### 2.2 配置后端服务

Railway 会自动检测 `railway.json` 配置。

**手动配置**（如果自动检测失败）：
- Root Directory: `source`
- Dockerfile Path: `Dockerfile`

**环境变量**（点击 "Variables" 添加）：
```bash
SPRING_PROFILES_ACTIVE=prod
JAVA_OPTS=-Xmx512m -Xms256m
TZ=Asia/Shanghai
```

**说明**：
- `application-prod.yml` 已包含默认的 Railway MySQL 配置
- Railway 会自动注入 `MYSQLHOST`、`MYSQLPORT` 等环境变量
- 如需覆盖默认配置，可手动添加数据库环境变量

#### 2.3 等待部署

- 构建时间：约 5-10 分钟（首次构建需要下载 Maven 依赖）
- 可以点击服务查看实时日志

#### 2.4 获取后端 URL

部署成功后：
1. 点击后端服务
2. 在页面顶部可以看到生成的 URL
3. 格式如：`https://xzs-backend-production.up.railway.app`
4. **复制这个 URL**，前端部署时需要用到

#### 2.5 验证后端

访问健康检查接口：
```bash
curl https://你的后端URL/api/admin/user/current
```

应该返回 JSON 响应（可能包含错误码 401，说明服务正常）

✅ **后端部署完成！**

---

### 第三步：部署管理员前端

#### 3.1 创建管理员前端服务

1. 在 Railway 项目中，点击 **"New"** → **"Deploy from GitHub repo"**
2. 选择同一个仓库
3. 配置：
   - **Root Directory**: `source/vue/xzs-admin`
   - **Dockerfile Path**: `Dockerfile`
4. 点击 **"Deploy"**

#### 3.2 配置环境变量

点击服务的 **"Variables"** 标签，添加环境变量：

```bash
VUE_APP_URL=https://你的后端URL
```

**重要**：
- 将 `https://你的后端URL` 替换为第二步中复制的实际后端地址
- 例如：`VUE_APP_URL=https://xzs-backend-production.up.railway.app`

**说明**：
- 这个环境变量会被 Nginx 配置使用
- Nginx 会将 `/api/*` 请求代理到后端
- 前端代码无需修改，构建时会使用 `.env.production` 中的配置

#### 3.3 等待部署

- 构建时间：约 3-5 分钟
- 首次构建需要下载 npm 依赖

#### 3.4 获取前端 URL

部署成功后：
1. 点击管理员前端服务
2. 复制页面顶部的 URL
3. 例如：`https://xzs-admin-production.up.railway.app`

✅ **管理员前端部署完成！**

---

### 第四步：部署学生端前端

#### 4.1 创建学生端服务

1. 在 Railway 项目中，点击 **"New"** → **"Deploy from GitHub repo"**
2. 选择同一个仓库
3. 配置：
   - **Root Directory**: `source/vue/xzs-student`
   - **Dockerfile Path**: `Dockerfile`
4. 点击 **"Deploy"**

#### 4.2 配置环境变量

点击服务的 **"Variables"** 标签，添加环境变量：

```bash
VUE_APP_URL=https://你的后端URL
```

**注意**：
- 使用与后端相同的 URL
- 与管理员前端使用相同的后端地址

#### 4.3 等待部署

- 构建时间：约 3-5 分钟

#### 4.4 获取前端 URL

部署成功后复制学生端 URL。

✅ **学生端前端部署完成！**

---

## ✅ 验证部署

### 1. 验证后端服务

```bash
# 健康检查
curl https://你的后端URL/api/admin/user/current
```

**预期结果**：返回 JSON 响应

### 2. 验证管理员前端

1. 访问管理员前端 URL
2. 应该看到登录页面
3. 使用默认账号登录：
   - 用户名：`admin`
   - 密码：`123456`
4. 应该能成功进入管理后台

### 3. 验证学生端前端

1. 访问学生端 URL
2. 应该看到登录/注册页面
3. 点击"注册"创建新学生账号
4. 登录后应该能看到学生界面

---

## 🔧 工作原理

### Docker 容器架构

#### 后端容器（Spring Boot）
```dockerfile
构建阶段: Maven 3.8.6 + JDK 8
├── 下载依赖（使用阿里云镜像）
├── 编译打包
└── 生成 JAR 文件

运行阶段: JRE 8
├── 复制 JAR 文件
├── 暴露 8000 端口
└── 启动 Spring Boot 应用
```

#### 前端容器（Vue + Nginx）
```dockerfile
构建阶段: Node 16 + Alpine
├── 下载依赖（使用国内镜像）
├── Vue CLI 构建
└── 生成静态文件

运行阶段: Nginx + Alpine
├── 复制静态文件
├── 配置 Nginx 反向代理
├── 暴露 80 端口
└── 启动 Nginx
```

### 环境变量流程

```
Railway 环境变量
    ↓
docker-entrypoint.sh
    ↓
nginx.conf.template (envsubst)
    ↓
nginx.conf (运行时配置)
    ↓
API 请求代理到后端
```

### 请求流程

```
浏览器 → 前端容器 (Nginx)
    ↓
静态资源: 直接返回 HTML/JS/CSS
API 请求: 代理到后端容器
    ↓
后端容器 (Spring Boot)
    ↓
MySQL 容器
```

---

## 📊 服务最终结构

| 服务名 | 类型 | 端口 | URL 示例 |
|--------|------|------|---------|
| MySQL | Database | 3306 | 内部访问 |
| Backend | API | 8000 | `https://xzs-backend-xxx.up.railway.app` |
| Admin | Frontend | 80 | `https://xzs-admin-xxx.up.railway.app` |
| Student | Frontend | 80 | `https://xzs-student-xxx.up.railway.app` |

---

## 🔄 更新部署

代码更新后，Railway 会自动检测并重新部署。

### 手动触发部署

1. 进入服务页面
2. 点击 **"Deployments"** 标签
3. 点击 **"New Deployment"**
4. 选择分支并点击 **"Deploy Now"**

### 查看部署日志

1. 进入服务页面
2. 点击 **"Deployments"** 标签
3. 点击具体的部署记录
4. 查看实时日志

---

## 💰 费用说明

Railway 免费额度：**$5/月**

### 各服务成本估算

| 服务 | 预估成本/月 |
|------|-----------|
| MySQL | ~$2 |
| Backend (Java) | ~$2-3 |
| Admin Frontend (Nginx) | ~$0.5-1 |
| Student Frontend (Nginx) | ~$0.5-1 |
| **总计** | **~$5-7** |

**超出免费额度的部分**：约 $0-2/月

**省钱建议**：
- 使用 Railway 的暂停功能（不使用时暂停服务）
- 将前端部署到 Vercel（完全免费）
- 升级到付费计划可以获得更好的性能

---

## 🛠️ 故障排查

### 问题 1：后端构建失败

**症状**：Docker 构建错误，无法找到文件

**解决方案**：
1. 检查 `source/Dockerfile` 是否存在
2. 确认构建上下文是 `source` 目录
3. 检查 `source/xzs/` 目录结构是否正确
4. 查看构建日志定位具体错误

### 问题 2：数据库连接失败

**症状**：后端日志显示无法连接数据库

**解决方案**：
1. 确认数据库已初始化（执行了 SQL 文件）
2. 检查环境变量 `SPRING_PROFILES_ACTIVE=prod`
3. 查看 `application-prod.yml` 配置
4. Railway 会自动注入数据库环境变量，检查是否正确

### 问题 3：前端无法连接后端

**症状**：前端页面显示但 API 请求失败

**解决方案**：
1. 检查前端服务的环境变量 `VUE_APP_URL`
2. 确认后端服务正在运行
3. 打开浏览器开发者工具查看 Network 请求
4. 检查 Nginx 配置是否正确加载了环境变量

### 问题 4：前端页面空白或 404

**症状**：访问前端 URL 显示空白页或 404

**解决方案**：
1. 检查 Dockerfile 是否正确复制了构建产物
2. 确认 `nginx.conf.template` 文件存在
3. 查看前端服务日志
4. 确认构建成功生成了 `dist` 目录

### 问题 5：前端路由刷新 404

**症状**：Vue Router 页面刷新后 404

**解决方案**：
1. 检查 `nginx.conf.template` 中的 `try_files` 配置
2. 确认有 `try_files $uri $uri/ /index.html;`
3. 重新部署前端服务

### 问题 6：CORS 错误

**症状**：浏览器控制台显示跨域错误

**解决方案**：
1. Nginx 配置已包含 CORS 头，检查是否正确
2. 或者在后端 `application-prod.yml` 中配置 CORS
3. 确认前端通过 Nginx 代理访问后端，而不是直接访问

---

## 🎯 优化建议

### 性能优化

1. **启用缓存**：Nginx 已配置静态资源缓存
2. **Gzip 压缩**：已启用，减少传输大小
3. **数据库索引**：确保 SQL 文件中的索引已创建
4. **JVM 参数**：根据实际负载调整 `JAVA_OPTS`

### 安全优化

1. **修改默认密码**：首次登录后立即修改 admin 密码
2. **HTTPS**：Railway 自动提供，无需配置
3. **环境变量**：不要在代码中硬编码敏感信息
4. **数据库备份**：定期备份 Railway MySQL 数据

### 监控和日志

1. **Railway Metrics**：查看各服务的 CPU、内存使用
2. **日志查看**：在服务页面查看实时日志
3. **健康检查**：后端已配置健康检查端点
4. **告警设置**：Railway 支持邮件告警

---

## 📚 进阶配置

### 自定义域名

1. 进入服务设置
2. 点击 **"Networking"** → **"Domains"**
3. 点击 **"Add Domain"**
4. 输入域名（如 `admin.yourdomain.com`）
5. 在域名注册商配置 DNS：
   - 类型：`CNAME`
   - 名称：`admin`
   - 值：你的 Railway URL

### 自动备份

Railway 的付费计划支持自动备份。

### 多环境部署

创建多个 Railway 项目：
- 开发环境
- 测试环境
- 生产环境

使用不同的 GitHub 分支部署。

---

## 📞 技术支持

- **Railway 文档**: [https://docs.railway.app](https://docs.railway.app)
- **项目文档**: [https://www.mindskip.net:999](https://www.mindskip.net:999)
- **QQ 群**: 700540955
- **GitHub Issues**: [https://github.com/mindskip/xzs-mysql/issues](https://github.com/mindskip/xzs-mysql/issues)

---

## 🎉 部署完成

恭喜！你现在拥有一个完整部署在 Railway 上的全栈考试系统：

✅ MySQL 数据库运行中
✅ 后端 API 服务运行中
✅ 管理员前端可访问
✅ 学生端前端可访问

**下一步**：
1. 修改默认密码
2. 配置自定义域名（可选）
3. 设置监控告警
4. 开始使用系统！

---

**祝使用愉快！🎊**
