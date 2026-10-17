--------------------------------------------------------------------------------
-- Data Explorer - smoke test (run as DATAEXP, after the app is installed)
--   sql DATAEXP/<pw>@<service> @tests/smoke_test.sql <APP_ID>
-- Free-text query checks run inside an APEX session on page 6 of the app,
-- exactly like the Workbench: parsing schema DATAEXP_RO, APEX_EXEC, server cap.
-- Prints PASS/FAIL per check and exits non-zero if any check fails.
-- Leaves no test data behind (test rows are removed at the end).
--------------------------------------------------------------------------------
set define on verify off feedback off serveroutput on size unlimited
whenever sqlerror exit failure rollback
define dx_app_id = '&1'

declare
  l_fail pls_integer := 0;
  l_pass pls_integer := 0;
  l_cnt  number;
  l_txt  varchar2(4000);
  l_clob clob;
  l_id   number;
  l_src  number;
  l_rows number;
  l_st   varchar2(30);
  l_err  varchar2(4000);
  l_ms   number;

  procedure check_(p_name in varchar2, p_ok in boolean, p_detail in varchar2 default null) is
  begin
    if p_ok then
      l_pass := l_pass + 1;
      dbms_output.put_line('PASS  ' || p_name || case when p_detail is not null then '  [' || p_detail || ']' end);
    else
      l_fail := l_fail + 1;
      dbms_output.put_line('FAIL  ' || p_name || case when p_detail is not null then '  [' || p_detail || ']' end);
    end if;
  end check_;

  -- runs p_sql the way the Workbench does (read-only runner, APEX_EXEC)
  function run_(p_sql in varchar2, p_max in pls_integer default 100) return clob is
  begin
    return dataexp_ro.dx_exec.result_html(p_sql, p_max, l_rows, l_st, l_err, l_ms);
  end run_;

  procedure rejected(p_name in varchar2, p_sql in varchar2) is
    l_html clob;
  begin
    l_html := run_(p_sql);
    check_('rejects ' || p_name, l_st = 'BLOCKED' and instr(l_html, 'dx-error') > 0, substr(l_err, 1, 160));
  end rejected;
