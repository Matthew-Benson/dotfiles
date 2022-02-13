#!/bin/bash

DOWNLOAD_URL=""
if [[ $OSTYPE == darwin* ]]; then
  DOWNLOAD_URL="https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-darwin-amd64"
else
  DOWNLOAD_URL="https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64"
fi

curl "${DOWNLOAD_URL}" -o bazelisk
chmod +x bazelisk
sudo mv bazelisk /usr/local/bin/bazel

echo "bazel installed via bazelisk to /usr/local/bin/bazel"

