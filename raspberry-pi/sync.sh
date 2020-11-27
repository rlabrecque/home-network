#!/usr/bin/env bash

# Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Copies the services folder over to the raspberry pi.

rsync -r ./services/ pi@raspberrypi:~/services
