#!/bin/bash
# 04-ords-service.sh - install + start the ords systemd unit (127.0.0.1:$ORDS_HTTP_PORT).
. "$(dirname "$0")/lib/common.sh"; need_root; load_env
T="$(dirname "$0")/../templates/ords.service"
backup /etc/systemd/system/ords.service
sed -e "s#@ORDS_HOME@#$ORDS_HOME#g" -e "s#@ORDS_CONFIG@#$ORDS_CONFIG#g" -e "s#@ORDS_USER@#$ORDS_USER#g" \
    -e "s#@ORDS_HEAP_MB@#$ORDS_HEAP_MB#g" "$T" > /etc/systemd/system/ords.service
systemctl daemon-reload; systemctl enable -q ords; systemctl restart ords
log "waiting for ORDS on 127.0.0.1:$ORDS_HTTP_PORT"
for i in $(seq 1 60); do
  c=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "http://127.0.0.1:$ORDS_HTTP_PORT/ords/" || true)
  case "$c" in 2??|3??) ok "ORDS answering ($c) after $((i*5))s"; exit 0;; esac; sleep 5
done
journalctl -u ords -n 40 --no-pager; die "ORDS did not start"
