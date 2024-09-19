#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <admin_user> <server_ip> <target_dir>"
    exit 1
fi

ADMIN_USER=$1
SERVER_IP=$2
TARGET_DIR=$3

ssh -i C:\\Users\\never\\.ssh\\spp_devops.pem $ADMIN_USER@$SERVER_IP << EOF
    screen -dmS permission_script bash -c '
    while true; do
        find "$TARGET_DIR" -type f -exec chmod 660 {} \;
        find "$TARGET_DIR" -type d -exec chmod 770 {} \;

        sleep 5
    done
    '
EOF

echo "Commands are executed on the server $SERVER_IP"
read -p "Press any key to exit..."