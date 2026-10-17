#!/bin/bash
# 06-smoke-test.sh - verify the APEX stack end to end. Exit code = number of failed checks.
#   sudo ./06-smoke-test.sh                 # on the host
#   ./06-smoke-test.sh --remote apex.example.com [IP]   # from anywhere (IP pins DNS, like curl --resolve)
set -uo pipefail
PASS=0; FAIL=0
t() { local name=$1; shift; if out=$("$@" 2>&1); then printf '  \033[32mPASS\033[0m %-44s %s\n' "$name" "$out"; PASS=$((PASS+1));
      else printf '  \033[31mFAIL\033[0m %-44s %s\n' "$name" "$out"; FAIL=$((FAIL+1)); fi; }
code() { curl -sk -o /dev/null -w '%{http_code}' --max-time 30 "${RES[@]}" "$@"; }
expect() { local want=$1; shift; local c; c=$(code "$@"); echo "HTTP $c"; [[ "$c" =~ ^($want)$ ]]; }

if [ "${1:-}" = --remote ]; then
  NAME=$2; IP=${3:-}; RES=(); [ -n "$IP" ] && RES=(--resolve "$NAME:443:$IP" --resolve "$NAME:80:$IP")
  ENV_FILE=/dev/null; APEX_VERSION=${APEX_VERSION:-}
else
  ENV_FILE="${ENV_FILE:-/etc/apex-ords/apex-ords.env}"
  # shellcheck disable=SC1090
  . "$ENV_FILE"; NAME=$APEX_SERVER_NAME
  RES=(--resolve "$NAME:443:127.0.0.1" --resolve "$NAME:80:127.0.0.1")
  echo "== host checks"
  t "java >= 17"                    bash -c 'java -version 2>&1 | head -1 | grep -E "\"(1[7-9]|2[0-9])"'
  t "ords binary"                   bash -c "$ORDS_HOME/bin/ords --version 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+[.0-9]*' | head -1 | grep ."
  t "ords.service active"           systemctl is-active ords
  t "ords bound to loopback only"   bash -c "ss -ltn | awk '{print \$4}' | grep -E ':${ORDS_HTTP_PORT}\$' | grep -v -E '^(0\.0\.0\.0|\*|\[::\]):' "
  t "ORDS direct 127.0.0.1:${ORDS_HTTP_PORT}"  expect '2..|3..' "http://127.0.0.1:${ORDS_HTTP_PORT}/ords/"
  t "nginx config valid"            bash -c 'nginx -t 2>&1 | grep -q successful && echo valid'
  t "ords.log has no pool errors"   bash -c "! journalctl -u ords --since -15min --no-pager 2>/dev/null | grep -E 'ORA-[0-9]+|pool.*(not|invalid)' | tail -3 | grep ."
fi
B="https://$NAME"
echo "== web checks ($B)"
t "nginx /health"                   expect 200 "$B/health"
t "http -> https redirect"          expect 301 "http://$NAME/ords/"
t "TLS handshake (1.2+)"            bash -c "curl -sk ${RES[*]} -o /dev/null -w '%{ssl_verify_result} ok' --tlsv1.2 --max-time 20 $B/health"
t "ORDS landing /ords/"             expect '2..|3..' "$B/ords/"
t "APEX sign-in page renders"       bash -c "curl -skL ${RES[*]} --max-time 60 '$B/ords/r/apex/workspace-sign-in/oauth2/' | grep -Eio 'Oracle APEX|apex_ui|Sign In' | sort -u | tr '\n' ' ' | grep -i apex"
t "APEX f?p=4550 (App Builder login)" expect '2..|3..' "$B/ords/f?p=4550:1"
V=${APEX_VERSION:-$(curl -skL "${RES[@]}" --max-time 60 "$B/ords/r/apex/workspace-sign-in/oauth2/" | grep -Eo '/i/[0-9]+\.[0-9]+\.[0-9]+/' | head -1 | tr -d /i)}
t "static /i/${V}/ Core CSS"        expect 200 "$B/i/${V}/apex_ui/css/Core.min.css"
t "static /i/${V}/ desktop JS"      expect 200 "$B/i/${V}/libraries/apex/minified/desktop_all.min.js"
t "no server version leak"          bash -c "! curl -skI ${RES[*]} --max-time 20 $B/health | grep -Ei '^server: .*[0-9]' "
echo "== result: $PASS passed, $FAIL failed"
exit $FAIL
