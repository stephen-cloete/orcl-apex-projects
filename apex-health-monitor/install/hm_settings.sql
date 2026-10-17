--------------------------------------------------------------------------------
-- apex-health-monitor : hm_settings.sql   (run as HEALTH_MON)
-- Creates HM_SETTINGS if missing and adds default rows.  Re-runnable; never
-- overwrites a value you have set.
--------------------------------------------------------------------------------
declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from user_tables where table_name = 'HM_SETTINGS';
  if l_cnt = 0 then
    execute immediate q'[create table hm_settings (
      name        varchar2(30 char)  constraint hm_settings_pk primary key,
      value       varchar2(100 char),
      description varchar2(400 char))]';
    execute immediate q'[comment on table hm_settings is 'apex-health-monitor settings (name/value)']';
  end if;
end;
/
merge into hm_settings d
using (select 'display_timezone' name,
              'Time zone for dates shown in the app (region or offset). Empty = database session time zone.' description
         from dual) s
on (d.name = s.name)
when not matched then insert (name, value, description) values (s.name, null, s.description);
commit;
