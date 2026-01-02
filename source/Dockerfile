# 多阶段构建 Dockerfile for Railway
# 第一阶段：构建阶段
FROM maven:3.8.6-eclipse-temurin-8 AS build

# 设置工作目录
WORKDIR /app

# 复制 pom.xml 并下载依赖（利用 Docker 缓存层）
COPY source/xzs/pom.xml .
RUN mvn dependency:go-offline -B

# 复制源代码并构建
COPY source/xzs/src ./xzs/src
COPY source/xzs/pom.xml ./xzs/
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
COPY --from=build /app/xzs/target/classes/static ./static

# 复制 SQL 初始化文件到镜像中
COPY source/xzs-mysql.sql /app/sql/xzs-mysql.sql

# 暴露端口（Railway 会自动映射）
EXPOSE 8000

# 设置 JVM 参数
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8000/api/admin/user/current || exit 1

# 启动应用
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
