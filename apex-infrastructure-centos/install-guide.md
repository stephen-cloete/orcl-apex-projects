# Installing Oracle APEX on CentOS / Oracle Linux (2026 edition)

Step-by-step guide to running **Oracle APEX** on your own Enterprise Linux machine (CentOS Stream,
Oracle Linux, Rocky or Alma Linux 7/8/9), with **ORDS** as the APEX listener and **nginx** as the
web tier. The database can be either an **Oracle Autonomous Database** (recommended, APEX is
pre-installed and patched for you) or a **local Oracle Database 23ai Free**.

> The original 2018 guide (CentOS 7 + 18c XE in Docker + Tomcat 9 + Apache httpd/AJP) is kept,
> unchanged, in [legacy-centos7-install-guide.md](legacy-centos7-install-guide.md).
> What changed since then: CentOS 7 and Java 8 are end of life, ORDS no longer ships as a
> `ords.war` you deploy with `java -jar ords.war install`, Tomcat/AJP is not needed (ORDS has
> its own Jetty server), and APEX static files can be served from Oracle's CDN.

## 1. Architecture

```
 browser ──HTTPS──▶ nginx :443  ──┬── /i/*     ──▶ static.oracle.com/cdn/apex/<ver>/  (or local images dir)
                  (TLS, gzip,     └── /ords/*  ──▶ ORDS standalone 127.0.0.1:8080 (Jetty, systemd "ords")
                   security hdrs)                         │ JDBC (TCPS 1521)
                                                          ▼
                                   Autonomous Database (APEX 26.1)  -or-  Oracle Database 23ai Free
```

| Component | Version tested | Notes |
|---|---|---|
| OS | Oracle Linux 7.9 (OCI `VM.Standard.E2.1.Micro`, 1 GB) | scripts also handle EL8/EL9 (`dnf`) |
| Java | Oracle JDK 21 (`jdk-21-headful`, EL7) / `java-21-openjdk-headless` (EL8/9) | ORDS 25+ needs Java 17 or 21 |
| ORDS | latest (`ords-latest.zip`, 26.x) | standalone mode, loopback only |
| APEX | 26.1.5 (on ADB) | static files from the APEX CDN |
| Database | Autonomous Database 26ai (Always Free) | customer-managed ORDS, TLS (no wallet) |
| Web tier | nginx 1.20 (EL7 EPEL) / 1.2x (EL8/9) | one extra vhost, existing sites untouched |

## 2. Quick start (scripted)

```bash
git clone https://github.com/stephen-cloete/orcl-apex-projects.git
cd orcl-apex-projects/apex-infrastructure-centos
sudo install -d -m 700 /etc/apex-ords
sudo cp scripts/apex-ords.env.example /etc/apex-ords/apex-ords.env
sudo vi /etc/apex-ords/apex-ords.env          # DB_CUSTOM_URL, APEX_SERVER_NAME, APEX_VERSION, ...
# ADB only, once, as ADMIN (prompts for the new runtime password):
sql admin@mydb_low @sql/adb-customer-managed-ords.sql ORDS_PUBLIC_USER2 ORDS_PLSQL_GATEWAY2
sudo ./scripts/install-all.sh                 # 01..05 then the smoke test
```

Each step can be run on its own and is safe to re-run:

| Script | What it does |
|---|---|
| `scripts/01-host-prereqs.sh` | Java 21, `ords` OS user, `/opt/oracle/ords`, `/etc/ords/config`, firewalld http/https, SELinux `httpd_can_network_connect` |
| `scripts/02-install-ords.sh` | downloads `ords-latest.zip`, integrity-tests it, keeps the previous install as `.prev` |
| `scripts/03-configure-ords.sh` | writes the pool config (ADB `customurl` or `ords install` for a local DB), stores the password in the ORDS wallet, binds to 127.0.0.1, honours `X-Forwarded-Proto` |
| `scripts/04-ords-service.sh` | renders `templates/ords.service` (small heap, hardening) and waits for ORDS |
| `scripts/05-nginx-apex.sh` | adds **one** vhost from `templates/nginx-apex.conf.template`, self-signed cert if none given, `nginx -t` before reload with automatic rollback |
| `scripts/06-smoke-test.sh` | 15+ checks: service, loopback bind, ORDS, TLS, redirect, APEX sign-in page, App Builder, static files; `--remote host [ip]` mode |
| `scripts/uninstall.sh` | removes only what the scripts added (backups first) |
| `cloud-init/apex-ords-nginx.yaml` | the same, unattended, for a new OCI/cloud VM (password via OCI Vault + instance principal) |

