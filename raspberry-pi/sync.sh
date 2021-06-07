#!/usr/bin/env bash

# Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Copies the services folder over to the raspberry pi.

echo Syncing install.sh
rsync -r ./install.sh pi@raspberrypi.local:~/install.sh

echo Syncing services/
rsync -r ./services/ pi@raspberrypi.local:~/services

echo Complete
