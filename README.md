pimatic auto installer with ssl
=======
Auto installer for pimatic on raspbian

pimatic is a home automation framework that runs on [node.js](http://nodejs.org). It provides a
common extensible platform for home control and automation tasks.

Read more at [pimatic.org](http://pimatic.org/) or visit the [forum](http://forum.pimatic.org).

Getting Started
------------

Git method:
Make sure raspbian is up to date:
	`sudo apt-get update && sudo apt-get upgrade`

Install git
	`sudo apt-get install -y git`

Clone repository
	`git clone https://github.com/xleeuwx/pimatic_installer /tmp`

Make installer executable
	`sudo chmod +x /tmp/pimatic_installer/installer.sh`
	`cd /tmp/pimatic_installer`

Run installer
	`./installer.sh`


Wget method:
Make sure raspbian is up to date:
	`sudo apt-get update && sudo apt-get upgrade`

Install wget
	`sudo apt-get install -y wget`

Clone repository
	`wget https://raw.githubusercontent.com/xleeuwx/pimatic_installer/master/installer.sh  -O /tmp/installer.sh`

Make installer executable
	`sudo chmod +x /tmp/installer.sh`
	`cd /tmp`

Run installer
	`./installer.sh`
