--------------------------------------------------------------------------------
-- Data Explorer - uninstall (run as ADMIN)
--   sql ADMIN/<pw>@<service> @uninstall.sql <WORKSPACE> <APP_ID>
-- Removes the APEX app, unmaps DATAEXP from the workspace and drops DATAEXP
-- with everything it owns (saved queries and the query log included).
--------------------------------------------------------------------------------
set define on verify off feedback off serveroutput on
define dx_workspace = '&1'
define dx_app_id = '&2'
whenever sqlerror exit failure rollback

declare
  l_ws_id number;
  l_cnt   pls_integer;
begin
  select workspace_id into l_ws_id from apex_workspaces where workspace = upper('&dx_workspace');
  select count(*) into l_cnt from apex_applications where application_id = &dx_app_id and owner = 'DATAEXP';
  if l_cnt = 1 then
    apex_application_install.set_workspace_id(l_ws_id);
    apex_application_install.remove_application(&dx_app_id);
    dbms_output.put_line('removed APEX application &dx_app_id');
  end if;
  select count(*) into l_cnt from apex_workspace_schemas where workspace_name = upper('&dx_workspace') and schema = 'DATAEXP';
  if l_cnt = 1 then
    apex_instance_admin.remove_schema(p_workspace => upper('&dx_workspace'), p_schema => 'DATAEXP');
    dbms_output.put_line('unmapped DATAEXP from workspace ' || upper('&dx_workspace'));
  end if;
  select count(*) into l_cnt from dba_users where username = 'DATAEXP';
  if l_cnt = 1 then
    execute immediate 'drop user DATAEXP cascade';
    dbms_output.put_line('dropped user DATAEXP');
  end if;
  commit;
end;
/
