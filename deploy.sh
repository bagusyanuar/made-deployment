#!/bin/bash

# --- CONFIGURATION ---
SSH_ALIAS="made-vps"
SERVER_PATH="/home/made-vps/made-deployment"
# ---------------------

echo "🚀 Memulai Deployment ke $SSH_ALIAS (PRODUCTION)..."

# 0. Safety Checks
if [ ! -f env/backend/.env ]; then
    echo "❌ Error: file env/backend/.env tidak ditemukan!"
    echo "⚠️  Silakan buat env/backend/.env (salin dari .env.example) terlebih dahulu!"
    exit 1
fi

if [ ! -f env/frontend/.env ]; then
    echo "❌ Error: file env/frontend/.env tidak ditemukan!"
    echo "⚠️  Silakan buat env/frontend/.env (salin dari .env.example) terlebih dahulu!"
    exit 1
fi

# 1. Transfer Secrets & Certs (Manual Sync)
echo "🔑 Mengirim .env dan SSL certificates..."
ssh $SSH_ALIAS "mkdir -p $SERVER_PATH/env/backend $SERVER_PATH/env/frontend $SERVER_PATH/nginx/cert $SERVER_PATH/configs"
scp env/backend/.env $SSH_ALIAS:$SERVER_PATH/env/backend/
scp env/frontend/.env $SSH_ALIAS:$SERVER_PATH/env/frontend/
scp -r nginx/cert/* $SSH_ALIAS:$SERVER_PATH/nginx/cert/

# 2. Sync Code & Configs
echo "📦 Sinkronisasi source code & config via rsync..."
rsync -avz --delete \
    --exclude-from='.gitignore' \
    --exclude='.git' \
    ./ $SSH_ALIAS:$SERVER_PATH/

# 3. Eksekusi Docker di Server
echo "🔄 Pulling latest images & restarting Docker containers..."
ssh $SSH_ALIAS "cd $SERVER_PATH && docker compose pull && docker compose up -d"

echo "✅ Selesai! Made Printing Production sudah Up di $SSH_ALIAS."