begin
  dbms_output.put_line('Data Explorer smoke test - dx_api ' || dx_api.c_version || ' - ' || to_char(systimestamp, 'YYYY-MM-DD HH24:MI:SS TZH:TZM'));

  -- 1. objects
  select count(*) into l_cnt from user_objects where status <> 'VALID';
  check_('no invalid objects in DATAEXP', l_cnt = 0, l_cnt || ' invalid');
  select count(*) into l_cnt from user_tables
   where table_name in ('DX_SETTINGS','DX_DATA_SOURCES','DX_REST_CACHE','DX_SAVED_QUERIES','DX_QUERY_LOG',
                        'DEMO_REGIONS','DEMO_PRODUCTS','DEMO_SALES');
  check_('8 tables present', l_cnt = 8, to_char(l_cnt));
  select count(*) into l_cnt from demo_sales;
  check_('demo data loaded', l_cnt = 1000, l_cnt || ' sales rows');

  -- 2. catalog
  select count(*) into l_cnt from dx_catalog_v where object_name like 'DEMO%';
  check_('catalog lists demo objects', l_cnt = 4, l_cnt || ' objects');
  select count(*) into l_cnt from dx_catalog_v where object_name like 'DX\_%' escape '\';
  check_('catalog hides internal DX_ tables', l_cnt = 0, to_char(l_cnt));
  select count(*) into l_cnt from dx_columns_v where table_name = 'DEMO_SALES';
  check_('column metadata for DEMO_SALES', l_cnt = 6, l_cnt || ' columns');

  -- 3. read-only runner: privileges and validation by parsing
  select count(*) into l_cnt from all_users where username = 'DATAEXP_RO';
  check_('read-only schema DATAEXP_RO exists', l_cnt = 1);
  select count(*) into l_cnt from all_tab_privs
   where grantee = 'DATAEXP_RO' and table_schema = user and privilege <> 'SELECT';
  check_('DATAEXP grants DATAEXP_RO nothing but SELECT', l_cnt = 0, l_cnt || ' other privilege(s)');
  select count(*) into l_cnt from all_tab_privs
   where grantee = 'DATAEXP_RO' and table_schema = user and table_name like 'DX\_%' escape '\'
     and table_name not like 'DX\_REST\_%' escape '\';
  check_('DATAEXP_RO cannot read Data Explorer tables', l_cnt = 0, l_cnt || ' grant(s)');
  check_('parser accepts plain SELECT', dataexp_ro.dx_exec.check_sql('select * from demo_sales') is null,
         dataexp_ro.dx_exec.check_sql('select * from demo_sales'));
  check_('parser accepts WITH + trailing ;', dataexp_ro.dx_exec.check_sql('with x as (select 1 n from dual) select n from x;') is null);
  check_('parser accepts ; inside a literal', dataexp_ro.dx_exec.check_sql('select ''a;b'' txt from dual') is null);

  -- an APEX session on the run page: parsing schema switches to DATAEXP_RO
  apex_session.create_session(p_app_id => &dx_app_id, p_page_id => 6, p_username => 'SMOKE_TEST');
  rejected('DML (DELETE)',           'delete from demo_sales');
  rejected('DML (UPDATE)',           'update demo_sales set amount = 0');
  rejected('DDL (DROP)',             'drop table demo_sales');
  rejected('DDL (CREATE)',           'create table dx_smoke (n number)');
  rejected('multi-statement',        'select 1 from dual; delete from demo_sales');
  rejected('multi-statement (DDL)',  'select 1 from dual; drop table demo_sales');
  rejected('PL/SQL block',           'begin null; end;');
  rejected('WITH FUNCTION',          'with function f return number is begin return 1; end; select f from dual');
  rejected('SELECT ... FOR UPDATE',  'select * from demo_sales for update');
  rejected('SELECT on non-granted table (DX_SETTINGS)',  'select * from ' || user || '.dx_settings');
  rejected('SELECT on non-granted table (DX_QUERY_LOG)', 'select * from ' || user || '.dx_query_log');
  rejected('SELECT on non-granted dictionary view',      'select * from dba_users');
  rejected('unparseable query',      'select from where');
  select count(*) into l_cnt from demo_sales;
  check_('rejected statements changed nothing', l_cnt = 1000, l_cnt || ' sales rows');

  -- 4. execution through APEX_EXEC as DATAEXP_RO
  l_clob := run_('select sys_context(''USERENV'', ''CURRENT_SCHEMA'') as parsing_schema from dual');
  check_('query executes as DATAEXP_RO', l_st = 'OK' and instr(l_clob, '>DATAEXP_RO<') > 0, nvl(l_err, l_st));
  l_clob := run_('select country, sum(amount) amount from demo_sales_summary_v group by country order by 1', 50);
  check_('HTML result renders table', l_st = 'OK' and instr(l_clob, '<table') > 0 and instr(l_clob, 'South Africa') > 0,
         regexp_substr(l_clob, '[0-9,]+ row\(s\)[^<]*'));
  l_clob := run_('select * from demo_sales', 10);
  check_('row cap enforced on the server (10)', l_rows = 10 and instr(l_clob, 'limited to the first 10 rows') > 0,
         regexp_substr(l_clob, '[0-9,]+ row\(s\)[^<]*'));
  l_clob := run_('select level n from dual connect by level <= 10050', 999999);
  check_('hard cap of 10000 rows whatever is requested', l_rows = 10000, l_rows || ' rows');
  l_clob := dataexp_ro.dx_exec.result_csv('select region_id, region_name from demo_regions order by 1', 3, l_rows, l_st, l_err, l_ms);
  check_('CSV export capped too', l_rows = 3 and l_clob like 'REGION_ID,REGION_NAME' || chr(13) || chr(10) || '1,Gauteng%',
         dbms_lob.substr(l_clob, 40, 1));
  l_clob := run_('select 1234567.5 as amount, 1234567 as quantity, 42 as region_id, date ''2026-03-01'' as sale_month from dual');
  check_('numbers right-aligned with separators', instr(l_clob, 'dx-num">1,234,567.50<') > 0 and instr(l_clob, 'dx-num">1,234,567<') > 0
         and instr(l_clob, 'dx-num">42<') > 0, regexp_substr(l_clob, '<td[^<]*1,234[^<]*'));
  check_('month values shown as MON-YYYY', instr(l_clob, '>MAR-2026<') > 0);
  check_('readable column headings', instr(l_clob, '>Sale month<') > 0 and instr(l_clob, '>Region id<') > 0);
  l_clob := run_('select ''<script>x</script>'' as html from dual');
  check_('HTML output is escaped', instr(l_clob, '<script>') = 0 and instr(l_clob, chr(38) || 'lt;script' || chr(38) || 'gt;') > 0);
  l_clob := run_('select to_clob(''clob value'') c, systimestamp ts from dual');
  check_('CLOB/TIMESTAMP columns render', l_st = 'OK' and instr(l_clob, 'clob value') > 0, nvl(l_err, l_st));
  apex_session.delete_session;

  -- outside the run page the runner refuses to execute (no fallback to DATAEXP)
  apex_session.create_session(p_app_id => &dx_app_id, p_page_id => 1, p_username => 'SMOKE_TEST');
  l_clob := run_('select 1 from dual');
  check_('runner refuses to execute outside the read-only page', l_st = 'ERROR', substr(l_err, 1, 120));
  apex_session.delete_session;

  l_txt := dbms_lob.substr(dx_api.object_sql(user, 'DEMO_SALES'), 4000, 1);
  check_('object_sql builds quoted SELECT', l_txt like 'select *%"' || user || '"."DEMO_SALES"', replace(l_txt, chr(10), ' '));

  -- 5. saved queries
  l_id := dx_api.save_query(null, 'SMOKE TEST query', 'select count(*) cnt from demo_sales', 'temporary', 'N');
  check_('save_query inserts', l_id is not null, 'query_id ' || l_id);
  l_id := dx_api.save_query(l_id, 'SMOKE TEST query', 'select count(*) cnt from demo_regions', 'temporary', 'Y');
  commit; -- saved row must be committed before the autonomous run log updates it
  check_('save_query updates', dbms_lob.substr(dx_api.get_query_sql(l_id), 100, 1) like '%demo_regions%');
  begin
    l_id := dx_api.save_query(null, 'SMOKE TEST bad', '   ');
    check_('save_query rejects an empty query', false);
  exception when others then
    check_('save_query rejects an empty query', sqlcode = -20031, sqlerrm);
  end;
  -- run log written by DATAEXP from the queue page 6 fills
  apex_session.create_session(p_app_id => &dx_app_id, p_page_id => 6, p_username => 'SMOKE_TEST');
  dataexp_ro.dx_exec.run_to_collection(dx_api.get_query_sql(l_id), 10, l_id);
  dataexp_ro.dx_exec.run_to_collection('delete from demo_sales', 10, null);
  check_('result kept for the Workbench', dx_api.has_result);
  dx_api.flush_run_log;
  apex_session.delete_session;
  select run_count into l_cnt from dx_saved_queries where query_id = l_id;
  check_('run count tracked for saved query', l_cnt = 1, to_char(l_cnt));
  select count(*) into l_cnt from dx_query_log where username = 'SMOKE_TEST' and status = 'BLOCKED' and run_at > systimestamp - interval '10' minute;
  check_('blocked runs logged', l_cnt >= 1, l_cnt || ' blocked in last 10 min');

  -- 6. REST source (offline: payload loaded directly, no network needed)
  l_src := dx_api.add_rest_source('SMOKE TEST rest', 'https://example.invalid/items',
             'id number path ''$.id'', name varchar2(50) path ''$.name''', '$.items[*]');
  dx_api.load_rest_payload(l_src, '{"items":[{"id":1,"name":"alpha"},{"id":2,"name":"beta"}]}');
  execute immediate 'select count(*) from dx_rest_' || l_src into l_cnt;
  check_('REST JSON exposed as relational view', l_cnt = 2, 'DX_REST_' || l_src || ' rows=' || l_cnt);
  apex_session.create_session(p_app_id => &dx_app_id, p_page_id => 6, p_username => 'SMOKE_TEST');
  l_clob := run_('select name from ' || user || '.dx_rest_' || l_src || ' order by id');
  apex_session.delete_session;
  check_('REST view queryable read-only', instr(l_clob, 'beta') > 0, nvl(l_err, l_st));
  select count(*) into l_cnt from dx_catalog_v where source_id = l_src;
  check_('REST view in catalog', l_cnt = 1);

  -- 7. APEX application
  select count(*) into l_cnt from apex_applications where application_id = &dx_app_id and owner = 'DATAEXP';
  check_('APEX app &dx_app_id installed with parsing schema DATAEXP', l_cnt = 1);
  select count(*) into l_cnt from apex_application_pages where application_id = &dx_app_id and page_id in (1,2,3,4,5,6,9999);
  check_('APEX pages 1-6 + login present', l_cnt = 7, l_cnt || ' pages');

  -- cleanup
  execute immediate 'drop view dx_rest_' || l_src;
  delete from dx_data_sources where name like 'SMOKE TEST%';
  delete from dx_saved_queries where title like 'SMOKE TEST%';
  delete from dx_query_log where username = 'SMOKE_TEST';
  commit;

  dbms_output.put_line('----');
  dbms_output.put_line('RESULT: ' || l_pass || ' passed, ' || l_fail || ' failed');
  if l_fail > 0 then
    raise_application_error(-20999, l_fail || ' smoke test check(s) failed');
  end if;
end;
/
