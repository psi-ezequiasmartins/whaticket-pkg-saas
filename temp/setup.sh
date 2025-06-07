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

# 11. Verificar se o script principal tem permissão de execução
if [ -f ./whaticketsaas ]; then
  if [ ! -x ./whaticketsaas ]; then
    echo "🔄 Ajustando permissão de execução do script principal... "
    sudo chmod +x ./whaticketsaas
  fi
fi
  
echo "🔄 Convertendo scripts para formato Unix..."
if ! command -v dos2unix &>/dev/null; then
  echo "🔄 Instalando dos2unix..."
  sudo apt-get install -y dos2unix
fi
dos2unix ./whaticketsaas.sh
dos2unix ./checklist_srv.sh
dos2unix ./check.sh

echo "🔄 Pré-configuração concluída!"
echo " "
echo "Para iniciar os serviços, execute:"
echo " "
echo "sudo systemctl start nginx"
echo "sudo systemctl start certbot"
echo "sudo systemctl start docker"
echo "sudo systemctl start snapd"
echo "sudo systemctl start whaticketsaas"
echo " "
echo "Para verificar o status dos serviços, execute:"
echo " "
echo "sudo systemctl status nginx"
echo "sudo systemctl status certbot"
echo "sudo systemctl status docker"
echo "sudo systemctl status snapd"
echo "sudo systemctl status 