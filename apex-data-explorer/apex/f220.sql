prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>0
,p_default_application_id=>220
,p_default_id_offset=>0
,p_default_owner=>'DATAEXP'
);
end;
/
 
prompt APPLICATION 220 - Data Explorer
--
-- Application Export:
--   Application:     220
--   Name:            Data Explorer
--   Export Type:     Application Export
--   Pages:           0 (global), 1, 2, 3, 4, 5, 6 (run), 9999
--   Parsing schema:  DATAEXP; page 6 runs as DATAEXP_RO (install database/ first)
--   Version:         26.1.5
--

prompt --application/delete_application
begin
wwv_flow_imp.remove_flow(wwv_flow.g_flow_id);
end;
/
prompt --application/create_application
begin
wwv_imp_workspace.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'DATAEXP')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'Data Explorer')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'DATA-EXPLORER')
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'7D3A0E5C91B24F68A0C3D5E7F9123456789ABCDEF0123456789ABCDEF0123456'
,p_bookmark_checksum_function=>'SH512'
,p_compatibility_mode=>'24.2'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'
,p_date_format=>'DS'
,p_timestamp_format=>'DS'
,p_timestamp_tz_format=>'DS'
,p_flow_image_prefix=>nvl(wwv_flow_application_install.get_image_prefix,'')
,p_authentication_id=>wwv_flow_imp.id(22000000000017)
,p_application_tab_set=>0
,p_logo_type=>'T'
,p_logo_text=>'Data Explorer'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'Release 1.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_authorize_batch_job=>'N'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_substitution_string_01=>'APP_TITLE'
,p_substitution_value_01=>'Data Explorer'
,p_file_prefix=>nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>1
,p_print_server_type=>'NATIVE'
,p_file_storage=>'DB'
,p_is_pwa=>'N'
,p_theme_id=>42
,p_home_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.'
,p_login_url=>'f?p=&APP_ID.:LOGIN:&SESSION.::&DEBUG.'
,p_theme_style_by_user_pref=>false
,p_built_with_love=>false
,p_global_page_id=>0
,p_navigation_list_id=>wwv_flow_imp.id(22000000000034)
,p_navigation_list_position=>'SIDE'
,p_navigation_list_template_id=>2469215554099805162
,p_nav_list_template_options=>'#DEFAULT#:js-defaultCollapsed:js-navCollapsed--hidden:t-TreeNav--styleA'
,p_nav_bar_type=>'LIST'
,p_nav_bar_list_id=>wwv_flow_imp.id(22000000000051)
,p_nav_bar_list_template_id=>2849019392706229583
,p_nav_bar_template_options=>'#DEFAULT#'
,p_vpd=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Page 6 runs the free-text Workbench queries: switch it to the read-only',
'-- schema, which holds nothing but SELECT grants on the objects users may query.',
'if :APP_PAGE_ID = 6 then',
'  apex_util.set_parsing_schema_for_request(p_schema => dx_api.c_ro_schema);',
'else',
'  :DX_MAX_ROWS := dx_api.max_rows;   -- server-side row cap (restricted item)',
'  dx_api.flush_run_log;              -- runs queued by page 6 -> DX_QUERY_LOG',
'end if;'))
);
end;
/
prompt --application/plugin_settings
begin
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000119)
,p_plugin_type=>'DYNAMIC ACTION'
,p_plugin=>'NATIVE_OPEN_AI_ASSISTANT'
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000136)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_COLOR_PICKER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'mode', 'FULL')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000153)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_DATE_PICKER_APEX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_behavior', 'MONTH-PICKER:YEAR-PICKER:TODAY-BUTTON',
  'days_outside_month', 'VISIBLE',
  'show_on', 'FOCUS',
  'time_increment', '15')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000170)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_GEOCODED_ADDRESS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'background', 'default',
  'display_as', 'LIST',
  'map_preview', 'POPUP:ITEM',
  'match_mode', 'RELAX_HOUSE_NUMBER')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000187)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SELECT_MANY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_values_as', 'separated')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000204)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SINGLE_CHECKBOX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'checked_value', 'Y',
  'unchecked_value', 'N')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000221)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_STAR_RATING'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'default_icon', 'fa-star',
  'tooltip', '#VALUE#')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000238)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_YES_NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_style', 'SWITCH_CB',
  'off_value', 'N',
  'on_value', 'Y')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000255)
