#!/usr/bin/env bash

# Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Copies the services folder over to the raspberry pi.

# TODO: Check that /mnt/external is actually mounted.

echo Syncing .ssh/
rsync -v -i -e ssh -r ./.ssh/authorized_keys pi@raspberrypi.local:~/.ssh/authorized_keys

# Sleeps required so the remote host doesn't close our new connection while shutting down the previous one.
sleep 1s

echo Syncing install.sh
rsync -v -i -e ssh -r ./install.sh pi@raspberrypi.local:/mnt/external/install.sh

sleep 1s

echo Syncing services/
rsync -v -i -e ssh -r ./services/ pi@raspberrypi.local:/mnt/external/services

# TODO: Reenable this when this 
#sleep 1s
#
#echo Running services.
#ssh pi@raspberrypi.local "cd /mnt/external/services ; ./run.sh"

echo Complete
