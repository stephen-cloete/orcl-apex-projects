#!/usr/bin/env python3
"""Run a SQL/PLSQL script on an Oracle database through ORDS REST-enabled SQL (/ords/<user>/_/sql).
Usage: ords_sql.py file.sql|- [--raw]
Config (environment): ADB_ORDS_URL  base URL of the ORDS host, e.g. https://<host>
                      DB_USER       REST-enabled database user (default ADMIN)
                      DB_PASSWORD   its password; prompted for when unset. Never printed or stored."""
import sys, json, base64, urllib.request, os, argparse, getpass
ap = argparse.ArgumentParser(); ap.add_argument("file", nargs="?", default="-"); ap.add_argument("--raw", action="store_true")
a = ap.parse_args()
base = os.environ.get("ADB_ORDS_URL") or sys.exit("set ADB_ORDS_URL (e.g. https://<host>)")
user = os.environ.get("DB_USER", "ADMIN")
pw = os.environ.get("DB_PASSWORD") or getpass.getpass(f"{user} password: ")
src = sys.stdin.read() if a.file == "-" else open(a.file).read()
body = json.dumps({"statementText": src, "limit": 5000}).encode()
req = urllib.request.Request(f"{base.rstrip('/')}/ords/{user.lower()}/_/sql", data=body, headers={"Content-Type": "application/json",
      "Authorization": "Basic " + base64.b64encode(f"{user}:{pw}".encode()).decode()})
try: d = json.load(urllib.request.urlopen(req, timeout=900))
except urllib.error.HTTPError as e: print("HTTP", e.code, e.read()[:500].decode(errors="replace")); sys.exit(1)
err = 0
for it in d.get("items", []):
    if a.raw: print(json.dumps(it)); continue
    st = it.get("statementText", "")[:90].replace("\n", " ")
    if "errorCode" in it or "errorMessage" in it:
        err += 1; print(f"ERR [{st}] {it.get('errorCode')} {it.get('errorMessage')}"); continue
    rs = it.get("resultSet")
    if rs:
        for r in rs.get("items", []): print(" | ".join(f"{k}={v}" for k, v in r.items()))
    else:
        resp = it.get("response") or []
        print(f"OK [{st}] {' '.join(x.strip() for x in resp)[:300]}")
sys.exit(1 if err else 0)
