-- adb-verify.sql <runtime_user> <gateway_user> : read-only checks for customer-managed ORDS on ADB
set verify off pages 100 lines 200 feedback off
col username format a30
col check_name format a40
col result format a60
select 'APEX version' check_name, version_no result from apex_release
union all select 'IMAGE_PREFIX', apex_instance_admin.get_parameter('IMAGE_PREFIX') from dual
union all select 'runtime user status', account_status||' / '||authentication_type from dba_users where username = upper('&1')
union all select 'gateway user auth', authentication_type from dba_users where username = upper('&2')
union all select 'gateway proxy through runtime', decode(count(*),1,'YES','NO') from proxy_users where proxy = upper('&1') and client = upper('&2')
union all select 'runtime has ORDS_RUNTIME_ROLE', decode(count(*),0,'NO','YES') from dba_role_privs where grantee = upper('&1') and granted_role = 'ORDS_RUNTIME_ROLE';
