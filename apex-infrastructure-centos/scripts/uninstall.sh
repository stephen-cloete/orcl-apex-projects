#!/bin/bash
# uninstall.sh - remove what these scripts added (ords service, ORDS product+config, APEX nginx vhost).
# Java, nginx itself and other vhosts are left alone. DB users: run sql/adb-remove-customer-managed-ords.sql.
. "$(dirname "$0")/lib/common.sh"; need_root; load_env
backup "$ORDS_CONFIG" /etc/systemd/system/ords.service "/etc/nginx/conf.d/apex-ords-${APEX_SERVER_NAME}.conf"
systemctl disable --now ords 2>/dev/null || true; rm -f /etc/systemd/system/ords.service; systemctl daemon-reload
rm -f "/etc/nginx/conf.d/apex-ords-${APEX_SERVER_NAME}.conf"
nginx -t 2>/dev/null && systemctl reload nginx
rm -rf "$ORDS_HOME" "$ORDS_HOME.prev" "$ORDS_CONFIG" /usr/local/bin/ords
ok "removed (backup in $BACKUP_DIR)"
