# Railway 快速部署指南

## 一键部署步骤

### 1. 准备代码
确保代码已推送到 GitHub/GitLab/Bitbucket

### 2. 在 Railway 创建项目
1. 访问 [Railway](https://railway.app) 并登录
2. 点击 **"New Project"**
3. 选择 **"Deploy from GitHub repo"**
4. 选择您的代码仓库

### 3. 添加 MySQL 数据库
1. 在项目中点击 **"New"**
2. 选择 **"Database"** → **"Add MySQL"**
3. Railway 会自动创建数据库

### 4. 配置应用服务
1. 在应用服务中，进入 **"Variables"** 标签
2. 添加以下环境变量：

```bash
SPRING_PROFILES_ACTIVE=prod
SPRING_DATASOURCE_URL=jdbc:mysql://${MYSQLHOST}:${MYSQLPORT}/${MYSQLDATABASE}?useSSL=false&useUnicode=true&serverTimezone=Asia/Shanghai&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&allowMultiQueries=true
SPRING_DATASOURCE_USERNAME=${MYSQLUSER}
SPRING_DATASOURCE_PASSWORD=${MYSQLPASSWORD}
SPRING_DATASOURCE_DRIVER_CLASS_NAME=com.mysql.cj.jdbc.Driver
TZ=Asia/Shanghai
```

**注意**：项目已配置为 Docker 模式，数据库连接通过环境变量配置，不再硬编码。

### 5. 初始化数据库
1. 在数据库服务中，点击 **"Connect"** 获取连接信息
2. 使用 MySQL 客户端连接数据库
3. 从 [文档网站](https://www.mindskip.net:999) 下载 SQL 初始化脚本
4. 执行 SQL 脚本初始化数据库

### 6. 部署
Railway 会自动检测 Dockerfile 并开始构建部署

### 7. 访问应用
部署成功后，Railway 会提供一个域名，例如：
- `https://your-app.railway.app`

## 重要提示

- **数据库初始化**：首次部署必须执行 SQL 初始化脚本
- **环境变量**：确保所有环境变量都已正确设置
- **构建路径**：如果 Dockerfile 在 `source/` 目录，需要在 Railway 设置中指定 Root Directory 为 `source`

## 详细文档

查看 `RAILWAY_DEPLOY.md` 获取更详细的部署说明。

