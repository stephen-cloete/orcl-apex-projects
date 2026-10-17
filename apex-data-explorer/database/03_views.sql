--------------------------------------------------------------------------------
-- Data Explorer - 03_views.sql   (run as DATAEXP)
-- Catalog of explorable objects. ALL_OBJECTS only returns objects DATAEXP can
-- read, so the catalog is naturally limited to what has been granted.
--------------------------------------------------------------------------------
create or replace view dx_catalog_v as
select s.source_id,
       s.name                 as source_name,
       s.source_type,
       o.owner,
       o.object_name,
       o.object_type,
       (select count(*)
          from all_tab_columns c
         where c.owner = o.owner
           and c.table_name = o.object_name) as column_count,
       tc.comments
  from dx_data_sources s
  join all_objects o
    on o.owner = s.schema_owner
  left join all_tab_comments tc
    on tc.owner = o.owner
   and tc.table_name = o.object_name
 where s.source_type = 'SCHEMA'
   and s.is_enabled = 'Y'
   and o.object_type in ('TABLE', 'VIEW')
   and not (o.owner = sys_context('USERENV', 'CURRENT_SCHEMA') and o.object_name like 'DX\_%' escape '\')  -- Data Explorer's own objects
   and o.object_name not like 'BIN$%'
union all
select s.source_id,
       s.name,
       s.source_type,
       sys_context('USERENV', 'CURRENT_SCHEMA'),
       s.view_name,
       'REST VIEW',
       (select count(*) from user_tab_columns c where c.table_name = s.view_name),
       s.description
  from dx_data_sources s
 where s.source_type = 'REST'
   and s.is_enabled = 'Y'
   and s.view_name is not null
/

create or replace view dx_columns_v as
select cat.source_name,
       c.owner,
       c.table_name,
       c.column_id,
       c.column_name,
       c.data_type
       || case
            when c.data_type in ('VARCHAR2', 'NVARCHAR2', 'CHAR', 'RAW') then '(' || c.char_length || ')'
            when c.data_type = 'NUMBER' and c.data_precision is not null
              then '(' || c.data_precision || nvl2(nullif(c.data_scale, 0), ',' || c.data_scale, '') || ')'
          end as data_type,
       c.nullable
  from dx_catalog_v cat
  join all_tab_columns c
    on c.owner = cat.owner
   and c.table_name = cat.object_name
/
