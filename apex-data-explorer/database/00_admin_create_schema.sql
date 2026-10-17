--------------------------------------------------------------------------------
-- Data Explorer - 00_admin_create_schema.sql
-- Run as: ADMIN (Autonomous Database) or a DBA user.
-- Args  : &1 = password for the DATAEXP schema (never hard-code it)
--         &2 = APEX workspace that will own the app (created if missing,
--              e.g. DATA_EXPLORER; an existing workspace also works)
-- Idempotent: creates DATAEXP if missing, otherwise resets its password and
-- re-applies grants; maps DATAEXP to the workspace only if not yet mapped.
-- Only privileges that Autonomous Database grants to ADMIN are used.
--------------------------------------------------------------------------------
set define on verify off feedback off serveroutput on
define dx_password = '&1'
define dx_workspace = '&2'
whenever sqlerror exit failure rollback

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from dba_users where username = 'DATAEXP';
  if l_cnt = 0 then
    execute immediate 'create user DATAEXP identified by "&dx_password" default tablespace DATA quota unlimited on DATA';
    dbms_output.put_line('created user DATAEXP');
  else
    begin
      execute immediate 'alter user DATAEXP identified by "&dx_password" account unlock';
      dbms_output.put_line('DATAEXP exists - password reset, account unlocked');
    exception
      when others then
        if sqlcode != -28007 then raise; end if;  -- same password again: nothing to change
        execute immediate 'alter user DATAEXP account unlock';
        dbms_output.put_line('DATAEXP exists - password unchanged, account unlocked');
    end;
  end if;
end;
/

grant create session, create table, create view, create procedure, create sequence, create type to DATAEXP;
alter user DATAEXP quota unlimited on DATA;
-- DATAEXP reads its own demo data plus whatever you grant it. To expose another
-- schema in Data Explorer: grant select on <owner>.<object> to DATAEXP, then
-- register the owner on the Data Sources page (or dx_api.add_schema_source).

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt
    from apex_workspace_schemas
   where workspace_name = upper('&dx_workspace')
     and schema = 'DATAEXP';
  if l_cnt = 0 then
    select count(*) into l_cnt from apex_workspaces where workspace = upper('&dx_workspace');
    if l_cnt = 0 then
      apex_instance_admin.add_workspace(p_workspace => upper('&dx_workspace'), p_primary_schema => 'DATAEXP');
      dbms_output.put_line('created APEX workspace '||upper('&dx_workspace')||' (primary schema DATAEXP)');
    else
      apex_instance_admin.add_schema(p_workspace => upper('&dx_workspace'), p_schema => 'DATAEXP');
    end if;
    commit;
    dbms_output.put_line('mapped DATAEXP to workspace '||upper('&dx_workspace'));
  else
    dbms_output.put_line('DATAEXP already mapped to workspace '||upper('&dx_workspace'));
  end if;
end;
/
undefine dx_password
undefine 1
