#!/bin/bash
# 03-configure-ords.sh - write the ORDS pool config.
#   DB_TYPE=adb   -> customer-managed ORDS against Autonomous Database (run sql/adb-customer-managed-ords.sql first)
#   DB_TYPE=local -> "ords install" into a local/on-prem DB (installs/upgrades the ORDS schema; prompts for SYS)
. "$(dirname "$0")/lib/common.sh"; need_root; load_env
O() { (cd /tmp && sudo -u "$ORDS_USER" -H env _JAVA_OPTIONS="$_JAVA_OPTIONS" "$ORDS_HOME/bin/ords" --config "$ORDS_CONFIG" "$@"); }
[ -d "$ORDS_CONFIG/global" ] && backup "$ORDS_CONFIG/global/settings.xml" "$ORDS_CONFIG/databases/default/pool.xml"

if [ "$DB_TYPE" = adb ]; then
  O config set db.connectionType customurl >/dev/null
  O config set db.customURL "$DB_CUSTOM_URL" >/dev/null
  O config set db.username "$ORDS_RUNTIME_USER" >/dev/null
  runtime_password | O config secret --password-stdin db.password >/dev/null
  O config set plsql.gateway.mode proxied >/dev/null
elif [ "$DB_TYPE" = local ]; then
  log "running ords install against $DB_HOST:$DB_PORT/$DB_SERVICE (you will be asked for SYS + ORDS_PUBLIC_USER passwords)"
  O install --admin-user SYS --db-hostname "$DB_HOST" --db-port "$DB_PORT" --db-servicename "$DB_SERVICE" \
     --feature-sdw true --feature-db-api true --gateway-mode proxied --gateway-user APEX_PUBLIC_USER --log-folder /var/log/ords
else die "DB_TYPE must be adb or local"; fi

# Standalone (Jetty) listener: loopback only, nginx terminates TLS in front.
O config set standalone.http.port "$ORDS_HTTP_PORT" >/dev/null
O config set standalone.binds 127.0.0.1 >/dev/null
O config set security.httpsHeaderCheck "X-Forwarded-Proto: https" >/dev/null   # APEX REQUIRE_HTTPS works behind the proxy
O config set standalone.access.log /var/log/ords >/dev/null
# Lightweight pool for small hosts; raise for production traffic.
O config set jdbc.InitialLimit 2 >/dev/null
O config set jdbc.MinLimit 2 >/dev/null
O config set jdbc.MaxLimit 15 >/dev/null
# Keep the attack surface small on an APEX-only listener.
O config set feature.sdw false >/dev/null
O config set restEnabledSql.active false >/dev/null
O config set database.api.enabled false >/dev/null
ok "ORDS configured in $ORDS_CONFIG"
O config list 2>/dev/null | grep -Ev 'password|secret' | sed -n '1,60p'
