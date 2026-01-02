# 🚀 Railway 全栈部署快速开始

5 分钟在 Railway 部署完整的前后端系统

---

## 📦 准备工作

1. ✅ GitHub 账号
2. ✅ Railway 账号（[https://railway.app](https://railway.app)）
3. ✅ 代码已推送到 GitHub

---

## ⚡ 快速部署步骤

### 1️⃣ 创建 Railway 项目

[登录 Railway](https://railway.app) → "New Project" → "Deploy from GitHub repo" → 选择仓库

---

### 2️⃣ 添加数据库

在项目页 → "New" → "Database" → "MySQL"

**初始化数据库**:
- 点击数据库 → "Query" 标签
- 复制 `source/xzs-mysql.sql` 内容粘贴进去
- 点击 "Run"

---

### 3️⃣ 部署后端

在项目页 → "New" → "Deploy from GitHub repo" → 选择同一个仓库

**配置**:
- Root Directory: `source`
- 环境变量:
  ```
  SPRING_PROFILES_ACTIVE=prod
  JAVA_OPTS=-Xmx512m -Xms256m
  TZ=Asia/Shanghai
  ```

**等待部署完成** → 复制后端 URL（如：`https://xxx.up.railway.app`）

---

### 4️⃣ 配置前端

**修改源代码中的后端地址**:

编辑 `source/vue/xzs-admin/.env.production`:
```env
VUE_APP_URL = 'https://你的后端URL'
```

编辑 `source/vue/xzs-student/.env.production`:
```env
VUE_APP_URL = 'https://你的后端URL'
```

**提交并推送**:
```bash
git add source/vue/xzs-admin/.env.production
git add source/vue/xzs-student/.env.production
git commit -m "配置后端地址"
git push
```

---

### 5️⃣ 部署管理员前端

在项目页 → "New" → "Deploy from GitHub repo" → 选择仓库

**配置**:
- Root Directory: `source/vue/xzs-admin`
- 等待自动部署完成

---

### 6️⃣ 部署学生端前端

在项目页 → "New" → "Deploy from GitHub repo" → 选择仓库

**配置**:
- Root Directory: `source/vue/xzs-student`
- 等待自动部署完成

---

## ✅ 验证部署

| 服务 | 访问 | 预期结果 |
|------|------|---------|
| 后端 | `https://后端URL/api/admin/user/current` | 返回 JSON |
| 管理员 | `https://管理员URL` | 显示登录页 |
| 学生端 | `https://学生端URL` | 显示登录页 |

**默认登录**:
- 管理员: `admin` / `123456`
- 学生: 需要注册

---

## 📁 项目文件结构

```
项目根目录/
├── source/
│   ├── Dockerfile                    # ✅ 后端 Docker 配置
│   ├── xzs-mysql.sql                 # ✅ 数据库初始化
│   ├── vue/
│   │   ├── xzs-admin/
│   │   │   ├── Dockerfile            # ✅ 管理员 Docker 配置
│   │   │   ├── nginx.conf            # ✅ Nginx 配置
│   │   │   └── .env.production       # ⚠️ 需要配置后端地址
│   │   └── xzs-student/
│   │       ├── Dockerfile            # ✅ 学生端 Docker 配置
│   │       ├── nginx.conf            # ✅ Nginx 配置
│   │       └── .env.production       # ⚠️ 需要配置后端地址
│   └── xzs/
│       └── src/main/resources/
│           └── application-prod.yml  # ✅ 后端生产配置
├── railway.json                      # ✅ Railway 后端配置
└── RAILWAY_MULTI_SERVICE_GUIDE.md    # 📖 详细部署指南
```

---

## 🎯 最终结果

你将拥有 **4 个 Railway 服务**：

| 服务 | 用途 | 端口 |
|------|------|------|
| MySQL | 数据库 | 3306 |
| Backend | 后端 API | 8000 |
| Admin | 管理员界面 | 80 |
| Student | 学生界面 | 80 |

**访问地址**：
- 后端 API: `https://xzs-backend-xxx.up.railway.app`
- 管理员: `https://xzs-admin-xxx.up.railway.app`
- 学生端: `https://xzs-student-xxx.up.railway.app`

---

## 💰 费用说明

Railway 免费额度：**$5/月**

实际成本：
- 后端: ~$2-3/月
- 数据库: ~$2/月
- 2 个前端: ~$1-2/月
- **总计**: ~$5-7/月

**提示**: 超出免费额度不多，适合测试和小规模使用。

---

## 🔄 更新代码

```bash
# 修改代码
git add .
git commit -m "更新内容"
git push

# Railway 会自动重新部署
```

---

## 🆘 常见问题

### Q: 后端部署失败？
A: 检查 `source/Dockerfile` 是否存在，查看 Railway 构建日志

### Q: 前端无法连接后端？
A: 检查 `.env.production` 中的 `VUE_APP_URL` 是否正确

### Q: 前端页面空白？
A: 检查 `nginx.conf` 是否存在，查看构建日志

### Q: 数据库连接失败？
A: 确认已执行 SQL 初始化文件，检查环境变量

---

## 📚 详细文档

查看完整部署指南：[RAILWAY_MULTI_SERVICE_GUIDE.md](RAILWAY_MULTI_SERVICE_GUIDE.md)

---

**祝部署成功！🎉**
