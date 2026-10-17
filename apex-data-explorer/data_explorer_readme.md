
# Data Explorer

## About
Data Explorer as an ad-hoc query and analysis reporting tool designed for developer and End-Users for an easy access point to their relational database and External Data Sources. Data Explorer enables users at all levels to make faster and more informed decisions by focusing on a single view of data while hiding the complexity of the underlying data structures and enabling the delivery of analytical content via Mobile and Web Browsers as a report

## What is in this folder

| Path | What it is |
| --- | --- |
| `database/00_admin_create_schema.sql` | Creates (or resets) the `DATAEXP` parsing schema, grants, workspace mapping. Run as ADMIN. |
| `database/install_db.sql` | Ordered, idempotent install of everything in `DATAEXP` (calls 01-06). |
| `database/01_tables.sql` | Settings, data sources, REST cache, saved queries, query log. |
| `database/02_dx_api.pks`, `04_dx_api.pkb` | `DX_API` package: SQL validation, execution, HTML/CSV output, saved queries, data sources. |
| `database/03_views.sql` | `DX_CATALOG_V` / `DX_COLUMNS_V` - what users can explore. |
| `database/05_app_views.sql` | Row-filtered views for the APEX pages. |
| `database/06_seed.sql` | Settings, demo sales data set, default data source, two shared sample queries. |
| `database/uninstall.sql` | Removes the app, the workspace mapping and the `DATAEXP` schema. |
| `apex/f220.sql` | APEX 26.1 application export (Universal Theme, Oracle APEX Accounts). |
| `apex/install_app.sql` | Imports `f220.sql` into a workspace with a chosen app id. |
| `tests/smoke_test.sql` | 38 PASS/FAIL checks; exits non-zero on any failure. |
| `scripts/install.sh` / `uninstall.sh` | One-shot install/uninstall + smoke test with SQLcl. |
| `apex/create_app_user.sql` | Optional: creates an APEX account in the workspace and adds it to `ADMIN_USERS`. |

## How it works

* **Data sources** are registered in `DX_DATA_SOURCES`:
  * `SCHEMA` - every table/view of an owner that `DATAEXP` can `SELECT`. `ALL_OBJECTS` drives the
    catalog, so users only ever see what has been granted to `DATAEXP`.
  * `REST` (external data) - a JSON endpoint is fetched with `APEX_WEB_SERVICE`, cached in
    `DX_REST_CACHE`, and exposed as a relational view `DX_REST_<id>` through `JSON_TABLE`
    (you supply the column list, e.g. `id number path '$.id', name varchar2(200) path '$.name'`).
* **Queries** are read-only. `DX_API.VALIDATE_SQL` accepts a single `SELECT`/`WITH` statement and
  rejects DML/DDL, `;`-separated batches, `FOR UPDATE`, PL/SQL in `WITH`, database links (unless
  `ALLOW_DB_LINKS=Y`) and Data Explorer's own tables. The statement is then parsed as a sub-query
  (DDL cannot parse there), executed with `DBMS_SQL`, capped at `MAX_ROWS`, rendered as an escaped
  Universal Theme report or streamed as CSV, and written to `DX_QUERY_LOG`.
* **Saved queries** are private or shared; run counts are tracked.

## The APEX app (mini app, 5 pages)

