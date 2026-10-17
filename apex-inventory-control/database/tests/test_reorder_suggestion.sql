--------------------------------------------------------------------------------
-- apex-inventory-control : API tests for reorder quantity / suggested order (rolls back)
-- Run as INVENTORY_CONTROL (or ADMIN with current_schema = inventory_control).
--------------------------------------------------------------------------------
declare
  l_id   inv_items.item_id%type;
  l_qty  number;
  l_low  varchar2(1);
  l_cnt  pls_integer;
  procedure ok(p_cond boolean, p_msg varchar2) is
  begin
    if not nvl(p_cond, false) then raise_application_error(-20999, 'FAIL: ' || p_msg); end if;
    dbms_output.put_line('PASS: ' || p_msg);
  end;
begin
  savepoint t;
  -- 1. reorder qty omitted -> defaults to the reorder level (5); on hand 0 -> suggest 5
  inv_api.save_item(p_item_id => l_id, p_sku => 'TEST-RQ-1', p_name => 'Test reorder 1',
                    p_reorder_level => 5, p_reorder_qty => null);
  select low_stock_yn, suggested_order_qty into l_low, l_qty from inv_items_v where item_id = l_id;
  ok(l_low = 'Y' and l_qty = 5, 'null reorder qty defaults to reorder level; suggested 5 (got ' || l_qty || ')');

  -- 2. explicit positive reorder qty wins
  inv_api.save_item(p_item_id => l_id, p_sku => 'TEST-RQ-1', p_name => 'Test reorder 1',
                    p_reorder_level => 5, p_reorder_qty => 12);
  select suggested_order_qty into l_qty from inv_items_v where item_id = l_id;
  ok(l_qty = 12, 'positive reorder qty is suggested (got ' || l_qty || ')');

  -- 3. zero / negative reorder qty rejected by the API
  begin
    inv_api.save_item(p_item_id => l_id, p_sku => 'TEST-RQ-1', p_name => 'Test reorder 1',
                      p_reorder_level => 5, p_reorder_qty => 0);
    ok(false, 'reorder qty 0 must be rejected');
  exception when others then
    ok(sqlcode = -20017, 'reorder qty 0 rejected with ORA-20017');
  end;

  -- 4. reorder level 0, nothing on hand, qty omitted -> minimum 1
  l_id := null;
  inv_api.save_item(p_item_id => l_id, p_sku => 'TEST-RQ-2', p_name => 'Test reorder 2',
                    p_reorder_level => 0, p_reorder_qty => null);
  select suggested_order_qty into l_qty from inv_items_v where item_id = l_id;
  ok(l_qty = 1, 'minimum suggestion is 1 (got ' || l_qty || ')');

  -- 5. invariant over all data: no low-stock item suggests <= 0
  select count(*) into l_cnt from inv_items_v
   where low_stock_yn = 'Y' and nvl(suggested_order_qty, 0) <= 0;
  ok(l_cnt = 0, 'no low-stock item suggests an order qty <= 0');
  rollback to t;
exception
  when others then rollback to t; raise;
end;
/
