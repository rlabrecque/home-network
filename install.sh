#!/usr/bin/env bash

# Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root."
	exit
fi


install-build-essentials () {
	echo -e "\e[1mInstalling Build Essentials\e[0m"

	apt-get install -y build-essential
	apt-get install -y libssl-dev
	apt-get install -y libffi-dev

	echo -e "\e[32mSuccess!\e[0m"
	echo ""
}


install-docker () {
	echo -e "\e[1mInstalling docker\e[0m"

	# Installing docker will disconnect ssh
	curl -sSL https://get.docker.com | sh
	usermod -aG docker pi
	python3 -m pip install -IU docker-compose

	echo -e "\e[32mSuccess!\e[0m"
	echo ""
}

install-python () {
	echo -e "\e[1mInstalling Python\e[0m"

	apt-get install -y python3
	apt-get install -y python3-pip
	pip3 install virtualenv

	echo -e "\e[32mSuccess!\e[0m"
	echo ""
}

echo -e "\e[1mUpdating and Upgrading...\e[0m"
apt-get update
echo ""
apt-get upgrade -y
echo ""
apt-get dist-upgrade -y
echo ""


# Set local time zone
timedatectl set-timezone America/Los_Angeles

# Uncomment en_US.UTF-8 for inclusion in generation
sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen

# Generate locale
locale-gen

# Set default locale
update-locale LANG=en_US.UTF-8

install-build-essentials

install-python

install-docker # Requires build-essentials, pytho
n
echo -e "\e[1mCleaning up...\e[0m"
apt-get autoclean -y
echo ""
apt-get autoremove -y
echo ""

echo -e "\e[32mInstalling completed successfully!\e[0m"
