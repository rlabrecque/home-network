#!/usr/bin/env bash

# Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Pull down the any updated images
docker-compose pull

# Update and restart the services
docker-compose up -d --build --remove-orphans
