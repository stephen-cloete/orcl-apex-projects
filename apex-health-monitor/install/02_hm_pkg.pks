create or replace package hm_pkg authid definer as
  --------------------------------------------------------------------------
  -- apex-health-monitor engine.
  --   HTTP targets : HTTPS GET, status = expected_status and response time
  --                  vs warn/crit thresholds (ms).
  --   SQL targets  : single-value SELECT, value vs warn/crit thresholds.
  -- State changes open / update / resolve rows in HM_INCIDENTS.
  --------------------------------------------------------------------------
  c_up       constant varchar2(10) := 'UP';
  c_degraded constant varchar2(10) := 'DEGRADED';
  c_down     constant varchar2(10) := 'DOWN';

  -- Run one target now and record the result. Returns the new status.
  function check_target (p_target_id in number) return varchar2;
  procedure check_target (p_target_id in number);

  -- Run every enabled target whose interval has elapsed (scheduler entry point).
  -- p_force => true runs all enabled targets regardless of interval.
  procedure run_due_checks (p_force in boolean default false);

  -- Remove check history older than p_days (incidents are kept).
  procedure purge_history (p_days in number default 30);

  -- Uptime % (UP or DEGRADED counts as available) over the last p_hours.
  function uptime_pct (p_target_id in number, p_hours in number default 24) return number;

  -- Validate a target definition; returns null when valid, else an error text.
  function validate_target (p_target_type in varchar2, p_endpoint in varchar2) return varchar2;
end hm_pkg;
/
