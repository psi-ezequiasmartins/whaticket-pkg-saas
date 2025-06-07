#!/bin/bash

clear

echo "🚀 Pré-checklist do ambiente para WhaticketSaaS"
echo "" 
echo -e "\n🔍 Verificando status dos serviços essenciais..."
echo "" 

for svc in snapd nginx docker; do
  systemctl is-active --quiet $svc
  if [ $? -eq 0 ]; then
    echo "✅ Serviço $svc está ativo."
  else
    echo "❌ Serviço $svc NÃO está ativo! Inicie com: sudo systemctl start $svc"
  fi
done

CONFIG_FILE="./config"

# Verifica se o arquivo existe
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "❌ Arquivo '$CONFIG_FILE' não encontrado!"
  exit 1
fi

# Verifica permissões do arquivo

PERM=$(stat -c "%a" "$CONFIG_FILE")

if [[ "$PERM" != "600" && "$PERM" != "700" ]]; then
  echo "⚠️ Permissão atual do '$CONFIG_FILE': $PERM esperado: 600 ou 700"
else
  echo "✅ Permissão do arquivo '$CONFIG_FILE': OK"
fi

# Verifica propriedade do arquivo

OWNER=$(stat -c "%U" "$CONFIG_FILE")
GROUP=$(stat -c "%G" "$CONFIG_FILE")

if [[ "$OWNER" != "root" || "$GROUP" != "root" ]]; then
  echo "⚠️ Propriedade atual do '$CONFIG_FILE': $OWNER:$GROUP esperado: root:root"
else
  echo "✅ Propriedade do arquivo '$CONFIG_FILE': OK"
fi

# Carrega variáveis
source "$CONFIG_FILE"

# Verifica variáveis obrigatórias
REQUIRED_VARS=(
  deploy_password
  mysql_root_password
  db_pass
  redis_pass
  jwt_secret
  jwt_refresh_secret
  deploy_email
  db_user
  db_name
)

MISSING_VARS=()
for var in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!var}" ]]; then
    MISSING_VARS+=("$var")
  fi
done

if [[ ${#MISSING_VARS[@]} -ne 0 ]]; then
  echo ""
  echo "❌ ERRO: As seguintes variáveis estão ausentes no arquivo '$CONFIG_FILE':"
  for var in "${MISSING_VARS[@]}"; do
    echo "   - $var"
  done
  echo ""
  echo "💡 Corrija o arquivo '$CONFIG_FILE' antes de continuar."
  exit 1
else
  echo "✅ Todas as variáveis obrigatórias estão definidas."
fi

echo ""
echo "✅ Ambiente validado com sucesso! Você pode executar './whaticketsaas' com segurança."
echo ""
echo "script atualizado em $(date +%Y-%m-%d) ${USER}" 
echo "by psi-software - copyright 2025" 
