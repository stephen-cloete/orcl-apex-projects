--------------------------------------------------------------------------------
-- apex-inventory-control : APEX error handling function (app 1301 references it by name)
-- Shows INV_API business messages (ORA-20000..20999) without the ORA- prefix and hides
-- internal error details from end users.
--------------------------------------------------------------------------------
create or replace function inv_ui_error (
  p_error in apex_error.t_error
) return apex_error.t_error_result
is
  l_result apex_error.t_error_result;
begin
  l_result := apex_error.init_error_result(p_error => p_error);
  if p_error.ora_sqlcode between -20999 and -20000 then
    l_result.message          := nvl(apex_error.get_first_ora_error_text(p_error => p_error),
                                     'The request could not be completed.');
    l_result.additional_info  := null;
    l_result.display_location := apex_error.c_inline_in_notification;
  elsif p_error.is_internal_error and not nvl(p_error.is_common_runtime_error, false) then
    l_result.message          := 'The request could not be completed. Please try again.';
    l_result.additional_info  := null;
    l_result.display_location := apex_error.c_inline_in_notification;
  end if;
  return l_result;
end inv_ui_error;
/
