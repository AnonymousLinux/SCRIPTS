#!/bin/bash

# By: Anonymous Linux
# Telegram (Chat): @AnonymousV
# Telegram (Channel): @Anonymous_Linux

# Este é um script que permite ao utilizador do mesmo, criar usuários no Linux em sequência, a partir de um arquivo (.txt) onde conterá com os nomes de usuários a serem criados.
# Primeiramente, você deve criar um arquivo (.txt) com os nomes de usuários e, transferir o mesmo para o servidor via SFTP, fazer o download com o wget ou, criar com o próprio editor nano no servidor. 
# Feito o passo anterior você poderá executar o script com o comando: userssequences, após isso o script será executado e você deverá informar o diretório onde está o arquivo (.txt) que conterá com os nomes de usuários, para que o script possa processá-los e, criá-los.
# Os usuários que conterá no arquivo (.txt) serão criados com senha e, um número de dias para expirar, que será determinado por você durante a execução do script.
# Lembre-se: é um script em fase de testes, os testes até agora foram perfeitamente aprovados, sem nenhum tipo bug ou problema apresentado. Você será o único responsável por executar este script. Use por sua conta e risco.

clear
echo -e "\033[01;32mModo de uso:\033[01;33m /DIRETÓRIO/ARQUIVO.txt"
echo -e "\033[01;32mExemplo:\033[01;33m /root/users.txt"
echo ""
echo -ne "\033[01;37mNome do arquivo (.txt) com lista de usuários: "; read FILE
echo -ne "\033[01;37mDigite uma senha para os usuários: "; read PASSWORD
echo -ne "\033[01;37mDias para expirar: "; read DAYS
if [ -z $FILE ]; then
  echo ""
  echo -e "\033[01;37;44mVocê digitou o nome de um arquivo vazio. Tente novamente!\033[0m"
  echo ""
  exit
else
if [ ! -f "$FILE" ]; then
  echo ""
  echo -e "\033[01;37;44mArquivo $FILE não encontrado!\033[0m"
  echo ""
  exit
else
if [ -z $PASSWORD ]; then
  echo ""
  echo -e "\033[01;37;44mVocê digitou uma senha vazia. Tente novamente!\033[0m"
  echo ""
  exit
else
if [ -z $DAYS ]; then
  echo ""
  echo -e "\033[1;37;44mVocê digitou um número de dias vazio. Tente novamente!\033[0m"
  echo ""
  exit
else
if [ $DAYS -lt 1 ]; then
  echo ""
  echo -e "\033[1;37;44mVocê digitou um número de dias inválido. Tente novamente!\033[0m"
  echo ""
  exit
else
if echo $DAYS | grep -q '[^0-9]'; then
  echo ""
  echo -e "\033[1;37;44mVocê digitou um número de dias inválido. Tente novamente!\033[0m"
  echo ""
  exit
else
  NUMBER=$(awk 'END{print NR}' $FILE)
if [ $NUMBER = "0" ]; then
  echo ""
  echo -e "\033[01;37;44mO arquivo $FILE está vazio!\033[0m"
  echo ""
  exit
else
  echo ""
  echo -e "\033[01;37mNúmero de usuários carregados: $NUMBER"
  echo ""
  awk  -F  :  '$3  >=  500  {print  $1}'  /etc/passwd | grep -v "nobody" | sort > /tmp/users.txt
  for USERS in `cat $FILE`; do
    if grep -Fxq "$USERS" /tmp/users.txt; then
      echo -e "\033[01;37;44mExistem usuários já existentes no arquivo $FILE!\033[0m"
      echo ""
      exit
    else
      VALIDITY1=$(date "+%Y-%m-%d" -d "+ $DAYS days")
      VALIDITY2=$(date "+%d/%m/%Y" -d "+ $DAYS days")
      USER=$(echo "$USERS" | cut -d " " -f1)
      useradd -e $VALIDITY1 -M -s /bin/false $USER
      (echo $PASSWORD; echo $PASSWORD) | passwd $USER 1> /dev/null 2> /dev/null
    fi  
  done
fi
fi
fi
fi
fi
fi
fi
echo -e "\033[01;32mUsuários criados com sucesso!"
echo -e "\033[01;32mSenha: $PASSWORD"
echo -e "\033[01;32mData de validade: $VALIDITY2\033[01;37m"
exit
