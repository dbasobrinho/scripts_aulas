#!/usr/bin/env bash
# Bash simples e explícito para baixar, extrair e limpar o backup AUTOBR
# Ambiente: Oracle Linux 7.9 (root)

set -e

echo "==== [1] Criando diretório e acessando destino ===="
mkdir -p /root/ADMDBA/PLDG/bkp_AUTOBR
cd /root/ADMDBA/PLDG/bkp_AUTOBR

echo "==== [2] Habilitando EPEL e preparando cache ===="
yum install -y oracle-epel-release-el7
yum clean all -y
yum makecache -y

echo "==== [3] Instalando 7-Zip ===="
yum install -y p7zip p7zip-plugins || yum install -y \
  https://yum.oracle.com/repo/OracleLinux/OL7/developer/EPEL/x86_64/getPackage/p7zip-16.02-10.el7.x86_64.rpm \
  https://yum.oracle.com/repo/OracleLinux/OL7/developer/EPEL/x86_64/getPackage/p7zip-plugins-16.02-10.el7.x86_64.rpm

echo "==== [4] Baixando arquivos do GitHub ===="
wget -q https://raw.githubusercontent.com/dbasobrinho/pplab/main/PLDG1T001_OUT-2025/bkp_AUTOBR-07-OUT-25/bkp_AUTOBR.7z.001
wget -q https://raw.githubusercontent.com/dbasobrinho/pplab/main/PLDG1T001_OUT-2025/bkp_AUTOBR-07-OUT-25/bkp_AUTOBR.7z.002
wget -q https://raw.githubusercontent.com/dbasobrinho/pplab/main/PLDG1T001_OUT-2025/bkp_AUTOBR-07-OUT-25/bkp_AUTOBR.7z.003
wget -q https://raw.githubusercontent.com/dbasobrinho/pplab/main/PLDG1T001_OUT-2025/bkp_AUTOBR-07-OUT-25/bkp_AUTOBR.7z.004
wget -q https://raw.githubusercontent.com/dbasobrinho/pplab/main/PLDG1T001_OUT-2025/bkp_AUTOBR-07-OUT-25/bkp_AUTOBR.7z.005
wget -q https://raw.githubusercontent.com/dbasobrinho/pplab/main/PLDG1T001_OUT-2025/bkp_AUTOBR-07-OUT-25/bkp_AUTOBR.exe

echo "==== [5] Juntando partes .7z em um único arquivo ===="
cat /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.001 \
    /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.002 \
    /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.003 \
    /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.004 \
    /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.005 \
    > /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z
	
echo '==== [6] Apagando arquivo compactado partes (.001... .005) ===='
rm -f /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.001
rm -f /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.002
rm -f /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.003
rm -f /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.004
rm -f /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z.005

echo "==== [6] Extraindo conteúdo do backup ===="
7z x /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z

echo '==== [7] Apagando arquivo compactado (.7z) ===='
rm -f /root/ADMDBA/PLDG/bkp_AUTOBR/bkp_AUTOBR.7z

echo "==== [8] Listando conteúdo final ===="
ls -lh /root/ADMDBA/PLDG/bkp_AUTOBR

echo "==== Processo concluído com sucesso! ===="
