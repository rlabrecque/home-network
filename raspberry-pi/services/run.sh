#!/usr/bin/env bash

# Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Pull down the any updated images, we explicity do this first because we need to download the images
# before we can restart the services.
docker compose pull

# Update and restart the services
docker compose up -d --build --remove-orphans

# Prune any old dnaling images
docker image prune -a
