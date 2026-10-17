create or replace package body dx_api as

  c_nl constant varchar2(1) := chr(10);

  ------------------------------------------------------------------ helpers
  function current_user_name return varchar2 is
  begin
    return coalesce(sys_context('APEX$SESSION', 'APP_USER'), user);
  end current_user_name;

  function in_apex return boolean is
  begin
    return sys_context('APEX$SESSION', 'APP_USER') is not null;
  end in_apex;

  procedure log_run(p_query_id in number, p_sql in clob, p_status in varchar2,
                    p_rows in number, p_ms in number, p_error in varchar2) is
    pragma autonomous_transaction;
    l_user varchar2(255) := current_user_name;
  begin
    insert into dx_query_log (username, query_id, sql_text, status, row_count, elapsed_ms, error_msg)
    values (l_user, p_query_id, dbms_lob.substr(p_sql, 4000, 1), p_status, p_rows, p_ms, substr(p_error, 1, 4000));
    if p_query_id is not null and p_status = 'OK' then
      update dx_saved_queries
         set run_count = run_count + 1, last_run_at = systimestamp
       where query_id = p_query_id
         and (owner = l_user or is_shared = 'Y');
    end if;
    commit;
  end log_run;

  ------------------------------------------------------------------ settings
  function get_setting(p_key in varchar2, p_default in varchar2 default null) return varchar2 is
    l_val dx_settings.setting_value%type;
  begin
    select setting_value into l_val from dx_settings where setting_key = upper(p_key);
    return nvl(l_val, p_default);
  exception
    when no_data_found then return p_default;
  end get_setting;

  procedure set_setting(p_key in varchar2, p_value in varchar2, p_description in varchar2 default null) is
  begin
    merge into dx_settings s
    using (select upper(p_key) k from dual) x
       on (s.setting_key = x.k)
     when matched then update set s.setting_value = p_value,
                                  s.description = nvl(p_description, s.description)
     when not matched then insert (setting_key, setting_value, description)
                           values (x.k, p_value, p_description);
  end set_setting;

  function max_rows return pls_integer is
  begin
    return least(greatest(to_number(get_setting('MAX_ROWS', '500')), 1), 10000);
  exception
    when value_error then return 500;
  end max_rows;

  function is_admin(p_user in varchar2 default null) return boolean is
    l_user varchar2(255) := upper(nvl(p_user, current_user_name));
  begin
    -- a direct database session as the owning schema (installer, tests) is admin
    if p_user is null and not in_apex then
      return true;
    end if;
    return instr(',' || upper(replace(get_setting('ADMIN_USERS'), ' ')) || ',', ',' || l_user || ',') > 0;
  end is_admin;

  function is_admin_yn(p_user in varchar2 default null) return varchar2 is
  begin
    return case when is_admin(p_user) then 'Y' else 'N' end;
  end is_admin_yn;

  procedure require_admin is
  begin
    if not is_admin then
      raise_application_error(-20001, 'Only Data Explorer administrators can change data sources.');
    end if;
  end require_admin;

  ------------------------------------------------------------------ queries
  function normalize_sql(p_sql in clob) return clob is
    l_sql clob := p_sql;
  begin
    -- trim trailing whitespace, ';' and SQL*Plus '/' terminators
    l_sql := regexp_replace(l_sql, '([[:space:]]|;|/)+$', '');
    l_sql := regexp_replace(l_sql, '^[[:space:]]+', '');
    return l_sql;
  end normalize_sql;

  function has_result return boolean is
  begin
    return apex_collection.collection_exists('DX_RESULT');
  end has_result;

  procedure render_last_result is
    l_html clob;
    l_len  pls_integer;
    l_pos  pls_integer := 1;
  begin
    if not has_result then
      return;
    end if;
    for r in (select clob001 from apex_collections
               where collection_name = 'DX_RESULT'
               order by seq_id desc
               fetch first 1 row only) loop
      l_html := r.clob001;
    end loop;
    l_len := nvl(dbms_lob.getlength(l_html), 0);
    while l_pos <= l_len loop
      sys.htp.prn(dbms_lob.substr(l_html, 4000, l_pos));
      l_pos := l_pos + 4000;
    end loop;
  end render_last_result;

  procedure clear_result is
  begin
    if has_result then
      apex_collection.delete_collection('DX_RESULT');
    end if;
  end clear_result;

  procedure flush_run_log is
  begin
    if not apex_collection.collection_exists('DX_RUN_LOG') then
      return;
    end if;
    for r in (select c001 status, c002 error_msg, n001 row_count, n002 elapsed_ms, n003 query_id, clob001 sql_text
                from apex_collections
               where collection_name = 'DX_RUN_LOG'
               order by seq_id) loop
      log_run(r.query_id, r.sql_text, r.status, r.row_count, r.elapsed_ms, r.error_msg);
    end loop;
    apex_collection.delete_collection('DX_RUN_LOG');
  end flush_run_log;

  function object_sql(p_owner in varchar2, p_object in varchar2) return clob is
    l_cnt pls_integer;
  begin
    select count(*) into l_cnt
      from dx_catalog_v
     where owner = p_owner
       and object_name = p_object;
    if l_cnt = 0 then
      raise_application_error(-20020, 'Object ' || p_owner || '.' || p_object || ' is not in a registered data source.');
    end if;
    return 'select *' || c_nl || '  from '
      || sys.dbms_assert.enquote_name(p_owner, false) || '.'
      || sys.dbms_assert.enquote_name(p_object, false);
  end object_sql;

  ------------------------------------------------------------------ saved queries
  function save_query(p_query_id in number, p_title in varchar2, p_sql in clob,
                      p_description in varchar2 default null, p_is_shared in varchar2 default 'N') return number is
    l_id    number := p_query_id;
    l_user  varchar2(255) := current_user_name;
    l_admin varchar2(1) := is_admin_yn;
  begin
    if trim(p_title) is null then
      raise_application_error(-20030, 'Give the query a title before saving it.');
    end if;
    if p_sql is null or trim(dbms_lob.substr(p_sql, 4000, 1)) is null then
      raise_application_error(-20031, 'Enter a query before saving it.');
    end if;
    -- the text is checked by the read-only runner every time it is run
    if l_id is null then
      insert into dx_saved_queries (title, description, sql_text, owner, is_shared)
      values (trim(p_title), p_description, normalize_sql(p_sql), l_user, nvl(p_is_shared, 'N'))
      returning query_id into l_id;
    else
      update dx_saved_queries
         set title = trim(p_title), description = p_description, sql_text = normalize_sql(p_sql),
             is_shared = nvl(p_is_shared, 'N'), updated_at = systimestamp
       where query_id = l_id
         and (owner = l_user or l_admin = 'Y');
      if sql%rowcount = 0 then
        raise_application_error(-20032, 'Query ' || l_id || ' was not found or belongs to another user.');
      end if;
    end if;
    return l_id;
  end save_query;

  procedure delete_query(p_query_id in number) is
    l_user  varchar2(255) := current_user_name;
    l_admin varchar2(1) := is_admin_yn;
  begin
    delete from dx_saved_queries
     where query_id = p_query_id
       and (owner = l_user or l_admin = 'Y');
    if sql%rowcount = 0 then
      raise_application_error(-20032, 'Query ' || p_query_id || ' was not found or belongs to another user.');
    end if;
  end delete_query;

  function get_query_sql(p_query_id in number) return clob is
    l_sql   clob;
    l_user  varchar2(255) := current_user_name;
    l_admin varchar2(1) := is_admin_yn;
  begin
    select sql_text into l_sql
      from dx_saved_queries
     where query_id = p_query_id
       and (owner = l_user or is_shared = 'Y' or l_admin = 'Y');
    return l_sql;
  exception
    when no_data_found then return null;
  end get_query_sql;

  ------------------------------------------------------------------ data sources
  function add_schema_source(p_name in varchar2, p_owner in varchar2, p_description in varchar2 default null) return number is
    l_cnt pls_integer;
    l_id  number;
  begin
    require_admin;
    select count(*) into l_cnt from all_users where username = upper(trim(p_owner));
    if l_cnt = 0 then
      raise_application_error(-20040, 'Schema ' || p_owner || ' does not exist or is not visible to DATAEXP.');
    end if;
    insert into dx_data_sources (name, source_type, schema_owner, description)
    values (trim(p_name), 'SCHEMA', upper(trim(p_owner)), p_description)
    returning source_id into l_id;
    return l_id;
  end add_schema_source;

  procedure build_rest_view(p_source_id in number) is
    l_src dx_data_sources%rowtype;
    l_view varchar2(128) := 'DX_REST_' || p_source_id;
  begin
    select * into l_src from dx_data_sources where source_id = p_source_id;
    if instr(l_src.rest_columns, ';') > 0 or instr(l_src.rest_columns, '--') > 0 or instr(l_src.rest_columns, '/*') > 0
       or instr(nvl(l_src.rest_row_path, '$[*]'), '''') > 0 then
      raise_application_error(-20041, 'REST column definition contains characters that are not allowed.');
    end if;
    execute immediate 'create or replace view ' || l_view || ' as select jt.* from dx_rest_cache c, json_table(c.payload, '''
      || nvl(l_src.rest_row_path, '$[*]') || ''' columns (' || l_src.rest_columns || ')) jt where c.source_id = '
      || to_char(p_source_id);
    update dx_data_sources set view_name = l_view where source_id = p_source_id;
    begin
      execute immediate 'grant select on ' || l_view || ' to ' || c_ro_schema;
    exception
      when others then
        if sqlcode != -1917 then raise; end if;  -- read-only schema not installed
    end;
  end build_rest_view;

  function add_rest_source(p_name in varchar2, p_url in varchar2, p_columns in varchar2,
                           p_row_path in varchar2 default '$[*]', p_description in varchar2 default null) return number is
    l_id number;
  begin
    require_admin;
    if not regexp_like(p_url, '^https?://[^[:space:]]+$', 'i') then
      raise_application_error(-20042, 'Enter a full http(s) URL for the REST source.');
    end if;
    insert into dx_data_sources (name, source_type, rest_url, rest_row_path, rest_columns, description)
    values (trim(p_name), 'REST', trim(p_url), nvl(trim(p_row_path), '$[*]'), trim(p_columns), p_description)
    returning source_id into l_id;
    build_rest_view(l_id);
    return l_id;
  end add_rest_source;

  procedure set_source_enabled(p_source_id in number, p_enabled in varchar2) is
  begin
    require_admin;
    update dx_data_sources set is_enabled = case when p_enabled = 'Y' then 'Y' else 'N' end
     where source_id = p_source_id;
  end set_source_enabled;

  procedure load_rest_payload(p_source_id in number, p_payload in clob, p_http_status in number default 200) is
    l_ok pls_integer;
  begin
    require_admin;
    select count(*) into l_ok from dual where p_payload is json;
    if l_ok = 0 then
      update dx_data_sources set last_status = 'HTTP ' || p_http_status || ': response is not JSON', refreshed_at = systimestamp
       where source_id = p_source_id;
      raise_application_error(-20043, 'The REST response is not valid JSON (HTTP ' || p_http_status || ').');
    end if;
    merge into dx_rest_cache c
    using (select p_source_id id from dual) x
       on (c.source_id = x.id)
     when matched then update set c.payload = p_payload, c.http_status = p_http_status, c.fetched_at = systimestamp
     when not matched then insert (source_id, payload, http_status) values (x.id, p_payload, p_http_status);
    update dx_data_sources
       set refreshed_at = systimestamp, last_status = 'HTTP ' || p_http_status || ': OK'
     where source_id = p_source_id;
  end load_rest_payload;

  procedure refresh_rest_source(p_source_id in number) is
    l_url  dx_data_sources.rest_url%type;
    l_resp clob;
  begin
    require_admin;
    select rest_url into l_url from dx_data_sources where source_id = p_source_id and source_type = 'REST';
    l_resp := apex_web_service.make_rest_request(p_url => l_url, p_http_method => 'GET');
    load_rest_payload(p_source_id, l_resp, apex_web_service.g_status_code);
  exception
    when no_data_found then
      raise_application_error(-20044, 'REST source ' || p_source_id || ' was not found.');
  end refresh_rest_source;

end dx_api;
/
