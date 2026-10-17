--------------------------------------------------------------------------------
-- Data Explorer - 00_admin_create_schema.sql
-- Run as: ADMIN (Autonomous Database) or a DBA user.
-- Args  : &1 = password for the DATAEXP schema (never hard-code it)
--         &2 = APEX workspace that will own the app (created if missing,
--              e.g. DATA_EXPLORER; an existing workspace also works)
--         &3 = password for the read-only DATAEXP_RO schema
-- Idempotent: creates DATAEXP and DATAEXP_RO if missing, otherwise resets their
-- passwords and re-applies grants; maps both to the workspace if not yet mapped.
--
-- DATAEXP     owns the app tables, DX_API and the demo data (app parsing schema).
-- DATAEXP_RO  runs the free-text Workbench queries. It is granted nothing but
--             SELECT on the objects users may query (granted by 06_seed.sql),
--             not even CREATE SESSION; 07_admin_readonly.sql creates its
--             DX_EXEC package.
-- Only privileges that Autonomous Database grants to ADMIN are used.
--------------------------------------------------------------------------------
set define on verify off feedback off serveroutput on
define dx_password = '&1'
define dx_workspace = '&2'
define dx_ro_password = '&3'
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

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from dba_users where username = 'DATAEXP_RO';
  if l_cnt = 0 then
    execute immediate 'create user DATAEXP_RO identified by "&dx_ro_password"';
    dbms_output.put_line('created user DATAEXP_RO (no system privileges)');
  else
    begin
      execute immediate 'alter user DATAEXP_RO identified by "&dx_ro_password"';
      dbms_output.put_line('DATAEXP_RO exists - password reset');
    exception
      when others then
        if sqlcode != -28007 then raise; end if;  -- same password again: nothing to change
        dbms_output.put_line('DATAEXP_RO exists - password unchanged');
    end;
  end if;
  -- keep it read-only: drop any system privilege or role someone added later
  for r in (select privilege from dba_sys_privs where grantee = 'DATAEXP_RO') loop
    execute immediate 'revoke ' || r.privilege || ' from DATAEXP_RO';
    dbms_output.put_line('revoked ' || r.privilege || ' from DATAEXP_RO');
  end loop;
  for r in (select granted_role from dba_role_privs where grantee = 'DATAEXP_RO') loop
    execute immediate 'revoke "' || r.granted_role || '" from DATAEXP_RO';
    dbms_output.put_line('revoked role ' || r.granted_role || ' from DATAEXP_RO');
  end loop;
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
  select count(*) into l_cnt
    from apex_workspace_schemas
   where workspace_name = upper('&dx_workspace')
     and schema = 'DATAEXP_RO';
  if l_cnt = 0 then
    apex_instance_admin.add_schema(p_workspace => upper('&dx_workspace'), p_schema => 'DATAEXP_RO');
    commit;
    dbms_output.put_line('mapped DATAEXP_RO to workspace '||upper('&dx_workspace'));
  end if;
end;
/
undefine dx_password
undefine dx_ro_password
undefine 1
undefine 3
