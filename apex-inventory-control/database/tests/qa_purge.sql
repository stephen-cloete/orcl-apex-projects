--------------------------------------------------------------------------------
-- apex-inventory-control : TEST-ONLY teardown. Removes 'QA-%' test items with their
-- stock and movements via inv_qa.qa_purge, commits, and prints remaining counts.
-- Requires database/tests/install_inv_qa.sql (test tooling only).
--------------------------------------------------------------------------------
set serveroutput on
declare
  l_items pls_integer; l_stock pls_integer; l_txns pls_integer;
begin
  inv_qa.qa_purge(p_confirm => inv_qa.c_qa_confirm, p_items => l_items,
                   p_stock_rows => l_stock, p_transactions => l_txns);
  commit;
  dbms_output.put_line('qa_purge deleted items=' || l_items || ' stock_rows=' || l_stock
                       || ' transactions=' || l_txns);
end;
/
select (select count(*) from inv_items where sku like 'QA-%') qa_items,
       (select count(*) from inv_stock s join inv_items i on i.item_id = s.item_id where i.sku like 'QA-%') qa_stock_rows,
       (select count(*) from inv_transactions t join inv_items i on i.item_id = t.item_id where i.sku like 'QA-%') qa_transactions
  from dual;
