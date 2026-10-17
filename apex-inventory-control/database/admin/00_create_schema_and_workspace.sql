--------------------------------------------------------------------------------
-- apex-inventory-control : schema + APEX workspace bootstrap (run once as ADMIN)
--
-- Re-runnable. Creates:
--   * database schema   INVENTORY_CONTROL  (owner of all INV_* objects)
--   * APEX workspace    INVENTORY_CONTROL  (parsing schema INVENTORY_CONTROL)
--   * workspace admin   INV_ADMIN          (also used to sign in to the app)
--
-- Passwords are NEVER stored in this repo. Supply them at run time, e.g. in SQLcl:
--   define schema_password = '<from vault>'
--   define admin_password  = '<from vault>'
--   @00_create_schema_and_workspace.sql
-- EU DEV keeps them in the EU OCI Vault (see ../../inventory-control.md).
--------------------------------------------------------------------------------
set define on verify off

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from dba_users where username = 'INVENTORY_CONTROL';
  if l_cnt = 0 then
    execute immediate 'create user inventory_control identified by "&schema_password." '
                   || 'default tablespace data temporary tablespace temp quota 200M on data';
  else
    execute immediate 'alter user inventory_control identified by "&schema_password." account unlock';
  end if;
  for g in (select column_value priv from table(sys.odcivarchar2list(
              'create session','create table','create view','create sequence',
              'create procedure','create trigger','create type','create synonym')))
  loop
    execute immediate 'grant ' || g.priv || ' to inventory_control';
  end loop;
end;
/

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from apex_workspaces where workspace = 'INVENTORY_CONTROL';
  if l_cnt = 0 then
    apex_instance_admin.add_workspace(
      p_workspace      => 'INVENTORY_CONTROL',
      p_primary_schema => 'INVENTORY_CONTROL');
  end if;
  commit;
end;
/

declare
  l_cnt pls_integer;
begin
  apex_util.set_workspace('INVENTORY_CONTROL');
  select count(*) into l_cnt from apex_workspace_apex_users
   where workspace_name = 'INVENTORY_CONTROL' and user_name = 'INV_ADMIN';
  if l_cnt = 0 then
    apex_util.create_user(
      p_user_name                    => 'INV_ADMIN',
      p_web_password                 => '&admin_password.',
      p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
      p_default_schema               => 'INVENTORY_CONTROL',
      p_allow_access_to_schemas      => 'INVENTORY_CONTROL',
      p_change_password_on_first_use => 'N');
  else
    apex_util.edit_user(
      p_user_id                      => apex_util.get_user_id('INV_ADMIN'),
      p_user_name                    => 'INV_ADMIN',
      p_web_password                 => '&admin_password.',
      p_new_password                 => '&admin_password.',
      p_change_password_on_first_use => 'N');
    apex_util.unlock_account('INV_ADMIN');
  end if;
  commit;
end;
/
