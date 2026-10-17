create or replace package body hm_pkg as

  function evaluate (p_value in number, p_warn in number, p_crit in number) return varchar2 is
  begin
    if p_crit is not null and p_value >= p_crit then return c_down;     end if;
    if p_warn is not null and p_value >= p_warn then return c_degraded; end if;
    return c_up;
  end evaluate;

  function validate_target (p_target_type in varchar2, p_endpoint in varchar2) return varchar2 is
    l_sql varchar2(32767) := ltrim(lower(p_endpoint));
  begin
    if p_endpoint is null then
      return 'Endpoint is required.';
    elsif p_target_type = 'HTTP' and not regexp_like(p_endpoint, '^https://[^[:space:]]+$', 'i') then
      return 'HTTP targets must be an https:// URL (Autonomous Database only allows HTTPS).';
    elsif p_target_type = 'SQL' and not (l_sql like 'select%' or l_sql like 'with%') then
      return 'SQL targets must be a single SELECT that returns one number.';
    elsif p_target_type = 'SQL' and instr(p_endpoint, ';') > 0 then
      return 'Remove the trailing semicolon; one SELECT only.';
    end if;
    return null;
  end validate_target;

  procedure http_probe (
    p_url        in  varchar2,
    p_timeout    in  number,
    o_http       out number,
    o_ms         out number,
    o_message    out varchar2)
  is
    l_req   utl_http.req;
    l_resp  utl_http.resp;
    l_start timestamp with time zone := systimestamp;
    l_buf   varchar2(2000);
  begin
    utl_http.set_transfer_timeout(p_timeout);
    utl_http.set_detailed_excp_support(true);
    l_req := utl_http.begin_request(p_url, 'GET', 'HTTP/1.1');
    utl_http.set_header(l_req, 'User-Agent', 'apex-health-monitor/1.0 (+Oracle APEX)');
    utl_http.set_header(l_req, 'Accept', 'text/html,application/json;q=0.9,*/*;q=0.8');
    l_resp := utl_http.get_response(l_req);
    o_http := l_resp.status_code;
    begin
      utl_http.read_text(l_resp, l_buf, 2000);   -- first chunk is enough
    exception when utl_http.end_of_body then null;
    end;
    utl_http.end_response(l_resp);
    o_ms := round(extract(second from (systimestamp - l_start)) * 1000
                + extract(minute from (systimestamp - l_start)) * 60000);
    o_message := 'HTTP ' || o_http || ' ' || l_resp.reason_phrase;
  exception
    when others then
      begin utl_http.end_response(l_resp); exception when others then null; end;
      o_ms := round(extract(second from (systimestamp - l_start)) * 1000
                  + extract(minute from (systimestamp - l_start)) * 60000);
      o_message := sqlerrm;
      if utl_http.get_detailed_sqlerrm is not null
         and instr(o_message, utl_http.get_detailed_sqlerrm) = 0 then
        o_message := o_message || ' ' || utl_http.get_detailed_sqlerrm;
      end if;
      o_message := substr(o_message, 1, 1000);
  end http_probe;

  procedure record_result (
    p_target_id in number,
    p_status    in varchar2,
    p_http      in number,
    p_ms        in number,
    p_value     in number,
    p_message   in varchar2)
  is
    l_open hm_incidents%rowtype;
  begin
    insert into hm_checks (target_id, status, http_status, response_ms, metric_value, message)
    values (p_target_id, p_status, p_http, p_ms, p_value, substr(p_message, 1, 1000));

    begin
      select * into l_open
        from hm_incidents
       where target_id = p_target_id and resolved_at is null
       order by started_at desc
       fetch first 1 row only;
    exception when no_data_found then l_open := null;
    end;

    if p_status = c_up then
      if l_open.incident_id is not null then
        update hm_incidents
           set resolved_at  = systimestamp,
               last_message = 'Recovered: ' || substr(p_message, 1, 980)
         where incident_id = l_open.incident_id;
      end if;
    elsif l_open.incident_id is null then
      insert into hm_incidents (target_id, severity, first_message, last_message)
      values (p_target_id, p_status, substr(p_message,1,1000), substr(p_message, 1, 1000));
    else
      update hm_incidents
         set check_count  = check_count + 1,
             last_message = substr(p_message, 1, 1000),
             severity     = case when p_status = c_down then c_down else severity end
       where incident_id = l_open.incident_id;
    end if;
  end record_result;

  function check_target (p_target_id in number) return varchar2 is
    l_t       hm_targets%rowtype;
    l_status  varchar2(10);
    l_http    number;
    l_ms      number;
    l_value   number;
    l_msg     varchar2(4000);
    l_start   timestamp with time zone;
  begin
    select * into l_t from hm_targets where target_id = p_target_id;

    if l_t.target_type = 'HTTP' then
      http_probe(l_t.endpoint, l_t.timeout_sec, l_http, l_ms, l_msg);
      if l_http is null then
        l_status := c_down;
      elsif l_http <> nvl(l_t.expected_status, 200) then
        l_status := c_down;
        l_msg := l_msg || ' (expected ' || nvl(l_t.expected_status, 200) || ')';
      else
        l_status := evaluate(l_ms, l_t.warn_threshold, l_t.crit_threshold);
        if l_status <> c_up then
          l_msg := l_msg || ' - slow: ' || l_ms || ' ms';
        end if;
      end if;
    else
      l_start := systimestamp;
      begin
        execute immediate l_t.endpoint into l_value;
        l_ms := round(extract(second from (systimestamp - l_start)) * 1000);
        l_status := evaluate(l_value, l_t.warn_threshold, l_t.crit_threshold);
        l_msg := 'Value ' || l_value ||
                 case when l_status <> c_up
                      then ' breached ' || case l_status when c_down then 'critical ' || l_t.crit_threshold
                                                         else 'warning ' || l_t.warn_threshold end
                 end;
      exception when others then
        l_ms := round(extract(second from (systimestamp - l_start)) * 1000);
        l_status := c_down;
        l_msg := substr(sqlerrm, 1, 1000);
      end;
    end if;

    record_result(p_target_id, l_status, l_http, l_ms, l_value, l_msg);
    commit;
    return l_status;
  end check_target;

  procedure check_target (p_target_id in number) is
    l_dummy varchar2(10);
  begin
    l_dummy := check_target(p_target_id);
  end check_target;

  procedure run_due_checks (p_force in boolean default false) is
  begin
    for r in (
      select t.target_id
        from hm_targets t
       where t.enabled_yn = 'Y'
         and (   p_force
              or not exists (select null from hm_checks c
                              where c.target_id = t.target_id
                                and c.checked_at > systimestamp - numtodsinterval(t.interval_min, 'MINUTE')
                                                               + interval '20' second))
       order by t.target_id)
    loop
      begin
        check_target(r.target_id);
      exception when others then
        rollback;
        -- never let one bad target stop the run
        record_result(r.target_id, c_down, null, null, null, 'Engine error: ' || sqlerrm);
        commit;
      end;
    end loop;
  end run_due_checks;

  procedure purge_history (p_days in number default 30) is
  begin
    delete from hm_checks where checked_at < systimestamp - numtodsinterval(p_days, 'DAY');
    commit;
  end purge_history;

  function uptime_pct (p_target_id in number, p_hours in number default 24) return number is
    l_pct number;
  begin
    select round(100 * avg(case when status = c_down then 0 else 1 end), 2)
      into l_pct
      from hm_checks
     where target_id = p_target_id
       and checked_at >= systimestamp - numtodsinterval(p_hours, 'HOUR');
    return l_pct;
  end uptime_pct;

end hm_pkg;
/
