#!/bin/bash
# 01-host-prereqs.sh - Java 21 runtime, ORDS OS user, directories, firewall.
# Safe to re-run. Does not touch existing web/app services.
. "$(dirname "$0")/lib/common.sh"; need_root; load_env
EL=$(el_major); log "Enterprise Linux major version: $EL"

if ! command -v java >/dev/null || ! java -version 2>&1 | grep -Eq 'version "(1[7-9]|2[0-9])'; then
  if [ -z "${JAVA_PKG}" ]; then
    if [ "$EL" = 7 ]; then JAVA_PKG=jdk-21-headful            # Oracle JDK 21 (ol7_oci_included / ol7_latest on OCI)
    else JAVA_PKG=java-21-openjdk-headless; fi                # EL8 / EL9 AppStream
  fi
  log "installing $JAVA_PKG"; pkg "$JAVA_PKG"
fi
java -version 2>&1 | head -1 | sed 's/^/  java: /'
pkg unzip curl openssl >/dev/null 2>&1 || true

id "$ORDS_USER" >/dev/null 2>&1 || { useradd -r -m -d /home/"$ORDS_USER" -s /sbin/nologin "$ORDS_USER"; ok "created user $ORDS_USER"; }
install -d -m 0755 "$ORDS_HOME"
install -d -m 0750 -o "$ORDS_USER" -g "$ORDS_USER" "$ORDS_CONFIG" /var/log/ords
install -d -m 0700 /etc/apex-ords

# ORDS listens on 127.0.0.1 only; nginx is the public face. Only 80/443 are opened.
if systemctl is-active -q firewalld; then
  for s in http https; do firewall-cmd -q --permanent --add-service=$s; done; firewall-cmd -q --reload
  ok "firewalld allows http/https (ORDS port ${ORDS_HTTP_PORT} stays local)"
fi
# SELinux: allow nginx to proxy to the local ORDS port.
if command -v getenforce >/dev/null && [ "$(getenforce)" != Disabled ]; then
  setsebool -P httpd_can_network_connect 1 && ok "SELinux httpd_can_network_connect=on"
fi
ok "prerequisites done"
