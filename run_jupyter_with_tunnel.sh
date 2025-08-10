#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="/beacon/data01/chengjie.zheng001/Projects/MACL_TianyuK/MACL"
HASH='argon2:$argon2id$v=19$m=10240,t=10,p=8$vcalfqzz9M0bGYk1bP1CcQ$LL+F0yf8grA4JjKAkizZwnO905SftRrL2MV2iJJvSy8'

# 1) 目录校验
if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "ERROR: PROJECT_DIR not found: $PROJECT_DIR"
  exit 1
fi

# 2) 清理残留
pkill -f 'jupyter.*ServerApp' || true
pkill -f cloudflared || true
rm -f /tmp/jupyter_cookie_secret || true

# 3) 启动 Jupyter（后台）
apptainer exec --nv macl_gpu.sif jupyter lab \
  --ServerApp.ip=127.0.0.1 \
  --ServerApp.port=8888 \
  --ServerApp.open_browser=False \
  --ServerApp.identity_provider_class='jupyter_server.auth.identity.PasswordIdentityProvider' \
  --IdentityProvider.token='' \
  --PasswordIdentityProvider.hashed_password="$HASH" \
  --ServerApp.allow_remote_access=True \
  --ServerApp.trust_xheaders=True \
  --ServerApp.disable_check_xsrf=True \
  --ServerApp.root_dir="$PROJECT_DIR" \
  --ServerApp.base_url=/ \
  --ServerApp.allow_root=True &

# 4) 等待 Jupyter 起来
sleep 5

# 5) 起 Tunnel（指向同一端口；若上面改了端口，这里也要一致）
./cloudflared tunnel --url http://127.0.0.1:8888
