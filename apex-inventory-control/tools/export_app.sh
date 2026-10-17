#!/usr/bin/env bash
# Export app 1301 from EU DEV with APEX_EXPORT (via ORDS REST SQL) into the repo
set -euo pipefail
OUT=/workspace/apex-inventory-control-repo/apex-inventory-control/apex/f1301.sql
printf "begin apex_util.set_workspace('INVENTORY_CONTROL'); end;\n/\nselect contents from table(apex_export.get_application(p_application_id => 1301));\n" \
 | "$(dirname "$0")/eu_sql.py" - --raw | python3 -c "
import sys,json
for l in sys.stdin:
    d=json.loads(l); rs=d.get('resultSet')
    if rs: open('$OUT','w').write(rs['items'][0]['contents']); print('exported', len(rs['items'][0]['contents']))"
