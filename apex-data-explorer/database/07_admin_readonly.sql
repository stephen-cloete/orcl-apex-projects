--------------------------------------------------------------------------------
-- Data Explorer - 07_admin_readonly.sql
-- Run as: ADMIN (or a DBA user), after install_db.sql.
-- Creates the query runner DATAEXP_RO.DX_EXEC plus private synonyms for the
-- objects DATAEXP_RO may read. DATAEXP_RO itself is never granted a system
-- privilege: ADMIN creates these objects in its schema on its behalf.
--
-- Why a separate schema: every free-text Workbench query runs on page 6, whose
-- parsing schema is switched to DATAEXP_RO in the application's Initialization
-- PL/SQL Code (apex_util.set_parsing_schema_for_request). DX_EXEC is definer
-- rights in DATAEXP_RO, so validation (DBMS_SQL.PARSE) and execution
-- (APEX_EXEC) both see only DATAEXP_RO's SELECT grants.
-- Idempotent.
--------------------------------------------------------------------------------
set define off verify off feedback off serveroutput on
whenever sqlerror exit failure rollback

create or replace package dataexp_ro.dx_exec authid definer as
  -- runs free-text queries for Data Explorer; owned by the read-only schema
  c_hard_max_rows constant pls_integer := 10000;  -- absolute cap, whatever the caller asks for
  c_max_columns   constant pls_integer := 100;

  -- null when p_sql is one query this schema may run, otherwise the reason.
  -- Decided by the parser: the text is parsed as an inline view, so only a
  -- single SELECT/WITH query can pass; DML, DDL, PL/SQL, several statements
  -- and objects without a SELECT grant fail to parse.
  function check_sql(p_sql in clob) return varchar2;

  -- validates and runs p_sql through APEX_EXEC with p_max_rows passed to it;
  -- returns the formatted result grid (or an error box)
  function result_html(p_sql      in clob,
                       p_max_rows in pls_integer,
                       p_rows     out number,
                       p_status   out varchar2,
                       p_error    out varchar2,
                       p_ms       out number) return clob;

  -- same as result_html, CSV with raw values
  function result_csv(p_sql      in clob,
                      p_max_rows in pls_integer,
                      p_rows     out number,
                      p_status   out varchar2,
                      p_error    out varchar2,
                      p_ms       out number) return clob;

  -- page 6: run and keep the grid in collection DX_RESULT; queue a log row in
  -- DX_RUN_LOG (DATAEXP writes it to DX_QUERY_LOG on the next page view)
  procedure run_to_collection(p_sql in clob, p_max_rows in pls_integer, p_query_id in number default null);

  -- page 6: stream the result as a CSV download
  procedure download_csv(p_sql in clob, p_filename in varchar2, p_max_rows in pls_integer, p_query_id in number default null);
end dx_exec;
/

