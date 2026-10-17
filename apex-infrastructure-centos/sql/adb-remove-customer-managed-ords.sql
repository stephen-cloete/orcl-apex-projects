-- adb-remove-customer-managed-ords.sql <runtime_user> <gateway_user> : undo adb-customer-managed-ords.sql (run as ADMIN)
set verify off
alter user &2 revoke connect through &1;
drop user &2;
drop user &1;
