#!/bin/bash

echo "Beginning install script.."

echo "Performing updates disabled during dev!"
#apt-get update && apt-get upgrade -y

#SSH From https://www.raspberrypi.org/documentation/configuration/security.md

echo "Installing ssh server"
apt-get -qq install openssh-server -y
service ssh start
echo "Started ssh server"

echo "Generating ssh key"
# Make directory accessible to pi for now, so it can generate keys in that folder.
sudo -u pi -g pi -- mkdir /home/pi/.ssh/
sudo -u pi -g pi -- ssh-keygen -t rsa -f /home/pi/.ssh/id_rsa -q -P ""
mv /home/pi/.ssh/id_rsa.pub /home/pi/.ssh/authorized_keys
echo -e "Default \e[31mSSH key generated. Please copy id_rsa to PC now and press enter to continue\e[m"
read enter
rm /home/pi/.ssh/id_rsa
chmod 600 /home/pi/.ssh/authorized_keys
chmod 600 /home/pi/.ssh/
chown root:root /home/pi/.ssh/

echo "Securing ssh"
sed -i 's/ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/UsePAM .*/UsePAM no/g' /etc/ssh/sshd_config
service ssh reload

echo "Installing ufw"
apt-get -qq install ufw -y
ufw enable
ufw allow ssh
ufw limit ssh/tcp

echo "Installing fail2ban"
apt-get -qq install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/^[sshd]/[sshd]\nenabled = true\nfilter = sshd\nport = ssh\nbanaction = iptables-multiport\nbantime = -1\nmaxretry = 3\n/g' /etc/fail2ban/jail.local
service fail2ban restart
echo "Fail2ban set up"

echo "Install complete!"
