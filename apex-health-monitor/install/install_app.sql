--------------------------------------------------------------------------------
-- apex-health-monitor : install_app.sql
-- Run as ADMIN (or any user with APEX_ADMINISTRATOR_ROLE) from the install
-- directory.  Installs apex/f2600.sql into workspace HEALTH_MON, parsing
-- schema HEALTH_MON, application id 2600, alias HEALTH-MONITOR.
--------------------------------------------------------------------------------
whenever sqlerror exit failure rollback
begin
  apex_application_install.set_workspace('HEALTH_MON');
  apex_application_install.set_application_id(2600);
  apex_application_install.set_schema('HEALTH_MON');
  apex_application_install.set_application_alias('HEALTH-MONITOR');
  apex_application_install.generate_offset;
end;
/
@@../apex/f2600.sql
