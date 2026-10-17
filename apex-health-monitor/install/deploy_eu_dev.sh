#!/usr/bin/env bash
# apex-health-monitor : deploy to EU DEV (APEXWORKS-DEV, eu-frankfurt-1) through eu-2-ha.
#
# All database traffic goes through the eu-2-ha compute instance (eu-webserver-ha-2):
# an SSH local forward from this machine via eu-2-ha to the ADB listener, so the
# database sees eu-2-ha's address.  Passwords come from the EU OCI Vault and are
# never printed.
#
# Prereqs: OCI CLI profile [EU]; SSH access to eu-2-ha (Bastion managed session or
# authorised key); SQLcl ("sql") on PATH.
#   EU_HA_SSH   ssh destination for eu-2-ha   (default: opc@92.5.101.47)
#   EU_HA_KEY   private key for eu-2-ha       (default: ~/.ssh/grokbot_eu_ha2)
set -euo pipefail
cd "$(dirname "$0")"

VAULT_ID=ocid1.vault.oc1.eu-frankfurt-1.envm4v7qaaggi.abtheljt7zjy4noltmqyvdg63jk6lcpkkoxjnqopyubc6z3ikuts7bxhgc6a
ADB_HOST=adb.eu-frankfurt-1.oraclecloud.com
SERVICE=sum3jolgpeajgmt_apexworksdev_low.adb.oraclecloud.com
LPORT=${LPORT:-15210}
EU_HA_SSH=${EU_HA_SSH:-opc@92.5.101.47}
EU_HA_KEY=${EU_HA_KEY:-$HOME/.ssh/grokbot_eu_ha2}

secret() {
  SUPPRESS_LABEL_WARNING=True oci --profile EU secrets secret-bundle get-secret-bundle-by-name \
    --vault-id "$VAULT_ID" --secret-name "$1" \
    --query 'data."secret-bundle-content".content' --raw-output | base64 -d
}

ssh -i "$EU_HA_KEY" -f -N -o ExitOnForwardFailure=yes -o BatchMode=yes \
    -L "$LPORT:$ADB_HOST:1521" "$EU_HA_SSH"
trap 'pkill -f "L $LPORT:$ADB_HOST:1521" || true' EXIT

CONN="(description=(address=(protocol=tcps)(port=$LPORT)(host=localhost))(connect_data=(service_name=$SERVICE))(security=(ssl_server_dn_match=no)))"
run() {  # run <user> <vault-secret> <sqlcl commands on stdin>
  local pw; pw=$(secret "$2")
  { echo "connect $1/\"$pw\"@\"$CONN\""; cat; echo exit; } | sql -S /nolog
}

SCHEMA_PW=$(secret apex-health-monitor-schema-password-eu-dev)
ADMIN_APP_PW=$(secret apex-health-monitor-admin-password-eu-dev)

echo "== 1/4 schema, grants, ACE, workspace (ADMIN)"
echo "@00_admin_setup.sql \"$SCHEMA_PW\" \"$ADMIN_APP_PW\"" | run ADMIN adb-healthcheck-admin-password-eu-dev
echo "== 2/4 tables, package, views, seed, jobs (HEALTH_MON)"
if [ "${FRESH:-N}" = "Y" ]; then echo "@uninstall.sql" | run HEALTH_MON apex-health-monitor-schema-password-eu-dev; fi
echo "@install_schema.sql" | run HEALTH_MON apex-health-monitor-schema-password-eu-dev
echo "== 3/4 APEX application 2600 (ADMIN)"
echo "@install_app.sql" | run ADMIN adb-healthcheck-admin-password-eu-dev
echo "== 4/4 tests (HEALTH_MON)"
echo "@../tests/test_hm_pkg.sql" | run HEALTH_MON apex-health-monitor-schema-password-eu-dev
