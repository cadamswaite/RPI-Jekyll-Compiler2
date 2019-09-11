#!/bin/bash

echo "Beginning install script.."

echo "Performing updates"
apt-get update && apt-get upgrade -y

#SSH From https://www.raspberrypi.org/documentation/configuration/security.md
ssh-keygen -t rsa -q -P ""

apt install openssh-server
sed -i 's/.*ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no' /etc/ssh/sshd_config
sed -i 's/.*PasswordAuthentication .*/PasswordAuthentication no' /etc/ssh/sshd_config
sed -i 's/.*UsePAM .*/UsePAM no' /etc/ssh/sshd_config
service ssh reload

echo "Installing ufw"
apt install ufw
ufw enable
ufw allow ssh
ufw limit ssh/tcp

echo "Installing fail2ban"
apt install fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
