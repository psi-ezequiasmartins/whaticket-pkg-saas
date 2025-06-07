#!/bin/bash

set -e

echo "Iniciando pré-configuração automática WhaticketSaaS (Pré-setup)..."

# 1. Instalar Node.js 22.x e npm
if ! command -v node &>/dev/null || ! node -v | grep -q "^v22"; then
  echo "🔄 Instalando Node.js 22.x..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

# 2. Instalar PM2
if ! command -v pm2 &>/dev/null; then
  echo "🔄 Instalando PM2..."
  sudo npm install -g pm2
fi

# 3. Criar usuário 'deploy' se não existir
if ! id deploy &>/dev/null; then
  echo "🔄 Criando usuário 'deploy'..."
  sudo useradd -m -s /bin/bash deploy
  sudo usermod -aG sudo deploy
fi

# 4. Ajustar permissão do arquivo ./config
if [ -f ./config ]; then
  echo "🔄 Ajustando permissão do arquivo ./config para 700..."
  sudo chmod 700 ./config
fi

# 5. Instalar pacotes essenciais
echo "🔄 Instalando pacotes essenciais..."
sudo apt-get update
sudo apt-get install -y unzip build-essential

# 6. Instalar certbot, nginx, docker, snapd
for pkg in certbot nginx docker.io snapd; do
  if ! dpkg -s $pkg &>/dev/null; then
    echo "🔄 Instalando $pkg..."
    sudo apt-get install -y $pkg
  fi
done

# 7. Garantir snapd ativo
sudo systemctl enable --now snapd

# 8. Permissões dos scripts na raiz
echo "🔄 Ajustando permissões dos scripts na raiz..."
sudo chmod 755 ./*.sh

# 9. Permissões dos scripts em subpastas
for dir in lib utils variables; do
  if [ -d "$dir" ]; then
    sudo chmod 755 $dir/*.sh
  fi
done

# 10. Executar checklist e instalação
echo "🔄 Executando checklist_srv.sh..."
sudo ./checklist_srv.sh

echo "🔄 Executando check.sh..."
sudo ./check.sh

echo "🔄 Executando whaticketsaas..."
sudo ./whaticketsaas

echo "Pré-configuração concluída!"