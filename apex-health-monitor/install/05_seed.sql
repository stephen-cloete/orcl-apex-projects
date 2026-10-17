--------------------------------------------------------------------------------
-- apex-health-monitor : 05_seed.sql   (run as HEALTH_MON)
-- Example targets only.  Put your real sites in the app (Targets > Add target)
-- or in a local, git-ignored install/targets.local.sql (see
-- targets.local.sql.example).  Merge keeps the script re-runnable and never
-- overwrites edits made in the app.
--------------------------------------------------------------------------------
merge into hm_targets d
using (
  select 'Example website' name, 'HTTP' target_type, 'https://www.example.com/' endpoint,
         200 expected_status, 1500 warn_threshold, 5000 crit_threshold, 5 interval_min,
         'Example public website' description from dual union all
  select 'Example shop', 'HTTP', 'https://shop.example.com/', 200, 1500, 5000, 5,
         'Example client site' from dual union all
  select 'Example API health', 'HTTP', 'https://api.example.com/health', 200, 1000, 3000, 5,
         'Example health endpoint' from dual union all
  select 'DB active sessions', 'SQL',
         'select count(*) from v$session where type = ''USER'' and status = ''ACTIVE''', null, 20, 40, 5,
         'Active user sessions' from dual union all
  select 'DATA tablespace used %', 'SQL',
         'select round(used_percent, 2) from dba_tablespace_usage_metrics where tablespace_name = ''DATA''', null, 80, 90, 15,
         'Storage head-room for the DATA tablespace' from dual union all
  select 'Failed scheduler jobs (24h)', 'SQL',
         'select count(*) from dba_scheduler_job_run_details where status = ''FAILED'' and log_date > systimestamp - interval ''1'' day', null, 1, 10, 15,
         'Scheduler job failures across the database in the last 24 hours' from dual union all
  select 'Invalid objects (app schemas)', 'SQL',
         'select count(*) from dba_objects where status = ''INVALID'' and owner in (select username from all_users where oracle_maintained = ''N'')', null, 1, 25, 15,
         'Invalid PL/SQL or views in non-Oracle schemas' from dual
) s
on (d.name = s.name)
when not matched then insert
  (name, target_type, endpoint, expected_status, warn_threshold, crit_threshold, interval_min, description)
values
  (s.name, s.target_type, s.endpoint, s.expected_status, s.warn_threshold, s.crit_threshold, s.interval_min, s.description);
commit;
