# 学生端前端 Dockerfile for Railway
# 构建阶段
FROM node:16-alpine AS build

WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package.json package-lock.json* ./

# 安装国内 npm 镜像（加速构建）
RUN npm config set registry https://registry.npmmirror.com/

# 安装依赖
RUN npm install

# 复制源代码
COPY . .

# 构建生产版本（使用 .env.production 中的配置）
RUN npm run build:prod

# 生产阶段 - 使用 Nginx
FROM nginx:alpine

# 安装 envsubst（用于环境变量替换）
RUN apk add --no-cache gettext

# 复制构建产物到 Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# 复制 Nginx 配置模板
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# 复制启动脚本
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# 暴露端口
EXPOSE 80

# 设置环境变量（Railway 会自动注入）
ENV VUE_APP_URL=http://localhost:8000

# 启动脚本
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
