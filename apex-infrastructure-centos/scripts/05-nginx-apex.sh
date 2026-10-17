#!/bin/bash
# 05-nginx-apex.sh - add ONE nginx vhost for APEX ($APEX_SERVER_NAME). Existing vhosts are untouched;
# the new file is validated with "nginx -t" and rolled back automatically if the test fails.
. "$(dirname "$0")/lib/common.sh"; need_root; load_env
command -v nginx >/dev/null || { [ "$(el_major)" = 7 ] && pkg oracle-epel-release-el7 >/dev/null 2>&1 || true; pkg nginx; systemctl enable -q nginx; }
CONF=/etc/nginx/conf.d/apex-ords-${APEX_SERVER_NAME}.conf
UP=$(echo "$APEX_SERVER_NAME" | tr -c 'a-zA-Z0-9\n' '_')
backup /etc/nginx/nginx.conf "$CONF"

if [ -z "${TLS_CERT}" ]; then
  TLS_CERT=/etc/nginx/ssl/${APEX_SERVER_NAME}.crt; TLS_KEY=/etc/nginx/ssl/${APEX_SERVER_NAME}.key
  if [ ! -s "$TLS_CERT" ]; then
    install -d -m 0755 /etc/nginx/ssl
    openssl req -x509 -nodes -newkey rsa:2048 -days 825 -subj "/CN=${APEX_SERVER_NAME}" \
      -keyout "$TLS_KEY" -out "$TLS_CERT" >/dev/null 2>&1
    [ -n "$(openssl x509 -in "$TLS_CERT" -noout -subject 2>/dev/null)" ] || die "cert generation failed"
    chmod 600 "$TLS_KEY"; ok "self-signed cert for ${APEX_SERVER_NAME} (replace with a real/origin cert)"
  fi
fi

if [ "$APEX_IMAGES_MODE" = cdn ]; then
  IMG="    location /i/ {
        proxy_pass https://static.oracle.com/cdn/apex/${APEX_VERSION}/;
        proxy_set_header Host static.oracle.com;
        proxy_ssl_server_name on;
        expires 7d;
    }
    location /i/${APEX_VERSION}/ {
        proxy_pass https://static.oracle.com/cdn/apex/${APEX_VERSION}/;
        proxy_set_header Host static.oracle.com;
        proxy_ssl_server_name on;
        expires 7d;
    }"
else
  [ -d "$APEX_IMAGES_DIR" ] || die "APEX_IMAGES_DIR $APEX_IMAGES_DIR missing (unzip apex_*.zip and copy apex/images there)"
  IMG="    location /i/${APEX_VERSION}/ { alias ${APEX_IMAGES_DIR}/; expires 7d; }
    location /i/ { alias ${APEX_IMAGES_DIR}/; expires 7d; }"
fi
TMPL="$(dirname "$0")/../templates/nginx-apex.conf.template"
export IMG
awk '{ if ($0 ~ /@IMAGES_BLOCK@/) print ENVIRON["IMG"]; else print }' "$TMPL" | sed -e "s#@SERVER_NAME@#${APEX_SERVER_NAME}#g" \
  -e "s#@UPSTREAM@#${UP}#g" -e "s#@ORDS_PORT@#${ORDS_HTTP_PORT}#g" -e "s#@TLS_CERT@#${TLS_CERT}#g" -e "s#@TLS_KEY@#${TLS_KEY}#g" > "$CONF"
if nginx -t 2>/tmp/nginx-t.log; then systemctl reload nginx; ok "nginx reloaded with $CONF"
else cat /tmp/nginx-t.log; rm -f "$CONF"; [ -e "$BACKUP_DIR$CONF" ] && cp -a "$BACKUP_DIR$CONF" "$CONF"; die "nginx -t failed; new vhost removed, nginx NOT reloaded"; fi
