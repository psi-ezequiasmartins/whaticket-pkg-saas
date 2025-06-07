#!/bin/bash
# checklist_srv.sh - Checklist automático de pré-instalação WhaticketSaaS
 
clear

echo  "Checklist Pré-Instalação WhaticketSaaS"

# 1. Recursos do servidor
echo -e "\n[1] Recursos do servidor:"
echo -n "  - CPUs: "; nproc
echo -n "  - RAM total: "; free -h | awk '/^Mem:/ {print $2}'
echo -n "  - Espaço em disco em /: "; df -h / | awk 'NR==2 {print $4 " livres"}'

# 2. Sistema operacional
echo -e "\n[2] Sistema operacional:"
lsb_release -d
echo -n "  - Kernel: "; uname -r

# 3. Pacotes essenciais
echo -e "\n[3] Pacotes essenciais:"
for pkg in curl wget git unzip sudo lsb-release ca-certificates build-essential; do
  dpkg -s $pkg &>/dev/null && echo "  - $pkg: OK" || echo "  - $pkg: FALTA"
done

# 4. Firewall UFW
echo -e "\n[4] Firewall:"
if command -v ufw &>/dev/null; then
  echo "  - UFW instalado"
  sudo ufw status | grep -q "Status: active" && echo "  - UFW ativo" || echo "  - UFW inativo"
  sudo ufw status | grep -q "OpenSSH" && echo "  - Porta SSH liberada" || echo "  - Porta SSH NÃO liberada"
  sudo ufw status | grep -q "80" && echo "  - Porta 80 liberada" || echo "  - Porta 80 NÃO liberada"
  sudo ufw status | grep -q "443" && echo "  - Porta 443 liberada" || echo "  - Porta 443 NÃO liberada"
else
  echo "  - UFW NÃO instalado"
fi

# 5. Timezone e hostname
echo -e "\n[5] Timezone e hostname:"
echo -n "  - Timezone: "; timedatectl | grep "Time zone"
echo -n "  - Hostname: "; hostname

# 6. Estrutura de pastas
echo -e "\n[6] Estrutura de pastas:"
if [ -d "/www/wwwroot" ]; then
  echo "  - /www/wwwroot existe"
  ls -ld /www/wwwroot
else
  echo "  - /www/wwwroot NÃO existe"
fi

# 7. Usuário deploy
echo -e "\n[7] Usuário 'deploy':"
id deploy &>/dev/null && echo "  - Usuário 'deploy' existe" || echo "  - Usuário 'deploy' NÃO existe"

# 8. Node.js, npm, pm2
echo -e "\n[8] Node.js, npm, pm2:"
if command -v node &>/dev/null; then
  echo -n "  - Node.js: "; node -v
  node -v | grep -q "^v22" && echo "    Versão recomendada 22.x" || echo "    Atenção: versão recomendada é 22.x"
else
  echo "  - Node.js NÃO instalado"
fi
if command -v npm &>/dev/null; then
  echo -n "  - npm: "; npm -v
else
  echo "  - npm NÃO instalado"
fi
if command -v pm2 &>/dev/null; then
  echo -n "  - pm2: "; pm2 -v
else
  echo "  - pm2 NÃO instalado"
fi

# 9. nginx, certbot, docker, snapd
echo -e "\n[9] nginx, certbot, docker, snapd:"
for svc in nginx certbot docker snap; do
  command -v $svc &>/dev/null && echo "  - $svc: OK" || echo "  - $svc: FALTA"
done

# 10. Backup
echo -e "\n[10] Backup:"
echo "  - Confirme se o backup/snapshot foi realizado manualmente!"

echo -e "\n[11] FIM DO CHECKLIST"
echo ""
echo "script atualizado em $(date +%Y-%m-%d) ${USER}" 
echo "by psi-software - copyright 2025" 
