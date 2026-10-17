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
  values ('__test_http__', 'HTTP', 'https://does-not-exist.invalid/', 'N', 5)
  returning target_id into l_bad;
  commit;
  ok('unresolvable host is DOWN', hm_pkg.check_target(l_bad) = 'DOWN');

  delete from hm_targets where target_id in (l_id, l_bad);   -- cascades checks + incidents
  commit;
  ok('cleanup', true);

  if l_fail > 0 then
    raise_application_error(-20000, l_fail || ' test(s) failed');
  end if;
  dbms_output.put_line('ALL TESTS PASSED');
end;
/
