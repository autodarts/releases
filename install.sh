#/bin/bash

REQ_VERSION=$1
if [ "$REQ_VERSION" = "" ]
then
    VERSION=$(curl -sL https://api.github.com/repos/autodarts/releases/releases/latest | grep tag_name | grep -o '[0-9]*\.[0-9]*\.[0-9]*')
    echo "Downloading latest version v${VERSION}."
else
    VERSION=$(curl -sL https://api.github.com/repos/autodarts/releases/releases/${VERSION} | grep tag_name | grep -o '[0-9]*\.[0-9]*\.[0-9]*')
    if [ "$VERSION" = "" ]
    then
        echo "Requested version v${REQ_VERSION} not found."
        echo "Exiting."
        exit 1
    fi
    echo "Downloading requested version v${VERSION}"
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
curl -sL https://github.com/autodarts/releases/releases/download/${VERSION}/autodarts${VERSION}.${PLATFORM}-${ARCH}.tar.gz | tar -xvz -C ~/.local/bin
chmod +x ~/.local/bin/autodarts

# Creat systemd service
cat <<EOF | sudo tee /etc/systemd/system/autodarts.service
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

sudo systemctl enable autodarts
sudo systemctl start autodarts