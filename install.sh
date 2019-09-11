#!/bin/bash

echo "Beginning install script.."

echo "Performing updates"
apt-get update && apt-get upgrade -y

#SSH From https://www.raspberrypi.org/documentation/configuration/security.md


if [ -f /home/pi/.ssh/id_rsa ]; then
    echo "id_rsa exists, not generating new ssh key"
else 
    echo "id_rsa does not exist. Generating ssh key"
    mkdir /home/pi/.ssh/
    ssh-keygen -t rsa -f /home/pi/.ssh/id_rsa -q -P ""
fi



apt install openssh-server
sed -i 's/ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/UsePAM .*/UsePAM no/g' /etc/ssh/sshd_config
service ssh start
service ssh reload

echo "Installing ufw"
apt install ufw -y
ufw enable
ufw allow ssh
ufw limit ssh/tcp

echo "Installing fail2ban"
apt install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Download bottle for creating webhooks
echo "Downloading Bottle"
wget https://bottlepy.org/bottle.py

# Download python script for creating webpages
sudo ufw allow 80
ip addr show
wget https://raw.githubusercontent.com/cadamswaite/RPI-Jekyll-Compiler/master/webhook.py
python ./webhook.py &