Every file the scripts change is copied first to `/root/apex-ords-backup/<timestamp>/`.
No password is ever written to the env file, the repo, or the terminal: it comes from a root-only
file, OCI Vault (`ORDS_DB_PASSWORD_OCI_SECRET`) or a hidden prompt, and ends up only in the
ORDS credentials wallet.

## 3. Manual walk-through

### 3.1 Host

```bash
sudo dnf -y install java-21-openjdk-headless nginx unzip      # EL7: sudo yum -y install jdk-21-headful nginx unzip
sudo useradd -r -m -s /sbin/nologin ords
sudo install -d -m 755 /opt/oracle/ords
sudo install -d -m 750 -o ords -g ords /etc/ords/config /var/log/ords
sudo firewall-cmd --permanent --add-service={http,https} && sudo firewall-cmd --reload
sudo setsebool -P httpd_can_network_connect 1                 # nginx -> 127.0.0.1:8080
```

Small hosts: ORDS runs fine on a 1 GB VM with `-Xmx320m` and `-XX:+UseSerialGC` if some swap exists.

### 3.2 Database option A: Autonomous Database (recommended)

APEX and ORDS are already installed in ADB. A self-hosted ORDS ("customer-managed ORDS") only needs
its own runtime user and PL/SQL gateway user. As `ADMIN`:

```sql
create user ORDS_PUBLIC_USER2 identified by "<strong password>";
create user ORDS_PLSQL_GATEWAY2 no authentication;
grant connect to ORDS_PUBLIC_USER2;
grant connect to ORDS_PLSQL_GATEWAY2;
alter user ORDS_PLSQL_GATEWAY2 grant connect through ORDS_PUBLIC_USER2;
begin
  ords_admin.provision_runtime_role(p_user => 'ORDS_PUBLIC_USER2', p_proxy_enabled_schemas => true);
  ords_admin.config_plsql_gateway(p_runtime_user => 'ORDS_PUBLIC_USER2', p_plsql_gateway_user => 'ORDS_PLSQL_GATEWAY2');
end;
/
```

(`sql/adb-customer-managed-ords.sql` does this idempotently and prompts for the password;
`sql/adb-verify.sql` checks it; `sql/adb-remove-customer-managed-ords.sql` undoes it.)

Network: the host must reach the ADB on TCP 1521. Either add the host's VCN/subnet or public IP to
the ADB access control list, or use a private endpoint. If the ADB does not require mutual TLS
you only need the TLS connect string, no wallet.

Do **not** change the ADB `IMAGE_PREFIX`: it is shared with the ADB's own ORDS. Instead nginx serves
`/i/<version>/` (see 3.5).

### 3.3 Database option B: local Oracle Database 23ai Free

The 18c XE + Docker route from 2018 is replaced by **Oracle Database 23ai Free** (RPM for EL8/9,
or the `container-registry.oracle.com/database/free` image):

```bash
sudo dnf -y install oracle-database-preinstall-23ai
sudo dnf -y localinstall oracle-ai-database-free-23ai-*.el8.x86_64.rpm   # from oracle.com/database/free
sudo /etc/init.d/oracle-free-23ai configure
```

Install APEX into `FREEPDB1` (download `apex-latest.zip` from oracle.com/apex):

```bash
unzip apex-latest.zip && cd apex
sql sys@localhost:1521/FREEPDB1 as sysdba @apexins.sql SYSAUX SYSAUX TEMP /i/
sql sys@localhost:1521/FREEPDB1 as sysdba @apex_rest_config.sql
sudo mkdir -p /var/www/apex && sudo cp -a images /var/www/apex/        # or use APEX_IMAGES_MODE=cdn
```

Then set `DB_TYPE=local`, `DB_SERVICE=FREEPDB1` and `APEX_IMAGES_MODE=local` in the env file;
`03-configure-ords.sh` runs `ords install` (it asks for the SYS password and creates/updates the
ORDS schema and `ORDS_PUBLIC_USER`).

### 3.4 ORDS (standalone, behind nginx)

