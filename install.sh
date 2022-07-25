#!/bin/bash

AUTOSTART="true"
while getopts n OPTION; do
  case "${OPTION}" in
    n) AUTOSTART="false";;
  esac
done
shift "$(($OPTIND -1))"

REQ_VERSION=$1
if [ "$REQ_VERSION" = "" ]
then
    VERSION=$(curl -sL https://api.github.com/repos/autodarts/releases/releases/latest | grep tag_name | grep -o '[0-9]*\.[0-9]*\.[0-9]*')
    echo "Installing latest version v${VERSION}."
else
    VERSION=$(curl -sL https://api.github.com/repos/autodarts/releases/releases | grep tag_name | grep ${REQ_VERSION} | grep -o '[0-9]*\.[0-9]*\.[0-9]*')
    if [ "$VERSION" = "" ]
    then
        echo "Requested version v${REQ_VERSION} not found."
        echo "Exiting."
        exit 1
    fi
    echo "Installing requested version v${VERSION}"
fi

PLATFORM=$(uname)
if [ "$PLATFORM" = "Linux" ]
then 
    PLATFORM="linux"
else
    echo "Platform is not linux, and hence is not supported by this script."
    echo "Exiting"
    exit 1
fi

ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]
then
    ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]
then
    ARCH="arm64"
elif [ "$ARCH" = "armv7l" ]
then
    ARCH="armv7l"
else
    echo "Kernel architecture ${ARCH} is not supported."
    echo "Exiting"
    exit 1
fi

# Download autodarts binary and unpack to ~/.local/bin
mkdir -p ~/.local/bin
echo "Downloading and extracting autodarts${VERSION}.${PLATFORM}-${ARCH}.tar.gz into ~/.local/bin"
curl -sL https://github.com/autodarts/releases/releases/download/${VERSION}/autodarts${VERSION}.${PLATFORM}-${ARCH}.tar.gz | tar -xz -C ~/.local/bin
echo "Making ~/.local/bin/autodarts executable"
chmod +x ~/.local/bin/autodarts

if [ ${AUTOSTART} = "true" ]; then
# Creat systemd service
echo "Creating systemd service for autodarts to start on system startup"
echo "We will need sudo access to do that"
cat <<EOF | sudo tee /etc/systemd/system/autodarts.service >/dev/null
# autodarts.service

[Unit]
Description=Start/Stop Autodarts board service
Wants=network.target
After=network.target

[Service]
User=${USER}
ExecStart=/home/${USER}/.local/bin/autodarts
Restart=on-failure
KillSignal=SIGINT
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

echo "Enabling systemd service."
sudo systemctl enable autodarts

echo "Starting autodarts."
sudo systemctl stop autodarts
sudo systemctl start autodarts
fi

echo "Finished."