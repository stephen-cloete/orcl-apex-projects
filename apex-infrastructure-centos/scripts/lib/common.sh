#!/bin/bash
# Shared helpers for the apex-infrastructure-centos scripts.
set -euo pipefail
ENV_FILE="${ENV_FILE:-/etc/apex-ords/apex-ords.env}"
log()  { printf '\033[1;34m[%s]\033[0m %s\n' "$(date +%H:%M:%S)" "$*"; }
ok()   { printf '\033[1;32m  OK\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mFAIL\033[0m %s\n' "$*" >&2; exit 1; }
need_root() { [ "$(id -u)" -eq 0 ] || die "run as root (sudo $0)"; }
load_env() {
  [ -r "$ENV_FILE" ] || die "missing $ENV_FILE (copy scripts/apex-ords.env.example)"
  # shellcheck disable=SC1090
  . "$ENV_FILE"
}
el_major() { rpm -E '%{rhel}' 2>/dev/null || sed -n 's/^VERSION_ID="\?\([0-9]*\).*/\1/p' /etc/os-release; }
pkg() { if command -v dnf >/dev/null; then dnf -y -q install "$@"; else yum -y -q install "$@"; fi; }
# Backup a file once per run: /root/apex-ords-backup/<ts>/<path>
BACKUP_DIR="${BACKUP_DIR:-/root/apex-ords-backup/$(date +%Y%m%d-%H%M%S)}"
backup() { for f in "$@"; do [ -e "$f" ] || continue; mkdir -p "$BACKUP_DIR$(dirname "$f")"; cp -a "$f" "$BACKUP_DIR$f"; ok "backed up $f -> $BACKUP_DIR$f"; done; }
# Print the ORDS runtime password to stdout (never echo it to the terminal yourself).
runtime_password() {
  if [ -n "${ORDS_DB_PASSWORD_FILE:-}" ] && [ -r "$ORDS_DB_PASSWORD_FILE" ]; then cat "$ORDS_DB_PASSWORD_FILE"
  elif [ -n "${ORDS_DB_PASSWORD_OCI_SECRET:-}" ]; then
    oci secrets secret-bundle get --secret-id "$ORDS_DB_PASSWORD_OCI_SECRET" ${OCI_AUTH:+--auth $OCI_AUTH} \
      --query 'data."secret-bundle-content".content' --raw-output | base64 -d
  else read -r -s -p "Password for ${ORDS_RUNTIME_USER}: " p; echo >&2; printf '%s' "$p"; fi
}
