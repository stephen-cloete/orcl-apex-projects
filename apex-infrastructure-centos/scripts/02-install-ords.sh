#!/bin/bash
# 02-install-ords.sh - download + unpack the latest ORDS into $ORDS_HOME (previous copy kept as .prev).
. "$(dirname "$0")/lib/common.sh"; need_root; load_env
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
log "downloading $ORDS_URL"
curl -fsSL --retry 3 --max-time 900 -o "$TMP/ords.zip" "$ORDS_URL"
unzip -tq "$TMP/ords.zip" >/dev/null || die "ORDS zip failed integrity test"
sha256sum "$TMP/ords.zip" | awk '{print "  sha256 " $1}'
if [ -x "$ORDS_HOME/bin/ords" ]; then rm -rf "$ORDS_HOME.prev"; cp -a "$ORDS_HOME" "$ORDS_HOME.prev"; ok "previous ORDS kept in $ORDS_HOME.prev"; fi
find "$ORDS_HOME" -mindepth 1 -delete
unzip -q "$TMP/ords.zip" -d "$ORDS_HOME"
chmod 0755 "$ORDS_HOME/bin/ords"
ln -sfn "$ORDS_HOME/bin/ords" /usr/local/bin/ords
ok "installed $("$ORDS_HOME/bin/ords" --version 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9.]+' | head -1)"
