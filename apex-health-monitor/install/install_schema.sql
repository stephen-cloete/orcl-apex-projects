--------------------------------------------------------------------------------
-- apex-health-monitor : install_schema.sql  (run as HEALTH_MON)
--------------------------------------------------------------------------------
set define off verify off feedback on
whenever sqlerror exit failure rollback
prompt == tables
@@01_tables.sql
prompt == package
@@02_hm_pkg.pks
@@02_hm_pkg.pkb
show errors package body hm_pkg
prompt == views
@@03_views.sql
prompt == seed data
@@05_seed.sql
prompt == scheduler jobs
@@04_jobs.sql
