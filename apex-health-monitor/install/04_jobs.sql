--------------------------------------------------------------------------------
-- apex-health-monitor : 04_jobs.sql   (run as HEALTH_MON)
-- HM_RUN_CHECKS every minute (each target honours its own interval_min),
-- HM_PURGE_HISTORY daily at 02:15 (keeps 30 days of checks).
--------------------------------------------------------------------------------
begin
  for j in (select job_name from user_scheduler_jobs
             where job_name in ('HM_RUN_CHECKS','HM_PURGE_HISTORY')) loop
    dbms_scheduler.drop_job(j.job_name, force => true);
  end loop;

  dbms_scheduler.create_job(
    job_name        => 'HM_RUN_CHECKS',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'begin hm_pkg.run_due_checks; end;',
    start_date      => systimestamp,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=1',
    enabled         => true,
    comments        => 'apex-health-monitor: run due health checks');

  dbms_scheduler.create_job(
    job_name        => 'HM_PURGE_HISTORY',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'begin hm_pkg.purge_history(30); end;',
    start_date      => systimestamp,
    repeat_interval => 'FREQ=DAILY;BYHOUR=2;BYMINUTE=15',
    enabled         => true,
    comments        => 'apex-health-monitor: purge check history older than 30 days');
end;
/
