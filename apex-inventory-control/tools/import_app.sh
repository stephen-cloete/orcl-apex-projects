#!/usr/bin/env bash
# Import an APEX export into EU DEV workspace INVENTORY_CONTROL as app 1301 via ORDS REST SQL (ADMIN).
set -euo pipefail
F="${1:?export file}"
{
cat <<'SQL'
set define off
begin
  apex_application_install.set_workspace('INVENTORY_CONTROL');
  apex_application_install.set_application_id(1301);
  apex_application_install.set_schema('INVENTORY_CONTROL');
  apex_application_install.set_application_alias('INVENTORY-CONTROL');
  apex_application_install.generate_offset;
end;
/
SQL
grep -v -E '^(set |whenever |prompt )' "$F"
echo "select application_id, alias, pages, last_updated_on from apex_applications where application_id = 1301;"
} > /tmp/inv_import.sql
"$(dirname "$0")/eu_sql.py" /tmp/inv_import.sql | rg -v "PL/SQL procedure successfully completed" | head -40
