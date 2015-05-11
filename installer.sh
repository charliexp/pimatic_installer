#!/bin/bash
clear
echo "Start installation of pimatic"

sudo apt-get install wget tar build-essentials -y
cd /tmp
sudo mkdir /installation_pimatic
wget http://nodejs.org/dist/v0.10.24/node-v0.10.24-linux-arm-pi.tar.gz -P /tmp/installation_pimatic
cd /usr/local
sudo tar xzvf /tmp/installation_pimatic/node-v0.10.24-linux-arm-pi.tar.gz --strip=1

echo " "
echo "NodeJS Version:"
/usr/bin/env node --version

echo "Install pimatic"
cd /home/pi
sudo mkdir /home/pi/pimatic-app
npm install pimatic --prefix pimatic-app --production

echo "Link pimatic so can be start with: sudo pimatic.js"
cd /home/pi/pimatic-app/node_modules/pimatic
sudo npm link

echo "Make a service pimatic"
cd /tmp/installation_pimatic
wget https://raw.github.com/pimatic/pimatic/master/install/pimatic-init-d
sudo cp pimatic-init-d /etc/init.d/pimatic
sudo chmod +x /etc/init.d/pimatic
sudo chown root:root /etc/init.d/pimatic
sudo update-rc.d pimatic defaults

echo "Setup SSL cert"
cd /home/pi/pimatic-app
wget https://raw.githubusercontent.com/pimatic/pimatic/master/install/ssl-setup
chmod +x ./ssl-setup
./ssl-setup

cd /tmp/installation_pimatic
wget https://raw.githubusercontent.com/xleeuwx/pimatic_installer/master/default_config.json
cp sudo rm -rf /tmp/installation_pimatic/default_config.json /home/pi/pimatic-app/config.json

echo "Cleanup files"
sudo rm -rf /tmp/installation_pimatic

echo "Start pimatic for the first time:"
sudo service pimatic start