```bash
cd /opt/oracle/ords && sudo curl -fLO https://download.oracle.com/otn_software/java/ords/ords-latest.zip
sudo unzip -q ords-latest.zip && sudo rm ords-latest.zip
export ORDS_CONFIG=/etc/ords/config
ords config set db.connectionType customurl
ords config set db.customURL 'jdbc:oracle:thin:@(description=...)'
ords config set db.username ORDS_PUBLIC_USER2
ords config secret --password-stdin db.password < /root/ords_runtime.pw
ords config set plsql.gateway.mode proxied
ords config set standalone.http.port 8080
ords config set standalone.binds 127.0.0.1
ords config set security.httpsHeaderCheck "X-Forwarded-Proto: https"
ords config set feature.sdw false
```

`security.httpsHeaderCheck` matters: APEX's *Require HTTPS* setting (on ADB it is `A`) only
works behind a TLS-terminating proxy if ORDS trusts `X-Forwarded-Proto`.

Run it with systemd (`templates/ords.service`): `sudo systemctl enable --now ords`.

### 3.5 nginx

`templates/nginx-apex.conf.template` (rendered by `05-nginx-apex.sh`) gives you: HTTP→HTTPS redirect,
TLS 1.2/1.3, `/health`, `/i/` and `/i/<version>/` proxied to `https://static.oracle.com/cdn/apex/<version>/`
(or `alias` to a local images directory), and `/ords/` proxied to `127.0.0.1:8080` with keep-alive,
`X-Forwarded-*` headers and 50 MB uploads. It is a separate `server_name`, so other sites on the
same nginx keep working.

### 3.6 Verify

```bash
sudo ./scripts/06-smoke-test.sh                                  # on the host
./scripts/06-smoke-test.sh --remote apex.example.com 203.0.113.10  # from your laptop, before DNS exists
```

Then open `https://<APEX_SERVER_NAME>/ords/r/<workspace>/<app-alias>/` (or `/ords/f?p=<app>:1`) and
sign in with an APEX account of that workspace.

### 3.7 Things that bite (found while testing on a 1 GB Always Free VM + ADB 26ai)

* **Heap for the `ords` CLI, not only the service.** On a ~700 MB host the JVM's default heap
  (1/4 of RAM) is too small and even `ords --version` dies with `OutOfMemoryError: Java heap space`.
  The scripts export `_JAVA_OPTIONS="-Xmx320m -XX:+UseSerialGC"` for every CLI call and the service.
  Each CLI call still takes ~20 s on such a host; ORDS itself needs ~60 s to start and ~350 MB RSS.
* **App Builder / workspace sign-in on ADB.** ADB sets `APEX_BUILDER_AUTHENTICATION=ADB`, which signs
  developers in through the ADB-managed ORDS single sign-on endpoint (`/ords/_sso/...`). A
  customer-managed ORDS does not provide that endpoint, so on this path **your applications work**
  (public pages, *Oracle APEX Accounts* / social / custom authentication), but App Builder and the
  workspace sign-in return 404. Keep using the ADB's own APEX URL for development, or (only if this
  ORDS is the sole entry point) change the instance's builder authentication. Turning on
  `feature.sdw` does not help.
* **`X-Forwarded-Proto`.** Without `security.httpsHeaderCheck` APEX on ADB (`REQUIRE_HTTPS=A`) loops or
  refuses sessions behind nginx.
* **`IMAGE_PREFIX` on ADB is `/i/<version>/`.** nginx must answer `/i/<version>/...`; the CDN proxy
  in the template does that without touching the ADB setting.
* **DB network ACL.** The host (its public IP, or its VCN) must be in the ADB access control list, or
  the pool shows `ORA-12506`/timeouts in `journalctl -u ords`.

## 4. Operations

* **Upgrade ORDS**: `sudo ./scripts/02-install-ords.sh && sudo systemctl restart ords` (config is separate, old binaries in `/opt/oracle/ords.prev`).
* **APEX patch on ADB**: Oracle patches APEX; set `APEX_VERSION` to the new version and re-run `05-nginx-apex.sh` so `/i/<version>/` follows.
* **Logs**: `journalctl -u ords`, `/var/log/ords/`, `/var/log/nginx/`.
* **Rotate the runtime password**: change it in the DB (`sql/adb-customer-managed-ords.sql` again), update your vault, re-run `03-configure-ords.sh`, restart ORDS.
* **Monitoring**: see [additional-applications.md](additional-applications.md) (Glances + InfluxDB + Grafana).
