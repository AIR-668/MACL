#!/bin/bash

# 环境变量 设置密码（加密）
export PASSWORD="666888"
export XDG_RUNTIME_DIR=/tmp/xdg
mkdir -p $XDG_RUNTIME_DIR

# 启动 Jupyter
# apptainer exec --nv macl_gpu.sif \
# jupyter lab --NotebookApp.token='' \
#              --NotebookApp.password='sha1:b3e4853376d0:86e516545f29ee24d51070d8412008a8db83d691' \
#              --no-browser --ip=127.0.0.1 --port=8888 &
# 启动 Jupyter Lab（监听 0.0.0.0 并允许 Cloudflare Host）
apptainer exec --nv macl_gpu.sif \
jupyter lab \
    --ServerApp.trust_xheaders=True \
    --ServerApp.allow_origin='*' \
    --ServerApp.allow_remote_access=True \
    --ServerApp.disable_check_xsrf=True \
    --ServerApp.token='' \
    --ServerApp.password='ssha1:b3e4853376d0:86e516545f29ee24d51070d8412008a8db83d691' \  # <=== 记得替换
    --ServerApp.base_url=/ \
    --ServerApp.ip=0.0.0.0 \
    --ServerApp.port=8888 \
    --no-browser &

# 等待启动
sleep 5

# 启动 Tunnel（需放置 cloudflared 可执行文件）
./cloudflared tunnel --url http://127.0.0.1:8888
