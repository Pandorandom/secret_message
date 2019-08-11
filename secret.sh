#!/usr/bin/env bash
#
#
#
# TOOL NAME: secretmessage
# WRITTEN BY: tacree
# DATE: 10/24/2018
# REV:
# First Worked: 10/24/2018
# Purpose: Tool will encrypt and decrypt files using open ssl and a Triple-DES Cipher. Must alias in your
# ~/.bashrc or ~/.bash_profile with:
# alias secret='/Path/to/secretmessage/secret.sh'

#
# REV LIST:
# BY:
# DATE:
# CHANGES MADE:

function USAGE() {
  echo -e "Usage:   secretmessage -e FILENAME (encrypt)\n      OR secretmessage -d FILENAME.des3 (decrypt)"
}

# While loop goes through positional parameters confirming the file to encrypt/decrypt.
# The multiple shifts per case statement allows multiple commands and multiple files in one go
# (e.g. secretmessage -e FILENAME -e FILENAME2 -e FILENAME3 -d FILENAME.des3)
while [ "$1" != "" ]; do
  case $1 in
    -e)
      shift
      METHOD=ENCRYPT
      FILENAME=$1
      shift
      ;;
    -d)
      shift
      METHOD=DECRYPT
      FILENAME=$1
      shift
      ;;
    *)
      USAGE
      exit 1
  esac
done

if [[ ${METHOD} = "ENCRYPT" ]]; then
  openssl des3 -salt -in "$FILENAME" -out "$FILENAME.des3"
elif [[ ${METHOD} = "DECRYPT" ]]; then
  openssl des3 -d -salt -in "$FILENAME" -out "${FILENAME}.true"
  echo -e "\033[0;32mPrint the decrypted message? (y|n) \033[0m"
  read -p "[secretmessage]: " PRINT
  if [[ ${PRINT} = "y" ]]; then
    cat ${FILENAME}.true
  elif [[ ${PRINT} = "n" ]]; then
    exit 0
  else
    USAGE
    exit 1
  fi
fi
