--------------------------------------------------------------------------------
-- Data Explorer - APEX application install
-- Run as ADMIN (or a user with APEX_ADMINISTRATOR_ROLE), from this folder:
--   sql ADMIN/<pw>@<service> @install_app.sql <WORKSPACE> <APP_ID>
-- Re-running replaces the application with the same id. DATAEXP must already
-- be installed (database/install_db.sql) and mapped to the workspace.
--------------------------------------------------------------------------------
set define on verify off feedback off serveroutput on
whenever sqlerror exit failure rollback
define dx_workspace = '&1'
define dx_app_id = '&2'

declare
  l_ws_id number;
begin
  select workspace_id into l_ws_id
    from apex_workspaces
   where workspace = upper('&dx_workspace');
  apex_application_install.set_workspace_id(l_ws_id);
  apex_application_install.set_application_id(&dx_app_id);
  apex_application_install.generate_offset;
  apex_application_install.set_schema('DATAEXP');
  apex_application_install.set_application_alias('DATA-EXPLORER');
  dbms_output.put_line('installing Data Explorer as app &dx_app_id in workspace ' || upper('&dx_workspace'));
end;
/
@@f220.sql
set define on
prompt == installed application
select application_id, application_name, alias, owner, pages
  from apex_applications
 where application_id = &dx_app_id;
