#!/usr/bin/env python3
"""Run SQL/PLSQL on EU DEV ADB (APEXWORKS-DEV, eu-frankfurt-1) via ORDS REST-enabled SQL.
Usage: eu_sql.py file.sql|- [--user ADMIN] [--raw]. Password comes from $EU_DB_PASSWORD or the EU OCI Vault (eu-oci-vault-secret); never printed or stored."""
import sys, json, subprocess, base64, urllib.request, os, argparse
H = "https://sum3jolgpeajgmt-apexworksdev.adb.eu-frankfurt-1.oraclecloudapps.com/ords/{schema}/_/sql"
ap = argparse.ArgumentParser(); ap.add_argument("file", nargs="?", default="-"); ap.add_argument("--user", default="ADMIN")
ap.add_argument("--secret", default="adb-healthcheck-admin-password-eu-dev"); ap.add_argument("--raw", action="store_true")
a = ap.parse_args()
pw = os.environ.get("EU_DB_PASSWORD") or subprocess.run(["eu-oci-vault-secret", a.secret], capture_output=True, text=True, check=True).stdout
if pw.startswith("{"): pw = json.loads(pw)["password"]
src = sys.stdin.read() if a.file == "-" else open(a.file).read()
body = json.dumps({"statementText": src, "limit": 5000}).encode()
req = urllib.request.Request(H.format(schema=a.user.lower()), data=body, headers={"Content-Type": "application/json",
      "Authorization": "Basic " + base64.b64encode(f"{a.user}:{pw}".encode()).decode()})
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
