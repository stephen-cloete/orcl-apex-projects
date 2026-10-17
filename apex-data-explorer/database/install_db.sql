--------------------------------------------------------------------------------
-- Data Explorer - database install (run as DATAEXP, from this folder)
--   sql DATAEXP/<password>@<service> @install_db.sql <ADMIN_USERS>
-- Ordered and idempotent; re-run it to upgrade in place.
--------------------------------------------------------------------------------
set define on verify off feedback off serveroutput on
whenever sqlerror exit failure rollback
define dx_admin_users = '&1'
-- package bodies contain HTML entities (&amp; ...): no substitution while loading them
set define off
prompt == Data Explorer: tables
@@01_tables.sql
prompt == Data Explorer: dx_api specification
@@02_dx_api.pks
prompt == Data Explorer: catalog views
@@03_views.sql
prompt == Data Explorer: dx_api body
@@04_dx_api.pkb
prompt == Data Explorer: application views
@@05_app_views.sql
set define on
prompt == Data Explorer: settings, demo data, default source
@@06_seed.sql "&dx_admin_users"

prompt == Data Explorer: invalid objects (expect none)
declare
  l_bad pls_integer := 0;
begin
  dbms_utility.compile_schema(schema => user, compile_all => false);
  for r in (select object_type, object_name from user_objects where status <> 'VALID' order by 1, 2) loop
    dbms_output.put_line('  INVALID ' || r.object_type || ' ' || r.object_name);
    l_bad := l_bad + 1;
  end loop;
  if l_bad > 0 then
    raise_application_error(-20000, l_bad || ' invalid object(s) after install');
  end if;
  dbms_output.put_line('  all objects valid - dx_api ' || dx_api.c_version);
end;
/
