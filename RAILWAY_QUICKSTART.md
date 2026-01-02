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
2. **只需添加一个环境变量**（数据库配置已在配置文件中设置好）：

```bash
SPRING_PROFILES_ACTIVE=prod
```

**说明**：
- 配置文件 `application-prod.yml` 已包含默认的 Railway MySQL 数据库连接信息
- 无需手动设置数据库相关环境变量，可直接部署
- 如果需要使用其他数据库，可以设置 `SPRING_DATASOURCE_URL` 等环境变量来覆盖默认值

### 5. 初始化数据库
1. 在数据库服务中，点击 **"Query"** 标签
2. 从项目仓库打开 `source/xzs-mysql.sql` 文件
3. 复制 SQL 内容并粘贴到 Query 编辑器
4. 点击 **"Run"** 执行 SQL 脚本初始化数据库

**提示**：SQL 文件已包含在 Docker 镜像中（`/app/sql/xzs-mysql.sql`），也可以通过应用容器访问

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

