#!/usr/bin/env bash

# Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root."
	exit
fi

rl-update-upgrade () {
	echo -e "\e[1mUpdating and Upgrading...\e[0m"

	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -y

	echo -e "\e[32mSuccess!\e[0m"
	echo ""
}

rl-cleanup () {
	echo -e "\e[1mCleaning up...\e[0m"

	apt-get autoclean -y
	apt-get autoremove -y

	echo -e "\e[32mSuccess!\e[0m"
	echo ""
}

rl-join-systemd-journal-group () {
	# Join the systemd-journal group to get access to system wide journal.
	usermod -a -G systemd-journal pi
}

rl-set-timezone () {
	# Set local time zone
	timedatectl set-timezone America/Los_Angeles
}

rl-set-locale () {
	# Uncomment en_US.UTF-8 for inclusion in generation
	sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen

	# Generate locale
	locale-gen

	# Set default locale
	update-locale LANG=en_US.UTF-8
}

rl-install-build-essentials () {
	echo -e "\e[1mInstalling Build Essentials\e[0m"

	apt-get install -y build-essential
	apt-get install -y libssl-dev
	apt-get install -y libffi-dev

	echo -e "\e[32mSuccess!\e[0m"
	echo ""
}

rl-install-python () {
	echo -e "\e[1mInstalling Python\e[0m"

	apt-get install -y python3
	apt-get install -y python3-pip
	apt-get install -y python3-venv
	pip3 install --upgrade pip

	echo -e "\e[32mSuccess!\e[0m"
	echo ""
}

rl-install-docker () {
	echo -e "\e[1mInstalling docker\e[0m"

	curl -sSL https://get.docker.com | sh
	usermod -aG docker pi
	pip3 install -IU docker-compose

	echo -e "\e[32mSuccess!\e[0m"
	echo ""
}

rl-join-systemd-journal-group

rl-update-upgrade

rl-set-timezone

rl-set-locale

rl-install-build-essentials

rl-install-python

rl-install-docker # Requires build-essentials, python

rl-cleanup

echo -e "\e[32mInstalling completed successfully!\e[0m"
