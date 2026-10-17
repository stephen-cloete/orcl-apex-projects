--------------------------------------------------------------------------------
-- Data Explorer - smoke test (run as DATAEXP)
--   sql DATAEXP/<pw>@<service> @tests/smoke_test.sql <APP_ID>
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

  procedure blocked(p_name in varchar2, p_sql in varchar2) is
    l_msg varchar2(4000) := dx_api.validate_sql(p_sql);
  begin
    check_('blocks ' || p_name, l_msg is not null, l_msg);
  end blocked;
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

  -- 3. validation
  check_('accepts plain SELECT', dx_api.validate_sql('select * from demo_sales') is null, dx_api.validate_sql('select * from demo_sales'));
  check_('accepts WITH + trailing ;', dx_api.validate_sql('with x as (select 1 n from dual) select n from x;') is null,
         dx_api.validate_sql('with x as (select 1 n from dual) select n from x;'));
  check_('accepts ; inside a literal', dx_api.validate_sql('select ''a;b'' txt from dual') is null);
  blocked('DELETE',            'delete from demo_sales');
  blocked('DDL',               'drop table demo_sales');
  blocked('two statements',    'select 1 from dual; delete from demo_sales');
  blocked('FOR UPDATE',        'select * from demo_sales for update');
  blocked('database link',     'select * from dual@remote_db');
  blocked('internal table',    'select * from dx_query_log');
  blocked('quoted internal',   'select * from "DX_SETTINGS"');
  blocked('WITH FUNCTION',     'with function f return number is begin return 1; end; select f from dual');
  blocked('unparseable query', 'select from where');
  blocked('PL/SQL block',      'begin null; end');

  -- 4. execution
  l_clob := dx_api.result_html('select country, sum(amount) amount from demo_sales_summary_v group by country order by 1', 50);
  check_('HTML result renders table', instr(l_clob, '<table') > 0 and instr(l_clob, 'South Africa') > 0,
         regexp_substr(l_clob, '[0-9]+ row\(s\)[^<]*'));
  l_clob := dx_api.result_html('select * from demo_sales', 10);
  check_('row cap applied', instr(l_clob, 'limited to the first 10 rows') > 0, regexp_substr(l_clob, '[0-9]+ row\(s\)[^<]*'));
  l_clob := dx_api.result_html('select ''<script>x</script>'' as html from dual');
  check_('HTML output is escaped', instr(l_clob, '<script>') = 0 and instr(l_clob, chr(38) || 'lt;script' || chr(38) || 'gt;') > 0);
  l_clob := dx_api.result_html('delete from demo_sales');
  check_('blocked query shows an error, not a result', instr(l_clob, 'dx-error') > 0);
  select count(*) into l_cnt from demo_sales;
  check_('blocked DELETE changed nothing', l_cnt = 1000, l_cnt || ' rows');
  l_clob := dx_api.csv_clob('select region_id, region_name from demo_regions order by 1');
  check_('CSV export', l_clob like 'REGION_ID,REGION_NAME' || chr(13) || chr(10) || '1,Gauteng%', dbms_lob.substr(l_clob, 40, 1));
  check_('row_count()', dx_api.row_count('select * from demo_products') = 6);
  l_clob := dx_api.result_html('select to_clob(''clob value'') c, utl_raw.cast_to_raw(''ab'') r, systimestamp ts from dual');
  check_('CLOB/RAW/TIMESTAMP columns render', instr(l_clob, 'clob value') > 0 and instr(l_clob, '6162') > 0);
  l_txt := dbms_lob.substr(dx_api.object_sql(user, 'DEMO_SALES'), 4000, 1);
  check_('object_sql builds quoted SELECT', l_txt like 'select *%"' || user || '"."DEMO_SALES"', replace(l_txt, chr(10), ' '));

  -- 5. saved queries
  l_id := dx_api.save_query(null, 'SMOKE TEST query', 'select count(*) cnt from demo_sales', 'temporary', 'N');
  check_('save_query inserts', l_id is not null, 'query_id ' || l_id);
  l_id := dx_api.save_query(l_id, 'SMOKE TEST query', 'select count(*) cnt from demo_regions', 'temporary', 'Y');
  commit; -- saved row must be committed before the autonomous run log updates it
  check_('save_query updates', dbms_lob.substr(dx_api.get_query_sql(l_id), 100, 1) like '%demo_regions%');
  begin
    l_id := dx_api.save_query(null, 'SMOKE TEST bad', 'truncate table demo_sales');
    check_('save_query rejects non-SELECT', false);
  exception when others then
    check_('save_query rejects non-SELECT', sqlcode = -20031, sqlerrm);
  end;
  l_clob := dx_api.result_html(dx_api.get_query_sql(l_id), 10, l_id);
  select run_count into l_cnt from dx_saved_queries where query_id = l_id;
  check_('run count tracked for saved query', l_cnt = 1, to_char(l_cnt));
  select count(*) into l_cnt from dx_query_log where status = 'BLOCKED' and run_at > systimestamp - interval '10' minute;
  check_('blocked runs logged', l_cnt >= 1, l_cnt || ' blocked in last 10 min');

  -- 6. REST source (offline: payload loaded directly, no network needed)
  l_src := dx_api.add_rest_source('SMOKE TEST rest', 'https://example.invalid/items',
             'id number path ''$.id'', name varchar2(50) path ''$.name''', '$.items[*]');
  dx_api.load_rest_payload(l_src, '{"items":[{"id":1,"name":"alpha"},{"id":2,"name":"beta"}]}');
  execute immediate 'select count(*) from dx_rest_' || l_src into l_cnt;
  check_('REST JSON exposed as relational view', l_cnt = 2, 'DX_REST_' || l_src || ' rows=' || l_cnt);
  l_clob := dx_api.result_html('select name from dx_rest_' || l_src || ' order by id');
  check_('REST view queryable in Data Explorer', instr(l_clob, 'beta') > 0);
  select count(*) into l_cnt from dx_catalog_v where source_id = l_src;
  check_('REST view in catalog', l_cnt = 1);

  -- 7. APEX application
  select count(*) into l_cnt from apex_applications where application_id = &dx_app_id and owner = 'DATAEXP';
  check_('APEX app &dx_app_id installed with parsing schema DATAEXP', l_cnt = 1);
  select count(*) into l_cnt from apex_application_pages where application_id = &dx_app_id and page_id in (1,2,3,4,5,9999);
  check_('APEX pages 1-5 + login present', l_cnt = 6, l_cnt || ' pages');

  -- cleanup
  execute immediate 'drop view dx_rest_' || l_src;
  delete from dx_data_sources where name like 'SMOKE TEST%';
  delete from dx_saved_queries where title like 'SMOKE TEST%';
  commit;

  dbms_output.put_line('----');
  dbms_output.put_line('RESULT: ' || l_pass || ' passed, ' || l_fail || ' failed');
  if l_fail > 0 then
    raise_application_error(-20999, l_fail || ' smoke test check(s) failed');
  end if;
end;
/
