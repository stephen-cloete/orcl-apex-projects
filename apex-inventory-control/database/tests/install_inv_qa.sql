--------------------------------------------------------------------------------
-- apex-inventory-control : TEST-ONLY package INV_QA
--
-- Not part of database/install.sql and never called by the application. Only the
-- test/teardown tooling installs it (tools/flow_check.py runs this script before
-- database/tests/qa_purge.sql). Re-runnable. Remove it with: drop package inv_qa;
--------------------------------------------------------------------------------
create or replace package inv_qa authid definer as
  -- Removes automated-test items (SKU 'QA-%') with their stock and movement rows.
  -- Guards:
  --   * runs only when p_confirm = c_qa_confirm (otherwise ORA-20091);
  --   * matches only the literal prefix 'QA-' ('-' is not a LIKE wildcard);
  --   * counts every non-QA item, stock row and movement first and, if any of them
  --     changed, rolls back to its savepoint and raises ORA-20090.
  -- Does not commit; the caller commits.
  c_qa_confirm constant varchar2(30) := 'PURGE QA ITEMS';
  procedure qa_purge(
    p_confirm      in  varchar2,
    p_items        out pls_integer,
    p_stock_rows   out pls_integer,
    p_transactions out pls_integer);
end inv_qa;
/
create or replace package body inv_qa as
  procedure qa_purge(
    p_confirm      in  varchar2,
    p_items        out pls_integer,
    p_stock_rows   out pls_integer,
    p_transactions out pls_integer)
  is
    c_like constant varchar2(10) := 'QA-%';
    l_other_items  pls_integer;
    l_other_stock  pls_integer;
    l_other_txns   pls_integer;
    l_after_items  pls_integer;
    l_after_stock  pls_integer;
    l_after_txns   pls_integer;
  begin
    if p_confirm is null or p_confirm <> c_qa_confirm then
      raise_application_error(-20091,
        'qa_purge is test-only; pass p_confirm => ''' || c_qa_confirm || '''.');
    end if;

    -- baseline of everything that must NOT change
    select count(*) into l_other_items from inv_items where sku not like c_like;
    select count(*) into l_other_stock from inv_stock s
     where not exists (select 1 from inv_items i where i.item_id = s.item_id and i.sku like c_like);
    select count(*) into l_other_txns from inv_transactions t
     where not exists (select 1 from inv_items i where i.item_id = t.item_id and i.sku like c_like);

    savepoint qa_purge_start;
    delete from inv_transactions t
     where t.item_id in (select i.item_id from inv_items i where i.sku like c_like);
    p_transactions := sql%rowcount;
    delete from inv_stock s
     where s.item_id in (select i.item_id from inv_items i where i.sku like c_like);
    p_stock_rows := sql%rowcount;
    delete from inv_items i where i.sku like c_like;
    p_items := sql%rowcount;

    -- guard: nothing outside QA-% may have changed
    select count(*) into l_after_items from inv_items;
    select count(*) into l_after_stock from inv_stock;
    select count(*) into l_after_txns  from inv_transactions;
    if l_after_items <> l_other_items or l_after_stock <> l_other_stock
       or l_after_txns <> l_other_txns then
      rollback to qa_purge_start;
      raise_application_error(-20090,
        'qa_purge guard tripped: non-QA rows would change. Nothing was deleted.');
    end if;
  end qa_purge;
end inv_qa;
/
