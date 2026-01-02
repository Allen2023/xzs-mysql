#!/bin/sh
set -e

# 替换 Nginx 配置中的环境变量
echo "Configuring Nginx with backend URL: ${VUE_APP_URL}"

# 启动 Nginx
exec "$@"
