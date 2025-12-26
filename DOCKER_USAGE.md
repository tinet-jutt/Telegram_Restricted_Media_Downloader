# Telegram 限制媒体下载器 Docker 使用指南

## 概述

本项目提供了Docker镜像，可以让你在不安装Python依赖的情况下运行Telegram限制媒体下载器。使用Docker可以避免环境冲突问题，简化部署流程。

## 系统要求

- Docker Engine 20.10+
- Docker Compose 1.29+（推荐使用）
- 可用内存：至少512MB
- 可用磁盘空间：至少2GB

## 快速开始

### 方法一：使用Docker Compose（推荐）

1. **启动容器**
   ```bash
   docker-compose up -d
   ```

2. **查看容器状态**
   ```bash
   docker-compose ps
   ```

3. **查看日志**
   ```bash
   docker-compose logs -f
   ```

4. **停止容器**
   ```bash
   docker-compose down
   ```

### 方法二：直接使用Docker命令

1. **构建镜像**
   ```bash
   docker build -t telegram-restricted-media-downloader:latest .
   ```

2. **运行容器**
   ```bash
   docker run -it --rm \
     -v $(pwd)/config:/app/config \
     -v $(pwd)/download:/app/download \
     -v $(pwd)/sessions:/app/sessions \
     -v $(pwd)/temp:/app/temp \
     telegram-restricted-media-downloader:latest
   ```

## 目录结构

使用Docker运行后，你的项目目录应该包含以下目录结构：

```
project/
├── config/              # 配置文件目录
│   ├── config.yaml      # 主要配置文件
│   └── ConfigBackup/    # 配置备份目录
├── download/            # 下载文件存储目录
├── sessions/            # Telegram会话文件目录
├── temp/               # 临时文件目录
└── docker-compose.yml  # Docker编排文件
```

## 配置文件

### 初始配置

首次运行容器时，应用会自动引导你配置必要的参数：

- `api_id`: Telegram API ID
- `api_hash`: Telegram API Hash
- `bot_token`: 机器人令牌（可选）
- `proxy`: 代理设置（可选）
- `links`: 链接文件路径
- `save_directory`: 下载目录（默认为`/app/download`）
- 其他下载相关配置

### 配置文件位置

配置文件位于 `config/config.yaml`，使用Docker Compose时会自动挂载到宿主机的 `./config/` 目录。

### 配置备份

每次重新配置时，旧的配置文件会自动备份到 `config/ConfigBackup/` 目录。

## 数据持久化

以下目录会挂载到宿主机，确保数据持久化：

- `./config/`: 配置文件和备份
- `./download/`: 下载的文件
- `./sessions/`: Telegram会话文件
- `./temp/`: 临时文件

## 常用操作

### 查看应用日志
```bash
docker-compose logs -f trmd
```

### 进入容器执行命令
```bash
docker-compose exec trmd bash
```

### 重新构建镜像
```bash
docker-compose build --no-cache
```

### 清理容器和镜像
```bash
docker-compose down --rmi all
```

## 高级配置

### 资源限制

`docker-compose.yml` 已配置了资源限制：
- 内存限制：1GB
- 内存保留：512MB  
- CPU限制：1核心
- CPU保留：0.5核心

你可以在 `docker-compose.yml` 中调整这些设置。

### 网络配置

容器使用桥接网络模式，如果需要特殊网络配置，可以修改 `docker-compose.yml` 中的 `network_mode` 设置。

### 环境变量

目前使用的主要环境变量：
- `PYTHONUNBUFFERED=1`: 确保Python输出立即显示

你可以在 `docker-compose.yml` 的 `environment` 部分添加更多环境变量。

## 故障排除

### 容器启动失败

1. 检查端口是否被占用
2. 检查目录权限
3. 查看容器日志：
   ```bash
   docker-compose logs trmd
   ```

### 权限问题

如果遇到权限问题，确保宿主机目录的所有者是UID 1000：
```bash
sudo chown -R 1000:1000 config/ download/ sessions/ temp/
```

### 配置文件问题

如果配置文件损坏，可以删除 `config/config.yaml` 让应用重新生成，或者从 `config/ConfigBackup/` 恢复备份。

## 安全注意事项

- 容器以非root用户（trmd, UID 1000）运行
- 启用了 `no-new-privileges` 安全选项
- 资源限制防止资源耗尽
- 敏感文件（会话文件、配置文件）只通过卷挂载访问

## 版本信息

- **Docker镜像版本**: 1.3.8
- **Python版本**: 3.13.2
- **基础镜像**: python:3.13.2-slim

## 更新日志

### v1.3.8 (Docker版本)
- 添加Python 3.13.2支持
- 创建Docker容器化方案
- 添加Docker Compose配置
- 优化镜像大小和安全配置
- 添加完整的Docker使用文档

## 支持

如有问题或建议，请通过以下方式联系：
- GitHub Issues: [项目地址](https://github.com/tinet-jutt/Telegram_Restricted_Media_Downloader)
- 邮箱: 请查看项目README.md中的联系信息