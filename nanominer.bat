@echo off
REM ==============================
REM Script de configuração e execução do NanoMiner
REM ==============================

REM Verifica se está sendo executado como administrador
>nul 2>&1 "%SystemRoot%\System32\cacls.exe" "%SystemRoot%\System32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Por favor, execute este script como administrador.
    exit /b
)

REM Configurações do minerador
set "NANOMINER_URL=https://github.com/nanopool/nanominer/releases/download/v3.7.5/nanominer-windows-3.7.5.zip"
set "WALLET=45iSszCbuwaVUXj4DuEqNPjC1GVBZQ6gJ7XJUYQn1KQyT5Z6GQxxmjtHrJL4WhiW1RcrarBX2xFDJhHirEccpUq2LaGbysx"
set "RIGNAME=OCC_MONERO"
set "EMAIL=andreocc@gmail.com"
set "POOLS=xmr-eu1.nanopool.org:10343,xmr-eu2.nanopool.org:10343,xmr-us-east1.nanopool.org:10343,xmr-us-west1.nanopool.org:10343,xmr-asia1.nanopool.org:10343"

REM Verifica se o curl está instalado
if not exist "%SystemRoot%\System32\curl.exe" (
    echo curl não encontrado! Por favor, instale o curl ou execute em um Windows 10+.
    exit /b
)

REM Verifica se o tar está instalado
if not exist "%SystemRoot%\System32\tar.exe" (
    echo tar não encontrado! Por favor, instale o tar ou execute em um Windows 10+.
    exit /b
)

REM Baixa o NanoMiner
echo Baixando o NanoMiner...
curl -L -o nanominer.zip %NANOMINER_URL%

REM Verifica se o download foi bem-sucedido
if not exist nanominer.zip (
    echo Falha no download do NanoMiner.
    exit /b
)

REM Extrai os arquivos usando o tar
echo Extraindo arquivos...
mkdir nanominer
tar -xf nanominer.zip -C nanominer
del nanominer.zip

REM Cria o arquivo de configuração
echo Criando arquivo de configuração...
(
    echo [RandomX]
    echo wallet = %WALLET%
    echo rigName = %RIGNAME%
    echo email = %EMAIL%
    for %%p in (%POOLS%) do (
        echo pool = %%p
    )
) > %cd%\nanominer\config.ini

REM Verifica se o arquivo de configuração foi criado
if not exist %cd%\nanominer\config.ini (
    echo Falha ao criar o arquivo de configuração.
    exit /b
)

REM Inicia o NanoMiner de forma minimizada
echo Iniciando o NanoMiner...
cd nanominer
start /min nanominer.exe

REM Mensagem final de sucesso
echo NanoMiner iniciado com sucesso!
exit /b
