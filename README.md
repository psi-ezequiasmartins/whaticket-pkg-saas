## REQUESITOS 
<ul>
  <li>UBUNTU 20.04 (OBRIGATORIO)</li>
  <li>VM COM MINIMO: 2CPU 4GB RAM</li>
  <li>VM COM RECOMENDADO: 4CPU 6GB RAM</li>  
</ul>

## CRIAR SUBDOMINIO E APONTAR PARA O IP DA SUA VPS ##

FRONTEND_URL:

nexus_app.seudominio.com

BACKEND_URL:

nexus_api.seudominio.com

## CHECAR PROPAGAÇÃO DO DOMÍNIO ##

https://dnschecker.org/

## COPIAR A PASTA PARA ROOT E RODAR OS COMANDOS ABAIXO no Seu SERVIDOR SSH ##

Aqui está um passo a passo seguro para preparar seu Ubuntu Server 22.04 LTS antes de copiar os arquivos do WhaticketSaaS para a pasta `www/wwwroot`. Assim, seu backup já terá um ambiente limpo, atualizado e pronto para a instalação.

## 1. Atualize o sistema

```sh
sudo apt update && sudo apt upgrade -y
```
## 2. Instale pacotes essenciais

```sh
sudo apt install -y curl wget git unzip sudo lsb-release ca-certificates build-essential
```

## 3. (Opcional) Configure timezone e hostname

```sh
sudo timedatectl set-timezone America/Sao_Paulo
sudo hostnamectl set-hostname seu-hostname
```

## 4. (Opcional) Configure o firewall

```sh
sudo ufw allow OpenSSH
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

## 5. Crie a estrutura da pasta de instalação

```sh
sudo mkdir -p /www/wwwroot
sudo chown $USER:$USER /www/wwwroot
```

## 6. (Opcional) Faça um snapshot/backup do servidor

Se estiver em uma VPS/cloud, use o painel do provedor para criar um snapshot.  
Se for backup manual, use `rsync` ou `tar` para salvar o estado atual do sistema.

## 7. Pronto para copiar os arquivos

Agora, com o ambiente preparado, você pode copiar os arquivos do WhaticketSaaS para `/www/wwwroot` e seguir com os scripts de checagem e instalação.

**Resumo:**  
Com esses passos, seu backup já terá um ambiente limpo, atualizado e pronto para receber o WhaticketSaaS.  

## 8. Configurar o servidor para receber o WhaticketSaaS
sudo mkdir -p /www/wwwroot
sudo git clone https://github.com/whaticket/whaticket-saas.git /www/wwwroot/whaticket-saas
sudo cd /www/wwwroot/whaticket-saas
sudo clear
sudo ./checklist_srv.sh
sudo ./check.sh
sudo ./check_v2.sh

mkdir -p /www/wwwroot/logs

## 9. Executar o WhaticketSaaS (com o script `whaticketsaas` + log de saída)
sudo chmod +x whaticketsaas
sudo ./whaticketsaas

## 10. Executar o script `whaticketsaas` e salvar a saída em um arquivo de log
Você pode executar o script e salvar toda a saída (stdout e stderr) em um arquivo de log assim:

```sh
script /www/wwwroot/logs/log-install.txt 2>&1 && ./whaticketsaas
exit
```

O script `./whaticketsaas` vai executar o WhaticketSaaS e salvar a saída em um arquivo de log chamado `log-install.txt` na pasta `/www/wwwroot/whaticket-saas`. Você pode acessar o arquivo de log em qualquer momento para ver o progresso do processo de instalação.

## login e senha | nexus-app.markagp.com.br

login: admin@admin.com
senha: 123456

Configuração de e-mail dentro do BACKEND no arquivo ENV

MAIL_HOST="smtp.gmail.com"
MAIL_USER="seu-email"
MAIL_PASS="sua-senha"
MAIL_FROM="seu-email"
MAIL_PORT="587"

Configuração de pagamento GERENCIANET dentro BACKEND no arquivo ENV

GERENCIANET_SANDBOX=true
GERENCIANET_CLIENT_ID=sua-id
GERENCIANET_CLIENT_SECRET=sua_chave_secreta
GERENCIANET_PIX_CERT=nome_do_certificado
GERENCIANET_PIX_KEY=chave_pix_gerencianet

# para usar GERENCIANET Em backend\certs
# Salvar o certificado no formato .p12
# Salvar a chave privada no formato .pem

## Customizar a template do Sistema

pm2 status
pm2 stop all

1. Trocar logo
cd /home/deploy/SUAEMPRESA/frontend/
cp /home/deploy/SUAEMPRESA/backend/certs/
logo.png 200x120 e logologin.png 250x250
cd /home/deploy/SUAEMPRESA/frontend/
npm run build
pm2 restart all

2. Trocar o favicon
https://favicon.io/favicon-converter/

3. Trocar o logo do sistema
cd /home/deploy/SUAEMPRESA/frontend/
npm run build
pm2 restart all

4. Mudar a cor: 
( Esse e verde ) #024d18
Arquivo App.js 
primary: { main: '#0872b9' },
cd /home/deploy/SUAEMPRESA/frontend/
npm run build
pm2 restart all

5. Trocar a Instania ( Empresa )
Arquivo index.html
cd /home/deploy/SUAEMPRESA/frontend/
npm run build
pm2 restart all
