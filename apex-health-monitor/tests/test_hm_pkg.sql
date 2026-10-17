--------------------------------------------------------------------------------
-- apex-health-monitor : tests/test_hm_pkg.sql   (run as HEALTH_MON)
-- Self-cleaning PL/SQL tests for the engine: validation, SQL thresholds,
-- incident open -> escalate -> resolve, uptime and HTTP failure handling.
-- Prints PASS/FAIL per case and raises if anything failed.
--------------------------------------------------------------------------------
set serveroutput on feedback off
declare
  l_id     number;
  l_bad    number;
  l_status varchar2(10);
  l_fail   pls_integer := 0;
  l_inc    hm_incidents%rowtype;
  l_msg    varchar2(4000);
  l_dup    varchar2(4000) := 'ORA-12545: host not found' || chr(10) || 'ORA-12545: host not found';
  procedure ok (p_name varchar2, p_cond boolean) is
  begin
    if p_cond then dbms_output.put_line('PASS  ' || p_name);
    else dbms_output.put_line('FAIL  ' || p_name); l_fail := l_fail + 1; end if;
  end;
begin
  -- validation
  ok('reject http:// URL',      hm_pkg.validate_target('HTTP', 'http://example.com') is not null);
  ok('accept https:// URL',     hm_pkg.validate_target('HTTP', 'https://example.com/') is null);
  ok('reject non-SELECT SQL',   hm_pkg.validate_target('SQL', 'delete from hm_checks') is not null);
  ok('reject multi statements', hm_pkg.validate_target('SQL', 'select 1 from dual;') is not null);
  ok('accept WITH query',       hm_pkg.validate_target('SQL', 'with x as (select 1 v from dual) select v from x') is null);

  -- error text handling
  ok('clean_error keeps one copy of a duplicated error',
     hm_pkg.clean_error(l_dup) = 'ORA-12545: host not found');
  ok('clean_error keeps distinct errors in order',
     hm_pkg.clean_error('ORA-29273: request failed ORA-12545: x ORA-29273: request failed')
       = 'ORA-29273: request failed ORA-12545: x');
  ok('clean_error leaves plain text alone', hm_pkg.clean_error('  HTTP 200 OK ') = 'HTTP 200 OK');
  ok('ORA-12545 is unreachable (DNS)', hm_pkg.is_unreachable_error(l_dup)
       and hm_pkg.unreachable_reason(l_dup) like 'DNS lookup failed%');
  ok('ORA-24247 is unreachable (ACL)', hm_pkg.is_unreachable_error('ORA-24247: access denied'));
  ok('ORA-12535 / ORA-29276 are unreachable (timeouts)',
     hm_pkg.is_unreachable_error('ORA-12535: timed out') and hm_pkg.is_unreachable_error('ORA-29276: timed out'));
  ok('ORA-29024 (TLS certificate) is not unreachable', not hm_pkg.is_unreachable_error('ORA-29024: certificate error'));

  insert into hm_targets (name, target_type, endpoint, warn_threshold, crit_threshold, enabled_yn)
  values ('__test_sql__', 'SQL', 'select 5 from dual', 10, 20, 'N')
  returning target_id into l_id;
  commit;

  l_status := hm_pkg.check_target(l_id);
  ok('SQL value below warn is UP', l_status = 'UP');

  update hm_targets set warn_threshold = 5 where target_id = l_id; commit;
  l_status := hm_pkg.check_target(l_id);
  ok('SQL value at warn is DEGRADED', l_status = 'DEGRADED');
  select * into l_inc from hm_incidents where target_id = l_id and resolved_at is null;
  ok('incident opened as DEGRADED', l_inc.severity = 'DEGRADED');

  update hm_targets set crit_threshold = 5 where target_id = l_id; commit;
  l_status := hm_pkg.check_target(l_id);
  select * into l_inc from hm_incidents where target_id = l_id and resolved_at is null;
  ok('incident escalated to DOWN, 2 checks', l_status = 'DOWN' and l_inc.severity = 'DOWN' and l_inc.check_count = 2);

  update hm_targets set warn_threshold = 100, crit_threshold = 200 where target_id = l_id; commit;
  l_status := hm_pkg.check_target(l_id);
  select * into l_inc from hm_incidents where incident_id = l_inc.incident_id;
  ok('recovery resolves incident', l_status = 'UP' and l_inc.resolved_at is not null);
  ok('uptime 24h = 75% (1 of 4 down, degraded counts as up)', hm_pkg.uptime_pct(l_id, 24) = 75);

  update hm_targets set endpoint = 'select 1/0 from dual' where target_id = l_id; commit;
  ok('SQL error is DOWN', hm_pkg.check_target(l_id) = 'DOWN');

  insert into hm_targets (name, target_type, endpoint, enabled_yn, timeout_sec)
  values ('__test_http__', 'HTTP', 'https://host.invalid/', 'N', 5)
  returning target_id into l_bad;
  commit;
  ok('unresolvable host is UNREACHABLE (not DOWN)', hm_pkg.check_target(l_bad) = 'UNREACHABLE');
  select message into l_msg from hm_checks where target_id = l_bad order by checked_at desc fetch first 1 row only;
  ok('unreachable message names the reason', l_msg like 'Unreachable: DNS lookup failed%');
  ok('unreachable message has ORA-12545 exactly once', regexp_count(l_msg, 'ORA-12545') = 1);
  select * into l_inc from hm_incidents where target_id = l_bad and resolved_at is null;
  ok('incident opened as UNREACHABLE with one copy of the error',
     l_inc.severity = 'UNREACHABLE' and regexp_count(l_inc.first_message, 'ORA-12545') = 1);
  ok('unreachable counts against uptime', hm_pkg.uptime_pct(l_bad, 24) = 0);

  delete from hm_targets where target_id in (l_id, l_bad);   -- cascades checks + incidents
  commit;
  ok('cleanup', true);

  if l_fail > 0 then
    raise_application_error(-20000, l_fail || ' test(s) failed');
  end if;
  dbms_output.put_line('ALL TESTS PASSED');
end;
/
