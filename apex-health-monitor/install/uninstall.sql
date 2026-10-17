--------------------------------------------------------------------------------
-- apex-health-monitor : uninstall.sql  (run as HEALTH_MON)
-- Drops jobs, views, package and tables.  The APEX app, workspace and schema are
-- removed separately by ADMIN (see readme).
--------------------------------------------------------------------------------
begin
  for j in (select job_name from user_scheduler_jobs where job_name like 'HM\_%' escape '\') loop
    dbms_scheduler.drop_job(j.job_name, force => true);
  end loop;
  for o in (select object_name, object_type from user_objects
             where object_type in ('VIEW','PACKAGE','TABLE') and object_name like 'HM\_%' escape '\'
             order by decode(object_type,'VIEW',1,'PACKAGE',2,'TABLE',3)) loop
    execute immediate 'drop ' || o.object_type || ' ' || o.object_name ||
                      case when o.object_type = 'TABLE' then ' cascade constraints purge' end;
  end loop;
end;
/
