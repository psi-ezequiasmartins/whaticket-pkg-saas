#!/bin/bash

# Cores
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

check() {
  echo -ne "${YELLOW}🔍 $1... ${NC}"
  eval "$2" &> /dev/null
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}OK${NC}"
  else
    echo -e "${RED}FALHOU${NC}"
    FAILED=true
  fi
}

echo -e "\n🚀 Iniciando verificação do ambiente antes de executar ./whaticketsaas\n"

echo "Node.js usado pelo script: $(which node)"

echo "Versão do Node.js: $(node -v)"
echo "Versão do NPM: $(npm -v)"
echo "Versão do PM2: $(pm2 -v)"

FAILED=false

# Verifica usuário 'deploy'
check "Verificando se o usuário 'deploy' existe" "id deploy"

# Verifica se o arquivo config existe
check "Verificando existência do arquivo './config'" "[ -f ./config ]"

# Verifica permissões do arquivo config
check "Verificando permissões do './config' (deve ser 700)" "[[ $(stat -c '%a' ./config) -eq 700 ]]"

# Verifica se o certbot está instalado
check "Verificando se o certbot está instalado" "command -v certbot"

# Verifica nginx
check "Verificando se o nginx está instalado" "command -v nginx"

# Verifica node.js
check "Verificando se o node.js está instalado" "command -v node"

# Verifica pm2
check "Verificando se o pm2 está instalado" "command -v pm2"

# Verifica docker
check "Verificando se o docker está instalado" "command -v docker"

# Verifica se snapd está instalado
check "Verificando se o snapd está instalado" "command -v snap"

# Verifica se o script principal está com permissão de execução
check "Verificando permissão de execução do './whaticketsaas'" "[ -x ./whaticketsaas ]"

echo ""

if [ "$FAILED" = true ]; then
  echo -e "${RED}❌ Algumas verificações falharam. Corrija os problemas antes de executar o instalador.${NC}"
else
  echo -e "${GREEN}✅ Tudo pronto para executar ./whaticketsaas com segurança!${NC}"
fi

echo ""
