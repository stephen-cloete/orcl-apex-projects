create or replace package body inv_api
as
  ------------------------------------------------------------------------------
  -- helpers
  ------------------------------------------------------------------------------
  function current_user_name return varchar2 is
  begin
    return coalesce(sys_context('APEX$SESSION', 'APP_USER'), user);
  end current_user_name;

  procedure fail(p_code in pls_integer, p_message in varchar2) is
  begin
    raise_application_error(p_code, p_message);
  end fail;

  procedure require(p_value in varchar2, p_label in varchar2) is
  begin
    if trim(p_value) is null then
      fail(-20001, p_label || ' is required.');
    end if;
  end require;

  procedure check_yn(p_value in varchar2) is
  begin
    if nvl(p_value, 'x') not in ('Y', 'N') then
      fail(-20002, 'Active must be Y or N.');
    end if;
  end check_yn;

  procedure check_active_location(p_location_id in number, p_label in varchar2) is
    l_active inv_locations.active_yn%type;
  begin
    if p_location_id is null then
      fail(-20010, p_label || ' is required for this movement type.');
    end if;
    select active_yn into l_active from inv_locations where location_id = p_location_id;
    if l_active <> 'Y' then
      fail(-20011, p_label || ' is inactive.');
    end if;
  exception
    when no_data_found then fail(-20012, p_label || ' does not exist.');
  end check_active_location;

  -- Adds p_delta to on-hand (row-locked); refuses to go below zero.
  procedure apply_delta(p_item_id in number, p_location_id in number, p_delta in number) is
    l_qty inv_stock.qty_on_hand%type;
  begin
    begin
      select qty_on_hand into l_qty
        from inv_stock
       where item_id = p_item_id and location_id = p_location_id
         for update;
    exception
      when no_data_found then
        l_qty := null;
    end;

    if nvl(l_qty, 0) + p_delta < 0 then
      fail(-20020, 'Not enough stock: ' || nvl(l_qty, 0) || ' on hand, '
                   || abs(p_delta) || ' requested.');
    end if;

    if l_qty is null then
      insert into inv_stock (item_id, location_id, qty_on_hand)
      values (p_item_id, p_location_id, p_delta);
    else
      update inv_stock
         set qty_on_hand = qty_on_hand + p_delta,
             updated_on  = localtimestamp,
             updated_by  = current_user_name
       where item_id = p_item_id and location_id = p_location_id;
    end if;
  end apply_delta;

  ------------------------------------------------------------------------------
  -- categories
  ------------------------------------------------------------------------------
  procedure save_category(
    p_category_id in out nocopy inv_categories.category_id%type,
    p_name        in inv_categories.name%type,
    p_description in inv_categories.description%type default null,
    p_active_yn   in inv_categories.active_yn%type default 'Y')
  is
  begin
    require(p_name, 'Name');
    check_yn(p_active_yn);
    if p_category_id is null then
      insert into inv_categories (name, description, active_yn)
      values (trim(p_name), p_description, p_active_yn)
      returning category_id into p_category_id;
    else
      update inv_categories
         set name = trim(p_name), description = p_description, active_yn = p_active_yn,
             updated_on = localtimestamp, updated_by = current_user_name
       where category_id = p_category_id;
      if sql%rowcount = 0 then fail(-20004, 'This category no longer exists.'); end if;
    end if;
  exception
    when dup_val_on_index then
      fail(-20003, 'A category named "' || trim(p_name) || '" already exists.');
  end save_category;

  procedure delete_category(p_category_id in inv_categories.category_id%type) is
    l_cnt pls_integer;
  begin
    select count(*) into l_cnt from inv_items where category_id = p_category_id;
    if l_cnt > 0 then
      fail(-20005, 'This category is used by ' || l_cnt || ' item(s). Mark it inactive instead.');
    end if;
    delete from inv_categories where category_id = p_category_id;
  end delete_category;

  ------------------------------------------------------------------------------
  -- locations
  ------------------------------------------------------------------------------
  procedure save_location(
    p_location_id in out nocopy inv_locations.location_id%type,
    p_code        in inv_locations.code%type,
    p_name        in inv_locations.name%type,
    p_description in inv_locations.description%type default null,
    p_active_yn   in inv_locations.active_yn%type default 'Y')
  is
  begin
    require(p_code, 'Code');
    require(p_name, 'Name');
    check_yn(p_active_yn);
    if p_location_id is null then
      insert into inv_locations (code, name, description, active_yn)
      values (upper(trim(p_code)), trim(p_name), p_description, p_active_yn)
      returning location_id into p_location_id;
    else
      if p_active_yn = 'N' and qty_on_hand(null, p_location_id) > 0 then
        fail(-20006, 'Move or issue the stock held here before making this location inactive.');
      end if;
      update inv_locations
         set code = upper(trim(p_code)), name = trim(p_name), description = p_description,
             active_yn = p_active_yn, updated_on = localtimestamp, updated_by = current_user_name
       where location_id = p_location_id;
      if sql%rowcount = 0 then fail(-20004, 'This location no longer exists.'); end if;
    end if;
  exception
    when dup_val_on_index then
      fail(-20003, 'Location code "' || upper(trim(p_code)) || '" already exists.');
  end save_location;

  procedure delete_location(p_location_id in inv_locations.location_id%type) is
    l_cnt pls_integer;
  begin
    select count(*) into l_cnt
      from inv_transactions
     where p_location_id in (from_location_id, to_location_id);
    if l_cnt > 0 then
      fail(-20005, 'This location has stock history. Mark it inactive instead.');
    end if;
    delete from inv_stock where location_id = p_location_id and qty_on_hand = 0;
    delete from inv_locations where location_id = p_location_id;
  end delete_location;

  ------------------------------------------------------------------------------
  -- suppliers
  ------------------------------------------------------------------------------
  procedure save_supplier(
    p_supplier_id  in out nocopy inv_suppliers.supplier_id%type,
    p_name         in inv_suppliers.name%type,
    p_contact_name in inv_suppliers.contact_name%type default null,
    p_email        in inv_suppliers.email%type default null,
    p_phone        in inv_suppliers.phone%type default null,
    p_active_yn    in inv_suppliers.active_yn%type default 'Y')
  is
  begin
    require(p_name, 'Name');
    check_yn(p_active_yn);
    if p_email is not null
       and not regexp_like(trim(p_email), '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$') then
      fail(-20007, 'Enter a valid email address.');
    end if;
    if p_supplier_id is null then
      insert into inv_suppliers (name, contact_name, email, phone, active_yn)
      values (trim(p_name), p_contact_name, lower(trim(p_email)), p_phone, p_active_yn)
      returning supplier_id into p_supplier_id;
    else
      update inv_suppliers
         set name = trim(p_name), contact_name = p_contact_name, email = lower(trim(p_email)),
             phone = p_phone, active_yn = p_active_yn,
             updated_on = localtimestamp, updated_by = current_user_name
       where supplier_id = p_supplier_id;
      if sql%rowcount = 0 then fail(-20004, 'This supplier no longer exists.'); end if;
    end if;
  exception
    when dup_val_on_index then
      fail(-20003, 'A supplier named "' || trim(p_name) || '" already exists.');
  end save_supplier;

  procedure delete_supplier(p_supplier_id in inv_suppliers.supplier_id%type) is
    l_cnt pls_integer;
  begin
    select count(*) into l_cnt from inv_items where supplier_id = p_supplier_id;
    if l_cnt > 0 then
      fail(-20005, 'This supplier is used by ' || l_cnt || ' item(s). Mark it inactive instead.');
    end if;
    delete from inv_suppliers where supplier_id = p_supplier_id;
  end delete_supplier;

  ------------------------------------------------------------------------------
  -- items
  ------------------------------------------------------------------------------
  procedure save_item(
    p_item_id       in out nocopy inv_items.item_id%type,
    p_sku           in inv_items.sku%type,
    p_name          in inv_items.name%type,
    p_description   in inv_items.description%type default null,
    p_category_id   in inv_items.category_id%type default null,
    p_supplier_id   in inv_items.supplier_id%type default null,
    p_uom           in inv_items.uom%type default 'EA',
    p_unit_cost     in inv_items.unit_cost%type default 0,
    p_reorder_level in inv_items.reorder_level%type default 0,
    p_reorder_qty   in inv_items.reorder_qty%type default null,
    p_active_yn     in inv_items.active_yn%type default 'Y')
  is
    l_reorder_qty inv_items.reorder_qty%type := nvl(p_reorder_qty, greatest(nvl(p_reorder_level, 0), 1));
  begin
    require(p_sku, 'SKU');
    require(p_name, 'Name');
    require(p_uom, 'Unit of measure');
    check_yn(p_active_yn);
    if nvl(p_unit_cost, 0) < 0 or nvl(p_reorder_level, 0) < 0 then
      fail(-20008, 'Unit cost and reorder level cannot be negative.');
    end if;
    if l_reorder_qty <= 0 then
      fail(-20017, 'Reorder quantity must be greater than 0.');
    end if;
    if p_item_id is null then
      insert into inv_items (sku, name, description, category_id, supplier_id, uom,
                             unit_cost, reorder_level, reorder_qty, active_yn)
      values (upper(trim(p_sku)), trim(p_name), p_description, p_category_id, p_supplier_id,
              upper(trim(p_uom)), nvl(p_unit_cost, 0), nvl(p_reorder_level, 0),
              l_reorder_qty, p_active_yn)
      returning item_id into p_item_id;
    else
      update inv_items
         set sku = upper(trim(p_sku)), name = trim(p_name), description = p_description,
             category_id = p_category_id, supplier_id = p_supplier_id, uom = upper(trim(p_uom)),
             unit_cost = nvl(p_unit_cost, 0), reorder_level = nvl(p_reorder_level, 0),
             reorder_qty = l_reorder_qty, active_yn = p_active_yn,
             updated_on = localtimestamp, updated_by = current_user_name
       where item_id = p_item_id;
      if sql%rowcount = 0 then fail(-20004, 'This item no longer exists.'); end if;
    end if;
  exception
    when dup_val_on_index then
      fail(-20003, 'SKU "' || upper(trim(p_sku)) || '" already exists.');
  end save_item;

  procedure delete_item(p_item_id in inv_items.item_id%type) is
    l_cnt pls_integer;
  begin
    select count(*) into l_cnt from inv_transactions where item_id = p_item_id;
    if l_cnt > 0 then
      if qty_on_hand(p_item_id) > 0 then
        fail(-20009, 'This item still has stock on hand. Issue or adjust it to zero first.');
      end if;
      update inv_items
         set active_yn = 'N', updated_on = localtimestamp, updated_by = current_user_name
       where item_id = p_item_id;
    else
      delete from inv_stock where item_id = p_item_id;
      delete from inv_items where item_id = p_item_id;
    end if;
  end delete_item;

  ------------------------------------------------------------------------------
  -- stock movements
  ------------------------------------------------------------------------------
  procedure post_transaction(
    p_txn_type         in inv_transactions.txn_type%type,
    p_item_id          in inv_transactions.item_id%type,
    p_quantity         in inv_transactions.quantity%type,
    p_from_location_id in inv_transactions.from_location_id%type default null,
    p_to_location_id   in inv_transactions.to_location_id%type default null,
    p_reference        in inv_transactions.reference%type default null,
    p_notes            in inv_transactions.notes%type default null,
    p_txn_date         in inv_transactions.txn_date%type default sysdate,
    p_txn_id           out inv_transactions.txn_id%type)
  is
    l_type   inv_transactions.txn_type%type := upper(trim(p_txn_type));
    l_active inv_items.active_yn%type;
    l_cost   inv_items.unit_cost%type;
    l_from   number := p_from_location_id;
    l_to     number := p_to_location_id;
  begin
    require(l_type, 'Movement type');
    if p_item_id is null then fail(-20001, 'Item is required.'); end if;
    if nvl(p_quantity, 0) = 0 then fail(-20013, 'Quantity must not be zero.'); end if;

    begin
      select active_yn, unit_cost into l_active, l_cost from inv_items where item_id = p_item_id;
    exception
      when no_data_found then fail(-20012, 'Item does not exist.');
    end;
    if l_active <> 'Y' then fail(-20011, 'Item is inactive.'); end if;

    case l_type
      when c_receipt then
        if p_quantity < 0 then fail(-20014, 'Receipt quantity must be positive.'); end if;
        l_from := null;
        check_active_location(l_to, 'To location');
        apply_delta(p_item_id, l_to, p_quantity);
      when c_issue then
        if p_quantity < 0 then fail(-20014, 'Issue quantity must be positive.'); end if;
        l_to := null;
        check_active_location(l_from, 'From location');
        apply_delta(p_item_id, l_from, -p_quantity);
      when c_transfer then
        if p_quantity < 0 then fail(-20014, 'Transfer quantity must be positive.'); end if;
        check_active_location(l_from, 'From location');
        check_active_location(l_to, 'To location');
        if l_from = l_to then fail(-20015, 'From and To locations must be different.'); end if;
        -- lock in a fixed order to avoid deadlocks between concurrent transfers
        if l_from < l_to then
          apply_delta(p_item_id, l_from, -p_quantity);
          apply_delta(p_item_id, l_to, p_quantity);
        else
          apply_delta(p_item_id, l_to, p_quantity);
          apply_delta(p_item_id, l_from, -p_quantity);
        end if;
      when c_adjust then
        l_from := null;
        check_active_location(l_to, 'Location');
        apply_delta(p_item_id, l_to, p_quantity);
      else
        fail(-20016, 'Unknown movement type ' || l_type || '.');
    end case;

    insert into inv_transactions (txn_type, item_id, from_location_id, to_location_id, quantity,
                                  unit_cost, reference, notes, txn_date)
    values (l_type, p_item_id, l_from, l_to, p_quantity,
            l_cost, trim(p_reference), p_notes, nvl(p_txn_date, sysdate))
    returning txn_id into p_txn_id;
  end post_transaction;

  function qty_on_hand(
    p_item_id     in inv_items.item_id%type,
    p_location_id in inv_locations.location_id%type default null) return number
  is
    l_qty number;
  begin
    select nvl(sum(qty_on_hand), 0) into l_qty
      from inv_stock
     where (p_item_id is null or item_id = p_item_id)
       and (p_location_id is null or location_id = p_location_id);
    return l_qty;
  end qty_on_hand;

  ------------------------------------------------------------------------------
  -- test-only purge
  ------------------------------------------------------------------------------
  procedure qa_purge(
    p_confirm      in  varchar2,
    p_items        out pls_integer,
    p_stock_rows   out pls_integer,
    p_transactions out pls_integer)
  is
    c_like constant varchar2(10) := 'QA-%';   -- '-' is literal; only '%' is a wildcard
    l_other_items  pls_integer;
    l_other_stock  pls_integer;
    l_other_txns   pls_integer;
    l_after_items  pls_integer;
    l_after_stock  pls_integer;
    l_after_txns   pls_integer;
  begin
    if p_confirm is null or p_confirm <> c_qa_confirm then
      fail(-20091, 'qa_purge is test-only; pass p_confirm => ''' || c_qa_confirm || '''.');
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
      fail(-20090, 'qa_purge guard tripped: non-QA rows would change. Nothing was deleted.');
    end if;
  end qa_purge;
end inv_api;
/
