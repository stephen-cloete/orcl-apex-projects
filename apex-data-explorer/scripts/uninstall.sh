#!/usr/bin/env bash
# Data Explorer - uninstall. Same environment as install.sh (DX_CONNECT,
# DX_ADMIN_PASSWORD, optional DX_WORKSPACE / DX_APP_ID).
set -euo pipefail
cd "$(dirname "$0")/../database"
: "${DX_CONNECT:?}" "${DX_ADMIN_PASSWORD:?}"
SQLBIN=${DX_SQL:-$(command -v sql || command -v sqlplus)}
"$SQLBIN" -S /nolog <<SQL
whenever sqlerror exit failure rollback
connect ADMIN/"${DX_ADMIN_PASSWORD}"@${DX_CONNECT}
@uninstall.sql ${DX_WORKSPACE:-DATA_EXPLORER} ${DX_APP_ID:-220}
exit
SQL
