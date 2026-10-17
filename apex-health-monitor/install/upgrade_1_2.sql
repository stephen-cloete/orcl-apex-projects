--------------------------------------------------------------------------------
-- apex-health-monitor : upgrade_1_2.sql   (run as HEALTH_MON on a 1.1 install)
-- 1.2: configurable display time zone (HM_SETTINGS.display_timezone).
-- Re-runnable; never overwrites a value you have set.
-- Set your own zone with, for example:
--   update hm_settings set value = 'Europe/London' where name = 'display_timezone'; commit;
--------------------------------------------------------------------------------
set define off feedback on
whenever sqlerror exit failure rollback
@@hm_settings.sql
@@02_hm_pkg.pks
@@02_hm_pkg.pkb
show errors package body hm_pkg
@@03_views.sql
