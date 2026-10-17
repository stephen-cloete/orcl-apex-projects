--------------------------------------------------------------------------------
-- apex-inventory-control : demo / reference data (re-runnable)
-- Reference rows are merged by natural key. Opening stock is only posted once
-- (when the ledger is empty) and goes through inv_api so the ledger balances.
--------------------------------------------------------------------------------
merge into inv_categories t
using (select 'Hardware' name, 'Fasteners, fittings and small hardware' description from dual union all
       select 'Electrical', 'Cables, switches and lighting' from dual union all
       select 'Safety', 'PPE and safety equipment' from dual union all
       select 'Consumables', 'Tape, adhesives and cleaning supplies' from dual) s
on (t.name = s.name)
when not matched then insert (name, description) values (s.name, s.description)
/
merge into inv_locations t
using (select 'MAIN' code, 'Main Warehouse' name, 'Primary storage' description from dual union all
       select 'STORE', 'Front Store', 'Customer counter stock' from dual union all
       select 'VAN1', 'Service Van 1', 'Mobile technician stock' from dual) s
on (t.code = s.code)
when not matched then insert (code, name, description) values (s.code, s.name, s.description)
/
merge into inv_suppliers t
using (select 'Acme Industrial Supply' name, 'Jane Mokoena' contact_name,
              'orders@acme.example' email, '+27 21 555 0101' phone from dual union all
       select 'Volt Electrical Wholesale', 'Pieter van Wyk', 'sales@volt.example', '+27 11 555 0202' from dual union all
       select 'SafeGuard PPE', 'Aisha Patel', 'hello@safeguard.example', '+27 31 555 0303' from dual) s
on (t.name = s.name)
when not matched then insert (name, contact_name, email, phone)
values (s.name, s.contact_name, s.email, s.phone)
/
merge into inv_items t
using (select 'HW-BOLT-M8' sku, 'Hex bolt M8 x 40mm' name, 'Hardware' cat, 'Acme Industrial Supply' sup,
              'EA' uom, 1.20 cost, 200 lvl, 500 rq from dual union all
       select 'HW-NUT-M8', 'Hex nut M8', 'Hardware', 'Acme Industrial Supply', 'EA', 0.45, 200, 500 from dual union all
       select 'HW-ANCHOR-10', 'Wall anchor 10mm', 'Hardware', 'Acme Industrial Supply', 'EA', 0.80, 100, 300 from dual union all
       select 'EL-CABLE-2.5', 'Cable 2.5mm twin and earth', 'Electrical', 'Volt Electrical Wholesale', 'M', 18.50, 100, 250 from dual union all
       select 'EL-SWITCH-1G', 'Light switch 1-gang', 'Electrical', 'Volt Electrical Wholesale', 'EA', 32.00, 20, 50 from dual union all
       select 'EL-LED-9W', 'LED bulb 9W E27', 'Electrical', 'Volt Electrical Wholesale', 'EA', 24.90, 40, 100 from dual union all
       select 'SF-GLOVE-L', 'Work gloves (large)', 'Safety', 'SafeGuard PPE', 'PR', 45.00, 25, 60 from dual union all
       select 'SF-GOGGLE', 'Safety goggles', 'Safety', 'SafeGuard PPE', 'EA', 65.00, 10, 30 from dual union all
       select 'SF-VEST-HV', 'Hi-vis vest', 'Safety', 'SafeGuard PPE', 'EA', 55.00, 10, 30 from dual union all
       select 'CN-TAPE-DUCT', 'Duct tape 48mm', 'Consumables', 'Acme Industrial Supply', 'RL', 39.00, 15, 40 from dual union all
       select 'CN-SILICONE', 'Silicone sealant clear', 'Consumables', 'Acme Industrial Supply', 'EA', 72.00, 12, 36 from dual union all
       select 'CN-WIPES', 'Industrial wipes (tub)', 'Consumables', 'SafeGuard PPE', 'EA', 89.00, 8, 24 from dual) s
on (t.sku = s.sku)
when not matched then insert (sku, name, category_id, supplier_id, uom, unit_cost, reorder_level, reorder_qty)
values (s.sku, s.name,
        (select category_id from inv_categories where name = s.cat),
        (select supplier_id from inv_suppliers where name = s.sup),
        s.uom, s.cost, s.lvl, s.rq)
/
declare
  l_cnt pls_integer;
  l_txn number;
  function item(p_sku varchar2) return number is
    l_id number;
  begin
    select item_id into l_id from inv_items where sku = p_sku;
    return l_id;
  end;
  function loc(p_code varchar2) return number is
    l_id number;
  begin
    select location_id into l_id from inv_locations where code = p_code;
    return l_id;
  end;
begin
  select count(*) into l_cnt from inv_transactions;
  if l_cnt = 0 then
    for r in (select 'HW-BOLT-M8' sku, 1500 qty from dual union all
              select 'HW-NUT-M8', 1400 from dual union all
              select 'HW-ANCHOR-10', 80 from dual union all
              select 'EL-CABLE-2.5', 600 from dual union all
              select 'EL-SWITCH-1G', 45 from dual union all
              select 'EL-LED-9W', 30 from dual union all
              select 'SF-GLOVE-L', 120 from dual union all
              select 'SF-GOGGLE', 40 from dual union all
              select 'SF-VEST-HV', 6 from dual union all
              select 'CN-TAPE-DUCT', 50 from dual union all
              select 'CN-SILICONE', 36 from dual union all
              select 'CN-WIPES', 20 from dual)
    loop
      inv_api.post_transaction(p_txn_type => 'RECEIPT', p_item_id => item(r.sku), p_quantity => r.qty,
                               p_to_location_id => loc('MAIN'), p_reference => 'OPENING',
                               p_notes => 'Opening balance', p_txn_date => trunc(sysdate) - 14,
                               p_txn_id => l_txn);
    end loop;
    inv_api.post_transaction('TRANSFER', item('EL-LED-9W'), 12, loc('MAIN'), loc('STORE'), 'TR-0001',
                             'Counter display', trunc(sysdate) - 6, l_txn);
    inv_api.post_transaction('TRANSFER', item('SF-GLOVE-L'), 20, loc('MAIN'), loc('VAN1'), 'TR-0002',
                             'Van restock', trunc(sysdate) - 5, l_txn);
    inv_api.post_transaction('ISSUE', item('HW-BOLT-M8'), 250, loc('MAIN'), null, 'JOB-1042',
                             'Site job 1042', trunc(sysdate) - 3, l_txn);
    inv_api.post_transaction('ISSUE', item('SF-GLOVE-L'), 4, loc('VAN1'), null, 'JOB-1043',
                             'Technician use', trunc(sysdate) - 2, l_txn);
    inv_api.post_transaction('ADJUST', item('CN-WIPES'), -2, null, loc('MAIN'), 'CNT-2026-10',
                             'Cycle count: damaged', trunc(sysdate) - 1, l_txn);
  end if;
  commit;
end;
/
