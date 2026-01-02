# 多阶段构建 Dockerfile for Railway
# 第一阶段：构建阶段
FROM maven:3.8.6-eclipse-temurin-8 AS build

# 设置工作目录
WORKDIR /app

# 创建自定义 Maven settings.xml 使用国内镜像
RUN mkdir -p /root/.m2 && \
    echo '<?xml version="1.0" encoding="UTF-8"?>' > /root/.m2/settings.xml && \
    echo '<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"' >> /root/.m2/settings.xml && \
    echo '    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /root/.m2/settings.xml && \
    echo '    xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">' >> /root/.m2/settings.xml && \
    echo '  <mirrors>' >> /root/.m2/settings.xml && \
    echo '    <mirror>' >> /root/.m2/settings.xml && \
    echo '      <id>aliyun-public</id>' >> /root/.m2/settings.xml && \
    echo '      <mirrorOf>*</mirrorOf>' >> /root/.m2/settings.xml && \
    echo '      <name>Aliyun Public</name>' >> /root/.m2/settings.xml && \
    echo '      <url>https://maven.aliyun.com/repository/public</url>' >> /root/.m2/settings.xml && \
    echo '    </mirror>' >> /root/.m2/settings.xml && \
    echo '  </mirrors>' >> /root/.m2/settings.xml && \
    echo '</settings>' >> /root/.m2/settings.xml

# 复制整个项目源代码（Railway 构建上下文是 source 目录）
COPY xzs ./xzs

# 进入项目目录并构建
WORKDIR /app/xzs
RUN mvn dependency:go-offline -B
RUN mvn clean package -DskipTests -B

# 第二阶段：运行阶段
FROM eclipse-temurin:8-jre

# 设置工作目录
WORKDIR /app

# 安装必要的工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# 从构建阶段复制 JAR 文件
COPY --from=build /app/xzs/target/xzs-*.jar app.jar

# 复制静态资源（如果需要）
COPY --from=build /app/xzs/target/classes/static ./static 2>/dev/null || echo "No static resources found"

# 复制 SQL 初始化文件到镜像中（Railway 构建上下文是 source 目录）
COPY xzs-mysql.sql /app/sql/xzs-mysql.sql

# 暴露端口（Railway 会自动映射）
EXPOSE 8000

# 设置 JVM 参数
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8000/api/admin/user/current || exit 1

# 启动应用
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
