#!/bin/bash

PLATFORM=$(uname)
if [[ "$PLATFORM" = "Linux" ]]; then 
    PLATFORM="linux"
else
    echo "Platform is not 'linux', and hence is not supported by this script." && exit 1
fi

ARCH=$(uname -m)
case "${ARCH}" in
    "x86_64"|"amd64") ARCH="amd64";;
    "aarch64"|"arm64") ARCH="arm64";;
    "armv7l") ARCH="armv7l";;
    *) echo "Kernel architecture '${ARCH}' is not supported." && exit 1;;
esac

CURRENT=$(~/.local/bin/autodarts --version)
LATEST=$(curl -sL https://storage.googleapis.com/autodarts-releases/detection/latest/${PLATFORM}/${ARCH}/RELEASES.json | grep -o '"currentVersion":"v[0-9]\+\.[0-9]\+\.[0-9]\+"' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')

echo "Current version: ${CURRENT}, latest version: ${LATEST}"

if [[ "$CURRENT" = "$LATEST" ]]; then
    echo "Current install is up-to-date, v${CURRENT}."
else
    echo "Updating Autodarts from v${CURRENT} to v${LATEST}."
    bash <(curl -sL get.autodarts.io)
fi
