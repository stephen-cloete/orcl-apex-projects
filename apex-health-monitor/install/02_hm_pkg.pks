create or replace package hm_pkg authid definer as
  --------------------------------------------------------------------------
  -- apex-health-monitor engine.
  --   HTTP targets : HTTPS GET, status = expected_status and response time
  --                  vs warn/crit thresholds (ms).
  --   SQL targets  : single-value SELECT, value vs warn/crit thresholds.
  --   UNREACHABLE  : the database could not reach the target at all (DNS
  --                  lookup failed, network ACL, refused, connect/transfer
  --                  timeout).  DOWN is reserved for a target that answered
  --                  badly (wrong HTTP status, too slow, SQL error / breach).
  -- State changes open / update / resolve rows in HM_INCIDENTS.
  --------------------------------------------------------------------------
  c_up       constant varchar2(12) := 'UP';
  c_degraded constant varchar2(12) := 'DEGRADED';
  c_down     constant varchar2(12) := 'DOWN';
  c_unreach  constant varchar2(12) := 'UNREACHABLE';

  -- Run one target now and record the result. Returns the new status.
  function check_target (p_target_id in number) return varchar2;
  procedure check_target (p_target_id in number);

  -- Run every enabled target whose interval has elapsed (scheduler entry point).
  -- p_force => true runs all enabled targets regardless of interval.
  procedure run_due_checks (p_force in boolean default false);

  -- Remove check history older than p_days (incidents are kept).
  procedure purge_history (p_days in number default 30);

  -- Network / name-resolution failure?  Returns true for ORA-12545 (host not
  -- found), ORA-24247 (network ACL), ORA-12541/12543 (refused / unreachable),
  -- ORA-12535/12170 (connect timeout) and ORA-29276 (transfer timeout).
  function is_unreachable_error (p_message in varchar2) return boolean;

  -- Readable reason for an unreachable error, e.g. 'DNS lookup failed'.
  function unreachable_reason (p_message in varchar2) return varchar2;

  -- Collapse an Oracle error text: each distinct ORA-/PLS- error once, in order.
  function clean_error (p_message in varchar2) return varchar2;

  -- Uptime % (UP or DEGRADED counts as available; DOWN and UNREACHABLE do not) over the last p_hours.
  function uptime_pct (p_target_id in number, p_hours in number default 24) return number;

  -- Validate a target definition; returns null when valid, else an error text.
  function validate_target (p_target_type in varchar2, p_endpoint in varchar2) return varchar2;
end hm_pkg;
/
