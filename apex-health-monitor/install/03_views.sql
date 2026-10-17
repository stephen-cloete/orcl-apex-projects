--------------------------------------------------------------------------------
-- apex-health-monitor : 03_views.sql   (run as HEALTH_MON)
--------------------------------------------------------------------------------
create or replace view hm_target_status_v as
select t.target_id,
       t.name,
       t.target_type,
       t.endpoint,
       t.enabled_yn,
       t.interval_min,
       t.warn_threshold,
       t.crit_threshold,
       t.description,
       l.checked_at                         as last_checked_at,
       nvl(l.status, 'PENDING')             as status,
       l.http_status,
       l.response_ms,
       l.metric_value,
       l.message,
       hm_pkg.uptime_pct(t.target_id, 24)   as uptime_24h,
       hm_pkg.uptime_pct(t.target_id, 24*7) as uptime_7d,
       (select round(avg(c.response_ms))
          from hm_checks c
         where c.target_id = t.target_id
           and c.checked_at >= systimestamp - interval '1' day) as avg_ms_24h,
       (select count(*) from hm_incidents i
         where i.target_id = t.target_id and i.resolved_at is null) as open_incidents,
       case nvl(l.status, 'PENDING')
         when 'UP'       then 'u-success'
         when 'DEGRADED' then 'u-warning'
         when 'DOWN'     then 'u-danger'
         when 'UNREACHABLE' then 'u-unreachable'
         else                 'u-color-7'
       end                                   as status_css,
       case nvl(l.status, 'PENDING')
         when 'UP'       then 'fa-check-circle'
         when 'DEGRADED' then 'fa-exclamation-triangle'
         when 'DOWN'     then 'fa-times-circle'
         when 'UNREACHABLE' then 'fa-chain-broken'
         else                 'fa-clock-o'
       end                                   as status_icon
  from hm_targets t
  left join lateral (
         select c.*
           from hm_checks c
          where c.target_id = t.target_id
          order by c.checked_at desc
          fetch first 1 row only) l on 1 = 1;

create or replace view hm_incidents_v as
select i.incident_id,
       t.name                                     as target_name,
       t.target_type,
       i.severity,
       case when i.resolved_at is null then 'OPEN' else 'RESOLVED' end as state,
       i.started_at,
       i.resolved_at,
       round((cast(nvl(i.resolved_at, systimestamp) as date) - cast(i.started_at as date)) * 1440, 1)
                                                  as duration_min,
       i.check_count,
       i.first_message,
       i.last_message,
       i.target_id
  from hm_incidents i
  join hm_targets t on t.target_id = i.target_id;
