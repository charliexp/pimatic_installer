#!/bin/bash
clear

# init
function pimatic_installer() {
	start_install | tee /tmp/pimatic_installation.log
}

function start_install() {

	echo "Start installation of pimatic"
	create_log_file
	check_dependencies
	prepare_install_dir
	install_nodeJS
	install_pimatic
# TODO create a .sh file to automate to create ssl cert.
#	install_ssl
	cleanup_files
#	config_ssl
}

function create_log_file() {
	if [ ! -f "/tmp/pimatic_installation.log" ]; then
		echo "Create log file" /tmp/pimatic_installation.log
		sudo touch /tmp/pimatic_installation.log
	fi
}

function check_dependencies() {
	echo "Install dependencies: wget | tar | build essential | ntp | ntpdate | samba "
	sudo apt-get install wget tar build-essential ntp ntpdate samba samba-client samba-commen-bin -y
}

function prepare_install_dir() {
	if [ -d "/tmp/installation_pimatic" ]; then
		echo "Directory already exists"
	else
		sudo mkdir /tmp/installation_pimatic
	fi
}

function install_nodeJS() {
	echo "Need nodeJS version:"
	if(/usr/bin/env node --version == "v0.10.24") then
		echo "nodeJS installed with version: "
		/usr/bin/env node --version
	else
		echo "Installing nodeJS v0.10.24"
		sudo wget http://nodejs.org/dist/v0.10.24/node-v0.10.24-linux-arm-pi.tar.gz -P /tmp/installation_pimatic
		cd /usr/local
		sudo tar xzvf /tmp/installation_pimatic/node-v0.10.24-linux-arm-pi.tar.gz --strip=1
	fi
}

function install_pimatic() {
	echo "Install pimatic"
	if [ ! -d "/home/pi/pimatic-app/" ]; then
		sudo mkdir /home/pi/pimatic-app/
		sudo npm install pimatic --prefix pimatic-app --production

		echo "Link pimatic to run it globally"
		cd  "/home/pi/pimatic-app/node_modules/pimatic"
		sudo npm link


		echo "Make a service pimatic"
		cd /tmp/installation_pimatic
		sudo wget https://raw.github.com/pimatic/pimatic/master/install/pimatic-init-d -P /tmp/installation_pimatic
		sudo cp pimatic-init-d /etc/init.d/pimatic
		sudo chmod +x /etc/init.d/pimatic
		sudo chown root:root /etc/init.d/pimatic
		sudo update-rc.d pimatic defaults

		echo "Copy default_config.json to config.json"
		cd /tmp/installation_pimatic
		sudo wget https://raw.githubusercontent.com/xleeuwx/pimatic_installer/master/default_config.json
		sudo cp /tmp/installation_pimatic/default_config.json "/home/pi/pimatic-app/config.json"
	else
		echo "Pimatic already installed"
	fi
}

function install_ssl() {
	if [ ! -f /home/pi/pimatic-app/config.json ]; then
		echo "Setup SSL cert"
		sudo wget https://raw.githubusercontent.com/pimatic/pimatic/master/install/ssl-setup
		sudo chmod +x ./ssl-setup

		echo "Create default config"
		cd /tmp/installation_pimatic
		sudo wget https://raw.githubusercontent.com/xleeuwx/pimatic_installer/master/default_config_ssl.json
		sudo cp /tmp/installation_pimatic/default_config.json /home/pi/pimatic-app/config.json
	fi
}

function cleanup_files() {
	if [ -d "/tmp/installation_pimatic" ]; then
		echo "Cleanup install dir"
		sudo rm -rf /tmp/installation_pimatic
	fi
}

function start_pimatic() {
	echo "Start pimatic for the first time:"
	sudo service pimatic start
}

function config_ssl() {
	cd /home/pi/pimatic-app/
	sudo ./ssl-setup
}

pimatic_installer
