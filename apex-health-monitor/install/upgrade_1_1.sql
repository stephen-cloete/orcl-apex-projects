--------------------------------------------------------------------------------
-- apex-health-monitor : upgrade_1_1.sql   (run as HEALTH_MON on a 1.0 install)
-- 1.1: UNREACHABLE status for DNS / network failures, de-duplicated error
--      messages, seed target endpoints updated.
-- Re-runnable.  Recompile the package and views afterwards (install_schema.sql
-- is for fresh installs; deploy.sh runs this script automatically).
--------------------------------------------------------------------------------
set define off feedback on
whenever sqlerror exit failure rollback
declare
  procedure ddl (p varchar2) is begin execute immediate p; exception when others then
    if sqlcode not in (-2443, -1430, -1442) then raise; end if; end;
begin
  ddl('alter table hm_checks modify status varchar2(12 char)');
  ddl('alter table hm_incidents modify severity varchar2(12 char)');
  ddl('alter table hm_checks drop constraint hm_checks_status_ck');
  ddl('alter table hm_checks add constraint hm_checks_status_ck check (status in (''UP'',''DEGRADED'',''DOWN'',''UNREACHABLE''))');
  ddl('alter table hm_incidents drop constraint hm_incidents_sev_ck');
  ddl('alter table hm_incidents add constraint hm_incidents_sev_ck check (severity in (''DEGRADED'',''DOWN'',''UNREACHABLE''))');
end;
/
@@hm_settings.sql
@@02_hm_pkg.pks
@@02_hm_pkg.pkb
show errors package body hm_pkg
@@03_views.sql

prompt == reclassify historic network failures and clean duplicated messages
update hm_checks
   set status  = 'UNREACHABLE',
       message = 'Unreachable: ' || hm_pkg.unreachable_reason(message) || ' (' || hm_pkg.clean_error(message) || ')'
 where status = 'DOWN' and http_status is null
   and regexp_like(message, 'ORA-(12545|24247|12541|12543|12535|12170|29276)')
   and message not like 'Unreachable:%';
update hm_incidents i
   set severity      = 'UNREACHABLE',
       first_message = 'Unreachable: ' || hm_pkg.unreachable_reason(first_message) || ' (' || hm_pkg.clean_error(first_message) || ')',
       last_message  = case when last_message like 'Recovered:%' then last_message
                            else 'Unreachable: ' || hm_pkg.unreachable_reason(last_message) || ' (' || hm_pkg.clean_error(last_message) || ')' end
 where severity = 'DOWN'
   and regexp_like(first_message, 'ORA-(12545|24247|12541|12543|12535|12170|29276)')
   and first_message not like 'Unreachable:%'
   and not exists (select null from hm_checks c where c.target_id = i.target_id
                    and c.checked_at >= i.started_at and c.status = 'DOWN');

prompt == seed changes
@@05_seed.sql
