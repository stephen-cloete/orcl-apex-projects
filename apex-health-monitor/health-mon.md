# apex-health-monitor

A small Oracle APEX app that watches websites and database health checks, keeps
a history of every result, and opens and closes incidents by itself.

* **HTTPS endpoints**: the database sends a GET request. The result is **UP** when the HTTP status matches the
  expected status and the response time is under the thresholds. It is **DEGRADED** when the response time
  reaches the warning level, and **DOWN** when the status is wrong, the response is too slow, or the request
  fails (DNS, TLS or timeout).
* **SQL checks**: a single `SELECT` that returns one number, compared with the warning and critical
  thresholds. Examples are active sessions, DATA tablespace usage, failed scheduler jobs and invalid objects.
* **Incidents**: opened when a target leaves UP, escalated from DEGRADED to DOWN if it gets worse, and closed
  automatically when the target recovers. Each incident records its duration and how many checks failed.
* **Scheduler**: `HM_RUN_CHECKS` runs every minute and checks only the targets whose own interval is due.
  `HM_PURGE_HISTORY` deletes check history older than 30 days.

The app is kept light on purpose: one schema, three tables, one package, two views, two jobs and a
7-page app with no plug-ins or custom JavaScript. It works on desktop and phone.

## Pages

| Page | What it shows |
|------|---------------|
| 1 Dashboard | Up / Degraded / Down / open-incident totals, a status card per target with 24h uptime and average response time, a chart of response times over the last 24 hours, and a **Run all checks now** button |
| 2 Targets | Interactive report of all targets with status, uptime (24h / 7d), average response time and last result |
| 3 Target | Form to add or edit a target (validated), with **Save**, **Save and check now** and **Delete** |
| 4 Check History | Every check in the last 7 days, with a filter by target |
| 5 Incidents | Open and resolved incidents with severity and duration |
| 9999 Login | APEX accounts sign-in |

Screenshots taken on EU DEV are in [`docs/screenshots`](docs/screenshots).

![Dashboard](docs/screenshots/apex-health-monitor-dashboard.png)

## Layout

```
apex-health-monitor/
  apex/f2600.sql              APEX 26.1 application export (app 2600, alias HEALTH-MONITOR)
  install/00_admin_setup.sql  ADMIN: HEALTH_MON schema, grants, HTTPS ACE, workspace + HM_ADMIN user
  install/01_tables.sql       HM_TARGETS, HM_CHECKS, HM_INCIDENTS
  install/02_hm_pkg.pks/.pkb  Check engine (HTTP + SQL), incidents, uptime, purge
  install/03_views.sql        HM_TARGET_STATUS_V, HM_INCIDENTS_V
  install/04_jobs.sql         HM_RUN_CHECKS (every minute), HM_PURGE_HISTORY (daily 02:15 UTC)
  install/05_seed.sql         Starter targets (APEX Works sites + database checks)
  install/install_schema.sql  Runs 01-05 as HEALTH_MON
  install/install_app.sql     Imports apex/f2600.sql into workspace HEALTH_MON
  install/deploy_eu_dev.sh    End-to-end deploy to EU DEV through eu-2-ha, passwords from EU Vault
  install/uninstall.sql       Drops the schema objects
  tests/test_hm_pkg.sql       Self-cleaning PL/SQL tests (14 cases)
  tools/gen_app.py            Generator for apex/f2600.sql
```

## Install

Target: **EU DEV**, Autonomous Database `APEXWORKS-DEV` in eu-frankfurt-1 (APEX 26.1.5, ORDS 26.3).
All database work goes through the **eu-2-ha** compute instance (`eu-webserver-ha-2`) using an SSH forward,
so the database sees eu-2-ha's address. eu-2-ha's public IP is on the ADB access list.

```bash
# needs OCI CLI profile [EU], SSH access to eu-2-ha and SQLcl
./install/deploy_eu_dev.sh            # FRESH=Y ./install/deploy_eu_dev.sh drops and rebuilds the schema objects
```

To run the steps by hand (each script can be run again safely):

1. As ADMIN: `@install/00_admin_setup.sql "<schema password>" "<HM_ADMIN password>"`
2. As HEALTH_MON: `@install/install_schema.sql`
3. As ADMIN: `@install/install_app.sql`
4. As HEALTH_MON: `@tests/test_hm_pkg.sql`, which should end with `ALL TESTS PASSED`

App URL (EU DEV): `https://sum3jolgpeajgmt-apexworksdev.adb.eu-frankfurt-1.oraclecloudapps.com/ords/r/health_mon/health-monitor/`
(sign in as `HM_ADMIN`).

## Credentials (EU OCI Vault)

No passwords are kept in this repo. The EU Vault (`vault`, eu-frankfurt-1) holds:

| Secret | Used for |
|--------|----------|
| `apex-health-monitor-schema-password-eu-dev` | `HEALTH_MON` database schema (parsing schema) |
| `apex-health-monitor-admin-password-eu-dev`  | APEX user `HM_ADMIN` in workspace `HEALTH_MON` |
| `adb-healthcheck-admin-password-eu-dev`      | ADB `ADMIN`, used only by the install scripts |

## Adding checks

You can add checks from **Targets → Add target**, or insert rows into `HM_TARGETS` directly:

* HTTP: an `https://` URL. Autonomous Database only allows outbound HTTPS, and the ACE is limited to port 443.
  Thresholds are in milliseconds.
* SQL: `select <number> from ...` with no trailing semicolon. It runs as `HEALTH_MON`, so the schema needs
  read access to whatever the query uses. The four seeded database checks use the grants in `00_admin_setup.sql`.

## Uninstall

As HEALTH_MON run `@install/uninstall.sql`. Then, as ADMIN, run
`apex_instance_admin.remove_workspace('HEALTH_MON')` and `drop user health_mon cascade`.
