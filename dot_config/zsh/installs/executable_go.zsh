#!/bin/zsh

DOWNLOAD_URL=""
if [[ $OSTYPE == darwin* ]]; then
  DOWNLOAD_URL="https://go.dev/dl/go1.18.darwin-amd64.pkg"
  curl -L "${DOWNLOAD_URL}" -o go.pkg
  sudo installer -pkg go.pkg -target /
  rm go.pkg
else
  DOWNLOAD_URL="https://go.dev/dl/go1.18.linux-amd64.tar.gz"
  curl -L "${DOWNLOAD_URL}" -o go.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go.tar.gz
  rm go.tar.gz
fi

echo "go installed to /usr/local/go"
