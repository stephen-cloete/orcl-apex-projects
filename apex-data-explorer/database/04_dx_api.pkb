create or replace package body dx_api as

  c_nl constant varchar2(1) := chr(10);
  c_internal_tables constant varchar2(200) :=
    'dx_settings|dx_data_sources|dx_rest_cache|dx_saved_queries|dx_query_log';

  type t_exec is record (
    out_clob   clob,
    row_count  pls_integer := 0,
    truncated  boolean := false,
    elapsed_ms number
  );

  ------------------------------------------------------------------ helpers
  function current_user_name return varchar2 is
  begin
    return coalesce(sys_context('APEX$SESSION', 'APP_USER'), user);
  end current_user_name;

  function in_apex return boolean is
  begin
    return sys_context('APEX$SESSION', 'APP_USER') is not null;
  end in_apex;

  function esc(p_text in varchar2) return varchar2 is
  begin
    return replace(replace(replace(replace(replace(p_text,
             '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '"', '&quot;'), '''', '&#x27;');
  end esc;

  procedure append(p_clob in out nocopy clob, p_buf in out nocopy varchar2, p_text in varchar2) is
  begin
    if lengthb(p_buf) + lengthb(p_text) > 30000 then
      dbms_lob.writeappend(p_clob, length(p_buf), p_buf);
      p_buf := null;
    end if;
    p_buf := p_buf || p_text;
  end append;

  procedure flush(p_clob in out nocopy clob, p_buf in out nocopy varchar2) is
  begin
    if p_buf is not null then
      dbms_lob.writeappend(p_clob, length(p_buf), p_buf);
      p_buf := null;
    end if;
  end flush;

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
       where query_id = p_query_id;
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

  ------------------------------------------------------------------ validation
  function normalize_sql(p_sql in clob) return clob is
    l_sql clob := p_sql;
  begin
    -- trim trailing whitespace, ';' and SQL*Plus '/' terminators
    l_sql := regexp_replace(l_sql, '([[:space:]]|;|/)+$', '');
    l_sql := regexp_replace(l_sql, '^[[:space:]]+', '');
    return l_sql;
  end normalize_sql;

  function validate_sql(p_sql in clob) return varchar2 is
    l_sql varchar2(32767);
    l_chk varchar2(32767);
    l_cur integer;
  begin
    if p_sql is null or dbms_lob.getlength(p_sql) = 0 then
      return 'Enter a query to run.';
    end if;
    if dbms_lob.getlength(p_sql) > 32000 then
      return 'The query is longer than 32000 characters.';
    end if;
    l_sql := normalize_sql(p_sql);
    -- strip comments and string literals before looking for keywords
    l_chk := regexp_replace(l_sql, '/\*.*?\*/', ' ', 1, 0, 'n');
    l_chk := regexp_replace(l_chk, '--[^' || c_nl || ']*', ' ');
    l_chk := regexp_replace(l_chk, '''([^'']|'''')*''', '''''');

    if trim(l_chk) is null then
      return 'Enter a query to run.';
    elsif not regexp_like(l_chk, '^[[:space:]]*(select|with)[[:space:](]', 'i') then
      return 'Only SELECT or WITH queries can be run in Data Explorer.';
    elsif instr(l_chk, ';') > 0 then
      return 'Run one statement at a time (remove the ";" separator).';
    elsif regexp_like(l_chk, '^[[:space:]]*with[[:space:]]+(function|procedure)[[:space:]]', 'i') then
      return 'PL/SQL declarations in the WITH clause are not allowed.';
    elsif regexp_like(l_chk, '[[:space:]]for[[:space:]]+update([[:space:]]|$)', 'i') then
      return 'SELECT ... FOR UPDATE is not allowed.';
    elsif get_setting('ALLOW_DB_LINKS', 'N') = 'N' and regexp_like(l_chk, '@[[:space:]]*"?[a-z]', 'i') then
      return 'Database links are not allowed.';
    elsif regexp_like(l_chk, '(^|[^a-z0-9_$#])"?(' || c_internal_tables || ')"?([^a-z0-9_$#]|$)', 'i') then
      return 'Data Explorer''s own tables cannot be queried here; use the Saved Queries and Query Log pages.';
    end if;

    -- final word: the statement must parse as a sub-query (DDL/DML cannot)
    l_cur := dbms_sql.open_cursor;
    begin
      dbms_sql.parse(l_cur, 'select * from (' || c_nl || l_sql || c_nl || ')', dbms_sql.native);
      dbms_sql.close_cursor(l_cur);
    exception
      when others then
        if dbms_sql.is_open(l_cur) then dbms_sql.close_cursor(l_cur); end if;
        return 'The query does not parse: ' || regexp_replace(sqlerrm, '^ORA-[0-9]+: ', '');
    end;
    return null;
  end validate_sql;

  ------------------------------------------------------------------ execution
  function exec_query(p_sql in clob, p_max_rows in pls_integer, p_format in varchar2) return t_exec is
    l_res    t_exec;
    l_cur    integer;
    l_cnt    integer;
    l_desc   dbms_sql.desc_tab2;
    l_cols   integer;
    l_vc     varchar2(4000);
    l_clob   clob;
    l_blob   blob;
    l_val    varchar2(4000);
    l_buf    varchar2(32767);
    l_max    pls_integer := least(nvl(p_max_rows, max_rows), max_rows);
    l_start  timestamp with time zone := systimestamp;
    l_ignore integer;

    function csv_field(p in varchar2) return varchar2 is
    begin
      if p is null then return null; end if;
      if regexp_like(p, '[",' || c_nl || chr(13) || ']') then
        return '"' || replace(p, '"', '""') || '"';
      end if;
      return p;
    end csv_field;
  begin
    dbms_lob.createtemporary(l_res.out_clob, true, dbms_lob.call);
    l_cur := dbms_sql.open_cursor;
    dbms_sql.parse(l_cur,
      'select * from (' || c_nl || normalize_sql(p_sql) || c_nl || ') where rownum <= ' || to_char(l_max + 1),
      dbms_sql.native);
    dbms_sql.describe_columns2(l_cur, l_cols, l_desc);

    if l_cols > to_number(get_setting('MAX_COLUMNS', '100')) then
      raise_application_error(-20011, 'The query returns ' || l_cols || ' columns; the limit is '
        || get_setting('MAX_COLUMNS', '100') || '. Select fewer columns.');
    end if;

    for i in 1 .. l_cols loop
      case
        when l_desc(i).col_type = 112 then dbms_sql.define_column(l_cur, i, l_clob);
        when l_desc(i).col_type = 113 then dbms_sql.define_column(l_cur, i, l_blob);
        when l_desc(i).col_type in (1, 2, 9, 11, 12, 13, 23, 96, 100, 101, 180, 181, 182, 183, 187, 188, 208, 231, 232)
          then dbms_sql.define_column(l_cur, i, l_vc, 4000);
        else
          raise_application_error(-20010, 'Column ' || l_desc(i).col_name || ' has a data type Data Explorer '
            || 'cannot display (type code ' || l_desc(i).col_type || '). Convert it in the query, for example '
            || 'with TO_CHAR or JSON_SERIALIZE.');
      end case;
    end loop;

    -- header
    if p_format = 'HTML' then
      append(l_res.out_clob, l_buf, '<div class="t-Report t-Report--stretch t-Report--staticRowColors t-Report--rowHighlight dx-result">'
        || '<div class="t-Report-wrap"><div class="t-Report-tableWrap" style="overflow:auto;max-height:60vh">'
        || '<table class="t-Report-report" aria-label="Query results"><thead><tr>');
      for i in 1 .. l_cols loop
        append(l_res.out_clob, l_buf, '<th class="t-Report-colHead" scope="col">' || esc(l_desc(i).col_name) || '</th>');
      end loop;
      append(l_res.out_clob, l_buf, '</tr></thead><tbody>');
    else
      for i in 1 .. l_cols loop
        append(l_res.out_clob, l_buf, case when i > 1 then ',' end || csv_field(l_desc(i).col_name));
      end loop;
      append(l_res.out_clob, l_buf, chr(13) || c_nl);
    end if;

    l_ignore := dbms_sql.execute(l_cur);
    loop
      l_cnt := dbms_sql.fetch_rows(l_cur);
      exit when l_cnt = 0;
      if l_res.row_count >= l_max then
        l_res.truncated := true;
        exit;
      end if;
      l_res.row_count := l_res.row_count + 1;
      if p_format = 'HTML' then
        append(l_res.out_clob, l_buf, '<tr>');
      end if;
      for i in 1 .. l_cols loop
        case
          when l_desc(i).col_type = 112 then
            dbms_sql.column_value(l_cur, i, l_clob);
            l_val := dbms_lob.substr(l_clob, 4000, 1);
          when l_desc(i).col_type = 113 then
            dbms_sql.column_value(l_cur, i, l_blob);
            l_val := case when l_blob is not null then '[BLOB ' || dbms_lob.getlength(l_blob) || ' bytes]' end;
          else
            dbms_sql.column_value(l_cur, i, l_vc);
            l_val := l_vc;
        end case;
        if p_format = 'HTML' then
          append(l_res.out_clob, l_buf, '<td class="t-Report-cell">' || esc(l_val) || '</td>');
        else
          append(l_res.out_clob, l_buf, case when i > 1 then ',' end || csv_field(l_val));
        end if;
      end loop;
      if p_format = 'HTML' then
        append(l_res.out_clob, l_buf, '</tr>');
      else
        append(l_res.out_clob, l_buf, chr(13) || c_nl);
      end if;
    end loop;
    dbms_sql.close_cursor(l_cur);

    l_res.elapsed_ms := round(extract(day from (systimestamp - l_start)) * 86400000
                        + extract(hour from (systimestamp - l_start)) * 3600000
                        + extract(minute from (systimestamp - l_start)) * 60000
                        + extract(second from (systimestamp - l_start)) * 1000);

    if p_format = 'HTML' then
      if l_res.row_count = 0 then
        append(l_res.out_clob, l_buf, '<tr><td class="t-Report-cell" colspan="' || l_cols || '">No rows returned.</td></tr>');
      end if;
      append(l_res.out_clob, l_buf, '</tbody></table></div></div></div>');
      append(l_res.out_clob, l_buf, '<p class="dx-meta u-color-text-muted">' || l_res.row_count || ' row(s)'
        || case when l_res.truncated then ', limited to the first ' || l_max || ' rows' end
        || ' &middot; ' || l_res.elapsed_ms || ' ms</p>');
    end if;
    flush(l_res.out_clob, l_buf);
    return l_res;
  exception
    when others then
      if dbms_sql.is_open(l_cur) then dbms_sql.close_cursor(l_cur); end if;
      raise;
  end exec_query;

  function error_html(p_message in varchar2) return clob is
  begin
    return '<div class="t-Alert t-Alert--colorBG t-Alert--horizontal t-Alert--danger t-Alert--wizard dx-error" role="alert">'
      || '<div class="t-Alert-wrap"><div class="t-Alert-content"><div class="t-Alert-body">'
      || esc(p_message) || '</div></div></div></div>';
  end error_html;

  function result_html(p_sql in clob, p_max_rows in pls_integer default null, p_query_id in number default null) return clob is
    l_err varchar2(4000) := validate_sql(p_sql);
    l_res t_exec;
  begin
    if l_err is not null then
      log_run(p_query_id, p_sql, 'BLOCKED', null, null, l_err);
      return error_html(l_err);
    end if;
    l_res := exec_query(p_sql, p_max_rows, 'HTML');
    log_run(p_query_id, p_sql, 'OK', l_res.row_count, l_res.elapsed_ms, null);
    return l_res.out_clob;
  exception
    when others then
      l_err := regexp_replace(sqlerrm, '^ORA-[0-9]+: ', '');
      log_run(p_query_id, p_sql, 'ERROR', null, null, l_err);
      return error_html(l_err);
  end result_html;

  procedure render_result(p_sql in clob, p_max_rows in pls_integer default null, p_query_id in number default null) is
    l_html clob := result_html(p_sql, p_max_rows, p_query_id);
    l_len  pls_integer := dbms_lob.getlength(l_html);
    l_pos  pls_integer := 1;
  begin
    while l_pos <= l_len loop
      sys.htp.prn(dbms_lob.substr(l_html, 4000, l_pos));
      l_pos := l_pos + 4000;
    end loop;
  end render_result;

  function csv_clob(p_sql in clob, p_max_rows in pls_integer default null) return clob is
    l_err varchar2(4000) := validate_sql(p_sql);
    l_res t_exec;
  begin
    if l_err is not null then
      log_run(null, p_sql, 'BLOCKED', null, null, l_err);
      raise_application_error(-20002, l_err);
    end if;
    l_res := exec_query(p_sql, p_max_rows, 'CSV');
    log_run(null, p_sql, 'OK', l_res.row_count, l_res.elapsed_ms, null);
    return l_res.out_clob;
  end csv_clob;

  procedure download_csv(p_sql in clob, p_filename in varchar2 default 'data-explorer.csv', p_max_rows in pls_integer default null) is
    l_csv clob := csv_clob(p_sql, p_max_rows);
    l_len pls_integer := dbms_lob.getlength(l_csv);
    l_pos pls_integer := 1;
  begin
    sys.owa_util.mime_header('text/csv', false, 'UTF-8');
    sys.htp.p('Content-Disposition: attachment; filename="'
      || regexp_replace(nvl(p_filename, 'data-explorer.csv'), '[^A-Za-z0-9._-]', '_') || '"');
    sys.htp.p('Cache-Control: no-store');
    sys.owa_util.http_header_close;
    while l_pos <= l_len loop
      sys.htp.prn(dbms_lob.substr(l_csv, 4000, l_pos));
      l_pos := l_pos + 4000;
    end loop;
  end download_csv;

  function row_count(p_sql in clob) return number is
    l_err varchar2(4000) := validate_sql(p_sql);
    l_cnt number;
  begin
    if l_err is not null then
      raise_application_error(-20002, l_err);
    end if;
    execute immediate 'select count(*) from (' || c_nl || normalize_sql(p_sql) || c_nl || ')' into l_cnt;
    return l_cnt;
  end row_count;

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
    l_err   varchar2(4000) := validate_sql(p_sql);
    l_id    number := p_query_id;
    l_user  varchar2(255) := current_user_name;
    l_admin varchar2(1) := is_admin_yn;
  begin
    if trim(p_title) is null then
      raise_application_error(-20030, 'Give the query a title before saving it.');
    end if;
    if l_err is not null then
      raise_application_error(-20031, l_err);
    end if;
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
