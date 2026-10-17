--------------------------------------------------------------------------------
-- apex-health-monitor : 00_admin_setup.sql
-- Run as ADMIN (Autonomous Database).  Creates the HEALTH_MON parsing schema,
-- its grants and network ACE, the HEALTH_MON APEX workspace and the HM_ADMIN
-- workspace user.  Re-runnable.
--
-- Substitution variables (pass them, never hard-code them):
--   &1  HEALTH_MON schema password       (Vault: apex-health-monitor-schema-password-eu-dev)
--   &2  HM_ADMIN APEX user password      (Vault: apex-health-monitor-admin-password-eu-dev)
--------------------------------------------------------------------------------
set define on verify off feedback off serveroutput on
whenever sqlerror exit failure rollback

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from dba_users where username = 'HEALTH_MON';
  if l_cnt = 0 then
    execute immediate 'create user health_mon identified by "&1" default tablespace data quota 200m on data';
    dbms_output.put_line('Created user HEALTH_MON');
  else
    -- Existing schema: keep its password (rotate with ALTER USER + Vault update).
    execute immediate 'alter user health_mon account unlock';
    dbms_output.put_line('HEALTH_MON exists, left password unchanged');
  end if;
end;
/

grant create session, create table, create view, create sequence,
      create procedure, create job, create type, create synonym to health_mon;

-- Read-only dictionary views used by the built-in database checks.
grant select on sys.v_$session                  to health_mon;
grant select on sys.v_$instance                 to health_mon;
grant select on sys.dba_tablespace_usage_metrics to health_mon;
grant select on sys.dba_scheduler_job_run_details to health_mon;
grant select on sys.dba_objects                 to health_mon;

-- HTTPS (443 only) outbound for the HTTP endpoint checks.
begin
  dbms_network_acl_admin.append_host_ace(
    host       => '*',
    lower_port => 443,
    upper_port => 443,
    ace        => xs$ace_type(privilege_list => xs$name_list('connect'),
                              principal_name => 'HEALTH_MON',
                              principal_type => xs_acl.ptype_db));
  dbms_network_acl_admin.append_host_ace(
    host       => '*',
    ace        => xs$ace_type(privilege_list => xs$name_list('resolve'),
                              principal_name => 'HEALTH_MON',
                              principal_type => xs_acl.ptype_db));
end;
/

-- APEX workspace + workspace administrator.
declare
  l_cnt pls_integer;
  l_ws  number;
begin
  select count(*) into l_cnt from apex_workspaces where workspace = 'HEALTH_MON';
  if l_cnt = 0 then
    apex_instance_admin.add_workspace(
      p_workspace      => 'HEALTH_MON',
      p_primary_schema => 'HEALTH_MON');
    dbms_output.put_line('Created APEX workspace HEALTH_MON');
  end if;
  commit;

  select workspace_id into l_ws from apex_workspaces where workspace = 'HEALTH_MON';
  apex_util.set_security_group_id(l_ws);

  select count(*) into l_cnt from apex_workspace_apex_users
   where workspace_name = 'HEALTH_MON' and user_name = 'HM_ADMIN';
  if l_cnt = 0 then
    apex_util.create_user(
      p_user_name                    => 'HM_ADMIN',
      p_web_password                 => '&2',
      p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
      p_default_schema               => 'HEALTH_MON',
      p_change_password_on_first_use => 'N');
    dbms_output.put_line('Created APEX user HM_ADMIN');
  else
    apex_util.unlock_account('HM_ADMIN');
    dbms_output.put_line('HM_ADMIN exists, unlocked (password unchanged)');
  end if;
  commit;
end;
/