| Page | Purpose |
| --- | --- |
| 1 Explore | Search the catalog; click an object to open it in the workbench. |
| 2 Query Workbench | Write/run a SELECT, pick a row limit, download CSV, save/share the query; shows the object's columns. |
| 3 Saved Queries | Own and shared queries; click to open. |
| 4 Query Log | Your runs (admins see everyone's), status, rows, elapsed ms, errors. |
| 5 Data Sources | Admins only (`ADMIN_USERS` setting): add schema/REST sources, refresh REST data, enable/disable. |
| 9999 Login | Oracle APEX Accounts. |

## Requirements

* Oracle Database 19c+ (developed for Autonomous Database 26ai) with APEX 26.1 (export version `2026.03.30`).
* SQLcl (or SQL*Plus) on the host that runs the install.
* ADMIN (or a DBA) once, to create `DATAEXP`. Privileges used are all available to ADB `ADMIN`:
  `CREATE USER`, `GRANT CREATE SESSION/TABLE/VIEW/PROCEDURE/SEQUENCE/TYPE`, quota on `DATA`,
  `APEX_INSTANCE_ADMIN.ADD_SCHEMA`. `DATAEXP` itself needs no system or `DBA_*` access.
* REST sources call out through `APEX_WEB_SERVICE`; the target host must be allowed by the instance's
  network ACL (public HTTPS hosts are allowed for APEX on ADB).

## Install

```bash
export DX_CONNECT='<TLS connect descriptor or tns alias>'   # or a tnsnames alias with TNS_ADMIN set
export DX_ADMIN_PASSWORD=...        # read from your secret store, do not type into history
export DX_SCHEMA_PASSWORD=...       # new strong password for DATAEXP (no quotes, @ or /)
export DX_WORKSPACE=DATA_EXPLORER DX_APP_ID=220 DX_ADMIN_USERS=ADMIN   # pick a free app id
scripts/install.sh
```

or step by step from SQLcl:

```sql
-- as ADMIN, in database/
@00_admin_create_schema.sql "<dataexp password>" DATA_EXPLORER
-- as DATAEXP, in database/
@install_db.sql "ADMIN,OTHER_ADMIN"
-- as ADMIN, in apex/
@install_app.sql DATA_EXPLORER 220
-- optional, as ADMIN, in apex/: an APEX account to sign in with
@create_app_user.sql DATA_EXPLORER <USERNAME> "<password>"
-- as DATAEXP, from the project folder
@tests/smoke_test.sql 220
```

No SQLcl on the host? The scripts also run through ORDS REST-enabled SQL once `@@` includes are
inlined and `whenever sqlerror` lines are removed (that endpoint rejects them); keep `set define off`
around 01-05 as `install_db.sql` does.

Keep passwords in a secret store and pass them via environment or stdin, never on the command line.

Every step is idempotent: re-running upgrades in place, keeps saved queries/logs and only loads demo
rows into empty tables. Then open `.../ords/r/<workspace>/data-explorer/home` and sign in with an
APEX account of that workspace.

To expose more data: `grant select on HR.EMPLOYEES to DATAEXP;` then add the `HR` schema on page 5.

## Test

`tests/smoke_test.sql <APP_ID>` checks objects are valid, catalog filtering, every validation rule
(DELETE, DDL, batches, FOR UPDATE, DB links, internal tables, PL/SQL), HTML escaping, row cap, CSV,
CLOB/RAW/TIMESTAMP rendering, saved-query round trip and run counts, the REST-to-view pipeline
(offline payload, no network) and that app pages 1-5 and 9999 exist. It prints `RESULT: n passed, m failed`
and exits non-zero on failure. Test rows are cleaned up.

## Uninstall

```bash
DX_CONNECT=... DX_ADMIN_PASSWORD=... DX_WORKSPACE=DATA_EXPLORER DX_APP_ID=220 scripts/uninstall.sh
```

This drops `DATAEXP` with its saved queries and log.

## Settings (`DX_SETTINGS`)

| Key | Default | Meaning |
| --- | --- | --- |
| `MAX_ROWS` | 500 | Hard row cap for screen and CSV (max 10000). |
| `MAX_COLUMNS` | 100 | Column cap per query. |
| `ALLOW_DB_LINKS` | N | `Y` allows `@dblink` in queries. |
| `ADMIN_USERS` | install arg | Comma-separated APEX users who manage data sources and see all logs. |

Change with `exec dx_api.set_setting('MAX_ROWS','1000'); commit;` as `DATAEXP`.

## Security notes

* Queries run with `DATAEXP`'s privileges only; grant it exactly what users may read.
* Validation is defence in depth; the real boundary is `DATAEXP`'s grants plus the sub-query parse.
  Users can still call functions in `SELECT` that `DATAEXP` can execute, so do not grant `DATAEXP`
  execute on packages with side effects.
* Output is HTML-escaped; CSV values are quoted per RFC 4180.

## Screenshots

![Explore](docs/screenshots/explore.png)

![Query Workbench](docs/screenshots/query-workbench.png)
