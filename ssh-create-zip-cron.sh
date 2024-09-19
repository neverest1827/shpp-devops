#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <admin_user> <server_ip> <target_dir>"
    exit 1
fi

ADMIN_USER=$1
SERVER_IP=$2
TARGET_DIR=$3


ssh -t -i C:\\Users\\never\\.ssh\\spp_devops.pem $ADMIN_USER@$SERVER_IP << EOF
    if ! command -v zip &> /dev/null; then
        sudo apt update && sudo apt install -y zip
    fi

    find "$TARGET_DIR" -type f -mmin +3 2>/dev/null | while read -r FILE; do
        if [ -f "\$FILE" ] && [ -r "\$FILE" ]; then
            FILE_NAME=\$(basename "\$FILE")

            ZIP_NAME="\${FILE_NAME}.zip"
            zip -j "/tmp/\$ZIP_NAME" "\$FILE"

            rm "\$FILE"
        fi
    done

    (crontab -l; echo "* * * * * find $TARGET_DIR -type f -mmin +3 2>/dev/null | while read -r FILE; do [ -f \"\$FILE\" ] && [ -r \"\$FILE\" ] && FILE_NAME=\$(basename \"\$FILE\") && ZIP_NAME=\"\${FILE_NAME}.zip\" && zip -j \"/tmp/\$ZIP_NAME\" \"\$FILE\" && rm \"\$FILE\"; done") | crontab -
EOF

echo "The commands are executed and cron is configured on the server $SERVER_IP"
read -p "Press any key to exit..."
