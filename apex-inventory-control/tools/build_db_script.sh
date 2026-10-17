#!/usr/bin/env bash
# Concatenate the install scripts into one ORDS-friendly script that runs as ADMIN in schema INVENTORY_CONTROL
D="$(cd "$(dirname "$0")/../database/install" && pwd)"
echo "alter session set current_schema = inventory_control;"
for f in 01_tables.sql 02_views.sql 03_inv_api.pks 04_inv_api.pkb 05_seed.sql 06_inv_ui_error.sql; do cat $D/$f; echo; done
echo "select object_name, object_type, status from all_objects where owner='INVENTORY_CONTROL' and status<>'VALID';"
echo "select 'objects='||count(*) c from all_objects where owner='INVENTORY_CONTROL';"
