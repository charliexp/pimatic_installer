#!/bin/bash
clear

# init
DIRECTORY="/tmp/installation_pimatic"
INSTALL_LOG_FILE="/tmp/pimatic_installation.log"

function pimatic_installer() {
	start_install | tee $INSTALL_LOG_FILE
}

function start_install() {

	echo "Start installation of pimatic"
	create_log_file
	check_build_essentials
	prepare_install_dir
	install_nodeJS
	install_pimatic
# TODO create a .sh file to automate to create ssl cert.
#	install_ssl
	cleanup_files
	config_ssl
}

function create_log_file() {
	if [ ! -f "$INSTALL_LOG_FILE" ]; then
		echo "Create log file" $INSTALL_LOG_FILE
		touch $INSTALL_LOG_FILE
	fi
}

function check_build_essentials() {
	echo "Install wget | tar | build essential "
	sudo apt-get install wget tar build-essential -y
}

function prepare_install_dir() {
	if [ -d "$DIRECTORY" ]; then
		echo "Directory already exists"
	else
		cd /tmp
		sudo mkdir /installation_pimatic
	fi
}

function install_nodeJS() {
	echo "Need nodeJS version:"
	if(/usr/bin/env node --version == "v0.10.24") then
		echo "nodeJS installed with version: "
		/usr/bin/env node --version
	else
		echo "Installing nodeJS v0.10.24"
		wget http://nodejs.org/dist/v0.10.24/node-v0.10.24-linux-arm-pi.tar.gz -P $DIRECTORY
		cd /usr/local
		sudo tar xzvf $DIRECTORY/node-v0.10.24-linux-arm-pi.tar.gz --strip=1
	fi
}

function install_pimatic() {
	echo "Install pimatic"
	cd /home/pi
	if [ ! -d "/home/pi/pimatic-app" ]; then
		sudo mkdir /home/pi/pimatic-app
		sudo npm install pimatic --prefix pimatic-app --production
		sudo npm install pimatic-mobile-frontend

		echo "Link pimatic to run it globally"
		cd  /home/pi/pimatic-app/node_modules/pimatic
		sudo npm link


		echo "Make a service pimatic"
		cd $DIRECTORY
		wget https://raw.github.com/pimatic/pimatic/master/install/pimatic-init-d
		sudo cp pimatic-init-d /etc/init.d/pimatic
		sudo chmod +x /etc/init.d/pimatic
		sudo chown root:root /etc/init.d/pimatic
		sudo update-rc.d pimatic defaults
	else
		echo "Pimatic already installed"
	fi
}

function install_ssl() {
	if [ ! -f /home/pi/pimatic-app/config.json ]; then
		echo "Setup SSL cert"
		wget https://raw.githubusercontent.com/pimatic/pimatic/master/install/ssl-setup
		sudo chmod +x ./ssl-setup

		echo "Create default config"
		cd $DIRECTORY
		wget https://raw.githubusercontent.com/xleeuwx/pimatic_installer/master/default_config.json
		cp /tmp/installation_pimatic/default_config.json /home/pi/pimatic-app/config.json
	fi
}

function cleanup_files() {
	if [ -d "$DIRECTORY" ]; then
		echo "Cleanup install dir"
		sudo rm -rf $DIRECTORY
	fi
}

function start_pimatic() {
	echo "Start pimatic for the first time:"
	sudo service pimatic start
}

function config_ssl() {
	cd /home/pi/pimatic-app
	sudo ./ssl-setup
}

pimatic_installer
