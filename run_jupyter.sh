# 2) 确认你的项目目录存在（按你的实际路径改）
PROJECT_DIR="/beacon/data01/chengjie.zheng001/Projects/MACL_TianyuK/MACL"
ls -ld "$PROJECT_DIR" || { echo "目录不存在：$PROJECT_DIR"; exit 1; }

# 3) 干净重启
pkill -f jupyter || true

# 4) 直接启动 Jupyter（别用 Tunnel，先确认本地OK）
apptainer exec --nv macl_gpu.sif jupyter lab \
  --ServerApp.ip=127.0.0.1 \
  --ServerApp.port=8888 \
  --ServerApp.open_browser=False \
  --ServerApp.identity_provider_class='jupyter_server.auth.identity.PasswordIdentityProvider' \
  --IdentityProvider.token='' \
  --PasswordIdentityProvider.hashed_password='argon2:$argon2id$v=19$m=10240,t=10,p=8$vcalfqzz9M0bGYk1bP1CcQ$LL+F0yf8grA4JjKAkizZwnO905SftRrL2MV2iJJvSy8' \
  --ServerApp.allow_remote_access=True \
  --ServerApp.trust_xheaders=True \
  --ServerApp.disable_check_xsrf=True \
  --ServerApp.root_dir="$PROJECT_DIR" \
  --ServerApp.base_url=/ \
  --ServerApp.allow_root=True
