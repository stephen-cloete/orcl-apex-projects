create or replace package dx_api authid definer as
--------------------------------------------------------------------------------
-- Data Explorer API (run as DATAEXP)
-- Ad-hoc, read-only query and analysis over registered data sources:
--   * SCHEMA sources: tables/views of an owner DATAEXP has SELECT on
--   * REST sources  : a JSON endpoint cached in DX_REST_CACHE and exposed as a
--                     relational view (DX_REST_<id>) through JSON_TABLE
-- Free-text queries do NOT run here: they run in the read-only schema
-- (DATAEXP_RO.DX_EXEC, see 07_admin_readonly.sql) on page 6. DX_API shows the
-- last result, writes the run log and manages everything else.
--------------------------------------------------------------------------------
  c_version   constant varchar2(10)  := '1.1.0';
  c_ro_schema constant varchar2(128) := 'DATAEXP_RO';  -- runs the free-text queries

  -- settings
  function get_setting(p_key in varchar2, p_default in varchar2 default null) return varchar2;
  procedure set_setting(p_key in varchar2, p_value in varchar2, p_description in varchar2 default null);
  function max_rows return pls_integer;
  function is_admin(p_user in varchar2 default null) return boolean;
  function is_admin_yn(p_user in varchar2 default null) return varchar2;

  function normalize_sql(p_sql in clob) return clob;

  -- query building and results (execution happens in DATAEXP_RO.DX_EXEC)
  function object_sql(p_owner in varchar2, p_object in varchar2) return clob;
  procedure render_last_result;              -- prints collection DX_RESULT
  function has_result return boolean;
  procedure clear_result;
  procedure flush_run_log;                   -- DX_RUN_LOG collection -> DX_QUERY_LOG

  -- saved queries
  function save_query(p_query_id in number, p_title in varchar2, p_sql in clob,
                      p_description in varchar2 default null, p_is_shared in varchar2 default 'N') return number;
  procedure delete_query(p_query_id in number);
  function get_query_sql(p_query_id in number) return clob;

  -- data sources
  function add_schema_source(p_name in varchar2, p_owner in varchar2, p_description in varchar2 default null) return number;
  function add_rest_source(p_name in varchar2, p_url in varchar2, p_columns in varchar2,
                           p_row_path in varchar2 default '$[*]', p_description in varchar2 default null) return number;
  procedure set_source_enabled(p_source_id in number, p_enabled in varchar2);
  procedure load_rest_payload(p_source_id in number, p_payload in clob, p_http_status in number default 200);
  procedure refresh_rest_source(p_source_id in number);
end dx_api;
/
