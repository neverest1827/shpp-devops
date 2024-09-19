#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <admin_user> <server_ip> <new_user> <ssh_key>"
    exit 1
fi

ADMIN_USER=$1
SERVER_IP=$2
NEW_USER=$3
SSH_KEY=$4

ssh -t -i C:\\Users\\never\\.ssh\\spp_devops.pem $ADMIN_USER@$SERVER_IP << EOF
    if id "$NEW_USER" &>/dev/null; then
        echo "User $NEW_USER already exists."
    else
        sudo adduser --disabled-password --gecos "" $NEW_USER
        sudo usermod -aG sudo $NEW_USER
    fi

    sudo mkdir -p /home/$NEW_USER/.ssh

    if ! grep -Fxq "$SSH_KEY" /home/$NEW_USER/.ssh/authorized_keys; then
        echo "$SSH_KEY" | sudo tee -a /home/$NEW_USER/.ssh/authorized_keys > /dev/null
    else
        echo "SSH key already exists in authorized_keys."
    fi

    sudo chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh
    sudo chmod 700 /home/$NEW_USER/.ssh
    sudo chmod 600 /home/$NEW_USER/.ssh/authorized_keys
EOF

echo "User $NEW_USER created and configured on server $SERVER_IP"
read -p "Press any key to exit..."
