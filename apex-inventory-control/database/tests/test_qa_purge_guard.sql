--------------------------------------------------------------------------------
-- apex-inventory-control : tests for the test-only inv_qa.qa_purge guard (rolls back)
--------------------------------------------------------------------------------
declare
  l_qa number; l_lookalike number; l_txn number; l_loc number; a pls_integer; b pls_integer; c pls_integer; l_cnt pls_integer;
  procedure ok(p_cond boolean, p_msg varchar2) is
  begin
    if not nvl(p_cond, false) then raise_application_error(-20999, 'FAIL: ' || p_msg); end if;
    dbms_output.put_line('PASS: ' || p_msg);
  end;
begin
  savepoint t;
  begin
    inv_qa.qa_purge('yes', a, b, c);
    ok(false, 'wrong confirm must be refused');
  exception when others then ok(sqlcode = -20091, 'wrong confirm refused with ORA-20091');
  end;
  inv_api.save_item(p_item_id => l_qa, p_sku => 'QA-GUARD-1', p_name => 'QA guard');
  inv_api.save_item(p_item_id => l_lookalike, p_sku => 'QAX-GUARD-2', p_name => 'Look-alike, must survive');
  select location_id into l_loc from inv_locations where code = 'MAIN';
  inv_api.post_transaction('RECEIPT', l_qa, 3, null, l_loc, 'T', null, sysdate, l_txn);
  inv_qa.qa_purge(inv_qa.c_qa_confirm, a, b, c);
  ok(a >= 1 and b >= 1 and c >= 1, 'QA item, stock and movement purged (' || a || '/' || b || '/' || c || ')');
  select count(*) into l_cnt from inv_items where item_id = l_lookalike;
  ok(l_cnt = 1, 'non-QA look-alike SKU QAX-% untouched');
  rollback to t;
exception when others then rollback to t; raise;
end;
/
