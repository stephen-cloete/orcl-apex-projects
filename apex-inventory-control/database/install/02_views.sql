--------------------------------------------------------------------------------
-- apex-inventory-control : reporting views (re-runnable, create or replace)
--------------------------------------------------------------------------------
create or replace view inv_items_v as
select i.item_id,
       i.sku,
       i.name,
       i.description,
       i.category_id,
       c.name                                     as category,
       i.supplier_id,
       s.name                                     as supplier,
       i.uom,
       i.unit_cost,
       i.reorder_level,
       i.reorder_qty,
       i.active_yn,
       nvl(st.qty_on_hand, 0)                     as qty_on_hand,
       nvl(st.qty_on_hand, 0) * i.unit_cost       as stock_value,
       case when i.active_yn = 'Y' and nvl(st.qty_on_hand, 0) <= i.reorder_level
            then 'Y' else 'N' end                 as low_stock_yn
  from inv_items i
  left join inv_categories c on c.category_id = i.category_id
  left join inv_suppliers  s on s.supplier_id = i.supplier_id
  left join (select item_id, sum(qty_on_hand) qty_on_hand
               from inv_stock group by item_id) st on st.item_id = i.item_id
/

create or replace view inv_stock_v as
select st.item_id,
       i.sku,
       i.name                          as item_name,
       st.location_id,
       l.code                          as location_code,
       l.name                          as location_name,
       st.qty_on_hand,
       i.uom,
       st.qty_on_hand * i.unit_cost    as stock_value,
       st.updated_on
  from inv_stock st
  join inv_items     i on i.item_id     = st.item_id
  join inv_locations l on l.location_id = st.location_id
/

create or replace view inv_transactions_v as
select t.txn_id,
       t.txn_type,
       initcap(t.txn_type)             as txn_type_label,
       t.txn_date,
       t.item_id,
       i.sku,
       i.name                          as item_name,
       t.from_location_id,
       fl.code                         as from_location,
       t.to_location_id,
       tl.code                         as to_location,
       t.quantity,
       i.uom,
       t.unit_cost,
       t.reference,
       t.notes,
       t.created_by,
       t.created_on
  from inv_transactions t
  join inv_items          i  on i.item_id      = t.item_id
  left join inv_locations fl on fl.location_id = t.from_location_id
  left join inv_locations tl on tl.location_id = t.to_location_id
/

create or replace view inv_dashboard_v as
select (select count(*) from inv_items where active_yn = 'Y')                 as active_items,
       (select count(*) from inv_items_v where low_stock_yn = 'Y')            as low_stock_items,
       (select nvl(sum(stock_value), 0) from inv_items_v)                     as stock_value,
       (select count(*) from inv_transactions where txn_date >= trunc(sysdate) - 7) as txns_7_days,
       (select count(*) from inv_locations where active_yn = 'Y')             as active_locations
  from dual
/
