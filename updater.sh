#!/bin/bash

CURRENT=$(~/.local/bin/autodarts --version)
LATEST=$(curl -sL https://api.github.com/repos/autodarts/releases/releases/latest | grep tag_name | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')

echo "Current version: ${CURRENT}, latest version: ${LATEST}"

if [[ "$CURRENT" = "$LATEST" ]]; then
    echo "Current install is up-to-date, v${CURRENT}."
else
	echo "Updating Autodarts from v${CURRENT} to v${LATEST}."
    bash <(curl -sL get.autodarts.io)
fi
