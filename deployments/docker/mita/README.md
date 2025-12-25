# Mita Docker 部署

这是 mieru 代理服务器（mita）的 Docker 部署配置。

## 使用方法

### 使用 docker-compose

```bash
docker-compose up -d
```

### 使用 docker run

```bash
docker build -t mita .
docker run -d -p 27017-27019:27017-27019/udp mita
```

## 环境变量配置

可以通过环境变量覆盖默认配置值：

- `USERNAME`: 用户名（默认: `uname1`）
- `PASSWORD`: 密码（默认: `pwd1`）
- `PROTOCOL`: 协议类型，可选 `UDP` 或 `TCP`（默认: `UDP`）

### 示例

使用 docker run 命令时设置环境变量：

```bash
docker run -d \
  -p 27017-27019:27017-27019/udp \
  -e USERNAME=myuser \
  -e PASSWORD=mypassword \
  -e PROTOCOL=TCP \
  mita
```

使用 docker-compose 时，编辑 `docker-compose.yml` 文件中的 environment 部分：

```yaml
environment:
  - TZ=Asia/Shanghai
  - USERNAME=myuser
  - PASSWORD=mypassword
  - PROTOCOL=TCP
```

## 配置文件

默认配置文件位于 `conf/config.json`，包含以下设置：

- 端口绑定范围：27017-27019
- 协议：UDP
- 用户名和密码
- 日志级别：INFO
- MTU：1400

如果不设置环境变量，将使用配置文件中的默认值。