create or replace package body dataexp_ro.dx_exec as

  c_nl constant varchar2(1) := chr(10);

  type t_col is record (name varchar2(128), heading varchar2(200), data_type pls_integer, kind varchar2(10));
  type t_cols is table of t_col index by pls_integer;

  ------------------------------------------------------------------ helpers
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

  function clean_error(p_msg in varchar2) return varchar2 is
  begin
    return regexp_replace(regexp_replace(p_msg, '(^|' || c_nl || ')ORA-[0-9]+: ', '\1'), c_nl || '.*$', '', 1, 1, 'n');
  end clean_error;

  function normalize_sql(p_sql in clob) return varchar2 is
  begin
    -- trailing terminators a user may paste from a script
    return regexp_replace(regexp_replace(dbms_lob.substr(p_sql, 32000, 1), '([[:space:]]|;|/)+$', ''), '^[[:space:]]+', '');
  end normalize_sql;

  function wrapped(p_sql in varchar2) return varchar2 is
  begin
    return 'select * from (' || c_nl || p_sql || c_nl || ')';
  end wrapped;

  -- readable heading for a dynamic column: SALE_MONTH -> Sale month
  function heading(p_name in varchar2) return varchar2 is
  begin
    if p_name <> upper(p_name) then
      return p_name;  -- quoted mixed-case alias: keep as written
    end if;
    return upper(substr(p_name, 1, 1)) || lower(replace(substr(p_name, 2), '_', ' '));
  end heading;

  function fmt_number(p_name in varchar2, p_val in number) return varchar2 is
    l_txt varchar2(100);
  begin
    if p_val is null then
      return null;
    elsif regexp_like(p_name, '(^|_)(ID|YEAR|CODE|NO|NUM)$') then
      return to_char(p_val, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
    elsif regexp_like(p_name, 'AMOUNT|PRICE|COST|REVENUE|TOTAL|VALUE|BALANCE|SALARY') then
      l_txt := to_char(p_val, 'FM999G999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS=''.,''');
    elsif p_val = trunc(p_val) then
      l_txt := to_char(p_val, 'FM999G999G999G999G999G990', 'NLS_NUMERIC_CHARACTERS=''.,''');
    else
      l_txt := rtrim(to_char(p_val, 'FM999G999G999G999G990D999999', 'NLS_NUMERIC_CHARACTERS=''.,'''), '0');
    end if;
    if instr(l_txt, '#') > 0 then
      l_txt := to_char(p_val, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
    end if;
    return l_txt;
  end fmt_number;

  function fmt_date(p_name in varchar2, p_val in date) return varchar2 is
  begin
    if p_val is null then
      return null;
    elsif regexp_like(p_name, 'MONTH') and p_val = trunc(p_val, 'MM') then
      return to_char(p_val, 'MON-YYYY', 'NLS_DATE_LANGUAGE=ENGLISH');
    elsif p_val = trunc(p_val) then
      return to_char(p_val, 'DD-MON-YYYY', 'NLS_DATE_LANGUAGE=ENGLISH');
    end if;
    return to_char(p_val, 'DD-MON-YYYY HH24:MI', 'NLS_DATE_LANGUAGE=ENGLISH');
  end fmt_date;

  -- display (p_raw = false) or CSV (p_raw = true) text for one cell
  function cell(p_ctx in apex_exec.t_context, p_pos in pls_integer, p_col in t_col, p_raw in boolean) return varchar2 is
    l_num  number;
    l_date date;
    l_clob clob;
    l_blob blob;
  begin
    case p_col.data_type
      when apex_exec.c_data_type_number then
        l_num := apex_exec.get_number(p_ctx, p_pos);
        return case when p_raw then to_char(l_num, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''') else fmt_number(p_col.name, l_num) end;
      when apex_exec.c_data_type_binary_number then
        l_num := apex_exec.get_number(p_ctx, p_pos);
        return case when p_raw then to_char(l_num, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''') else fmt_number(p_col.name, l_num) end;
      when apex_exec.c_data_type_date then
        l_date := apex_exec.get_date(p_ctx, p_pos);
        return case when p_raw then to_char(l_date, 'YYYY-MM-DD HH24:MI:SS') else fmt_date(p_col.name, l_date) end;
      when apex_exec.c_data_type_timestamp then
        return to_char(apex_exec.get_timestamp(p_ctx, p_pos), 'YYYY-MM-DD HH24:MI:SS.FF3');
      when apex_exec.c_data_type_timestamp_tz then
        return to_char(apex_exec.get_timestamp_tz(p_ctx, p_pos), 'YYYY-MM-DD HH24:MI:SS.FF3 TZH:TZM');
      when apex_exec.c_data_type_timestamp_ltz then
        return to_char(apex_exec.get_timestamp_ltz(p_ctx, p_pos), 'YYYY-MM-DD HH24:MI:SS.FF3');
      when apex_exec.c_data_type_clob then
        l_clob := apex_exec.get_clob(p_ctx, p_pos);
        return dbms_lob.substr(l_clob, 4000, 1);
      when apex_exec.c_data_type_blob then
        l_blob := apex_exec.get_blob(p_ctx, p_pos);
        return case when l_blob is not null then '[BLOB ' || dbms_lob.getlength(l_blob) || ' bytes]' end;
      else
        return apex_exec.get_varchar2(p_ctx, p_pos);
    end case;
  exception
    when others then
      return '[' || lower(p_col.kind) || ' value]';
  end cell;

  function elapsed_ms(p_start in timestamp with time zone) return number is
    l_diff interval day to second := systimestamp - p_start;
  begin
    return round(extract(day from l_diff) * 86400000 + extract(hour from l_diff) * 3600000
               + extract(minute from l_diff) * 60000 + extract(second from l_diff) * 1000);
  end elapsed_ms;

  procedure assert_read_only is
    l_ctx    apex_exec.t_context;
    l_schema varchar2(128);
  begin
    -- APEX_EXEC parses as the page's parsing schema; refuse to run unless that
    -- is this read-only schema (page 6 switches to it in the init code)
    l_ctx := apex_exec.open_query_context(
               p_location  => apex_exec.c_location_local_db,
               p_sql_query => 'select sys_context(''USERENV'', ''CURRENT_SCHEMA'') from dual',
               p_max_rows  => 1);
    if apex_exec.next_row(l_ctx) then
      l_schema := apex_exec.get_varchar2(l_ctx, 1);
    end if;
    apex_exec.close(l_ctx);
    if l_schema is null or l_schema <> $$PLSQL_UNIT_OWNER then
      raise_application_error(-20050, 'Queries can only run from the Data Explorer run page (read-only parsing schema).');
    end if;
  exception
    when others then
      apex_exec.close(l_ctx);
      raise;
  end assert_read_only;

  ------------------------------------------------------------------ validation
  function check_sql(p_sql in clob) return varchar2 is
    l_sql  varchar2(32767);
    l_cur  integer;
    l_cols integer;
    l_desc dbms_sql.desc_tab2;
  begin
    if p_sql is null or dbms_lob.getlength(p_sql) = 0 then
      return 'Enter a query to run.';
    elsif dbms_lob.getlength(p_sql) > 32000 then
      return 'The query is longer than 32000 characters.';
    end if;
    l_sql := normalize_sql(p_sql);
    if l_sql is null then
      return 'Enter a query to run.';
    end if;
    -- parsed (never executed) by this schema as an inline view: the parser
    -- rejects anything that is not exactly one query, and any object this
    -- schema has no SELECT grant on
    l_cur := dbms_sql.open_cursor;
    begin
      dbms_sql.parse(l_cur, wrapped(l_sql), dbms_sql.native);
      dbms_sql.describe_columns2(l_cur, l_cols, l_desc);
      dbms_sql.close_cursor(l_cur);
    exception
      when others then
        if dbms_sql.is_open(l_cur) then dbms_sql.close_cursor(l_cur); end if;
        return 'Only a single SELECT or WITH query on objects you can read is allowed: ' || clean_error(sqlerrm);
    end;
    if l_cols > c_max_columns then
      return 'The query returns ' || l_cols || ' columns; the limit is ' || c_max_columns || '. Select fewer columns.';
    end if;
    return null;
  end check_sql;

  ------------------------------------------------------------------ execution
  function run_query(p_sql      in clob,
                     p_max_rows in pls_integer,
                     p_format   in varchar2,
                     p_rows     out number,
                     p_status   out varchar2,
                     p_error    out varchar2,
                     p_ms       out number) return clob is
    l_out   clob;
    l_buf   varchar2(32767);
    l_ctx   apex_exec.t_context;
    l_cols  t_cols;
    l_ncol  pls_integer;
    l_cap   pls_integer := least(greatest(nvl(p_max_rows, 100), 1), c_hard_max_rows);
    l_more  boolean := false;
    l_start timestamp with time zone := systimestamp;
    l_val   varchar2(4000);
    l_col   apex_exec.t_column;

    function csv_field(p in varchar2) return varchar2 is
    begin
      if p is null then return null; end if;
      if regexp_like(p, '[",' || c_nl || chr(13) || ']') then
        return '"' || replace(p, '"', '""') || '"';
      end if;
      return p;
    end csv_field;
  begin
    p_rows := 0;
    dbms_lob.createtemporary(l_out, true, dbms_lob.call);
    p_error := check_sql(p_sql);
    if p_error is not null then
      p_status := 'BLOCKED';
      raise_application_error(-20051, p_error);
    end if;
    assert_read_only;

    -- the validated text, unchanged, with the row cap enforced by APEX_EXEC;
    -- one extra row is requested only to tell the user the result was cut
    l_ctx := apex_exec.open_query_context(
               p_location  => apex_exec.c_location_local_db,
               p_sql_query => wrapped(normalize_sql(p_sql)),
               p_max_rows  => l_cap + 1);
    l_ncol := apex_exec.get_column_count(l_ctx);
    for i in 1 .. l_ncol loop
      l_col := apex_exec.get_column(l_ctx, i);
      l_cols(i).name      := l_col.name;
      l_cols(i).heading   := heading(l_col.name);
      l_cols(i).data_type := l_col.data_type;
      l_cols(i).kind      := case when l_col.data_type in (apex_exec.c_data_type_number, apex_exec.c_data_type_binary_number) then 'NUMBER'
                                  when l_col.data_type in (apex_exec.c_data_type_date, apex_exec.c_data_type_timestamp,
                                                           apex_exec.c_data_type_timestamp_tz, apex_exec.c_data_type_timestamp_ltz) then 'DATE'
                                  else 'TEXT' end;
    end loop;

    if p_format = 'HTML' then
      append(l_out, l_buf, '<div class="t-Report t-Report--stretch t-Report--staticRowColors t-Report--rowHighlight dx-result">'
        || '<div class="t-Report-wrap"><div class="t-Report-tableWrap dx-scroll">'
        || '<table class="t-Report-report" aria-label="Query results"><thead><tr>');
      for i in 1 .. l_ncol loop
        append(l_out, l_buf, '<th class="t-Report-colHead' || case when l_cols(i).kind = 'NUMBER' then ' dx-num' end
          || '" scope="col" title="' || esc(l_cols(i).name) || '">' || esc(l_cols(i).heading) || '</th>');
      end loop;
      append(l_out, l_buf, '</tr></thead><tbody>');
    else
      for i in 1 .. l_ncol loop
        append(l_out, l_buf, case when i > 1 then ',' end || csv_field(l_cols(i).name));
      end loop;
      append(l_out, l_buf, chr(13) || c_nl);
    end if;

    while apex_exec.next_row(l_ctx) loop
      if p_rows >= l_cap then
        l_more := true;
        exit;
      end if;
      p_rows := p_rows + 1;
      if p_format = 'HTML' then
        append(l_out, l_buf, '<tr>');
      end if;
      for i in 1 .. l_ncol loop
        l_val := cell(l_ctx, i, l_cols(i), p_format <> 'HTML');
        if p_format = 'HTML' then
          append(l_out, l_buf, '<td class="t-Report-cell' || case when l_cols(i).kind = 'NUMBER' then ' dx-num' end
            || '">' || esc(l_val) || '</td>');
        else
          append(l_out, l_buf, case when i > 1 then ',' end || csv_field(l_val));
        end if;
      end loop;
      if p_format = 'HTML' then
        append(l_out, l_buf, '</tr>');
      else
        append(l_out, l_buf, chr(13) || c_nl);
      end if;
    end loop;
    apex_exec.close(l_ctx);
    p_ms := elapsed_ms(l_start);

    if p_format = 'HTML' then
      if p_rows = 0 then
        append(l_out, l_buf, '<tr><td class="t-Report-cell" colspan="' || l_ncol || '">No rows returned.</td></tr>');
      end if;
      append(l_out, l_buf, '</tbody></table></div></div></div>');
      append(l_out, l_buf, '<p class="dx-meta u-color-text-muted">'
        || to_char(p_rows, 'FM999G999G990', 'NLS_NUMERIC_CHARACTERS=''.,''') || ' row(s)'
        || case when l_more then ', limited to the first ' || l_cap || ' rows' end
        || ' &middot; ' || p_ms || ' ms</p>');
    end if;
    flush(l_out, l_buf);
    p_status := 'OK';
    return l_out;
  exception
    when others then
      apex_exec.close(l_ctx);
      p_status := nvl(p_status, 'ERROR');
      p_error  := nvl(p_error, clean_error(sqlerrm));
      p_ms     := elapsed_ms(l_start);
      if p_format = 'HTML' then
        return '<div class="t-Alert t-Alert--colorBG t-Alert--horizontal t-Alert--danger t-Alert--wizard dx-error" role="alert">'
          || '<div class="t-Alert-wrap"><div class="t-Alert-content"><div class="t-Alert-body">'
          || esc(p_error) || '</div></div></div></div>';
      end if;
      return null;
  end run_query;

  function result_html(p_sql in clob, p_max_rows in pls_integer, p_rows out number, p_status out varchar2,
                       p_error out varchar2, p_ms out number) return clob is
  begin
    return run_query(p_sql, p_max_rows, 'HTML', p_rows, p_status, p_error, p_ms);
  end result_html;

  function result_csv(p_sql in clob, p_max_rows in pls_integer, p_rows out number, p_status out varchar2,
                      p_error out varchar2, p_ms out number) return clob is
  begin
    return run_query(p_sql, p_max_rows, 'CSV', p_rows, p_status, p_error, p_ms);
  end result_csv;

  procedure queue_log(p_sql in clob, p_query_id in number, p_status in varchar2, p_rows in number, p_ms in number, p_error in varchar2) is
  begin
    if not apex_collection.collection_exists('DX_RUN_LOG') then
      apex_collection.create_collection('DX_RUN_LOG');
    end if;
    apex_collection.add_member(
      p_collection_name => 'DX_RUN_LOG',
      p_c001            => p_status,
      p_c002            => substr(p_error, 1, 4000),
      p_n001            => p_rows,
      p_n002            => p_ms,
      p_n003            => p_query_id,
      p_clob001         => p_sql);
  end queue_log;

  procedure run_to_collection(p_sql in clob, p_max_rows in pls_integer, p_query_id in number default null) is
    l_html   clob;
    l_rows   number;
    l_status varchar2(10);
    l_error  varchar2(4000);
    l_ms     number;
  begin
    l_html := result_html(p_sql, p_max_rows, l_rows, l_status, l_error, l_ms);
    apex_collection.create_or_truncate_collection('DX_RESULT');
    apex_collection.add_member(p_collection_name => 'DX_RESULT', p_c001 => l_status, p_n001 => l_rows, p_clob001 => l_html);
    queue_log(p_sql, p_query_id, l_status, l_rows, l_ms, l_error);
  end run_to_collection;

  procedure download_csv(p_sql in clob, p_filename in varchar2, p_max_rows in pls_integer, p_query_id in number default null) is
    l_csv    clob;
    l_rows   number;
    l_status varchar2(10);
    l_error  varchar2(4000);
    l_ms     number;
    l_len    pls_integer;
    l_pos    pls_integer := 1;
  begin
    l_csv := result_csv(p_sql, p_max_rows, l_rows, l_status, l_error, l_ms);
    queue_log(p_sql, p_query_id, l_status, l_rows, l_ms, l_error);
    if l_status <> 'OK' then
      raise_application_error(-20052, l_error);
    end if;
    l_len := dbms_lob.getlength(l_csv);
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

end dx_exec;
/

-- private synonyms so users can write "from demo_sales" instead of the owner prefix
declare
  l_cnt pls_integer := 0;
begin
  for r in (select p.table_name
              from dba_tab_privs p
             where p.grantee = 'DATAEXP_RO'
               and p.owner = 'DATAEXP'
               and p.privilege = 'SELECT') loop
    execute immediate 'create or replace synonym DATAEXP_RO."' || r.table_name || '" for DATAEXP."' || r.table_name || '"';
    l_cnt := l_cnt + 1;
  end loop;
  dbms_output.put_line(l_cnt || ' synonym(s) in DATAEXP_RO');
end;
/

-- DATAEXP (app pages, smoke test) may call the runner; this grants nothing to DATAEXP_RO
grant execute on dataexp_ro.dx_exec to DATAEXP;

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from dba_objects where owner = 'DATAEXP_RO' and status <> 'VALID';
  if l_cnt > 0 then
    raise_application_error(-20000, l_cnt || ' invalid object(s) in DATAEXP_RO');
  end if;
  select count(*) into l_cnt from dba_sys_privs where grantee = 'DATAEXP_RO';
  dbms_output.put_line('DATAEXP_RO.DX_EXEC valid; DATAEXP_RO system privileges: ' || l_cnt);
end;
/
