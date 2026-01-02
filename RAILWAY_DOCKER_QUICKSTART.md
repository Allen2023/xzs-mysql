# ⚡ Railway Docker 部署 - 快速开始

5 步完成 Railway 全栈 Docker 部署

---

## 📦 准备工作

- [ ] GitHub 账号
- [ ] Railway 账号 ([https://railway.app](https://railway.app))
- [ ] 代码已推送到 GitHub

---

## 🚀 5 步部署

### 步骤 1：创建项目和数据库

```
Railway 控制台
  → New Project
  → Deploy from GitHub repo
  → 选择仓库
  → New → Database → MySQL
```

**初始化数据库**：
- 点击 MySQL 服务 → Query 标签
- 复制 `source/xzs-mysql.sql` 内容
- 粘贴并点击 Run

---

### 步骤 2：部署后端

```
Railway 项目
  → New → Deploy from GitHub repo
  → 选择同一个仓库
  → Deploy
```

**配置**：
- Root Directory: `source`
- 环境变量：
  ```
  SPRING_PROFILES_ACTIVE=prod
  JAVA_OPTS=-Xmx512m -Xms256m
  TZ=Asia/Shanghai
  ```

**等待 5-10 分钟** → 复制后端 URL（如：`https://xxx.up.railway.app`）

---

### 步骤 3：部署管理员前端

```
Railway 项目
  → New → Deploy from GitHub repo
  → Root Directory: source/vue/xzs-admin
  → Deploy
```

**环境变量**：
```
VUE_APP_URL=https://你的后端URL
```

**等待 3-5 分钟**

---

### 步骤 4：部署学生端前端

```
Railway 项目
  → New → Deploy from GitHub repo
  → Root Directory: source/vue/xzs-student
  → Deploy
```

**环境变量**：
```
VUE_APP_URL=https://你的后端URL
```

**等待 3-5 分钟**

---

### 步骤 5：验证部署

| 服务 | 验证方法 | 预期结果 |
|------|---------|---------|
| 后端 | 访问 `/api/admin/user/current` | 返回 JSON |
| 管理员 | 打开前端 URL | 显示登录页 |
| 学生端 | 打开前端 URL | 显示登录页 |

**默认登录**：
- 管理员: `admin` / `123456`
- 学生: 需要注册

---

## ✅ 最终结果

```
Railway Project
├── MySQL         (数据库)
├── Backend       (https://xzs-backend-xxx.up.railway.app)
├── Admin         (https://xzs-admin-xxx.up.railway.app)
└── Student       (https://xzs-student-xxx.up.railway.app)
```

---

## 🔑 关键点

### 环境变量配置

**后端**（`source/Dockerfile` 构建上下文）：
- Railway Root Directory: `source`
- 自动使用阿里云 Maven 镜像
- 自动连接 Railway MySQL

**前端**（环境变量驱动）：
- `VUE_APP_URL` 环境变量 → Nginx 反向代理
- 无需修改源代码
- 支持运行时配置后端地址

### Docker 文件位置

```
source/
├── Dockerfile                    ← 后端
├── vue/xzs-admin/
│   ├── Dockerfile                ← 管理员前端
│   ├── nginx.conf.template       ← Nginx 配置模板
│   └── docker-entrypoint.sh      ← 启动脚本
└── vue/xzs-student/
    ├── Dockerfile                ← 学生端前端
    ├── nginx.conf.template       ← Nginx 配置模板
    └── docker-entrypoint.sh      ← 启动脚本
```

---

## 💰 费用

免费额度：**$5/月**

实际成本：**~$5-7/月**（4 个服务）

---

## 📚 详细文档

查看完整指南：[RAILWAY_DOCKER_DEPLOYMENT.md](RAILWAY_DOCKER_DEPLOYMENT.md)

---

## 🆘 常见问题

**Q: 构建失败？**
A: 检查 Root Directory 是否正确

**Q: 前端无法连接后端？**
A: 检查 `VUE_APP_URL` 环境变量

**Q: 数据库连接失败？**
A: 确认已执行 SQL 初始化文件

---

**🎉 部署成功！**
