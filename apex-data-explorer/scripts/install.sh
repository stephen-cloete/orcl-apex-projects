#!/usr/bin/env bash
# Data Explorer - full install + smoke test. Run on the compute host that can
# reach the database.
#
# Required environment (read from stdin-fed env or exported by the caller;
# never pass passwords as command-line arguments):
#   DX_CONNECT          SQLcl connect string, e.g. the ADB TLS descriptor or
#                       a tnsnames alias (with TNS_ADMIN set)
#   DX_ADMIN_PASSWORD   ADB ADMIN password
#   DX_SCHEMA_PASSWORD  password for the DATAEXP schema (created/reset here)
# Optional:
#   DX_WORKSPACE        APEX workspace (default DATA_EXPLORER, created if missing)
#   DX_APP_ID           application id (default 220)
#   DX_ADMIN_USERS      comma-separated APEX users who may manage sources (default ADMIN)
#   DX_SQL              SQL client binary (default: sql, falls back to sqlplus)
#   DX_SKIP_APP=1       database only
#   DX_ONLY_TEST=1      run the smoke test only
set -euo pipefail
cd "$(dirname "$0")/.."
: "${DX_CONNECT:?set DX_CONNECT}" "${DX_ADMIN_PASSWORD:?set DX_ADMIN_PASSWORD}" "${DX_SCHEMA_PASSWORD:?set DX_SCHEMA_PASSWORD}"
WS=${DX_WORKSPACE:-DATA_EXPLORER}; APP=${DX_APP_ID:-220}; ADMINS=${DX_ADMIN_USERS:-ADMIN}
SQLBIN=${DX_SQL:-$(command -v sql || command -v sqlplus || true)}
[[ -n "$SQLBIN" ]] || { echo "SQLcl (sql) or sqlplus not found on PATH" >&2; exit 2; }
case "$DX_SCHEMA_PASSWORD" in *\"*|*\'*|*@*|*/*) echo "DATAEXP password must not contain quotes, @ or /" >&2; exit 2;; esac

run_as() { # $1=user $2=password $3=script (+args); password goes via stdin only
  local user=$1 pw=$2; shift 2
  "$SQLBIN" -S /nolog <<SQL
whenever sqlerror exit failure rollback
connect ${user}/"${pw}"@${DX_CONNECT}
$*
exit
SQL
}

if [[ "${DX_ONLY_TEST:-0}" == 1 ]]; then
  run_as DATAEXP "$DX_SCHEMA_PASSWORD" "@tests/smoke_test.sql $APP"; exit
fi
echo "== $(date '+%F %T %Z') Data Explorer install: workspace=$WS app=$APP"
echo "== 1/4 schema DATAEXP (as ADMIN)"
(cd database && run_as ADMIN "$DX_ADMIN_PASSWORD" "@00_admin_create_schema.sql \"$DX_SCHEMA_PASSWORD\" $WS")
echo "== 2/4 database objects (as DATAEXP)"
(cd database && run_as DATAEXP "$DX_SCHEMA_PASSWORD" "@install_db.sql \"$ADMINS\"")
if [[ "${DX_SKIP_APP:-0}" != 1 ]]; then
  echo "== 3/4 APEX application $APP (as ADMIN)"
  (cd apex && run_as ADMIN "$DX_ADMIN_PASSWORD" "@install_app.sql $WS $APP")
fi
echo "== 4/4 smoke test (as DATAEXP)"
run_as DATAEXP "$DX_SCHEMA_PASSWORD" "@tests/smoke_test.sql $APP"
echo "== done $(date '+%F %T %Z')"
