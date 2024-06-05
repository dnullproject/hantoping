#!/bin/bash

ROUTER_IP="${1}"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <router_ip>"
    exit 1
fi

SOURCE_DIR="$(dirname "$(readlink -f "$0")")"
SCRIPT_DEST="/usr/local/bin/haltoping.sh"
SERVICE_DEST="/etc/systemd/system/haltoping.service"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

cp "$SOURCE_DIR/haltoping.sh" "$SCRIPT_DEST"
chmod +x "$SCRIPT_DEST"
cp "$SOURCE_DIR/haltoping.service" "$SERVICE_DEST"
sed -i "s|<ROUTER_IP>|$ROUTER_IP|g" "$SERVICE_DEST"

systemctl daemon-reload
systemctl enable haltoping.service
systemctl start haltoping.service

echo "haltoping has been installed and started successfully."
