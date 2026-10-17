# APEX Inventory Control

A lightweight Oracle APEX 26.1 mini app for stock control: items, locations, suppliers and
categories, stock on hand per location, and an immutable ledger of stock movements
(receipts, issues, transfers and count adjustments) with reorder-level alerts.

| | |
|---|---|
| APEX | 26.1 (Universal Theme 42 / 26.1, Vita style, compatibility mode 26.1) |
| Application | 1301, alias `INVENTORY-CONTROL` |
| Workspace / schema | `INVENTORY_CONTROL` / `INVENTORY_CONTROL` |
| Authentication | Oracle APEX Accounts |

## Design

* **Schema (`INV_*`)**: `inv_categories`, `inv_locations`, `inv_suppliers`, `inv_items`,
  `inv_stock` (on hand per item and location, never negative) and `inv_transactions`
  (the movement ledger). Identity keys, check constraints, FK indexes and audit columns.
* **Views**: `inv_items_v` (on hand, stock value, low-stock flag), `inv_stock_v`,
  `inv_transactions_v`, `inv_dashboard_v`.
* **PL/SQL API `inv_api`**: every write goes through it (`save_*`, `delete_*`,
  `post_transaction`). It validates input, locks stock rows (`select ... for update`, fixed
  lock order for transfers), refuses to take stock below zero, and raises readable
  `ORA-20001..20099` messages. Page processes contain only a single API call.
* **`inv_ui_error`**: the app's error handling function. It shows API messages without the
  ORA prefix and hides internal error detail.
* **UI**: 13 pages (Home dashboard, Items + form, Stock on Hand, Stock Movements + new
  movement, Locations / Categories / Suppliers + forms, Sign In). Floating labels and
  stretched inputs on a 12-column grid. Secondary report columns hide below 640px, so
  every page fits a 390px phone without horizontal scrolling.

## Layout

```
apex-inventory-control/
  database/
    admin/00_create_schema_and_workspace.sql   run once as ADMIN (schema, workspace, INV_ADMIN)
    install.sql                                re-runnable install (tables, views, API, seed, error fn)
    install/01_tables.sql .. 06_inv_ui_error.sql
    uninstall.sql                              drops INV_* objects (dev only)
  apex/
    f1301.sql                                  APEX 26.1.5 export (APEX_EXPORT) - source of truth
    bootstrap/f1301_bootstrap.sql              generated first-install export (tools/generate_app.py)
    static/inv-app.css                         app CSS (also embedded as a static app file)
  tools/                                       generator, ORDS REST SQL helper, import/export, Playwright checks
  docs/screenshots/                            phone (390x844) and desktop (1280x800) evidence
```

## Install

1. **Schema and workspace** (once, as ADMIN). Passwords are supplied at run time and never stored
   in git:
   ```sql
   define schema_password = '...'
   define admin_password  = '...'
   @database/admin/00_create_schema_and_workspace.sql
   ```
2. **Database objects** (re-runnable). Connect as `INVENTORY_CONTROL`, or as ADMIN after
   `alter session set current_schema = inventory_control;`, then:
   ```sql
   @database/install.sql
   ```
3. **Application.** Connect as `INVENTORY_CONTROL` (or ADMIN) and run:
   ```sql
   begin
     apex_application_install.set_workspace('INVENTORY_CONTROL');
     apex_application_install.set_application_id(1301);
     apex_application_install.set_schema('INVENTORY_CONTROL');
   end;
   /
   @apex/f1301.sql
   ```
   Or import `apex/f1301.sql` with App Builder > Import.
4. Sign in at `/ords/r/inventory_control/inventory-control/` with the workspace user.

### No SQL*Net? Use ORDS REST-enabled SQL

`tools/eu_sql.py` posts scripts to `/ords/admin/_/sql` over HTTPS:
`tools/build_db_script.sh | tools/eu_sql.py -` installs the schema objects, and
`tools/import_app.sh apex/f1301.sql` imports the app. The password comes from
`$EU_DB_PASSWORD` or the OCI Vault (via `tools/eu-oci-vault-secret`).

### Regenerating / exporting

Change `tools/generate_app.py` and run it, import `apex/bootstrap/f1301_bootstrap.sql`, then
refresh the committed export with `tools/export_app.sh`.

## Testing

`tools/ui_check.py` signs in headlessly and checks every page at 390x844 and 1280x800: no
horizontal page overflow, and every input, button and region inside the viewport. It saves
full-page screenshots. `tools/flow_check.py` creates an item, receives stock, checks that
over-issuing is refused with a friendly message, then issues stock and searches for it.

Last run on EU DEV (2026-10-17): 26/26 page checks passed; the functional flow passed on
phone and desktop. See `docs/screenshots/`.

| Phone 390px | Desktop 1280px |
|---|---|
| ![home](docs/screenshots/phone-01-home.png) | ![home](docs/screenshots/desktop-01-home.png) |
| ![items](docs/screenshots/phone-02-items.png) | ![items](docs/screenshots/desktop-02-items.png) |
| ![movement](docs/screenshots/phone-06-new-movement.png) | ![movement](docs/screenshots/desktop-06-new-movement.png) |

## Credentials

Nothing secret lives in this repo. On EU DEV the schema password and the `INV_ADMIN`
workspace/app login are kept in the EU OCI Vault
(`adb-inventory-control-schema-password-eu-dev`, `apex-inventory-control-admin-eu-dev`).
