# Railway 全栈部署指南 - 后端 + 前端

本指南将帮助你在 Railway 上同时部署后端 API、管理员前端和学生端前端。

## 📋 部署架构

```
Railway Project
├── MySQL Database (数据库服务)
├── Backend Service (后端 API - Java)
├── Admin Frontend (管理员前端 - Vue + Nginx)
└── Student Frontend (学生端前端 - Vue + Nginx)
```

---

## 🚀 部署步骤

### 第一步：在 Railway 创建项目

1. 登录 [Railway](https://railway.app)
2. 点击 **"New Project"**
3. 选择 **"Deploy from GitHub repo"**
4. 选择你的代码仓库

---

### 第二步：创建 MySQL 数据库

1. 在 Railway 项目中，点击 **"New"** → **"Database"**
2. 选择 **"MySQL"**
3. 等待数据库创建完成（Railway 会自动生成连接信息）

#### 初始化数据库

1. 点击创建的 MySQL 数据库服务
2. 进入 **"Query"** 标签
3. 复制 `source/xzs-mysql.sql` 文件的全部内容
4. 粘贴到 Query 编辑器
5. 点击 **"Run"** 执行 SQL

**完成后**，数据库表就创建好了。

---

### 第三步：部署后端 API 服务

1. 在 Railway 项目中，点击 **"New"** → **"Deploy from GitHub repo"**
2. 选择同一个仓库
3. Railway 会自动检测到 `railway.json` 配置

#### 配置后端服务

在服务设置中，配置以下内容：

**Root Directory**: `source`

**Dockerfile Path**: `Dockerfile`（会自动检测 `source/Dockerfile`）

**环境变量**（点击 "Variables" 添加）:
```bash
SPRING_PROFILES_ACTIVE=prod
JAVA_OPTS=-Xmx512m -Xms256m
TZ=Asia/Shanghai
```

**注意**：
- 配置文件 `application-prod.yml` 中已包含默认的 Railway MySQL 配置
- Railway 会自动注入 `MYSQLHOST`、`MYSQLPORT` 等环境变量
- 如果需要覆盖，可以手动添加 `SPRING_DATASOURCE_URL` 等环境变量

4. 点击 **"Deploy"**
5. 等待构建完成（可能需要 5-10 分钟）

#### 获取后端 URL

部署成功后：
1. 点击后端服务
2. 在顶部会看到生成的 URL
3. 例如：`https://xzs-backend-production.up.railway.app`
4. **复制这个 URL**，前端需要用到

---

### 第四步：部署管理员前端

1. 在 Railway 项目中，点击 **"New"** → **"Deploy from GitHub repo"**
2. 选择同一个仓库

#### 配置管理员前端

**Root Directory**: `source/vue/xzs-admin`

**Dockerfile Path**: `Dockerfile`（会自动检测）

**环境变量**:
```bash
VUE_APP_URL=https://你的后端URL
```

**重要**：将 `https://你的后端URL` 替换为第三步中复制的实际后端地址

例如：
```bash
VUE_APP_URL=https://xzs-backend-production.up.railway.app
```

**构建参数**（Build Config）:
如果 Railway 支持 Build Args，添加：
```
VUE_APP_URL=https://你的后端URL
```

如果不支持 Build Args，需要修改 `.env.production` 文件（见下方说明）

3. 点击 **"Deploy"**
4. 等待构建完成（2-5 分钟）

#### 修改方案：使用 .env.production（推荐）

如果 Railway 不支持传递构建参数，直接修改源代码：

1. 编辑 `source/vue/xzs-admin/.env.production`
2. 将 `VUE_APP_URL` 改为实际的后端地址
3. 提交到 Git
4. 重新部署

---

### 第五步：部署学生端前端

1. 在 Railway 项目中，点击 **"New"** → **"Deploy from GitHub repo"**
2. 选择同一个仓库

#### 配置学生端前端

**Root Directory**: `source/vue/xzs-student`

**Dockerfile Path**: `Dockerfile`

**环境变量**:
```bash
VUE_APP_URL=https://你的后端URL
```

**同样修改** `source/vue/xzs-student/.env.production` 文件，将后端地址写进去

3. 点击 **"Deploy"**
4. 等待构建完成

---

## 🔗 最终的服务结构

部署完成后，你的 Railway 项目会包含以下服务：

| 服务名称 | 类型 | URL 示例 | 用途 |
|---------|------|---------|------|
| MySQL | Database | `mysql://xxx` | 数据存储 |
| Backend | API | `https://xzs-backend-xxx.up.railway.app` | 后端 API |
| Admin | Frontend | `https://xzs-admin-xxx.up.railway.app` | 管理员界面 |
| Student | Frontend | `https://xzs-student-xxx.up.railway.app` | 学生界面 |

---

## ✅ 验证部署

### 1. 验证后端

访问后端健康检查接口：
```bash
curl https://你的后端URL/api/admin/user/current
```

应该返回 JSON 响应（可能包含错误码，但说明服务运行正常）

### 2. 验证管理员前端

1. 访问管理员前端 URL
2. 应该看到登录页面
3. 使用默认账号登录：
   - 用户名: `admin`
   - 密码: `123456`
4. 应该能成功进入管理后台

### 3. 验证学生端前端

1. 访问学生端 URL
2. 应该看到登录/注册页面
3. 可以注册新学生账号
4. 登录后应该能看到学生界面

---

## 📝 配置文件总结

已创建的配置文件：

```
source/
├── Dockerfile                          # 后端 Docker 配置
├── xzs-mysql.sql                       # 数据库初始化文件
├── vue/
│   ├── xzs-admin/
│   │   ├── Dockerfile                  # 管理员前端 Docker 配置
│   │   ├── nginx.conf                  # Nginx 配置
│   │   └── .env.production             # 生产环境变量
│   └── xzs-student/
│       ├── Dockerfile                  # 学生端前端 Docker 配置
│       ├── nginx.conf                  # Nginx 配置
│       └── .env.production             # 生产环境变量
└── xzs/
    └── src/main/resources/application-prod.yml  # 后端生产配置
```

---

## ⚙️ 环境变量完整配置

### 后端服务
```bash
# Spring 配置
SPRING_PROFILES_ACTIVE=prod

# JVM 参数
JAVA_OPTS=-Xmx512m -Xms256m

# 时区
TZ=Asia/Shanghai

# 数据库（可选，覆盖默认配置）
# SPRING_DATASOURCE_URL=jdbc:mysql://host:port/db?...
# SPRING_DATASOURCE_USERNAME=username
# SPRING_DATASOURCE_PASSWORD=password
```

### 管理员前端
```bash
# 后端 API 地址
VUE_APP_URL=https://你的后端URL
```

### 学生端前端
```bash
# 后端 API 地址
VUE_APP_URL=https://你的后端URL
```

---

## 🛠️ 故障排查

### 后端无法启动

**问题**: 构建失败或服务启动失败

**解决**:
1. 检查 Railway 构建日志
2. 确认 `source/Dockerfile` 存在且正确
3. 检查数据库是否已初始化（执行了 SQL 文件）
4. 查看环境变量是否正确

### 前端无法连接后端

**问题**: 前端可以访问，但 API 请求失败

**解决**:
1. 检查 `.env.production` 或环境变量中的 `VUE_APP_URL` 是否正确
2. 确认后端服务是否正常运行
3. 打开浏览器开发者工具，查看 Network 请求
4. 检查是否有 CORS 错误

### 前端页面空白或 404

**问题**: 访问前端 URL 显示空白或 404

**解决**:
1. 检查 `nginx.conf` 是否存在且正确
2. 检查构建产物是否正确生成
3. 查看 Railway 日志，确认 Nginx 是否正常启动
4. 尝试重新构建部署

### 前端路由刷新 404

**问题**: Vue Router 页面刷新后 404

**解决**:
1. 确认 `nginx.conf` 中有 `try_files $uri $uri/ /index.html;`
2. 重新部署前端服务

---

## 💰 成本说明

Railway 免费额度：
- **每月 $5 免费额度**
- **500 小时运行时间/月**
- **512MB 数据库**

每个服务都会消耗额度：
- 后端服务（Java）：~$2-3/月
- 数据库：~$2/月
- 前端服务（Nginx）：~$0.5-1/月/个

**总计**: 4 个服务大约 $6-8/月，会超出免费额度。

**省钱方案**:
1. 只在需要时启动服务（使用 Railway 的暂停功能）
2. 前端部署到 Vercel/Netlify（完全免费）
3. 使用更小的实例规格

---

## 🔄 更新部署

当代码更新后：

1. **推送代码到 GitHub**
2. **Railway 会自动检测到更新**
3. **自动触发重新构建和部署**
4. **可以在 Railway 控制台查看部署进度**

如果需要手动重新部署：
1. 进入服务页面
2. 点击 **"Deployments"** 标签
3. 点击 **"New Deployment"**
4. 选择分支并点击 **"Deploy Now"**

---

## 🌐 自定义域名

为服务添加自定义域名：

1. 进入服务设置
2. 点击 **"Networking"** 或 **"Domains"**
3. 点击 **"Add Domain"**
4. 输入你的域名（如 `admin.yourdomain.com`）
5. 在域名注册商配置 DNS：
   - 类型: `CNAME`
   - 名称: `admin`
   - 值: 你的 Railway URL

Railway 会自动配置 SSL 证书。

---

## 📊 监控和日志

### 查看日志
1. 进入服务页面
2. 点击 **"Metrics"** 或 **"Logs"** 标签
3. 实时查看服务日志

### 健康检查
- 后端：`/api/admin/user/current`
- 前端：Nginx 默认健康检查

### 资源使用
1. 进入项目设置
2. 查看 **"Metrics"** 标签
3. 查看各服务的 CPU、内存、网络使用情况

---

## 🎯 下一步

部署成功后：

1. ✅ 修改默认密码
2. ✅ 配置自定义域名
3. ✅ 设置监控告警
4. ✅ 配置自动备份
5. ✅ 优化性能和成本

---

## 📞 技术支持

- Railway 文档: [https://docs.railway.app](https://docs.railway.app)
- 项目文档: [https://www.mindskip.net:999](https://www.mindskip.net:999)
- QQ 群: 700540955

---

**祝部署顺利！🎉**
