# apex-infrastructure-centos

Run **Oracle APEX on your own CentOS / Oracle Linux host**: ORDS (standalone) behind nginx, talking to
an **Autonomous Database** or a local **Oracle Database 23ai Free**. Started in 2018 as a CentOS 7 +
18c XE + Tomcat + httpd guide; brought up to date for 2026 with scripts you can actually run.

| File | Purpose |
|---|---|
| [install-guide.md](install-guide.md) | current step-by-step guide (architecture, ADB or 23ai Free, ORDS, nginx, verification, operations) |
| [scripts/](scripts) | `install-all.sh` + numbered steps `01`..`06`, `uninstall.sh`, `apex-ords.env.example` (no secrets) |
| [sql/](sql) | ADB customer-managed ORDS users: create (idempotent), verify, remove |
| [templates/](templates) | `ords.service` (systemd) and `nginx-apex.conf.template` |
| [cloud-init/](cloud-init) | unattended install on a new cloud VM |
| [additional-applications.md](additional-applications.md) | Glances + InfluxDB + Grafana host monitoring (with 2026 notes) |
| [legacy-centos7-install-guide.md](legacy-centos7-install-guide.md) | the original 2018 guide, kept for reference |

## Quick start

```bash
sudo cp scripts/apex-ords.env.example /etc/apex-ords/apex-ords.env && sudo vi /etc/apex-ords/apex-ords.env
sql admin@mydb_low @sql/adb-customer-managed-ords.sql ORDS_PUBLIC_USER2 ORDS_PLSQL_GATEWAY2   # ADB only
sudo ./scripts/install-all.sh
```

## Design choices

* **Lightweight**: no Tomcat, no AJP, no 400 MB images copy (APEX CDN through nginx), ORDS heap 320 MB, aimed at small (about 1 GB) VMs.
* **Safe on a shared web server**: ORDS binds to `127.0.0.1`; nginx gets one extra `server_name`; every changed file is backed up and `nginx -t` gates the reload.
* **No secrets in config or git**: the ORDS runtime password comes from a root-only file, OCI Vault, or a hidden prompt and is stored only in the ORDS wallet.
* **Doesn't touch ADB settings** shared with the built-in ORDS (`IMAGE_PREFIX` stays as it is).

## Status

Static checks only: `bash -n` and `shellcheck -S warning` on all scripts, cloud-init YAML parse,
nginx template reviewed. Not run against a live system in this change, by request: try it on a
throw-away VM first and run `scripts/06-smoke-test.sh` after installing.
