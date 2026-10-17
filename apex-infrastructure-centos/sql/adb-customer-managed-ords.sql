-- adb-customer-managed-ords.sql
-- Run as ADMIN on Autonomous Database (SQLcl / SQL Developer Web / Database Actions).
-- Creates the runtime + PL/SQL gateway users that a self-hosted ("customer managed") ORDS uses.
-- Idempotent: re-running resets the runtime password and re-applies grants.
--   sql admin@mydb_low @adb-customer-managed-ords.sql ORDS_PUBLIC_USER2 ORDS_PLSQL_GATEWAY2
-- The runtime password is prompted for (ACCEPT ... HIDE) - never put it on the command line or in git.
set verify off feedback on serveroutput on
define RUNTIME_USER = '&1'
define GATEWAY_USER = '&2'
accept RUNTIME_PW char prompt 'Password for &RUNTIME_USER: ' hide

declare
  procedure ensure(p_user varchar2, p_ddl varchar2, p_alter varchar2) is
    n number;
  begin
    select count(*) into n from dba_users where username = p_user;
    execute immediate case when n = 0 then p_ddl else p_alter end;
    dbms_output.put_line(case when n = 0 then 'created ' else 'updated ' end || p_user);
  end;
begin
  ensure('&RUNTIME_USER', 'create user &RUNTIME_USER identified by "&RUNTIME_PW"',
                          'alter user &RUNTIME_USER identified by "&RUNTIME_PW" account unlock');
  ensure('&GATEWAY_USER', 'create user &GATEWAY_USER no authentication',
                          'alter user &GATEWAY_USER no authentication');
end;
/
grant connect to &RUNTIME_USER;
grant connect to &GATEWAY_USER;
alter user &GATEWAY_USER grant connect through &RUNTIME_USER;
begin
  ords_admin.provision_runtime_role(p_user => '&RUNTIME_USER', p_proxy_enabled_schemas => true);
  ords_admin.config_plsql_gateway(p_runtime_user => '&RUNTIME_USER', p_plsql_gateway_user => '&GATEWAY_USER');
end;
/
undefine RUNTIME_PW
@@adb-verify.sql &RUNTIME_USER &GATEWAY_USER
