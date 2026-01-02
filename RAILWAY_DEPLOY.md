# Railway Docker 部署指南

本指南将帮助您在 Railway 平台上使用 Docker 部署学之思考试系统。

## 前置要求

1. Railway 账号（[https://railway.app](https://railway.app)）
2. GitHub/GitLab/Bitbucket 账号（用于连接代码仓库）
3. MySQL 数据库（Railway 提供或使用外部数据库）

## 部署步骤

### 1. 准备代码仓库

确保您的代码已推送到 GitHub/GitLab/Bitbucket 等 Git 托管平台。

### 2. 在 Railway 创建项目

1. 登录 Railway 控制台
2. 点击 "New Project"
3. 选择 "Deploy from GitHub repo"（或您使用的 Git 平台）
4. 选择您的代码仓库
5. 选择要部署的分支（通常是 `main` 或 `master`）

### 3. 配置数据库

#### 选项 A：使用 Railway 提供的 MySQL

1. 在 Railway 项目中点击 "New"
2. 选择 "Database" → "Add MySQL"
3. Railway 会自动创建 MySQL 数据库实例
4. 记下数据库连接信息（会在环境变量中自动设置）

#### 选项 B：使用外部 MySQL 数据库

如果您使用外部 MySQL 数据库，需要手动设置环境变量。

### 4. 配置环境变量

**重要提示**：项目已配置为 Docker 模式，所有数据库连接信息通过环境变量配置，不再硬编码在配置文件中。

在 Railway 项目设置中，添加以下环境变量：

#### 必需的环境变量

```bash
# Spring 配置
SPRING_PROFILES_ACTIVE=prod

# 数据库配置（如果使用 Railway MySQL，这些会自动设置）
SPRING_DATASOURCE_URL=jdbc:mysql://MYSQLHOST:PORT/MYSQLDATABASE?useSSL=false&useUnicode=true&serverTimezone=Asia/Shanghai&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&allowMultiQueries=true
SPRING_DATASOURCE_USERNAME=root
SPRING_DATASOURCE_PASSWORD=your_password
SPRING_DATASOURCE_DRIVER_CLASS_NAME=com.mysql.cj.jdbc.Driver

# JVM 参数（可选）
JAVA_OPTS=-Xmx512m -Xms256m

# 时区
TZ=Asia/Shanghai
```

#### 如果使用 Railway MySQL

Railway 会自动提供以下环境变量：
- `MYSQLHOST`
- `MYSQLPORT`
- `MYSQLDATABASE`
- `MYSQLUSER`
- `MYSQLPASSWORD`

您需要在应用服务中设置：

```bash
SPRING_PROFILES_ACTIVE=prod
SPRING_DATASOURCE_URL=jdbc:mysql://${MYSQLHOST}:${MYSQLPORT}/${MYSQLDATABASE}?useSSL=false&useUnicode=true&serverTimezone=Asia/Shanghai&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&allowMultiQueries=true
SPRING_DATASOURCE_USERNAME=${MYSQLUSER}
SPRING_DATASOURCE_PASSWORD=${MYSQLPASSWORD}
SPRING_DATASOURCE_DRIVER_CLASS_NAME=com.mysql.cj.jdbc.Driver
TZ=Asia/Shanghai
```

**配置说明**：
- 配置文件（`application-prod.yml` 等）已更新为使用环境变量占位符
- 如果环境变量未设置，将使用默认值（localhost:3306/xzs）
- 在 Docker/Railway 环境中，必须通过环境变量提供数据库连接信息

### 5. 配置构建和部署

1. 在 Railway 项目设置中，找到 "Settings"
2. 在 "Build" 部分，确保：
   - Root Directory: `source`（如果 Dockerfile 在 source 目录）
   - 或者 Root Directory: `.`（如果 Dockerfile 在根目录）

### 6. 初始化数据库

在首次部署前，您需要：

1. 连接到 MySQL 数据库
2. 执行 SQL 初始化脚本（通常在 `sql/` 目录下）
3. 或者使用 Railway 的数据库管理工具导入 SQL 文件

### 7. 部署

1. Railway 会自动检测到 Dockerfile 并开始构建
2. 构建完成后会自动部署
3. 查看部署日志确保应用正常启动

### 8. 配置域名（可选）

1. 在 Railway 项目设置中，找到 "Settings" → "Networking"
2. 点击 "Generate Domain" 生成一个 Railway 域名
3. 或者添加自定义域名

### 9. 访问应用

部署成功后，您可以通过 Railway 提供的域名访问应用：
- 后端 API: `https://your-app.railway.app`
- 默认端口: 8000（Railway 会自动处理端口映射）

## 故障排查

### 构建失败

- 检查 Dockerfile 路径是否正确
- 查看构建日志中的错误信息
- 确保 Maven 依赖可以正常下载

### 应用启动失败

- 检查环境变量是否正确设置
- 查看应用日志确认数据库连接是否成功
- 确认数据库已初始化

### 数据库连接问题

- 验证数据库连接字符串格式
- 确认数据库允许外部连接
- 检查防火墙和网络设置

## 注意事项

1. **数据库初始化**：首次部署需要手动执行 SQL 初始化脚本
2. **静态资源**：前端资源需要单独部署或使用 CDN
3. **文件上传**：如果需要文件上传功能，建议使用对象存储服务（如七牛云、AWS S3）
4. **日志**：Railway 提供日志查看功能，可以在控制台查看应用日志
5. **资源限制**：注意 Railway 的免费额度限制

## 更新应用

当您推送新代码到 Git 仓库时，Railway 会自动触发重新构建和部署。

## 相关文件

- `source/Dockerfile` - Docker 构建文件
- `railway.json` - Railway 配置文件（可选）
- `.dockerignore` - Docker 构建忽略文件

## 更多信息

- Railway 文档: [https://docs.railway.app](https://docs.railway.app)
- 学之思项目文档: [https://www.mindskip.net:999](https://www.mindskip.net:999)

