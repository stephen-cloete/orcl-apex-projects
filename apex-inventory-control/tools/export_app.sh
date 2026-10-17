#!/usr/bin/env bash
# Export app 1301 with APEX_EXPORT (via ORDS REST-enabled SQL, see ords_sql.py) into apex/f1301.sql
set -euo pipefail
OUT="$(cd "$(dirname "$0")/.." && pwd)/apex/f1301.sql"
printf "begin apex_util.set_workspace('INVENTORY_CONTROL'); end;\n/\nselect contents from table(apex_export.get_application(p_application_id => 1301));\n" \
 | "$(dirname "$0")/ords_sql.py" - --raw | python3 -c "
import sys,json
for l in sys.stdin:
    d=json.loads(l); rs=d.get('resultSet')
    if rs:
        import re; c=re.sub(r'p_default_workspace_id=>\\d+', 'p_default_workspace_id=>0', rs['items'][0]['contents'])  # environment-neutral; import_app.sh sets the workspace
        open('$OUT','w').write(c); print('exported', len(c))"
