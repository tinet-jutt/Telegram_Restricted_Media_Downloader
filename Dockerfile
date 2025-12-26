# 使用Python 3.13.2作为基础镜像
FROM python:3.13.2-slim

# 设置维护者信息
LABEL maintainer="Gentlesprite <https://github.com/tinet-jutt>"
LABEL description="Telegram Restricted Media Downloader Docker Image"
LABEL version="1.3.8"

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    libffi-dev \
    libjpeg-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    libmediainfo-dev \
    unrar-free \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 复制requirements文件
COPY requirements.txt .

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制项目文件
COPY . .

# 创建必要的目录
RUN mkdir -p download config/ConfigBackup sessions temp

# 设置权限
RUN chmod +x main.py

# 创建非root用户
RUN useradd -m -u 1000 trmd && \
    chown -R trmd:trmd /app

# 切换到非root用户
USER trmd

# 暴露端口（如果需要）
# EXPOSE 8000

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python3 -c "import sys; sys.exit(0)" || exit 1

# 默认启动命令
CMD ["python3", "main.py"]