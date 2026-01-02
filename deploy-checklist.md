# 学之思考试系统 - 快速部署清单

## 项目结构

```
xzs-mysql/
├── source/
│   ├── xzs/                    # 后端服务 (Java Spring Boot)
│   │   └── src/main/java/...
│   ├── vue/
│   │   ├── xzs-admin/          # 管理员前端 (Vue)
│   │   │   └── src/
│   │   └── xzs-student/        # 学生端前端 (Vue)
│   │       └── src/
│   ├── wx/                     # 微信小程序
│   │   └── xzs-student/
│   └── xzs-mysql.sql           # 数据库初始化文件
├── source/Dockerfile           # 后端 Docker 构建文件
├── railway.json                # Railway 配置
└── FULL_DEPLOYMENT_GUIDE.md    # 完整部署指南
```

---

## 部署步骤概览

### 第一步：部署后端服务 (Railway)

**1. 创建 MySQL 数据库**
- [ ] 登录 Railway 控制台
- [ ] 新建项目 → Add Database → MySQL
- [ ] 等待数据库创建完成

**2. 初始化数据库**
- [ ] 点击数据库服务 → Query 标签
- [ ] 复制 `source/xzs-mysql.sql` 文件内容
- [ ] 粘贴到 Query 编辑器并点击 "Run"

**3. 部署后端 API**
- [ ] 在同一 Railway 项目中 → New Project → Deploy from GitHub repo
- [ ] 选择你的代码仓库和分支
- [ ] 等待自动构建和部署
- [ ] 配置环境变量（可选）:
  ```
  SPRING_PROFILES_ACTIVE=prod
  JAVA_OPTS=-Xmx512m -Xms256m
  TZ=Asia/Shanghai
  ```
- [ ] 复制后端 URL（例如: `https://your-backend.railway.app`）

**4. 验证后端**
- [ ] 访问健康检查: `https://your-backend.railway.app/api/admin/user/current`
- [ ] 应该返回 JSON 响应

---

### 第二步：部署前端 (Vercel 或 Netlify)

#### 方案 A: 使用 Vercel

**1. 修改后端地址**
- [ ] 编辑 `source/vue/xzs-admin/.env.production`
- [ ] 编辑 `source/vue/xzs-student/.env.production`
- [ ] 将 `VUE_APP_URL` 改为你的后端地址

**2. 部署管理员前端**
- [ ] 登录 [Vercel](https://vercel.com)
- [ ] 点击 "New Project"
- [ ] 导入 GitHub 仓库
- [ ] 配置:
  - Root Directory: `source/vue/xzs-admin`
  - Framework Preset: Vue.js
  - Build Command: `npm run build:prod`
  - Output Directory: `dist`
- [ ] 点击 Deploy
- [ ] 记录管理员前端 URL

**3. 部署学生端前端**
- [ ] 重复上述步骤
- [ ] Root Directory: `source/vue/xzs-student`
- [ ] 记录学生端前端 URL

#### 方案 B: 使用 Netlify

**1. 修改后端地址**（同上）

**2. 部署管理员前端**
- [ ] 登录 [Netlify](https://netlify.com)
- [ ] "New site from Git"
- [ ] 选择仓库
- [ ] 配置:
  - Build command: `npm run build:prod`
  - Publish directory: `dist`
  - Base directory: `source/vue/xzs-admin`
- [ ] 点击 Deploy

**3. 部署学生端前端**
- [ ] 重复上述步骤
- [ ] Base directory: `source/vue/xzs-student`

---

### 第三步：微信小程序部署（可选）

**1. 修改 API 地址**
- [ ] 打开 `source/wx/xzs-student/utils/request.js`
- [ ] 修改 `baseURL` 为后端地址

**2. 上传小程序**
- [ ] 打开微信开发者工具
- [ ] 导入项目: `source/wx/xzs-student`
- [ ] 填写小程序 AppID
- [ ] 测试功能
- [ ] 开发者工具 → 上传
- [ ] 登录微信小程序平台 → 提交审核 → 发布

---

## 部署后的 URL 示例

完成后，你会拥有以下访问地址：

```
后端 API:        https://your-backend.railway.app
管理员前端:      https://xzs-admin.vercel.app
学生端前端:      https://xzs-student.vercel.app
微信小程序:      (需微信扫码)
```

---

## 默认登录信息

```
管理员账号: admin
密码: 123456

学生账号: 需要在学生端注册
```

---

## 快速验证清单

### 后端验证
- [ ] 后端 URL 可以访问
- [ ] 健康检查接口返回 JSON
- [ ] 数据库连接正常

### 管理员前端验证
- [ ] 访问管理员前端 URL
- [ ] 可以看到登录页面
- [ ] 使用 admin/123456 可以登录
- [ ] 可以看到管理面板

### 学生端前端验证
- [ ] 访问学生端 URL
- [ ] 可以看到登录/注册页面
- [ ] 可以注册新学生账号
- [ ] 登录后可以看到学生界面

---

## 常见问题

### 1. 后端构建失败
**检查**:
- Dockerfile 路径是否正确
- 源代码文件是否存在
- Railway 构建日志

### 2. 前端无法连接后端
**检查**:
- `.env.production` 中的 `VUE_APP_URL` 是否正确
- 后端服务是否正常运行
- 浏览器控制台是否有跨域错误

### 3. 前端路由 404
**检查**:
- 是否已配置 `vercel.json` 或 `netlify.toml`
- 重新部署前端项目

### 4. 数据库连接失败
**检查**:
- 数据库是否已初始化（执行了 SQL 文件）
- 后端环境变量配置
- Railway 数据库服务状态

---

## 费用说明

使用免费额度部署：

| 服务 | 平台 | 费用 |
|------|------|------|
| 后端 | Railway | 免费 (有额度限制) |
| 数据库 | Railway MySQL | 免费 (512MB) |
| 前端 | Vercel | 免费 (100GB/月) |
| 前端 | Netlify | 免费 (100GB/月) |

**注意**: 免费额度适合测试和小规模使用，生产环境建议升级付费计划。

---

## 下一步

1. **自定义域名** (可选):
   - Vercel/Netlify/Railway 都支持自定义域名
   - 需要在域名注册商配置 DNS

2. **配置 HTTPS**:
   - 所有平台自动提供 SSL 证书
   - 无需手动配置

3. **监控和日志**:
   - Railway: 在控制台查看日志
   - Vercel: 在 Deployments 页面查看
   - Netlify: 在 Deploys 页面查看

4. **数据备份**:
   - 定期导出 MySQL 数据
   - Railway 支持自动备份（付费功能）

---

## 技术支持

- 官方文档: https://www.mindskip.net:999
- GitHub Issues: https://github.com/mindskip/xzs-mysql/issues
- QQ 群: 700540955

---

## 更新部署

当代码更新后：

**后端**:
- Railway 会自动检测 git push 并重新构建部署

**前端**:
- Vercel/Netlify 会在 git push 后自动构建部署
- 或者在控制台手动触发重新部署

---

**祝部署顺利！**
