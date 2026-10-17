#!/usr/bin/env bash
# apex-health-monitor : deploy / upgrade and test, driven only by environment variables.
#
# Optionally tunnels the database connection through an SSH jump host (so the
# database sees the jump host's address).  Passwords are read from environment
# variables; never commit them.
#
# Required
#   ADB_HOST            database listener host        e.g. adb.<region>.oraclecloud.com
#   ADB_SERVICE         database service name         e.g. <dbname>_low.adb.oraclecloud.com
#   DBA_USER            DBA account used for 00_admin_setup.sql / install_app.sql
#   DBA_PASSWORD        its password                  (from your secret store)
#   SCHEMA_PASSWORD     HEALTH_MON schema password    (from your secret store)
#   APP_ADMIN_USER      APEX workspace admin user name
#   APP_ADMIN_PASSWORD  its password                  (from your secret store)
# Optional
#   ADB_PORT            listener port (default 1521)
#   JUMP_HOST           ssh destination to tunnel through, e.g. opc@203.0.113.10 (documentation example)
#   JUMP_KEY            ssh private key for JUMP_HOST
#   LPORT               local tunnel port (default 15210)
#   FRESH=Y             drop and rebuild the schema objects (use for a first install)
set -euo pipefail
cd "$(dirname "$0")"

: "${ADB_HOST:?set ADB_HOST}" "${ADB_SERVICE:?set ADB_SERVICE}" "${DBA_USER:?set DBA_USER}"
: "${DBA_PASSWORD:?set DBA_PASSWORD}" "${SCHEMA_PASSWORD:?set SCHEMA_PASSWORD}"
: "${APP_ADMIN_USER:?set APP_ADMIN_USER}" "${APP_ADMIN_PASSWORD:?set APP_ADMIN_PASSWORD}"
ADB_PORT=${ADB_PORT:-1521}
LPORT=${LPORT:-15210}

if [ -n "${JUMP_HOST:-}" ]; then
  ssh ${JUMP_KEY:+-i "$JUMP_KEY"} -f -N -o ExitOnForwardFailure=yes -o BatchMode=yes \
      -L "$LPORT:$ADB_HOST:$ADB_PORT" "$JUMP_HOST"
  trap 'pkill -f "L $LPORT:$ADB_HOST:$ADB_PORT" || true' EXIT
  HOST=localhost; PORT=$LPORT; DN=no
else
  HOST=$ADB_HOST; PORT=$ADB_PORT; DN=yes
fi
CONN="(description=(address=(protocol=tcps)(port=$PORT)(host=$HOST))(connect_data=(service_name=$ADB_SERVICE))(security=(ssl_server_dn_match=$DN)))"

run() {  # run <user> <password> ; sqlcl commands on stdin
  { echo "connect $1/\"$2\"@\"$CONN\""; cat; echo exit; } | sql -S /nolog
}

echo "== 1/4 schema, grants, ACE, workspace (DBA)"
echo "@00_admin_setup.sql \"$SCHEMA_PASSWORD\" \"$APP_ADMIN_PASSWORD\" \"$APP_ADMIN_USER\"" | run "$DBA_USER" "$DBA_PASSWORD"
echo "== 2/4 tables, package, views, seed, jobs (HEALTH_MON)"
if [ "${FRESH:-N}" = "Y" ]; then
  echo "@uninstall.sql"      | run HEALTH_MON "$SCHEMA_PASSWORD"
  echo "@install_schema.sql" | run HEALTH_MON "$SCHEMA_PASSWORD"
else
  echo "@upgrade_1_1.sql"    | run HEALTH_MON "$SCHEMA_PASSWORD"
  echo "@upgrade_1_2.sql"    | run HEALTH_MON "$SCHEMA_PASSWORD"
fi
for f in targets.local.sql settings.local.sql; do
  if [ -f "$f" ]; then echo "@$f" | run HEALTH_MON "$SCHEMA_PASSWORD"; fi
done
echo "== 3/4 APEX application 2600 (DBA)"
echo "@install_app.sql" | run "$DBA_USER" "$DBA_PASSWORD"
echo "== 4/4 tests (HEALTH_MON)"
echo "@../tests/test_hm_pkg.sql" | run HEALTH_MON "$SCHEMA_PASSWORD"
