#!/bin/bash
# ===========================
# Script de configuração e execução do NanoMiner no Linux
# ===========================

# Verifica se está sendo executado como root
if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute este script como root."
  exit
fi

# Configurações do minerador
NANOMINER_URL="https://github.com/nanopool/nanominer/releases/download/v3.7.5/nanominer-linux-3.7.5.tar.gz"
WALLET="45iSszCbuwaVUXj4DuEqNPjC1GVBZQ6gJ7XJUYQn1KQyT5Z6GQxxmjtHrJL4WhiW1RcrarBX2xFDJhHirEccpUq2LaGbysx"
RIGNAME="MONERO"
EMAIL="email@email.com"
POOLS=("xmr-eu1.nanopool.org:10343" "xmr-eu2.nanopool.org:10343" "xmr-us-east1.nanopool.org:10343" "xmr-us-west1.nanopool.org:10343" "xmr-asia1.nanopool.org:10343")

# Verifica se o curl está instalado
if ! [ -x "$(command -v curl)" ]; then
  echo "Erro: curl não está instalado." >&2
  exit 1
fi

# Verifica se o tar está instalado
if ! [ -x "$(command -v tar)" ]; then
  echo "Erro: tar não está instalado." >&2
  exit 1
fi

# Baixa o NanoMiner
echo "Baixando o NanoMiner..."
curl -L -o nanominer.tar.gz $NANOMINER_URL

# Verifica se o download foi bem-sucedido
if [ ! -f "nanominer.tar.gz" ]; then
  echo "Falha no download do NanoMiner."
  exit 1
fi

# Extrai os arquivos
echo "Extraindo arquivos..."
mkdir nanominer
tar -xzf nanominer.tar.gz -C nanominer --strip-components=1
rm nanominer.tar.gz

# Cria o arquivo de configuração
echo "Criando arquivo de configuração..."
cat > nanominer/config.ini <<EOL
[RandomX]
wallet = $WALLET
rigName = $RIGNAME
email = $EMAIL
EOL

# Adiciona as pools ao arquivo de configuração
for POOL in "${POOLS[@]}"
do
    echo "pool = $POOL" >> nanominer/config.ini
done

# Verifica se o arquivo de configuração foi criado
if [ ! -f "nanominer/config.ini" ]; then
  echo "Falha ao criar o arquivo de configuração."
  exit 1
fi

# Dá permissão de execução ao binário do NanoMiner
chmod +x nanominer/nanominer

# Inicia o NanoMiner
echo "Iniciando o NanoMiner..."
cd nanominer
./nanominer

# Mensagem final de sucesso
echo "NanoMiner iniciado com sucesso!"
