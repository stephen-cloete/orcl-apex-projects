--------------------------------------------------------------------------------
-- apex-inventory-control : database install (re-runnable)
-- Run in SQLcl / SQL*Plus connected as INVENTORY_CONTROL:
--   @install.sql
-- or as ADMIN:
--   alter session set current_schema = inventory_control;
--   @install.sql
--------------------------------------------------------------------------------
set define off
whenever sqlerror exit failure rollback
prompt == tables
@@install/01_tables.sql
prompt == views
@@install/02_views.sql
prompt == inv_api
@@install/03_inv_api.pks
@@install/04_inv_api.pkb
prompt == seed data
@@install/05_seed.sql
prompt == apex error handler
@@install/06_inv_ui_error.sql
prompt == invalid objects (expect none)
select object_name, object_type from user_objects where status <> 'VALID';
