--------------------------------------------------------------------------------
-- Data Explorer - optional: create an APEX account to sign in with
-- Run as ADMIN:  @create_app_user.sql <WORKSPACE> <USERNAME> "<password>"
-- Idempotent: an existing user is left unchanged. The user is also added to
-- the ADMIN_USERS setting so it can manage data sources.
--------------------------------------------------------------------------------
set define on verify off feedback off serveroutput on
define dx_workspace = '&1'
define dx_user = '&2'
define dx_user_pw = '&3'
declare
  l_cnt pls_integer;
begin
  apex_util.set_security_group_id(apex_util.find_security_group_id(p_workspace => upper('&dx_workspace')));
  select count(*) into l_cnt from apex_workspace_apex_users
   where workspace_name = upper('&dx_workspace') and user_name = upper('&dx_user');
  if l_cnt = 0 then
    apex_util.create_user(
      p_user_name                    => upper('&dx_user'),
      p_web_password                 => '&dx_user_pw',
      p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
      p_default_schema               => 'DATAEXP',
      p_change_password_on_first_use => 'N');
    dbms_output.put_line('created APEX user '||upper('&dx_user')||' in '||upper('&dx_workspace'));
  else
    dbms_output.put_line('APEX user '||upper('&dx_user')||' already exists - unchanged');
  end if;
  update dataexp.dx_settings
     set setting_value = setting_value || ',' || upper('&dx_user')
   where setting_key = 'ADMIN_USERS'
     and instr(',' || setting_value || ',', ',' || upper('&dx_user') || ',') = 0;
  commit;
end;
/
undefine dx_user_pw
undefine 3
