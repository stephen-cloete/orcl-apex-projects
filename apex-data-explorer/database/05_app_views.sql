--------------------------------------------------------------------------------
-- Data Explorer - 05_app_views.sql   (run as DATAEXP)
-- Row-filtered views used by the APEX pages.
--------------------------------------------------------------------------------
create or replace view dx_saved_queries_v as
select q.query_id,
       q.title,
       q.description,
       q.sql_text,
       q.owner,
       q.is_shared,
       q.run_count,
       q.last_run_at,
       q.created_at,
       q.updated_at
  from dx_saved_queries q
 where q.owner = coalesce(sys_context('APEX$SESSION', 'APP_USER'), user)
    or q.is_shared = 'Y'
    or dx_api.is_admin_yn = 'Y'
/

create or replace view dx_query_log_v as
select l.log_id,
       l.username,
       l.query_id,
       l.sql_text,
       l.status,
       l.row_count,
       l.elapsed_ms,
       l.error_msg,
       l.run_at
  from dx_query_log l
 where l.username = coalesce(sys_context('APEX$SESSION', 'APP_USER'), user)
    or dx_api.is_admin_yn = 'Y'
/
