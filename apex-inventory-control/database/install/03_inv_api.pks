create or replace package inv_api
authid definer
as
  ------------------------------------------------------------------------------
  -- apex-inventory-control : business API.
  -- All writes from the APEX app go through this package; pages hold no DML.
  -- Errors are raised as ORA-20001..20099 with user-facing messages.
  ------------------------------------------------------------------------------
  c_receipt  constant varchar2(10) := 'RECEIPT';
  c_issue    constant varchar2(10) := 'ISSUE';
  c_transfer constant varchar2(10) := 'TRANSFER';
  c_adjust   constant varchar2(10) := 'ADJUST';

  -- Audit user: APEX user when called from the app, else the DB user.
  function current_user_name return varchar2;

  -- reference data ------------------------------------------------------------
  procedure save_category(
    p_category_id in out nocopy inv_categories.category_id%type,
    p_name        in inv_categories.name%type,
    p_description in inv_categories.description%type default null,
    p_active_yn   in inv_categories.active_yn%type default 'Y');
  procedure delete_category(p_category_id in inv_categories.category_id%type);

  procedure save_location(
    p_location_id in out nocopy inv_locations.location_id%type,
    p_code        in inv_locations.code%type,
    p_name        in inv_locations.name%type,
    p_description in inv_locations.description%type default null,
    p_active_yn   in inv_locations.active_yn%type default 'Y');
  procedure delete_location(p_location_id in inv_locations.location_id%type);

  procedure save_supplier(
    p_supplier_id  in out nocopy inv_suppliers.supplier_id%type,
    p_name         in inv_suppliers.name%type,
    p_contact_name in inv_suppliers.contact_name%type default null,
    p_email        in inv_suppliers.email%type default null,
    p_phone        in inv_suppliers.phone%type default null,
    p_active_yn    in inv_suppliers.active_yn%type default 'Y');
  procedure delete_supplier(p_supplier_id in inv_suppliers.supplier_id%type);

  -- items -----------------------------------------------------------------------
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
    p_reorder_qty   in inv_items.reorder_qty%type default null,  -- null => greatest(reorder level, 1); must be > 0
    p_active_yn     in inv_items.active_yn%type default 'Y');

  -- Deletes an item with no stock history; otherwise marks it inactive.
  procedure delete_item(p_item_id in inv_items.item_id%type);

  -- stock movements -------------------------------------------------------------
  -- RECEIPT  : p_to_location_id,   p_quantity > 0
  -- ISSUE    : p_from_location_id, p_quantity > 0
  -- TRANSFER : both locations (different), p_quantity > 0
  -- ADJUST   : p_to_location_id, signed p_quantity (+ found / - shrinkage)
  procedure post_transaction(
    p_txn_type         in inv_transactions.txn_type%type,
    p_item_id          in inv_transactions.item_id%type,
    p_quantity         in inv_transactions.quantity%type,
    p_from_location_id in inv_transactions.from_location_id%type default null,
    p_to_location_id   in inv_transactions.to_location_id%type default null,
    p_reference        in inv_transactions.reference%type default null,
    p_notes            in inv_transactions.notes%type default null,
    p_txn_date         in inv_transactions.txn_date%type default sysdate,
    p_txn_id           out inv_transactions.txn_id%type);

  -- Current on-hand for an item, at one location or across all locations.
  function qty_on_hand(
    p_item_id     in inv_items.item_id%type,
    p_location_id in inv_locations.location_id%type default null) return number;
end inv_api;
/
