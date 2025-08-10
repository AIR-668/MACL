#!/bin/bash

echo "🛑 正在尝试关闭 Jupyter Notebook 和 Cloudflare Tunnel..."

# 停止 jupyter 进程（当前用户）
pkill -u $(whoami) -f jupyter-notebook

# 停止 cloudflared 进程（当前用户）
pkill -u $(whoami) -f cloudflared

echo "✅ 已尝试终止所有相关进程"