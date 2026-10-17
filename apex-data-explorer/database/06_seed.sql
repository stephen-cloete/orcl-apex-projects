--------------------------------------------------------------------------------
-- Data Explorer - 06_seed.sql   (run as DATAEXP)
-- Settings, demo data set and the default data source. Safe to re-run:
-- settings are merged, demo rows load only into empty tables, and the
-- default source / sample queries are inserted only when missing.
-- Arg: &1 = comma-separated APEX usernames who administer Data Explorer
--------------------------------------------------------------------------------
set define on verify off
define dx_admins = '&1'

begin
  dx_api.set_setting('MAX_ROWS', nvl(dx_api.get_setting('MAX_ROWS'), '500'), 'Hard cap on rows returned to the browser or CSV');
  dx_api.set_setting('MAX_COLUMNS', nvl(dx_api.get_setting('MAX_COLUMNS'), '100'), 'Maximum columns a query may return');
  dx_api.set_setting('ALLOW_DB_LINKS', nvl(dx_api.get_setting('ALLOW_DB_LINKS'), 'N'), 'Y lets queries use @dblink');
  dx_api.set_setting('ADMIN_USERS', upper(replace('&dx_admins', ' ')), 'APEX users who manage data sources and see all logs');
  commit;
end;
/

begin
  dx_ddl('
create table demo_regions (
  region_id   number       constraint demo_regions_pk primary key,
  region_name varchar2(50) not null,
  country     varchar2(50) not null
)');
  dx_ddl('
create table demo_products (
  product_id   number        constraint demo_products_pk primary key,
  product_name varchar2(100) not null,
  category     varchar2(50)  not null,
  list_price   number(10,2)  not null
)');
  dx_ddl('
create table demo_sales (
  sale_id    number       constraint demo_sales_pk primary key,
  sale_date  date         not null,
  region_id  number       not null constraint demo_sales_region_fk references demo_regions,
  product_id number       not null constraint demo_sales_product_fk references demo_products,
  quantity   number(6)    not null,
  amount     number(12,2) not null
)');
end;
/
comment on table demo_regions  is 'Data Explorer demo: sales regions';
comment on table demo_products is 'Data Explorer demo: product catalogue';
comment on table demo_sales    is 'Data Explorer demo: 1 000 generated sales lines (deterministic)';

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from demo_regions;
  if l_cnt = 0 then
    insert into demo_regions values (1, 'Gauteng', 'South Africa');
    insert into demo_regions values (2, 'Western Cape', 'South Africa');
    insert into demo_regions values (3, 'KwaZulu-Natal', 'South Africa');
    insert into demo_regions values (4, 'Bavaria', 'Germany');
    insert into demo_regions values (5, 'Hesse', 'Germany');
  end if;
  select count(*) into l_cnt from demo_products;
  if l_cnt = 0 then
    insert into demo_products values (1, 'APEX Starter Licence', 'Software', 1200);
    insert into demo_products values (2, 'APEX Enterprise Licence', 'Software', 9800);
    insert into demo_products values (3, 'ADB Health Check', 'Services', 4500);
    insert into demo_products values (4, 'Data Migration Day', 'Services', 7500);
    insert into demo_products values (5, 'Training Seat', 'Training', 2500);
    insert into demo_products values (6, 'Support Retainer', 'Services', 15000);
  end if;
  select count(*) into l_cnt from demo_sales;
  if l_cnt = 0 then
    insert into demo_sales (sale_id, sale_date, region_id, product_id, quantity, amount)
    select level,
           date '2026-01-01' + mod(level * 7, 290),
           mod(level, 5) + 1,
           mod(level * 3, 6) + 1,
           mod(level, 9) + 1,
           0
      from dual
    connect by level <= 1000;
    update demo_sales s
       set amount = s.quantity * (select p.list_price from demo_products p where p.product_id = s.product_id);
  end if;
  commit;
end;
/

create or replace view demo_sales_summary_v as
select r.country,
       r.region_name,
       p.category,
       p.product_name,
       trunc(s.sale_date, 'MM') as sale_month,
       count(*)                 as sales_count,
       sum(s.quantity)          as quantity,
       sum(s.amount)            as amount
  from demo_sales s
  join demo_regions r  on r.region_id = s.region_id
  join demo_products p on p.product_id = s.product_id
 group by r.country, r.region_name, p.category, p.product_name, trunc(s.sale_date, 'MM')
/
comment on table demo_sales_summary_v is 'Data Explorer demo: monthly sales by region and product';

declare
  l_cnt pls_integer;
  l_id  number;
begin
  select count(*) into l_cnt from dx_data_sources where name = 'Data Explorer demo';
  if l_cnt = 0 then
    l_id := dx_api.add_schema_source('Data Explorer demo', user, 'Demo sales data installed with Data Explorer');
  end if;
  select count(*) into l_cnt from dx_saved_queries where title = 'Sales by country and category';
  if l_cnt = 0 then
    l_id := dx_api.save_query(null, 'Sales by country and category',
      'select country, category, sum(amount) as amount, sum(quantity) as quantity' || chr(10)
      || '  from demo_sales_summary_v' || chr(10)
      || ' group by country, category' || chr(10)
      || ' order by amount desc',
      'Demo: totals per country and product category', 'Y');
  end if;
  select count(*) into l_cnt from dx_saved_queries where title = 'Top 10 sales months';
  if l_cnt = 0 then
    l_id := dx_api.save_query(null, 'Top 10 sales months',
      'select to_char(sale_month, ''YYYY-MM'') as month, sum(amount) as amount' || chr(10)
      || '  from demo_sales_summary_v' || chr(10)
      || ' group by sale_month' || chr(10)
      || ' order by amount desc' || chr(10)
      || ' fetch first 10 rows only',
      'Demo: best months by revenue', 'Y');
  end if;
  commit;
end;
/
undefine dx_admins