,p_plugin_type=>'PROCESS TYPE'
,p_plugin=>'NATIVE_GEOCODING'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'match_mode', 'RELAX_HOUSE_NUMBER')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000272)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_DISPLAY_SELECTOR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'include_slider', 'Y')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000289)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_IR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'actions_menu_structure', 'IG')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000306)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_MAP_REGION'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_vector_tile_layers', 'Y')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000323)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_ADFBC'
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(22000000000340)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_BOSS'
);
end;
/
prompt --application/shared_components/navigation/lists/navigation_bar
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(22000000000051)
,p_name=>'Navigation Bar'
,p_static_id=>'navigation-bar'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22000000000357)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'&APP_USER.'
,p_static_id=>'app-user'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user'
,p_list_text_02=>'has-username'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22000000000374)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Sign Out'
,p_static_id=>'sign-out'
,p_list_item_link_target=>'&LOGOUT_URL.'
,p_list_item_icon=>'fa-sign-out'
,p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'
,p_parent_list_item_id=>wwv_flow_imp.id(22000000000357)
,p_list_item_current_type=>'TARGET_PAGE'
);
end;
/
prompt --application/shared_components/navigation/lists/navigation_menu
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(22000000000034)
,p_name=>'Navigation Menu'
,p_static_id=>'navigation-menu'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22000000000391)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Explore'
,p_static_id=>'explore'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-database-search'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22000000000408)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Query Workbench'
,p_static_id=>'workbench'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-terminal'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22000000000425)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Saved Queries'
,p_static_id=>'saved-queries'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-bookmark-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22000000000442)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Query Log'
,p_static_id=>'query-log'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-history'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22000000000459)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Data Sources'
,p_static_id=>'data-sources'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-plug'
,p_security_scheme=>wwv_flow_imp.id(22000000000085)
,p_list_item_current_type=>'TARGET_PAGE'
);
end;
/
prompt --application/shared_components/logic/application_items/dx_max_rows
begin
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(22000000000102)
,p_name=>'DX_MAX_ROWS'
,p_protection_level=>'I'
);
end;
/
prompt --application/shared_components/security/authorizations/data_explorer_admin
begin
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(22000000000085)
,p_name=>'Data Explorer Admin'
,p_static_id=>'data-explorer-admin'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'plsql_function_body', 'return dx_api.is_admin(:APP_USER);')).to_clob
,p_error_message=>'Data Explorer administrator access is required. Ask an administrator to add you to ADMIN_USERS.'
,p_caching=>'BY_USER_BY_SESSION'
);
end;
/
prompt --application/shared_components/user_interface/themes
begin
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(22000000000068)
,p_theme_id=>42
,p_static_id=>'universal-theme'
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_version_identifier=>'26.1'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_is_locked=>false
,p_current_theme_style_id=>2243014446517417
,p_default_page_template=>4073832297226169690
,p_default_dialog_template=>2101883943284197310
,p_error_template=>2102634289808461002
,p_printer_friendly_template=>4073832297226169690
,p_login_template=>2102634289808461002
,p_default_button_template=>4073839297780169708
,p_default_region_template=>4073835273271169698
,p_default_chart_template=>4073835273271169698
,p_default_form_template=>4073835273271169698
,p_default_reportr_template=>4073835273271169698
,p_default_wizard_template=>4073835273271169698
,p_default_menur_template=>2532939663579242476
,p_default_listr_template=>4073835273271169698
,p_default_irr_template=>2102002977963900996
,p_default_report_template=>2540130677583398057
,p_default_label_template=>1610598304472262251
,p_default_menu_template=>4073839682315169711
,p_default_list_template=>4073837480889169704
,p_default_top_nav_list_temp=>2528231041045349458
,p_default_side_nav_list_temp=>2469215554099805162
,p_default_nav_list_position=>'SIDE'
,p_default_dialogbtnr_template=>2127905476394690047
,p_default_dialogr_template=>4502917002193490937
,p_default_option_label=>1610598304472262251
,p_default_required_label=>1610598484065263269
,p_default_navbar_list_template=>2849019392706229583
,p_file_prefix=>nvl(wwv_flow_application_install.get_static_theme_file_prefix(42),'#APEX_FILES#themes/theme_42/26.1/')
,p_files_version=>2461306150227
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APEX_FILES#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_FILES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_FILES#css/Core#MIN#.css?v=#APEX_VERSION#'
,p_reference_id=>wwv_imp_util.get_subscription_id(4073840274158169736,2000,'universal-theme',8842.261)
,p_version_scn_master=>'SH256:WOPVC8vP1TPWUxczh2dJ4mCZcNGSTzA1cn8DjR2oQjY'
);
end;
/
prompt --application/shared_components/security/authentications/oracle_apex_accounts
begin
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(22000000000017)
,p_name=>'Oracle APEX Accounts'
,p_static_id=>'oracle-apex-accounts'
,p_scheme_type=>'NATIVE_APEX_ACCOUNTS'
,p_invalid_session_type=>'LOGIN'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
);
end;
/
prompt --application/pages/page_00000
begin
wwv_flow_imp_page.create_page(
 p_id=>0
,p_name=>'Global Page'
,p_reload_on_submit=>null
,p_warn_on_unsaved_changes=>null
,p_autocomplete_on_off=>'OFF'
,p_protection_level=>'D'
);
end;
/
prompt --application/pages/page_00001
begin
wwv_flow_imp_page.create_page(
 p_id=>1
,p_name=>'Explore'
,p_alias=>'HOME'
,p_step_title=>'Explore'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* results and reports scroll inside their region on small screens */',
'.t-Body-content, .t-Body-contentInner, .t-Body-mainContent { min-width: 0; }',
'.t-Region-body { overflow-x: auto; -webkit-overflow-scrolling: touch; }',
'.dx-scroll { overflow-x: auto; max-width: 100%; }',
'.dx-result .t-Report-report th, .dx-result .t-Report-report td { white-space: nowrap; }',
'.dx-num { text-align: right !important; font-variant-numeric: tabular-nums; }'))
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22000000000476)
,p_plug_name=>'Data Explorer'
,p_static_id=>'intro'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p>Pick a table or view from a registered data source to open it in the <a href="f?p=&APP_ID.:2:&SESSION.">Query Workbench</a>, or write your own SELECT there. Results are read-only and capped; every run is recorded in the Query Log.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22000000000510)
,p_plug_name=>'Search'
,p_static_id=>'search'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000000527)
,p_name=>'P1_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(22000000000510)
,p_prompt=>'Search objects'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>200
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_inline_help_text=>'Matches source, object name or comment. Press Enter.'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'Y',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(22000000000493)
,p_name=>'Explorable objects'
,p_static_id=>'catalog'
,p_template=>4073835273271169698
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select source_name,',
'       owner,',
'       object_name,',
'       object_type,',
'       column_count,',
'       comments',
'  from dx_catalog_v',
' where :P1_SEARCH is null',
'    or instr(upper(source_name || '' '' || object_name || '' '' || comments), upper(:P1_SEARCH)) > 0',
' order by source_name, owner, object_name'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2540130677583398057
,p_query_num_rows=>25
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000000544)
,p_column_alias=>'SOURCE_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Source'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000000561)
,p_column_alias=>'OWNER'
,p_column_display_sequence=>20
,p_column_heading=>'Owner'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000000578)
,p_column_alias=>'OBJECT_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Object'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.:EXPLORE:&DEBUG.:2:P2_OWNER,P2_OBJECT:#OWNER#,#OBJECT_NAME#'
,p_column_linktext=>'#OBJECT_NAME#'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000000595)
,p_column_alias=>'OBJECT_TYPE'
,p_column_display_sequence=>40
,p_column_heading=>'Type'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000000612)
,p_column_alias=>'COLUMN_COUNT'
,p_column_display_sequence=>50
,p_column_heading=>'Columns'
,p_column_format=>'999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000000629)
,p_column_alias=>'COMMENTS'
,p_column_display_sequence=>60
,p_column_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(22000000000646)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
end;
/
prompt --application/pages/page_00002
begin
wwv_flow_imp_page.create_page(
 p_id=>2
,p_name=>'Query Workbench'
,p_alias=>'QUERY-WORKBENCH'
,p_step_title=>'Query Workbench'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* results and reports scroll inside their region on small screens */',
'.t-Body-content, .t-Body-contentInner, .t-Body-mainContent { min-width: 0; }',
'.t-Region-body { overflow-x: auto; -webkit-overflow-scrolling: touch; }',
'.dx-scroll { overflow-x: auto; max-width: 100%; }',
'.dx-result .t-Report-report th, .dx-result .t-Report-report td { white-space: nowrap; }',
'.dx-num { text-align: right !important; font-variant-numeric: tabular-nums; }'))
,p_warn_on_unsaved_changes=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22000000000663)
,p_plug_name=>'Query'
,p_static_id=>'query'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000000782)
,p_name=>'P2_QUERY_ID'
,p_item_sequence=>5
,p_item_plug_id=>wwv_flow_imp.id(22000000000663)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000000799)
,p_name=>'P2_OWNER'
,p_item_sequence=>6
,p_item_plug_id=>wwv_flow_imp.id(22000000000663)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000000816)
,p_name=>'P2_OBJECT'
,p_item_sequence=>7
,p_item_plug_id=>wwv_flow_imp.id(22000000000663)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000000833)
,p_name=>'P2_SQL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(22000000000663)
,p_prompt=>'SELECT statement'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cHeight=>10
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_inline_help_text=>'One SELECT or WITH query. It runs read-only, on the objects you have been given access to, and rows are capped on the server.'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000000850)
,p_name=>'P2_MAX_ROWS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(22000000000663)
,p_prompt=>'Rows'
,p_item_default=>'100'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:50;50,100;100,500;500,1000;1000'
,p_lov_display_null=>'NO'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000000867)
,p_name=>'P2_TITLE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(22000000000663)
,p_prompt=>'Title (to save)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000000884)
,p_name=>'P2_SHARED'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(22000000000663)
,p_prompt=>'Share with all users'
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:No;N,Yes;Y'
,p_lov_display_null=>'NO'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(22000000000714)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(22000000000663)
,p_button_name=>'RUN'
,p_static_id=>'run'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(22000000000731)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(22000000000663)
,p_button_name=>'DOWNLOAD'
,p_static_id=>'download'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_image_alt=>'Download CSV'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P2_SQL is not null'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(22000000000748)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(22000000000663)
,p_button_name=>'SAVE'
,p_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_image_alt=>'Save query'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P2_SQL is not null'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(22000000000765)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(22000000000663)
,p_button_name=>'NEW'
,p_static_id=>'new'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_image_alt=>'New query'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.:NEW:&DEBUG.:2::'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22000000000680)
,p_plug_name=>'Results'
,p_static_id=>'results'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'dx_api.render_last_result;'
,p_plug_source_type=>'NATIVE_PLSQL'
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>'dx_api.has_result'
,p_plug_display_when_cond2=>'PLSQL'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(22000000000697)
,p_name=>'Columns'
,p_static_id=>'columns'
,p_template=>4073835273271169698
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select column_name, data_type, nullable',
'  from dx_columns_v',
' where owner = :P2_OWNER',
'   and table_name = :P2_OBJECT',
' order by column_id'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2540130677583398057
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000000901)
,p_column_alias=>'COLUMN_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Column'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000000918)
,p_column_alias=>'DATA_TYPE'
,p_column_display_sequence=>20
,p_column_heading=>'Data type'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000000935)
,p_column_alias=>'NULLABLE'
,p_column_display_sequence=>30
,p_column_heading=>'Nullable'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000000952)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load query'
,p_static_id=>'load-query'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_run boolean := false;',
'begin',
'  if :REQUEST = ''NEW'' then',
'    dx_api.clear_result;',
'  elsif :REQUEST = ''EXPLORE'' and :P2_OWNER is not null and :P2_OBJECT is not null then',
'    :P2_SQL      := dx_api.object_sql(:P2_OWNER, :P2_OBJECT);',
'    :P2_QUERY_ID := null;',
'    :P2_TITLE    := initcap(replace(:P2_OBJECT, ''_'', '' ''));',
'    l_run        := true;',
'  elsif :P2_QUERY_ID is not null and :P2_SQL is null then',
'    for q in (select title, sql_text, is_shared from dx_saved_queries_v where query_id = to_number(:P2_QUERY_ID)) loop',
'      :P2_SQL    := q.sql_text;',
'      :P2_TITLE  := q.title;',
'      :P2_SHARED := q.is_shared;',
'      l_run      := true;',
'    end loop;',
'  end if;',
'  if l_run then',
'    -- run it straight away on the read-only run page, which comes back here;',
'    -- persist state first: redirect_url stops the engine',
'    apex_util.set_session_state(''P2_SQL'', :P2_SQL);',
'    apex_util.set_session_state(''P2_QUERY_ID'', :P2_QUERY_ID);',
'    apex_util.set_session_state(''P2_TITLE'', :P2_TITLE);',
'    apex_util.set_session_state(''P2_SHARED'', :P2_SHARED);',
'    dx_api.clear_result;',
'    commit;',
'    apex_util.redirect_url(apex_page.get_url(p_page => 6));',
'  end if;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>22000000000952
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000000969)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save query'
,p_static_id=>'save-query'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  :P2_QUERY_ID := dx_api.save_query(',
'                    p_query_id  => to_number(:P2_QUERY_ID),',
'                    p_title     => :P2_TITLE,',
'                    p_sql       => :P2_SQL,',
'                    p_is_shared => :P2_SHARED);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(22000000000748)
,p_process_success_message=>'Query saved.'
,p_internal_uid=>22000000000969
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(22000000000986)
,p_branch_name=>'Run on page 6'
,p_branch_action=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(22000000000714)
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(22000000001003)
,p_branch_name=>'CSV on page 6'
,p_branch_action=>'f?p=&APP_ID.:6:&SESSION.:CSV:&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(22000000000731)
,p_branch_sequence=>20
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(22000000001020)
,p_branch_name=>'Go To Page 2'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
);
end;
/
prompt --application/pages/page_00006
begin
wwv_flow_imp_page.create_page(
 p_id=>6
,p_name=>'Run Query'
,p_alias=>'RUN-QUERY'
,p_step_title=>'Run Query'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'U'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* results and reports scroll inside their region on small screens */',
'.t-Body-content, .t-Body-contentInner, .t-Body-mainContent { min-width: 0; }',
'.t-Region-body { overflow-x: auto; -webkit-overflow-scrolling: touch; }',
'.dx-scroll { overflow-x: auto; max-width: 100%; }',
'.dx-result .t-Report-report th, .dx-result .t-Report-report td { white-space: nowrap; }',
'.dx-num { text-align: right !important; font-variant-numeric: tabular-nums; }'))
,p_page_mode=>'NORMAL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000001037)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Run query'
,p_static_id=>'run-query'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- parsed as DATAEXP_RO: only DX_EXEC (its own package) and APEX APIs are used here',
'declare',
'  l_max pls_integer := least(nvl(to_number(v(''P2_MAX_ROWS'')), 100), nvl(to_number(:DX_MAX_ROWS), 500));',
'begin',
'  if :REQUEST = ''CSV'' then',
'    dx_exec.download_csv(',
'      p_sql      => v(''P2_SQL''),',
'      p_filename => nvl(regexp_replace(lower(v(''P2_TITLE'')), ''[^a-z0-9]+'', ''-''), ''data-explorer'') || ''.csv'',',
'      p_max_rows => l_max,',
'      p_query_id => to_number(v(''P2_QUERY_ID'')));',
'    apex_application.stop_apex_engine;',
'  else',
'    dx_exec.run_to_collection(',
'      p_sql      => v(''P2_SQL''),',
'      p_max_rows => l_max,',
'      p_query_id => to_number(v(''P2_QUERY_ID'')));',
'    commit;  -- keep the result and queued log row: redirect_url stops the engine',
'    apex_util.redirect_url(apex_page.get_url(p_page => 2));',
'  end if;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>22000000001037
);
end;
/
prompt --application/pages/page_00003
begin
wwv_flow_imp_page.create_page(
 p_id=>3
,p_name=>'Saved Queries'
,p_alias=>'SAVED-QUERIES'
,p_step_title=>'Saved Queries'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* results and reports scroll inside their region on small screens */',
'.t-Body-content, .t-Body-contentInner, .t-Body-mainContent { min-width: 0; }',
'.t-Region-body { overflow-x: auto; -webkit-overflow-scrolling: touch; }',
'.dx-scroll { overflow-x: auto; max-width: 100%; }',
'.dx-result .t-Report-report th, .dx-result .t-Report-report td { white-space: nowrap; }',
'.dx-num { text-align: right !important; font-variant-numeric: tabular-nums; }'))
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(22000000001054)
,p_name=>'Saved queries'
,p_static_id=>'saved-queries'
,p_template=>4073835273271169698
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select query_id,',
'       title,',
'       description,',
'       owner,',
'       case is_shared when ''Y'' then ''Shared'' else ''Private'' end as visibility,',
'       run_count,',
'       to_char(last_run_at, ''YYYY-MM-DD HH24:MI'') as last_run,',
'       to_char(updated_at, ''YYYY-MM-DD HH24:MI'') as updated',
'  from dx_saved_queries_v',
' order by updated_at desc'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2540130677583398057
,p_query_num_rows=>25
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_csv_output=>'Y'
,p_csv_output_link_text=>'Download'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001071)
,p_column_alias=>'QUERY_ID'
,p_column_display_sequence=>10
,p_column_heading=>'ID'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001088)
,p_column_alias=>'TITLE'
,p_column_display_sequence=>20
,p_column_heading=>'Title'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_QUERY_ID:#QUERY_ID#'
,p_column_linktext=>'#TITLE#'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001105)
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>30
,p_column_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001122)
,p_column_alias=>'OWNER'
,p_column_display_sequence=>40
,p_column_heading=>'Owner'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001139)
,p_column_alias=>'VISIBILITY'
,p_column_display_sequence=>50
,p_column_heading=>'Visibility'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001156)
,p_column_alias=>'RUN_COUNT'
,p_column_display_sequence=>60
,p_column_heading=>'Runs'
,p_column_format=>'999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001173)
,p_column_alias=>'LAST_RUN'
,p_column_display_sequence=>70
,p_column_heading=>'Last run'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001190)
,p_column_alias=>'UPDATED'
,p_column_display_sequence=>80
,p_column_heading=>'Updated'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
end;
/
prompt --application/pages/page_00004
begin
wwv_flow_imp_page.create_page(
 p_id=>4
,p_name=>'Query Log'
,p_alias=>'QUERY-LOG'
,p_step_title=>'Query Log'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* results and reports scroll inside their region on small screens */',
'.t-Body-content, .t-Body-contentInner, .t-Body-mainContent { min-width: 0; }',
'.t-Region-body { overflow-x: auto; -webkit-overflow-scrolling: touch; }',
'.dx-scroll { overflow-x: auto; max-width: 100%; }',
'.dx-result .t-Report-report th, .dx-result .t-Report-report td { white-space: nowrap; }',
'.dx-num { text-align: right !important; font-variant-numeric: tabular-nums; }'))
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(22000000001207)
,p_name=>'Query log'
,p_static_id=>'query-log'
,p_template=>4073835273271169698
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(run_at, ''YYYY-MM-DD HH24:MI:SS'') as run_at,',
'       username,',
'       status,',
'       row_count,',
'       elapsed_ms,',
'       substr(sql_text, 1, 300) as sql_text,',
'       error_msg',
'  from dx_query_log_v',
' order by log_id desc',
' fetch first 500 rows only'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2540130677583398057
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_csv_output=>'Y'
,p_csv_output_link_text=>'Download'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001224)
,p_column_alias=>'RUN_AT'
,p_column_display_sequence=>10
,p_column_heading=>'Run at'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001241)
,p_column_alias=>'USERNAME'
,p_column_display_sequence=>20
,p_column_heading=>'User'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001258)
,p_column_alias=>'STATUS'
,p_column_display_sequence=>30
,p_column_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001275)
,p_column_alias=>'ROW_COUNT'
,p_column_display_sequence=>40
,p_column_heading=>'Rows'
,p_column_format=>'999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001292)
,p_column_alias=>'ELAPSED_MS'
,p_column_display_sequence=>50
,p_column_heading=>'ms'
,p_column_format=>'999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001309)
,p_column_alias=>'SQL_TEXT'
,p_column_display_sequence=>60
,p_column_heading=>'SQL'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001326)
,p_column_alias=>'ERROR_MSG'
,p_column_display_sequence=>70
,p_column_heading=>'Message'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
end;
/
prompt --application/pages/page_00005
begin
wwv_flow_imp_page.create_page(
 p_id=>5
,p_name=>'Data Sources'
,p_alias=>'DATA-SOURCES'
,p_step_title=>'Data Sources'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* results and reports scroll inside their region on small screens */',
'.t-Body-content, .t-Body-contentInner, .t-Body-mainContent { min-width: 0; }',
'.t-Region-body { overflow-x: auto; -webkit-overflow-scrolling: touch; }',
'.dx-scroll { overflow-x: auto; max-width: 100%; }',
'.dx-result .t-Report-report th, .dx-result .t-Report-report td { white-space: nowrap; }',
'.dx-num { text-align: right !important; font-variant-numeric: tabular-nums; }'))
,p_required_role=>wwv_flow_imp.id(22000000000085)
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(22000000001343)
,p_name=>'Registered data sources'
,p_static_id=>'sources'
,p_template=>4073835273271169698
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select source_id,',
'       name,',
'       source_type,',
'       coalesce(schema_owner, view_name) as target,',
'       rest_url,',
'       is_enabled,',
'       to_char(refreshed_at, ''YYYY-MM-DD HH24:MI'') as refreshed,',
'       last_status',
'  from dx_data_sources',
' order by name'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2540130677583398057
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001462)
,p_column_alias=>'SOURCE_ID'
,p_column_display_sequence=>10
,p_column_heading=>'ID'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001479)
,p_column_alias=>'NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Name'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001496)
,p_column_alias=>'SOURCE_TYPE'
,p_column_display_sequence=>30
,p_column_heading=>'Type'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001513)
,p_column_alias=>'TARGET'
,p_column_display_sequence=>40
,p_column_heading=>'Schema / view'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001530)
,p_column_alias=>'REST_URL'
,p_column_display_sequence=>50
,p_column_heading=>'REST URL'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001547)
,p_column_alias=>'IS_ENABLED'
,p_column_display_sequence=>60
,p_column_heading=>'Enabled'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001564)
,p_column_alias=>'REFRESHED'
,p_column_display_sequence=>70
,p_column_heading=>'Refreshed'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(22000000001581)
,p_column_alias=>'LAST_STATUS'
,p_column_display_sequence=>80
,p_column_heading=>'Last status'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22000000001360)
,p_plug_name=>'Add a data source'
,p_static_id=>'add-source'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p><strong>Schema:</strong> first <code>grant select on owner.object</code> to DATAEXP (catalog) and DATAEXP_RO (queries), then register the owner. <strong>REST:</strong> a JSON endpoint is cached and exposed as view DX_REST_&lt;id&gt; using the JSON_TABLE column list, for example <code>id number path ''$.id'', name varchar2(200) path ''$.name''</code>.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001598)
,p_name=>'P5_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(22000000001360)
,p_prompt=>'Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>128
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001615)
,p_name=>'P5_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(22000000001360)
,p_prompt=>'Type'
,p_item_default=>'SCHEMA'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Database schema;SCHEMA,REST JSON endpoint;REST'
,p_lov_display_null=>'NO'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001632)
,p_name=>'P5_SCHEMA'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(22000000001360)
,p_prompt=>'Schema (type Schema)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select username d, username r from all_users where oracle_maintained = ''N'' order by 1'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001649)
,p_name=>'P5_URL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(22000000001360)
,p_prompt=>'REST URL (type REST)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>2000
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001666)
,p_name=>'P5_ROW_PATH'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(22000000001360)
,p_prompt=>'JSON row path'
,p_item_default=>'$[*]'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>400
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001683)
,p_name=>'P5_COLUMNS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(22000000001360)
,p_prompt=>'JSON_TABLE columns (type REST)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cHeight=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(22000000001394)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(22000000001360)
,p_button_name=>'ADD'
,p_static_id=>'add'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add source'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22000000001377)
,p_plug_name=>'Maintain a data source'
,p_static_id=>'maintain'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001700)
,p_name=>'P5_SOURCE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(22000000001377)
,p_prompt=>'Data source'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select name || '' ('' || source_type || '')'' d, source_id r from dx_data_sources order by name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(22000000001411)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(22000000001377)
,p_button_name=>'REFRESH'
,p_static_id=>'refresh'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_image_alt=>'Refresh REST data'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(22000000001428)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(22000000001377)
,p_button_name=>'ENABLE'
,p_static_id=>'enable'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_image_alt=>'Enable'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(22000000001445)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(22000000001377)
,p_button_name=>'DISABLE'
,p_static_id=>'disable'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_image_alt=>'Disable'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000001717)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add source'
,p_static_id=>'add-source'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_id number;',
'begin',
'  if :P5_TYPE = ''REST'' then',
'    l_id := dx_api.add_rest_source(:P5_NAME, :P5_URL, :P5_COLUMNS, nvl(:P5_ROW_PATH, ''$[*]''));',
'  else',
'    l_id := dx_api.add_schema_source(:P5_NAME, :P5_SCHEMA);',
'  end if;',
'  :P5_SOURCE_ID := l_id;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(22000000001394)
,p_process_success_message=>'Data source added.'
,p_security_scheme=>wwv_flow_imp.id(22000000000085)
,p_internal_uid=>22000000001717
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000001734)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Refresh REST data'
,p_static_id=>'refresh-rest-data'
,p_process_sql_clob=>'dx_api.refresh_rest_source(to_number(:P5_SOURCE_ID));'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(22000000001411)
,p_process_success_message=>'REST data refreshed.'
,p_security_scheme=>wwv_flow_imp.id(22000000000085)
,p_internal_uid=>22000000001734
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000001751)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Enable source'
,p_static_id=>'enable-source'
,p_process_sql_clob=>'dx_api.set_source_enabled(to_number(:P5_SOURCE_ID), ''Y'');'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(22000000001428)
,p_process_success_message=>'Data source enabled.'
,p_security_scheme=>wwv_flow_imp.id(22000000000085)
,p_internal_uid=>22000000001751
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000001768)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Disable source'
,p_static_id=>'disable-source'
,p_process_sql_clob=>'dx_api.set_source_enabled(to_number(:P5_SOURCE_ID), ''N'');'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(22000000001445)
,p_process_success_message=>'Data source disabled.'
,p_security_scheme=>wwv_flow_imp.id(22000000000085)
,p_internal_uid=>22000000001768
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(22000000001785)
,p_branch_name=>'Go To Page 5'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
end;
/
prompt --application/pages/page_09999
begin
wwv_flow_imp_page.create_page(
 p_id=>9999
,p_name=>'Login Page'
,p_alias=>'LOGIN'
,p_step_title=>'&APP_TITLE. - Log In'
,p_warn_on_unsaved_changes=>'N'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2102634289808461002
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22000000001802)
,p_plug_name=>'Login'
,p_static_id=>'app-name'
,p_title=>'&APP_TITLE.'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2675634334296186762
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(22000000001819)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(22000000001802)
,p_button_name=>'LOGIN'
,p_static_id=>'login'
,p_show_as_disabled=>false
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Sign In'
,p_button_position=>'NEXT'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001836)
,p_name=>'P9999_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(22000000001802)
,p_prompt=>'Password'
,p_placeholder=>'Password'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>40
,p_cMaxlength=>100
,p_tag_attributes=>'autocomplete="current-password"'
,p_label_alignment=>'RIGHT'
,p_field_template=>2042262243893469891
,p_item_icon_css_classes=>'fa-key'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001853)
,p_name=>'P9999_REMEMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(22000000001802)
,p_prompt=>'Remember username'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_label_alignment=>'RIGHT'
,p_display_when=>'apex_authentication.persistent_cookies_enabled'
,p_display_when2=>'PLSQL'
,p_display_when_type=>'EXPRESSION'
,p_field_template=>2042262243893469891
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(22000000001870)
,p_name=>'P9999_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(22000000001802)
,p_prompt=>'Username'
,p_placeholder=>'Username'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
,p_tag_attributes=>'autocomplete="username"'
,p_label_alignment=>'RIGHT'
,p_field_template=>2042262243893469891
,p_item_icon_css_classes=>'fa-user'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000001887)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Page(s) Cache'
,p_static_id=>'clear-page-s-cache'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'type', 'CLEAR_CACHE_CURRENT_PAGE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>22000000002040
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000001904)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get Username Cookie'
,p_static_id=>'get-username-cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P9999_USERNAME := apex_authentication.get_login_username_cookie;',
':P9999_REMEMBER := case when :P9999_USERNAME is not null then ''Y'' end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>22000000002057
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000001921)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_INVOKE_API'
,p_process_name=>'Login'
,p_static_id=>'login'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'package', 'APEX_AUTHENTICATION',
  'package_method', 'LOGIN',
  'type', 'PLSQL_PACKAGE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>22000000002074
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(22000000001938)
,p_page_process_id=>wwv_flow_imp.id(22000000001921)
,p_page_id=>9999
,p_name=>'p_password'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>2
,p_value_type=>'ITEM'
,p_value=>'P9999_PASSWORD'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(22000000001955)
,p_page_process_id=>wwv_flow_imp.id(22000000001921)
,p_page_id=>9999
,p_name=>'p_set_persistent_auth'
,p_direction=>'IN'
,p_data_type=>'BOOLEAN'
,p_has_default=>true
,p_display_sequence=>3
,p_value_type=>'API_DEFAULT'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(22000000001972)
,p_page_process_id=>wwv_flow_imp.id(22000000001921)
,p_page_id=>9999
,p_name=>'p_username'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>1
,p_value_type=>'ITEM'
,p_value=>'P9999_USERNAME'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(22000000001989)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_INVOKE_API'
,p_process_name=>'Set Username Cookie'
,p_static_id=>'set-username-cookie'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'package', 'APEX_AUTHENTICATION',
  'package_method', 'SEND_LOGIN_USERNAME_COOKIE',
  'type', 'PLSQL_PACKAGE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>22000000002091
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(22000000002006)
,p_page_process_id=>wwv_flow_imp.id(22000000001989)
,p_page_id=>9999
,p_name=>'p_consent'
,p_direction=>'IN'
,p_data_type=>'BOOLEAN'
,p_has_default=>false
,p_display_sequence=>2
,p_value_type=>'ITEM'
,p_value=>'P9999_REMEMBER'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(22000000002023)
,p_page_process_id=>wwv_flow_imp.id(22000000001989)
,p_page_id=>9999
,p_name=>'p_username'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>1
,p_value_type=>'EXPRESSION'
,p_value_language=>'PLSQL'
,p_value=>'lower( :P9999_USERNAME )'
);
end;
/
prompt --application/deployment/definition
begin
null;
end;
/
prompt --application/deployment/checks
begin
null;
end;
/
prompt --application/deployment/buildoptions
begin
null;
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
