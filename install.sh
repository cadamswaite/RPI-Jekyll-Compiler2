#!/bin/bash

echo "Beginning install script.."

echo "Performing updates disabled during dev!"
#apt-get update && apt-get upgrade -y

#SSH From https://www.raspberrypi.org/documentation/configuration/security.md

echo "Installing ssh server"
apt -qq install openssh-server -y
service ssh start
echo "Started ssh server"

if [ -f /home/pi/.ssh/id_rsa ]; then
    echo "id_rsa exists, not generating new ssh key"
else 
    echo "id_rsa does not exist. Generating ssh key"
    sudo -u pi -g pi -- mkdir /home/pi/.ssh/
    sudo -u pi -g pi -- ssh-keygen -t rsa -f /home/pi/.ssh/id_rsa -q -P ""
    mv /home/pi/.ssh/id_rsa.pub /home/pi/.ssh/authorized_keys
    echo -e "Default \e[31mSSH key generated. Please copy id_rsa to PC now and press enter to continue"
    read enter
    rm /home/pi/.ssh/id_rsa
    chmod 600 /home/pi/.ssh/authorized_keys
    chmod 600 /home/pi/.ssh/
fi

echo "Securing ssh"
sed -i 's/ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/UsePAM .*/UsePAM no/g' /etc/ssh/sshd_config
service ssh reload

echo "Installing ufw"
apt install ufw -y
ufw enable
ufw allow ssh
ufw limit ssh/tcp

echo "Installing fail2ban"
apt -qq install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Download bottle for creating webhooks
echo "Downloading Bottle"
wget https://bottlepy.org/bottle.py

# Download python script for creating webpages
sudo ufw allow 80
ip addr show
wget https://raw.githubusercontent.com/cadamswaite/RPI-Jekyll-Compiler/master/webhook.py
python ./webhook.py &
