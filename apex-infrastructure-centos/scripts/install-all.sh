#!/bin/bash
# install-all.sh - run steps 01..06 in order. Usage: sudo ENV_FILE=/etc/apex-ords/apex-ords.env ./install-all.sh
set -euo pipefail; cd "$(dirname "$0")"
for s in 01-host-prereqs.sh 02-install-ords.sh 03-configure-ords.sh 04-ords-service.sh 05-nginx-apex.sh; do
  echo; echo "################ $s"; bash "$s"; done
echo; echo "################ 06-smoke-test.sh"; bash 06-smoke-test.sh
