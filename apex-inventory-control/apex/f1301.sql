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
,p_default_application_id=>1301
,p_default_id_offset=>11515208843258817
,p_default_owner=>'INVENTORY_CONTROL'
);
end;
/
 
prompt APPLICATION 1301 - Inventory Control
--
-- Application Export:
--   Application:     1301
--   Name:            Inventory Control
--   Exported By:     ADMIN
--   Flashback:       0
--   Export Type:     Application Export
--     Pages:                     13
--       Items:                   44
--       Validations:              1
--       Processes:               17
--       Regions:                 30
--       Buttons:                 23
--     Shared Components:
--       Logic:
--       Navigation:
--         Lists:                  2
--         Breadcrumbs:            1
--           Entries:             12
--       Security:
--         Authentication:         1
--       User Interface:
--         Themes:                 1
--         Templates:
--       PWA:
--       Globalization:
--       Reports:
--       E-Mail:
--     Supporting Objects:  Excluded
--   Version:         26.1.5
--   Instance ID:     9259717415689234
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
,p_owner=>nvl(wwv_flow_application_install.get_schema,'INVENTORY_CONTROL')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'Inventory Control')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'INVENTORY-CONTROL')
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'9E3C1B7A5D2F4E6081A7C3B5D9E2F4A6C8B0D1E3F5A7C9B2D4E6F8A0C2B4D6E8'
,p_bookmark_checksum_function=>'SH512'
,p_compatibility_mode=>'26.1'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'
,p_date_format=>'DD-MON-YYYY'
,p_timestamp_format=>'DD-MON-YYYY HH24:MI'
,p_timestamp_tz_format=>'DS'
,p_flow_image_prefix=>nvl(wwv_flow_application_install.get_image_prefix,'')
,p_authentication_id=>wwv_flow_imp.id(24525208843258818)
,p_application_tab_set=>1
,p_logo_type=>'IT'
,p_logo=>'fa-cubes'
,p_logo_text=>'Inventory Control'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'1.0.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_deep_linking=>'Y'
,p_authorize_batch_job=>'N'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_error_handling_function=>'inv_ui_error'
,p_modernization_available=>'Y'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'Inventory Control'
,p_file_prefix=>nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>1
,p_version_scn=>'1'
,p_print_server_type=>'INSTANCE'
,p_file_storage=>'DB'
,p_is_pwa=>'N'
,p_theme_id=>42
,p_home_url=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_login_url=>'f?p=&APP_ID.:LOGIN:&APP_SESSION.::&DEBUG.:::'
,p_theme_style_by_user_pref=>false
,p_built_with_love=>false
,p_navigation_list_id=>wwv_flow_imp.id(24525208843258819)
,p_navigation_list_position=>'SIDE'
,p_navigation_list_template_id=>2467739217141810545
,p_nav_list_template_options=>'#DEFAULT#:js-defaultCollapsed:js-navCollapsed--hidden:t-TreeNav--styleA'
,p_nav_bar_type=>'LIST'
,p_nav_bar_list_id=>wwv_flow_imp.id(24525208843258820)
,p_nav_bar_list_template_id=>2847543055748234966
,p_nav_bar_template_options=>'#DEFAULT#'
);
end;
/
prompt --application/plugin_settings
begin
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11515361324258845)
,p_plugin_type=>'DYNAMIC ACTION'
,p_plugin=>'NATIVE_OPEN_AI_ASSISTANT'
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11515646203258847)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_COLOR_PICKER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'mode', 'FULL')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11515722401258848)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_DATE_PICKER_APEX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_behavior', 'MONTH-PICKER:YEAR-PICKER:TODAY-BUTTON',
  'days_outside_month', 'VISIBLE',
  'show_on', 'FOCUS',
  'time_increment', '15')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11515510463258846)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_GEOCODED_ADDRESS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'background', 'default',
  'display_as', 'LIST',
  'map_preview', 'POPUP:ITEM',
  'match_mode', 'RELAX_HOUSE_NUMBER')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11516043112258850)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SELECT_MANY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_values_as', 'separated')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11515458377258845)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SINGLE_CHECKBOX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'checked_value', 'Y',
  'unchecked_value', 'N')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11515825738258848)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_STAR_RATING'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'default_icon', 'fa-star',
  'tooltip', '#VALUE#')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11515957969258849)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_YES_NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_style', 'SWITCH_CB',
  'off_value', 'N',
  'on_value', 'Y')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11516121646258850)
,p_plugin_type=>'PROCESS TYPE'
,p_plugin=>'NATIVE_GEOCODING'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'match_mode', 'RELAX_HOUSE_NUMBER')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11516213081258851)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_DISPLAY_SELECTOR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'include_slider', 'Y')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11516371372258852)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_IR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'actions_menu_structure', 'IG')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11516412516258852)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_MAP_REGION'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_vector_tile_layers', 'Y')).to_clob
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11516672605258854)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_ADFBC'
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(11516533864258853)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_BOSS'
);
end;
/
prompt --application/shared_components/navigation/lists/navigation_bar
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(24525208843258820)
,p_name=>'Navigation Bar'
,p_static_id=>'navigation-bar'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843260818)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'&APP_USER.'
,p_static_id=>'app-user'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user'
,p_list_text_02=>'has-username'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843260819)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Sign Out'
,p_static_id=>'sign-out'
,p_list_item_link_target=>'&LOGOUT_URL.'
,p_list_item_icon=>'fa-sign-out'
,p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'
,p_parent_list_item_id=>wwv_flow_imp.id(24525208843260818)
,p_list_item_current_type=>'TARGET_PAGE'
);
end;
/
prompt --application/shared_components/navigation/lists/navigation_menu
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(24525208843258819)
,p_name=>'Navigation Menu'
,p_static_id=>'navigation-menu'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843259869)
,p_list_item_display_sequence=>52
,p_list_item_link_text=>'Categories'
,p_static_id=>'categories'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-tags'
,p_parent_list_item_id=>wwv_flow_imp.id(24525208843259867)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'9,10'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843259827)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_static_id=>'home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843259837)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Items'
,p_static_id=>'items'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-cube'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2,3'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843259868)
,p_list_item_display_sequence=>51
,p_list_item_link_text=>'Locations'
,p_static_id=>'locations'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-map-marker'
,p_parent_list_item_id=>wwv_flow_imp.id(24525208843259867)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'7,8'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843259867)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Setup'
,p_static_id=>'setup'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-cog'
,p_list_item_current_type=>'NEVER'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843259857)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Stock Movements'
,p_static_id=>'stock-movements'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-exchange'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'5,6'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843259847)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Stock on Hand'
,p_static_id=>'stock-on-hand'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-cubes'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(24525208843259870)
,p_list_item_display_sequence=>53
,p_list_item_link_text=>'Suppliers'
,p_static_id=>'suppliers'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-truck'
,p_parent_list_item_id=>wwv_flow_imp.id(24525208843259867)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'11,12'
);
end;
/
prompt --application/shared_components/navigation/listentry
begin
null;
end;
/
prompt --application/shared_components/files/css_inv_app_css
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A20496E76656E746F727920436F6E74726F6C2028617070203133303129202D20736D616C6C206C61796572206F6E20746F70206F6620556E6976657273616C205468656D652032362E31202F20566974612E0A202020476F616C3A206E6F20686F72';
wwv_flow_imp.g_varchar2_table(2) := '697A6F6E74616C2070616765206F766572666C6F772061742033393070782C20696E707574732074686174206C696E652075702C20636F6D70616374207461626C65732E202A2F0A68746D6C2C20626F6479207B206D61782D77696474683A2031303025';
wwv_flow_imp.g_varchar2_table(3) := '3B206F766572666C6F772D783A2068696464656E3B207D0A2E742D426F64792D636F6E74656E742C202E742D426F64792D636F6E74656E74496E6E6572207B206D696E2D77696474683A20303B207D0A0A2F2A206865726F206F6E20686F6D65202A2F0A';
wwv_flow_imp.g_varchar2_table(4) := '2E696E762D6865726F207B2070616464696E673A20313670782031367078203470783B207D0A2E696E762D6865726F202E742D526567696F6E2D7469746C652C202E696E762D6865726F206832207B20666F6E742D73697A653A20312E3572656D3B207D';
wwv_flow_imp.g_varchar2_table(5) := '0A2E696E762D6C656164207B206D617267696E3A2030203020313270783B20636F6C6F723A20766172282D2D75742D626F64792D746578742D636F6C6F722C2023343434293B206F7061636974793A202E383B207D0A2E696E762D6865726F202E742D52';
wwv_flow_imp.g_varchar2_table(6) := '6567696F6E2D6865616465724974656D732D2D627574746F6E732C0A2E696E762D6865726F202E742D427574746F6E526567696F6E2D627574746F6E73207B20646973706C61793A20666C65783B20666C65782D777261703A20777261703B206761703A';
wwv_flow_imp.g_varchar2_table(7) := '203870783B207D0A0A2F2A206261646765206C69737420737461797320696E73696465207468652076696577706F7274202A2F0A2E696E762D6F76657276696577202E742D42616467654C697374207B20666C65782D777261703A20777261703B207D0A';
wwv_flow_imp.g_varchar2_table(8) := '2E696E762D6F76657276696577202E742D42616467654C6973742D6974656D207B206D696E2D77696474683A20303B20666C65783A203120312031343070783B207D0A2E696E762D6F76657276696577202E742D42616467654C6973742D76616C756520';
wwv_flow_imp.g_varchar2_table(9) := '7B20666F6E742D73697A653A20312E323572656D3B2077686974652D73706163653A206E6F777261703B207D0A0A2E696E762D6F76657276696577202E742D5265706F72742D706167696E6174696F6E2C202E696E762D6F76657276696577202E742D52';
wwv_flow_imp.g_varchar2_table(10) := '65706F72742D6C696E6B732C0A2E696E762D6C6F772D73746F636B202E742D5265706F72742D706167696E6174696F6E2C202E696E762D726563656E74202E742D5265706F72742D706167696E6174696F6E207B20646973706C61793A206E6F6E653B20';
wwv_flow_imp.g_varchar2_table(11) := '7D0A0A2F2A207374617475732070696C6C73202A2F0A2E696E762D70696C6C207B20646973706C61793A20696E6C696E652D626C6F636B3B2070616464696E673A20327078203870783B20626F726465722D7261646975733A2039393970783B20666F6E';
wwv_flow_imp.g_varchar2_table(12) := '742D73697A653A202E373572656D3B0A202020202020202020202020666F6E742D7765696768743A203630303B206261636B67726F756E643A20236536653665363B20636F6C6F723A20233434343B2077686974652D73706163653A206E6F777261703B';
wwv_flow_imp.g_varchar2_table(13) := '207D0A2E696E762D70696C6C2D2D6F6B207B206261636B67726F756E643A20236466663365363B20636F6C6F723A20233164366233613B207D0A2E696E762D70696C6C2D2D7761726E207B206261636B67726F756E643A20236664653764363B20636F6C';
wwv_flow_imp.g_varchar2_table(14) := '6F723A20233961336430373B207D0A0A2F2A207461626C6573206E657665722070757368207468652070616765207769646572207468616E207468652073637265656E202A2F0A2E742D5265706F72742D777261702C202E742D5265706F72742D746162';
wwv_flow_imp.g_varchar2_table(15) := '6C6557726170207B206D61782D77696474683A20313030253B206F766572666C6F772D783A206175746F3B207D0A2E742D5265706F72742D7265706F72742074642C202E742D5265706F72742D7265706F7274207468207B2077686974652D7370616365';
wwv_flow_imp.g_varchar2_table(16) := '3A206E6F777261703B207D0A2E742D5265706F72742D7265706F72742074645B686561646572733D224E414D45225D2C202E742D5265706F72742D7265706F72742074645B686561646572733D224954454D5F4E414D45225D2C0A2E742D5265706F7274';
wwv_flow_imp.g_varchar2_table(17) := '2D7265706F72742074645B686561646572733D224445534352495054494F4E225D207B2077686974652D73706163653A206E6F726D616C3B206D696E2D77696474683A203872656D3B207D0A0A2F2A20746F6F6C62617273202F20666F726D733A206669';
wwv_flow_imp.g_varchar2_table(18) := '656C6473207374726574636820746F207468656972206772696420636F6C756D6E20616E64206C696E65207570202A2F0A2E696E762D746F6F6C626172207B206D617267696E2D626F74746F6D3A203870783B207D0A2E696E762D70616765202E742D46';
wwv_flow_imp.g_varchar2_table(19) := '6F726D2D6669656C64436F6E7461696E65722D2D73747265746368496E70757473202E742D466F726D2D696E707574436F6E7461696E65722C0A2E696E762D70616765202E742D466F726D2D6669656C64436F6E7461696E65722D2D7374726574636849';
wwv_flow_imp.g_varchar2_table(20) := '6E70757473202E742D466F726D2D6974656D57726170706572207B2077696474683A20313030253B207D0A2E696E762D706167652073656C6563742E73656C6563746C6973742C202E696E762D7061676520696E7075742E746578745F6669656C642C20';
wwv_flow_imp.g_varchar2_table(21) := '2E696E762D7061676520696E7075742E6E756D6265725F6669656C642C0A2E696E762D706167652074657874617265612E7465787461726561207B2077696474683A20313030253B206D61782D77696474683A20313030253B20626F782D73697A696E67';
wwv_flow_imp.g_varchar2_table(22) := '3A20626F726465722D626F783B207D0A0A2F2A2070686F6E653A2068696465207365636F6E6461727920636F6C756D6E732C207469676874656E2070616464696E67202A2F0A406D6564696120286D61782D77696474683A20363430707829207B0A2020';
wwv_flow_imp.g_varchar2_table(23) := '2E742D426F64792D636F6E74656E74496E6E6572207B2070616464696E672D6C6566743A203870783B2070616464696E672D72696768743A203870783B207D0A20202E696E762D7270742074682343415445474F52592C202E696E762D7270742074645B';
wwv_flow_imp.g_varchar2_table(24) := '686561646572733D2243415445474F5259225D2C0A20202E696E762D7270742074682352454F524445525F4C4556454C2C202E696E762D7270742074645B686561646572733D2252454F524445525F4C4556454C225D2C0A20202E696E762D7270742074';
wwv_flow_imp.g_varchar2_table(25) := '682356414C55452C202E696E762D7270742074645B686561646572733D2256414C5545225D2C0A20202E696E762D727074207468235245464552454E43452C202E696E762D7270742074645B686561646572733D225245464552454E4345225D2C0A2020';
wwv_flow_imp.g_varchar2_table(26) := '2E696E762D72707420746823435245415445445F42592C202E696E762D7270742074645B686561646572733D22435245415445445F4259225D2C0A20202E696E762D727074207468234954454D5F4E414D452C202E696E762D7270742074645B68656164';
wwv_flow_imp.g_varchar2_table(27) := '6572733D224954454D5F4E414D45225D2C0A20202E696E762D727074207468234445534352495054494F4E2C202E696E762D7270742074645B686561646572733D224445534352495054494F4E225D2C0A20202E696E762D72707420746823434F4E5441';
wwv_flow_imp.g_varchar2_table(28) := '43545F4E414D452C202E696E762D7270742074645B686561646572733D22434F4E544143545F4E414D45225D2C0A20202E696E762D7270742074682350484F4E452C202E696E762D7270742074645B686561646572733D2250484F4E45225D2C0A20202E';
wwv_flow_imp.g_varchar2_table(29) := '696E762D727074207468234954454D532C202E696E762D7270742074645B686561646572733D224954454D53225D2C0A20202E696E762D726563656E74207468234954454D5F4E414D452C202E696E762D726563656E742074645B686561646572733D22';
wwv_flow_imp.g_varchar2_table(30) := '4954454D5F4E414D45225D2C0A20202E696E762D726563656E74207468234C4F434154494F4E2C202E696E762D726563656E742074645B686561646572733D224C4F434154494F4E225D2C0A20202E696E762D6C6F772D73746F636B207468234E414D45';
wwv_flow_imp.g_varchar2_table(31) := '2C202E696E762D6C6F772D73746F636B2074645B686561646572733D224E414D45225D2C0A20202E696E762D6C6F772D73746F636B2074682352454F524445525F4C4556454C2C202E696E762D6C6F772D73746F636B2074645B686561646572733D2252';
wwv_flow_imp.g_varchar2_table(32) := '454F524445525F4C4556454C225D207B20646973706C61793A206E6F6E653B207D0A20202E742D5265706F72742D63656C6C2C202E742D5265706F72742D636F6C48656164207B2070616464696E673A20387078203570783B207D0A20202E742D526570';
wwv_flow_imp.g_varchar2_table(33) := '6F72742D7265706F72742074642C202E742D5265706F72742D7265706F7274207468207B20666F6E742D73697A653A202E3831323572656D3B207D0A20202E742D5265706F72742D7265706F7274207464207B2077686974652D73706163653A206E6F72';
wwv_flow_imp.g_varchar2_table(34) := '6D616C3B206F766572666C6F772D777261703A20616E7977686572653B207D0A20202E742D5265706F72742D7265706F72742074645B686561646572733D224E414D45225D2C202E742D5265706F72742D7265706F72742074645B686561646572733D22';
wwv_flow_imp.g_varchar2_table(35) := '4954454D5F4E414D45225D2C0A20202E742D5265706F72742D7265706F72742074645B686561646572733D224445534352495054494F4E225D207B206D696E2D77696474683A20303B207D0A20202E742D5265706F72742D7265706F72742074645B6865';
wwv_flow_imp.g_varchar2_table(36) := '61646572733D225155414E54495459225D2C202E742D5265706F72742D7265706F72742074645B686561646572733D224F4E5F48414E44225D2C0A20202E742D5265706F72742D7265706F72742074645B686561646572733D22515459225D2C202E742D';
wwv_flow_imp.g_varchar2_table(37) := '5265706F72742D7265706F72742074645B686561646572733D22535441545553225D2C0A20202E742D5265706F72742D7265706F72742074645B686561646572733D2254584E5F44415445225D2C202E742D5265706F72742D7265706F72742074645B68';
wwv_flow_imp.g_varchar2_table(38) := '6561646572733D2254584E5F545950455F4C4142454C225D207B2077686974652D73706163653A206E6F777261703B206F766572666C6F772D777261703A206E6F726D616C3B207D0A20202E742D526567696F6E2D6865616465724974656D732D2D6275';
wwv_flow_imp.g_varchar2_table(39) := '74746F6E73202E742D427574746F6E207B2070616464696E672D6C6566743A20313070783B2070616464696E672D72696768743A20313070783B207D0A20202E742D526567696F6E2D6865616465724974656D732D2D7469746C65207B206D696E2D7769';
wwv_flow_imp.g_varchar2_table(40) := '6474683A20303B207D0A7D0A0A2F2A206C6F67696E202A2F0A2E696E762D6C6F67696E202E742D4C6F67696E2D6C6F676F207B20646973706C61793A20666C65783B20616C69676E2D6974656D733A2063656E7465723B206A7573746966792D636F6E74';
wwv_flow_imp.g_varchar2_table(41) := '656E743A2063656E7465723B0A202077696474683A20363470783B206865696768743A20363470783B206D617267696E3A2030206175746F203870783B20626F726465722D7261646975733A20313670783B0A20206261636B67726F756E643A20766172';
wwv_flow_imp.g_varchar2_table(42) := '282D2D75742D70616C657474652D7072696D6172792C2023326536626432293B20636F6C6F723A20236666663B20666F6E742D73697A653A20333270783B207D0A2E696E762D6C6F67696E2D7461676C696E65207B20746578742D616C69676E3A206365';
wwv_flow_imp.g_varchar2_table(43) := '6E7465723B206D617267696E3A20302030203870783B206F7061636974793A202E37353B207D0A';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(24525208843258825)
,p_file_name=>'css/inv-app.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/shared_components/navigation/navigation_bar
begin
null;
end;
/
prompt --application/shared_components/logic/application_settings
begin
null;
end;
/
prompt --application/shared_components/navigation/tabs/standard
begin
null;
end;
/
prompt --application/shared_components/navigation/tabs/parent
begin
null;
end;
/
prompt --application/pages/page_groups
begin
null;
end;
/
prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(24525208843258823)
,p_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261826)
,p_parent_id=>wwv_flow_imp.id(24525208843261818)
,p_short_name=>'Categories'
,p_static_id=>'categories'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261827)
,p_parent_id=>wwv_flow_imp.id(24525208843261826)
,p_short_name=>'Category'
,p_static_id=>'category'
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261818)
,p_short_name=>'Home'
,p_static_id=>'home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261820)
,p_parent_id=>wwv_flow_imp.id(24525208843261819)
,p_short_name=>'Item'
,p_static_id=>'item'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261819)
,p_parent_id=>wwv_flow_imp.id(24525208843261818)
,p_short_name=>'Items'
,p_static_id=>'items'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261825)
,p_parent_id=>wwv_flow_imp.id(24525208843261824)
,p_short_name=>'Location'
,p_static_id=>'location'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261824)
,p_parent_id=>wwv_flow_imp.id(24525208843261818)
,p_short_name=>'Locations'
,p_static_id=>'locations'
,p_link=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261823)
,p_parent_id=>wwv_flow_imp.id(24525208843261822)
,p_short_name=>'New Movement'
,p_static_id=>'new-movement'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261822)
,p_parent_id=>wwv_flow_imp.id(24525208843261818)
,p_short_name=>'Stock Movements'
,p_static_id=>'stock-movements'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261821)
,p_parent_id=>wwv_flow_imp.id(24525208843261818)
,p_short_name=>'Stock on Hand'
,p_static_id=>'stock-on-hand'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261829)
,p_parent_id=>wwv_flow_imp.id(24525208843261828)
,p_short_name=>'Supplier'
,p_static_id=>'supplier'
,p_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(24525208843261828)
,p_parent_id=>wwv_flow_imp.id(24525208843261818)
,p_short_name=>'Suppliers'
,p_static_id=>'suppliers'
,p_link=>'f?p=&APP_ID.:11:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>11
);
end;
/
prompt --application/shared_components/navigation/breadcrumbentry
begin
null;
end;
/
prompt --application/shared_components/user_interface/themes
begin
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(24525208843258822)
,p_theme_id=>42
,p_static_id=>'universal-theme'
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_version_identifier=>'26.1'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_is_locked=>false
,p_current_theme_style_id=>wwv_flow_imp.id(24525208843258824)
,p_default_page_template=>4072355960268175073
,p_default_dialog_template=>2100407606326202693
,p_error_template=>2101157952850466385
,p_login_template=>2101157952850466385
,p_default_button_template=>4072362960822175091
,p_default_region_template=>4072358936313175081
,p_default_report_template=>2538654340625403440
,p_default_label_template=>1609121967514267634
,p_default_menu_template=>4072363345357175094
,p_default_list_template=>4072361143931175087
,p_default_side_nav_list_temp=>2467739217141810545
,p_default_navbar_list_template=>2847543055748234966
,p_file_prefix=>nvl(wwv_flow_application_install.get_static_theme_file_prefix(42),'#APEX_FILES#themes/theme_42/26.1/')
,p_files_version=>1
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APEX_FILES#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_FILES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_FILES#css/Core#MIN#.css?v=#APEX_VERSION#'
,p_reference_id=>wwv_imp_util.get_subscription_id(4072363937200175119,2000,'universal-theme',8842.242)
,p_version_scn_master=>'KOY+ZuWWBAiMPOEb84kykGCYvLY='
);
end;
/
prompt --application/shared_components/user_interface/theme_style
begin
wwv_flow_imp_shared.create_theme_style(
 p_id=>wwv_flow_imp.id(24525208843258824)
,p_theme_id=>42
,p_name=>'Vita'
,p_static_id=>'vita'
,p_css_file_urls=>'#THEME_FILES#css/Vita#MIN#.css?v=#APEX_VERSION#'
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_read_only=>true
);
end;
/
prompt --application/shared_components/user_interface/theme_files
begin
null;
end;
/
prompt --application/shared_components/user_interface/template_opt_groups
begin
null;
end;
/
prompt --application/shared_components/user_interface/template_options
begin
null;
end;
/
prompt --application/shared_components/globalization/language
begin
null;
end;
/
prompt --application/shared_components/logic/build_options
begin
null;
end;
/
prompt --application/shared_components/globalization/messages
begin
null;
end;
/
prompt --application/shared_components/globalization/dyntranslations
begin
null;
end;
/
prompt --application/shared_components/security/authentications/oracle_apex_accounts
begin
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(24525208843258818)
,p_name=>'Oracle APEX Accounts'
,p_static_id=>'oracle-apex-accounts'
,p_scheme_type=>'NATIVE_APEX_ACCOUNTS'
,p_invalid_session_type=>'LOGIN'
,p_use_secure_cookie_yn=>'Y'
,p_ras_mode=>0
);
end;
/
prompt --application/user_interfaces/combined_files
begin
null;
end;
/
prompt --application/pages/page_00001
begin
wwv_flow_imp_page.create_page(
 p_id=>1
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Home'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page inv-home'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843359818)
,p_plug_name=>'Inventory Control'
,p_static_id=>'inventory-control'
,p_region_css_classes=>'inv-hero'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p class="inv-lead">Track items, stock on hand and every stock movement across your locations.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(24525208843359820)
,p_name=>'Low Stock'
,p_static_id=>'low-stock'
,p_template=>4072358936313175081
,p_display_sequence=>30
,p_region_css_classes=>'inv-low-stock'
,p_icon_css_classes=>'fa-warning'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select item_id, sku, name, qty_on_hand, reorder_level, suggested_order_qty',
'  from inv_items_v',
' where low_stock_yn = ''Y''',
' order by qty_on_hand - reorder_level, sku'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'Nothing is below its reorder level.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360178)
,p_query_column_id=>1
,p_column_alias=>'ITEM_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360180)
,p_query_column_id=>3
,p_column_alias=>'NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Item'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360181)
,p_query_column_id=>4
,p_column_alias=>'QTY_ON_HAND'
,p_column_display_sequence=>40
,p_column_heading=>'On hand'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360182)
,p_query_column_id=>5
,p_column_alias=>'REORDER_LEVEL'
,p_column_display_sequence=>50
,p_column_heading=>'Reorder at'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360179)
,p_query_column_id=>2
,p_column_alias=>'SKU'
,p_column_display_sequence=>20
,p_column_heading=>'SKU'
,p_column_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:3:P3_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#SKU#'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360183)
,p_query_column_id=>6
,p_column_alias=>'SUGGESTED_ORDER_QTY'
,p_column_display_sequence=>60
,p_column_heading=>'Order qty'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(24525208843359819)
,p_name=>'Overview'
,p_static_id=>'overview'
,p_template=>4072358936313175081
,p_display_sequence=>20
,p_region_css_classes=>'inv-overview'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder'
,p_component_template_options=>'#DEFAULT#:t-BadgeList--responsive:t-BadgeList--large:t-BadgeList--flex'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select active_items, low_stock_items,',
'       ''R '' || to_char(stock_value, ''FM999G999G990D00'') stock_value,',
'       txns_7_days, active_locations',
'  from inv_dashboard_v'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2104643962563030528
,p_query_num_rows=>1
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No rows found.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360158)
,p_query_column_id=>1
,p_column_alias=>'ACTIVE_ITEMS'
,p_column_display_sequence=>10
,p_column_heading=>'Active items'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360162)
,p_query_column_id=>5
,p_column_alias=>'ACTIVE_LOCATIONS'
,p_column_display_sequence=>50
,p_column_heading=>'Locations'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360159)
,p_query_column_id=>2
,p_column_alias=>'LOW_STOCK_ITEMS'
,p_column_display_sequence=>20
,p_column_heading=>'Low stock'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360160)
,p_query_column_id=>3
,p_column_alias=>'STOCK_VALUE'
,p_column_display_sequence=>30
,p_column_heading=>'Stock value'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360161)
,p_query_column_id=>4
,p_column_alias=>'TXNS_7_DAYS'
,p_column_display_sequence=>40
,p_column_heading=>'Movements (7 days)'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(24525208843359821)
,p_name=>'Recent Movements'
,p_static_id=>'recent-movements'
,p_template=>4072358936313175081
,p_display_sequence=>40
,p_region_css_classes=>'inv-recent'
,p_icon_css_classes=>'fa-history'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select txn_id, txn_date, txn_type_label, sku, item_name,',
'       case when txn_type in (''ISSUE'') or quantity < 0 then ''-'' else ''+'' end || abs(quantity) quantity,',
'       coalesce(to_location, from_location) location',
'  from inv_transactions_v',
' order by txn_date desc, txn_id desc',
' fetch first 8 rows only'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>8
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No stock movements yet.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360202)
,p_query_column_id=>5
,p_column_alias=>'ITEM_NAME'
,p_column_display_sequence=>50
,p_column_heading=>'Item'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360204)
,p_query_column_id=>7
,p_column_alias=>'LOCATION'
,p_column_display_sequence=>70
,p_column_heading=>'Location'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360203)
,p_query_column_id=>6
,p_column_alias=>'QUANTITY'
,p_column_display_sequence=>60
,p_column_heading=>'Qty'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360201)
,p_query_column_id=>4
,p_column_alias=>'SKU'
,p_column_display_sequence=>40
,p_column_heading=>'SKU'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360199)
,p_query_column_id=>2
,p_column_alias=>'TXN_DATE'
,p_column_display_sequence=>20
,p_column_heading=>'Date'
,p_column_format=>'DD-MON'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360198)
,p_query_column_id=>1
,p_column_alias=>'TXN_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843360200)
,p_query_column_id=>3
,p_column_alias=>'TXN_TYPE_LABEL'
,p_column_display_sequence=>30
,p_column_heading=>'Type'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843360419)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(24525208843359818)
,p_button_name=>'ISSUE'
,p_static_id=>'issue'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Issue stock'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_TXN_TYPE:ISSUE'
,p_icon_css_classes=>'fa-arrow-up'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843360418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843359818)
,p_button_name=>'RECEIVE'
,p_static_id=>'receive'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Receive stock'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_TXN_TYPE:RECEIPT'
,p_icon_css_classes=>'fa-arrow-down'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843360420)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(24525208843359818)
,p_button_name=>'TRANSFER'
,p_static_id=>'transfer'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Transfer'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_TXN_TYPE:TRANSFER'
,p_icon_css_classes=>'fa-exchange'
);
end;
/
prompt --application/pages/page_00002
begin
wwv_flow_imp_page.create_page(
 p_id=>2
,p_name=>'Items'
,p_alias=>'ITEMS'
,p_step_title=>'Items'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page '
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843361807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(24525208843360819)
,p_name=>'Items'
,p_static_id=>'items'
,p_template=>4072358936313175081
,p_display_sequence=>20
,p_region_css_classes=>'inv-rpt inv-items'
,p_icon_css_classes=>'fa-cube'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select item_id, sku, name, category, qty_on_hand || '' '' || uom on_hand, reorder_level,',
'       case when active_yn = ''N'' then ''<span class="inv-pill">Inactive</span>''',
'            when low_stock_yn = ''Y'' then ''<span class="inv-pill inv-pill--warn">Low</span>''',
'            else ''<span class="inv-pill inv-pill--ok">OK</span>'' end status',
'  from inv_items_v',
' where (:P2_SEARCH is null',
'        or upper(sku) like ''%'' || upper(:P2_SEARCH) || ''%''',
'        or upper(name) like ''%'' || upper(:P2_SEARCH) || ''%'')',
'   and (:P2_CATEGORY_ID is null or category_id = :P2_CATEGORY_ID)',
'   and (:P2_STATUS is null',
'        or (:P2_STATUS = ''LOW'' and low_stock_yn = ''Y'')',
'        or (:P2_STATUS in (''Y'',''N'') and active_yn = :P2_STATUS))',
' order by sku'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>25
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No items match your search.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843361161)
,p_query_column_id=>4
,p_column_alias=>'CATEGORY'
,p_column_display_sequence=>40
,p_column_heading=>'Category'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843361158)
,p_query_column_id=>1
,p_column_alias=>'ITEM_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843361160)
,p_query_column_id=>3
,p_column_alias=>'NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843361162)
,p_query_column_id=>5
,p_column_alias=>'ON_HAND'
,p_column_display_sequence=>50
,p_column_heading=>'On hand'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843361163)
,p_query_column_id=>6
,p_column_alias=>'REORDER_LEVEL'
,p_column_display_sequence=>60
,p_column_heading=>'Reorder at'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843361159)
,p_query_column_id=>2
,p_column_alias=>'SKU'
,p_column_display_sequence=>20
,p_column_heading=>'SKU'
,p_column_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:3:P3_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#SKU#'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843361164)
,p_query_column_id=>7
,p_column_alias=>'STATUS'
,p_column_display_sequence=>70
,p_column_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843360818)
,p_plug_name=>'Search'
,p_static_id=>'search'
,p_region_css_classes=>'inv-toolbar'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843361418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843360819)
,p_button_name=>'CREATE'
,p_static_id=>'create'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Item'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843360919)
,p_name=>'P2_CATEGORY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24525208843360818)
,p_prompt=>'Category'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select name d, category_id r from inv_categories order by name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All categories'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'execute_validations', 'Y',
  'page_action_on_selection', 'SUBMIT')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843360918)
,p_name=>'P2_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24525208843360818)
,p_prompt=>'Search SKU or name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_icon_css_classes=>'fa-search'
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'Y',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843360920)
,p_name=>'P2_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(24525208843360818)
,p_item_default=>'Y'
,p_prompt=>'Show'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Active items;Y,Low stock;LOW,Inactive items;N'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All items'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'execute_validations', 'Y',
  'page_action_on_selection', 'SUBMIT')).to_clob
);
end;
/
prompt --application/pages/page_00003
begin
wwv_flow_imp_page.create_page(
 p_id=>3
,p_name=>'Item'
,p_alias=>'ITEM'
,p_step_title=>'Item'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page inv-form'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843362807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843361818)
,p_plug_name=>'Item Details'
,p_static_id=>'item-details'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-cube'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843362418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843362419)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_button_name=>'DELETE'
,p_static_id=>'delete'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(''Delete this item?'',''DELETE'');'
,p_button_condition=>':P3_ITEM_ID is not null'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843362420)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_button_name=>'SAVE'
,p_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(24525208843362816)
,p_branch_name=>'Go To Page 2'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361928)
,p_name=>'P3_ACTIVE_YN'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_item_default=>'Y'
,p_prompt=>'Status'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Active;Y,Inactive;N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361921)
,p_name=>'P3_CATEGORY_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_prompt=>'Category'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select name d, category_id r from inv_categories where active_yn = ''Y'' or category_id = :P3_CATEGORY_ID order by name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361927)
,p_name=>'P3_DESCRIPTION'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_prompt=>'Description'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361918)
,p_name=>'P3_ITEM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361920)
,p_name=>'P3_NAME'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_prompt=>'Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>150
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361929)
,p_name=>'P3_QTY_ON_HAND'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_prompt=>'On hand (all locations)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361925)
,p_name=>'P3_REORDER_LEVEL'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_item_default=>'0'
,p_prompt=>'Reorder level'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361926)
,p_name=>'P3_REORDER_QTY'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_item_default=>'1'
,p_prompt=>'Reorder quantity'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_inline_help_text=>'Ordered when stock is low (> 0)'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361919)
,p_name=>'P3_SKU'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_prompt=>'SKU'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>40
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361922)
,p_name=>'P3_SUPPLIER_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_prompt=>'Supplier'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select name d, supplier_id r from inv_suppliers where active_yn = ''Y'' or supplier_id = :P3_SUPPLIER_ID order by name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361924)
,p_name=>'P3_UNIT_COST'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_item_default=>'0'
,p_prompt=>'Unit cost'
,p_format_mask=>'FM999G999G990D00'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843361923)
,p_name=>'P3_UOM'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(24525208843361818)
,p_item_default=>'EA'
,p_prompt=>'Unit of measure'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_colspan=>3
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_inline_help_text=>'EA, M, PR, RL, KG ...'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(24525208843362518)
,p_validation_name=>'Reorder quantity > 0'
,p_static_id=>'reorder-quantity'
,p_validation_sequence=>10
,p_validation=>'to_number(:P3_REORDER_QTY) > 0'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Reorder quantity must be greater than 0.'
,p_when_button_pressed=>wwv_flow_imp.id(24525208843362420)
,p_associated_item=>wwv_flow_imp.id(24525208843361926)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843362620)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete item'
,p_static_id=>'delete-item'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  inv_api.delete_item(p_item_id => :P3_ITEM_ID);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208843362419)
,p_process_success_message=>'Item deleted (or made inactive if it has stock history).'
,p_internal_uid=>24525208843362620
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843362618)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load item'
,p_static_id=>'load-item'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sku, name, category_id, supplier_id, uom, unit_cost, reorder_level, reorder_qty,',
'       description, active_yn, qty_on_hand || '' '' || uom',
'  into :P3_SKU, :P3_NAME, :P3_CATEGORY_ID, :P3_SUPPLIER_ID, :P3_UOM, :P3_UNIT_COST,',
'       :P3_REORDER_LEVEL, :P3_REORDER_QTY, :P3_DESCRIPTION, :P3_ACTIVE_YN, :P3_QTY_ON_HAND',
'  from inv_items_v',
' where item_id = :P3_ITEM_ID;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>':P3_ITEM_ID is not null'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>24525208843362618
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843362619)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save item'
,p_static_id=>'save-item'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_id inv_items.item_id%type := :P3_ITEM_ID;',
'begin',
'  inv_api.save_item(p_item_id => l_id, p_sku => :P3_SKU, p_name => :P3_NAME,',
'    p_description => :P3_DESCRIPTION, p_category_id => :P3_CATEGORY_ID,',
'    p_supplier_id => :P3_SUPPLIER_ID, p_uom => :P3_UOM, p_unit_cost => :P3_UNIT_COST,',
'    p_reorder_level => :P3_REORDER_LEVEL, p_reorder_qty => :P3_REORDER_QTY,',
'    p_active_yn => :P3_ACTIVE_YN);',
'  :P3_ITEM_ID := l_id;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208843362420)
,p_process_success_message=>'Item saved.'
,p_internal_uid=>24525208843362619
);
end;
/
prompt --application/pages/page_00004
begin
wwv_flow_imp_page.create_page(
 p_id=>4
,p_name=>'Stock on Hand'
,p_alias=>'STOCK'
,p_step_title=>'Stock on Hand'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page '
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843363807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843362818)
,p_plug_name=>'Filter'
,p_static_id=>'filter'
,p_region_css_classes=>'inv-toolbar'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(24525208843362819)
,p_name=>'Stock on Hand'
,p_static_id=>'stock-on-hand'
,p_template=>4072358936313175081
,p_display_sequence=>20
,p_region_css_classes=>'inv-rpt inv-stock'
,p_icon_css_classes=>'fa-cubes'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select item_id, sku, item_name, location_code, qty_on_hand || '' '' || uom qty,',
'       ''R '' || to_char(stock_value, ''FM999G999G990D00'') value',
'  from inv_stock_v',
' where (:P4_LOCATION_ID is null or location_id = :P4_LOCATION_ID)',
'   and (:P4_SEARCH is null',
'        or upper(sku) like ''%'' || upper(:P4_SEARCH) || ''%''',
'        or upper(item_name) like ''%'' || upper(:P4_SEARCH) || ''%'')',
'   and qty_on_hand <> 0',
' order by sku, location_code'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No stock at this location.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843363158)
,p_query_column_id=>1
,p_column_alias=>'ITEM_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843363160)
,p_query_column_id=>3
,p_column_alias=>'ITEM_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Item'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843363161)
,p_query_column_id=>4
,p_column_alias=>'LOCATION_CODE'
,p_column_display_sequence=>40
,p_column_heading=>'Location'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843363162)
,p_query_column_id=>5
,p_column_alias=>'QTY'
,p_column_display_sequence=>50
,p_column_heading=>'On hand'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843363159)
,p_query_column_id=>2
,p_column_alias=>'SKU'
,p_column_display_sequence=>20
,p_column_heading=>'SKU'
,p_column_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:3:P3_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#SKU#'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843363163)
,p_query_column_id=>6
,p_column_alias=>'VALUE'
,p_column_display_sequence=>60
,p_column_heading=>'Value'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843362918)
,p_name=>'P4_LOCATION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24525208843362818)
,p_prompt=>'Location'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select code || '' - '' || name d, location_id r from inv_locations order by code'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All locations'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'execute_validations', 'Y',
  'page_action_on_selection', 'SUBMIT')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843362919)
,p_name=>'P4_SEARCH'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24525208843362818)
,p_prompt=>'Search SKU or name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_icon_css_classes=>'fa-search'
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'Y',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
end;
/
prompt --application/pages/page_00005
begin
wwv_flow_imp_page.create_page(
 p_id=>5
,p_name=>'Stock Movements'
,p_alias=>'MOVEMENTS'
,p_step_title=>'Stock Movements'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page '
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843364807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843363818)
,p_plug_name=>'Filter'
,p_static_id=>'filter'
,p_region_css_classes=>'inv-toolbar'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(24525208843363819)
,p_name=>'Stock Movements'
,p_static_id=>'stock-movements'
,p_template=>4072358936313175081
,p_display_sequence=>20
,p_region_css_classes=>'inv-rpt inv-moves'
,p_icon_css_classes=>'fa-exchange'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select txn_id, txn_date, txn_type_label, sku, item_name,',
'       case when txn_type = ''ISSUE'' or quantity < 0 then ''-'' else ''+'' end || abs(quantity) quantity,',
'       case txn_type when ''TRANSFER'' then from_location || '' > '' || to_location',
'                     else coalesce(to_location, from_location) end location,',
'       reference, created_by',
'  from inv_transactions_v',
' where (:P5_TXN_TYPE is null or txn_type = :P5_TXN_TYPE)',
'   and (:P5_SEARCH is null',
'        or upper(sku) like ''%'' || upper(:P5_SEARCH) || ''%''',
'        or upper(item_name) like ''%'' || upper(:P5_SEARCH) || ''%''',
'        or upper(reference) like ''%'' || upper(:P5_SEARCH) || ''%'')',
' order by txn_date desc, txn_id desc'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No stock movements match.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843364166)
,p_query_column_id=>9
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>90
,p_column_heading=>'By'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843364162)
,p_query_column_id=>5
,p_column_alias=>'ITEM_NAME'
,p_column_display_sequence=>50
,p_column_heading=>'Item'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843364164)
,p_query_column_id=>7
,p_column_alias=>'LOCATION'
,p_column_display_sequence=>70
,p_column_heading=>'Location'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843364163)
,p_query_column_id=>6
,p_column_alias=>'QUANTITY'
,p_column_display_sequence=>60
,p_column_heading=>'Qty'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843364165)
,p_query_column_id=>8
,p_column_alias=>'REFERENCE'
,p_column_display_sequence=>80
,p_column_heading=>'Reference'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843364161)
,p_query_column_id=>4
,p_column_alias=>'SKU'
,p_column_display_sequence=>40
,p_column_heading=>'SKU'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843364159)
,p_query_column_id=>2
,p_column_alias=>'TXN_DATE'
,p_column_display_sequence=>20
,p_column_heading=>'Date'
,p_column_format=>'DD-MON-YY'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843364158)
,p_query_column_id=>1
,p_column_alias=>'TXN_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843364160)
,p_query_column_id=>3
,p_column_alias=>'TXN_TYPE_LABEL'
,p_column_display_sequence=>30
,p_column_heading=>'Type'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843364418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843363819)
,p_button_name=>'NEW'
,p_static_id=>'new'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Movement'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843363919)
,p_name=>'P5_SEARCH'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24525208843363818)
,p_prompt=>'Search SKU, item or reference'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
,p_colspan=>8
,p_field_template=>1609121967514267634
,p_item_icon_css_classes=>'fa-search'
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'Y',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843363918)
,p_name=>'P5_TXN_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24525208843363818)
,p_prompt=>'Type'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Receipt;RECEIPT,Issue;ISSUE,Transfer;TRANSFER,Adjust;ADJUST'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All types'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'execute_validations', 'Y',
  'page_action_on_selection', 'SUBMIT')).to_clob
);
end;
/
prompt --application/pages/page_00006
begin
wwv_flow_imp_page.create_page(
 p_id=>6
,p_name=>'New Movement'
,p_alias=>'NEW-MOVEMENT'
,p_step_title=>'New Movement'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page inv-form'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843365807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843364818)
,p_plug_name=>'Stock Movement'
,p_static_id=>'stock-movement'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-exchange'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843365418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843364818)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843365419)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(24525208843364818)
,p_button_name=>'POST'
,p_static_id=>'post'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Post Movement'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(24525208843365816)
,p_branch_name=>'Go To Page 5'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843364920)
,p_name=>'P6_FROM_LOCATION_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(24525208843364818)
,p_prompt=>'From location'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select code || '' - '' || name d, location_id r from inv_locations where active_yn = ''Y'' order by code'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'Issue and Transfer'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843364919)
,p_name=>'P6_ITEM_ID'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24525208843364818)
,p_prompt=>'Item'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select sku || '' - '' || name || '' ('' || qty_on_hand || '' '' || uom || '')'' d, item_id r from inv_items_v where active_yn = ''Y'' order by sku'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843364924)
,p_name=>'P6_NOTES'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(24525208843364818)
,p_prompt=>'Notes'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843364922)
,p_name=>'P6_QUANTITY'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(24525208843364818)
,p_prompt=>'Quantity'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_inline_help_text=>'Adjustments may be negative (shrinkage).'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843364923)
,p_name=>'P6_REFERENCE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(24525208843364818)
,p_prompt=>'Reference'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_inline_help_text=>'PO, job or count number'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843364921)
,p_name=>'P6_TO_LOCATION_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(24525208843364818)
,p_prompt=>'To location'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select code || '' - '' || name d, location_id r from inv_locations where active_yn = ''Y'' order by code'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'Receipt, Transfer and Adjustment'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843364918)
,p_name=>'P6_TXN_TYPE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24525208843364818)
,p_item_default=>'RECEIPT'
,p_prompt=>'Movement type'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Receipt (stock in);RECEIPT,Issue (stock out);ISSUE,Transfer between locations;TRANSFER,Adjustment (count correction);ADJUST'
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843365618)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Post movement'
,p_static_id=>'post-movement'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_txn_id inv_transactions.txn_id%type;',
'begin',
'  inv_api.post_transaction(',
'    p_txn_type         => :P6_TXN_TYPE,',
'    p_item_id          => :P6_ITEM_ID,',
'    p_quantity         => :P6_QUANTITY,',
'    p_from_location_id => :P6_FROM_LOCATION_ID,',
'    p_to_location_id   => :P6_TO_LOCATION_ID,',
'    p_reference        => :P6_REFERENCE,',
'    p_notes            => :P6_NOTES,',
'    p_txn_id           => l_txn_id);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208843365419)
,p_process_success_message=>'Stock movement posted.'
,p_internal_uid=>24525208843365618
);
end;
/
prompt --application/pages/page_00007
begin
wwv_flow_imp_page.create_page(
 p_id=>7
,p_name=>'Locations'
,p_alias=>'LOCATIONS'
,p_step_title=>'Locations'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page '
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843366807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(24525208843365818)
,p_name=>'Locations'
,p_static_id=>'locations'
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_css_classes=>'inv-rpt inv-locations'
,p_icon_css_classes=>'fa-map-marker'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select l.location_id, l.code, l.name,',
'       (select count(*) from inv_stock s where s.location_id = l.location_id and s.qty_on_hand > 0) items,',
'       case when l.active_yn = ''Y'' then ''<span class="inv-pill inv-pill--ok">Active</span>'' else ''<span class="inv-pill">Inactive</span>'' end status',
'  from inv_locations l order by l.code'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No locations yet.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843366139)
,p_query_column_id=>2
,p_column_alias=>'CODE'
,p_column_display_sequence=>20
,p_column_heading=>'Code'
,p_column_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:8:P8_LOCATION_ID:#LOCATION_ID#'
,p_column_linktext=>'#CODE#'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843366141)
,p_query_column_id=>4
,p_column_alias=>'ITEMS'
,p_column_display_sequence=>40
,p_column_heading=>'Items stocked'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843366138)
,p_query_column_id=>1
,p_column_alias=>'LOCATION_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843366140)
,p_query_column_id=>3
,p_column_alias=>'NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843366142)
,p_query_column_id=>5
,p_column_alias=>'STATUS'
,p_column_display_sequence=>50
,p_column_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843366418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843365818)
,p_button_name=>'CREATE'
,p_static_id=>'create'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Location'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8::'
,p_icon_css_classes=>'fa-plus'
);
end;
/
prompt --application/pages/page_00008
begin
wwv_flow_imp_page.create_page(
 p_id=>8
,p_name=>'Location'
,p_alias=>'LOCATION'
,p_step_title=>'Location'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page inv-form'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843367807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843366818)
,p_plug_name=>'Location Details'
,p_static_id=>'location-details'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-map-marker'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843367418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843366818)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843367419)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(24525208843366818)
,p_button_name=>'DELETE'
,p_static_id=>'delete'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(''Delete this location?'',''DELETE'');'
,p_button_condition=>':P8_LOCATION_ID is not null'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843367420)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(24525208843366818)
,p_button_name=>'SAVE'
,p_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(24525208843367816)
,p_branch_name=>'Go To Page 7'
,p_branch_action=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843366922)
,p_name=>'P8_ACTIVE_YN'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(24525208843366818)
,p_item_default=>'Y'
,p_prompt=>'Status'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Active;Y,Inactive;N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843366919)
,p_name=>'P8_CODE'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24525208843366818)
,p_prompt=>'Code'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843366921)
,p_name=>'P8_DESCRIPTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(24525208843366818)
,p_prompt=>'Description'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>500
,p_cHeight=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843366918)
,p_name=>'P8_LOCATION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24525208843366818)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843366920)
,p_name=>'P8_NAME'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(24525208843366818)
,p_prompt=>'Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
,p_colspan=>8
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843367620)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete location'
,p_static_id=>'delete-location'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  inv_api.delete_location(p_location_id => :P8_LOCATION_ID);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208843367419)
,p_process_success_message=>'Location deleted.'
,p_internal_uid=>24525208843367620
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843367618)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load location'
,p_static_id=>'load-location'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select code, name, description, active_yn into :P8_CODE, :P8_NAME, :P8_DESCRIPTION, :P8_ACTIVE_YN',
'  from inv_locations where location_id = :P8_LOCATION_ID;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>':P8_LOCATION_ID is not null'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>24525208843367618
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843367619)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save location'
,p_static_id=>'save-location'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_id inv_locations.location_id%type := :P8_LOCATION_ID;',
'begin',
'  inv_api.save_location(p_location_id => l_id, p_code => :P8_CODE, p_name => :P8_NAME,',
'    p_description => :P8_DESCRIPTION, p_active_yn => :P8_ACTIVE_YN);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208843367420)
,p_process_success_message=>'Location saved.'
,p_internal_uid=>24525208843367619
);
end;
/
prompt --application/pages/page_00009
begin
wwv_flow_imp_page.create_page(
 p_id=>9
,p_name=>'Categories'
,p_alias=>'CATEGORIES'
,p_step_title=>'Categories'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page '
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843368807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(24525208843367818)
,p_name=>'Categories'
,p_static_id=>'categories'
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_css_classes=>'inv-rpt inv-categories'
,p_icon_css_classes=>'fa-tags'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select c.category_id, c.name, c.description,',
'       (select count(*) from inv_items i where i.category_id = c.category_id) items,',
'       case when c.active_yn = ''Y'' then ''<span class="inv-pill inv-pill--ok">Active</span>'' else ''<span class="inv-pill">Inactive</span>'' end status',
'  from inv_categories c order by c.name'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No categories yet.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843368138)
,p_query_column_id=>1
,p_column_alias=>'CATEGORY_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843368140)
,p_query_column_id=>3
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>30
,p_column_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843368141)
,p_query_column_id=>4
,p_column_alias=>'ITEMS'
,p_column_display_sequence=>40
,p_column_heading=>'Items'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843368139)
,p_query_column_id=>2
,p_column_alias=>'NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Name'
,p_column_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:10:P10_CATEGORY_ID:#CATEGORY_ID#'
,p_column_linktext=>'#NAME#'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843368142)
,p_query_column_id=>5
,p_column_alias=>'STATUS'
,p_column_display_sequence=>50
,p_column_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843368418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843367818)
,p_button_name=>'CREATE'
,p_static_id=>'create'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Category'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10::'
,p_icon_css_classes=>'fa-plus'
);
end;
/
prompt --application/pages/page_00010
begin
wwv_flow_imp_page.create_page(
 p_id=>10
,p_name=>'Category'
,p_alias=>'CATEGORY'
,p_step_title=>'Category'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page inv-form'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843369807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843368818)
,p_plug_name=>'Category Details'
,p_static_id=>'category-details'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-tags'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843369418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843368818)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843369419)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(24525208843368818)
,p_button_name=>'DELETE'
,p_static_id=>'delete'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(''Delete this category?'',''DELETE'');'
,p_button_condition=>':P10_CATEGORY_ID is not null'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843369420)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(24525208843368818)
,p_button_name=>'SAVE'
,p_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(24525208843369816)
,p_branch_name=>'Go To Page 9'
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843368920)
,p_name=>'P10_ACTIVE_YN'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(24525208843368818)
,p_item_default=>'Y'
,p_prompt=>'Status'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Active;Y,Inactive;N'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843368918)
,p_name=>'P10_CATEGORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24525208843368818)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843368921)
,p_name=>'P10_DESCRIPTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(24525208843368818)
,p_prompt=>'Description'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>500
,p_cHeight=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843368919)
,p_name=>'P10_NAME'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24525208843368818)
,p_prompt=>'Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_colspan=>8
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843369620)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete category'
,p_static_id=>'delete-category'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  inv_api.delete_category(p_category_id => :P10_CATEGORY_ID);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208843369419)
,p_process_success_message=>'Category deleted.'
,p_internal_uid=>24525208843369620
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843369618)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load category'
,p_static_id=>'load-category'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name, description, active_yn into :P10_NAME, :P10_DESCRIPTION, :P10_ACTIVE_YN',
'  from inv_categories where category_id = :P10_CATEGORY_ID;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>':P10_CATEGORY_ID is not null'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>24525208843369618
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843369619)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save category'
,p_static_id=>'save-category'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_id inv_categories.category_id%type := :P10_CATEGORY_ID;',
'begin',
'  inv_api.save_category(p_category_id => l_id, p_name => :P10_NAME,',
'    p_description => :P10_DESCRIPTION, p_active_yn => :P10_ACTIVE_YN);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208843369420)
,p_process_success_message=>'Category saved.'
,p_internal_uid=>24525208843369619
);
end;
/
prompt --application/pages/page_00011
begin
wwv_flow_imp_page.create_page(
 p_id=>11
,p_name=>'Suppliers'
,p_alias=>'SUPPLIERS'
,p_step_title=>'Suppliers'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page '
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843370807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(24525208843369818)
,p_name=>'Suppliers'
,p_static_id=>'suppliers'
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_css_classes=>'inv-rpt inv-suppliers'
,p_icon_css_classes=>'fa-truck'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select s.supplier_id, s.name, s.contact_name, s.email, s.phone,',
'       case when s.active_yn = ''Y'' then ''<span class="inv-pill inv-pill--ok">Active</span>'' else ''<span class="inv-pill">Inactive</span>'' end status',
'  from inv_suppliers s order by s.name'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No suppliers yet.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843370140)
,p_query_column_id=>3
,p_column_alias=>'CONTACT_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Contact'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843370141)
,p_query_column_id=>4
,p_column_alias=>'EMAIL'
,p_column_display_sequence=>40
,p_column_heading=>'Email'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843370139)
,p_query_column_id=>2
,p_column_alias=>'NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Name'
,p_column_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:12:P12_SUPPLIER_ID:#SUPPLIER_ID#'
,p_column_linktext=>'#NAME#'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843370142)
,p_query_column_id=>5
,p_column_alias=>'PHONE'
,p_column_display_sequence=>50
,p_column_heading=>'Phone'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843370143)
,p_query_column_id=>6
,p_column_alias=>'STATUS'
,p_column_display_sequence=>60
,p_column_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(24525208843370138)
,p_query_column_id=>1
,p_column_alias=>'SUPPLIER_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843370418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843369818)
,p_button_name=>'CREATE'
,p_static_id=>'create'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Supplier'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12::'
,p_icon_css_classes=>'fa-plus'
);
end;
/
prompt --application/pages/page_00012
begin
wwv_flow_imp_page.create_page(
 p_id=>12
,p_name=>'Supplier'
,p_alias=>'SUPPLIER'
,p_step_title=>'Supplier'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>4072355960268175073
,p_page_css_classes=>'inv-page inv-form'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843371807)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(24525208843258823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208843370818)
,p_plug_name=>'Supplier Details'
,p_static_id=>'supplier-details'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-truck'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843371418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208843370818)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843371419)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(24525208843370818)
,p_button_name=>'DELETE'
,p_static_id=>'delete'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(''Delete this supplier?'',''DELETE'');'
,p_button_condition=>':P12_SUPPLIER_ID is not null'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208843371420)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(24525208843370818)
,p_button_name=>'SAVE'
,p_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(24525208843371816)
,p_branch_name=>'Go To Page 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843370923)
,p_name=>'P12_ACTIVE_YN'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(24525208843370818)
,p_item_default=>'Y'
,p_prompt=>'Status'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Active;Y,Inactive;N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843370920)
,p_name=>'P12_CONTACT_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(24525208843370818)
,p_prompt=>'Contact name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>150
,p_begin_on_new_line=>'N'
,p_colspan=>6
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
 p_id=>wwv_flow_imp.id(24525208843370921)
,p_name=>'P12_EMAIL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(24525208843370818)
,p_prompt=>'Email'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_tag_attributes=>'type="email" autocomplete="email"'
,p_colspan=>6
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
 p_id=>wwv_flow_imp.id(24525208843370919)
,p_name=>'P12_NAME'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24525208843370818)
,p_prompt=>'Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>150
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208843370922)
,p_name=>'P12_PHONE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(24525208843370818)
,p_prompt=>'Phone'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_tag_attributes=>'type="tel"'
,p_begin_on_new_line=>'N'
,p_colspan=>6
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
 p_id=>wwv_flow_imp.id(24525208843370918)
,p_name=>'P12_SUPPLIER_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24525208843370818)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843371620)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete supplier'
,p_static_id=>'delete-supplier'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  inv_api.delete_supplier(p_supplier_id => :P12_SUPPLIER_ID);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208843371419)
,p_process_success_message=>'Supplier deleted.'
,p_internal_uid=>24525208843371620
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843371618)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load supplier'
,p_static_id=>'load-supplier'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name, contact_name, email, phone, active_yn',
'  into :P12_NAME, :P12_CONTACT_NAME, :P12_EMAIL, :P12_PHONE, :P12_ACTIVE_YN',
'  from inv_suppliers where supplier_id = :P12_SUPPLIER_ID;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>':P12_SUPPLIER_ID is not null'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>24525208843371618
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208843371619)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save supplier'
,p_static_id=>'save-supplier'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_id inv_suppliers.supplier_id%type := :P12_SUPPLIER_ID;',
'begin',
'  inv_api.save_supplier(p_supplier_id => l_id, p_name => :P12_NAME,',
'    p_contact_name => :P12_CONTACT_NAME, p_email => :P12_EMAIL, p_phone => :P12_PHONE,',
'    p_active_yn => :P12_ACTIVE_YN);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208843371420)
,p_process_success_message=>'Supplier saved.'
,p_internal_uid=>24525208843371619
);
end;
/
prompt --application/pages/page_09999
begin
wwv_flow_imp_page.create_page(
 p_id=>9999
,p_name=>'Sign In'
,p_alias=>'LOGIN'
,p_step_title=>'Sign In'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_step_template=>2101157952850466385
,p_page_css_classes=>'inv-page inv-login'
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_page_component_map=>'12'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24525208853357818)
,p_plug_name=>'Inventory Control'
,p_static_id=>'inventory-control'
,p_icon_css_classes=>'fa-cubes'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2674157997338192145
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p class="inv-login-tagline">Sign in to manage stock</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(24525208853358418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(24525208853357818)
,p_button_name=>'LOGIN'
,p_static_id=>'login'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--stretch'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Sign In'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208853357919)
,p_name=>'P9999_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24525208853357818)
,p_prompt=>'Password'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>40
,p_cMaxlength=>100
,p_tag_attributes=>'autocomplete="current-password"'
,p_field_template=>1609121967514267634
,p_item_icon_css_classes=>'fa-key'
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208853357920)
,p_name=>'P9999_REMEMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(24525208853357818)
,p_prompt=>'Remember username'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_cSize=>30
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24525208853357918)
,p_name=>'P9999_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24525208853357818)
,p_prompt=>'Username'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
,p_tag_attributes=>'autocomplete="username" autocapitalize="none"'
,p_field_template=>1609121967514267634
,p_item_icon_css_classes=>'fa-user'
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208853358621)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Clear page cache'
,p_static_id=>'clear-page-cache'
,p_process_sql_clob=>'apex_util.clear_page_cache(:APP_PAGE_ID);'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208853358418)
,p_internal_uid=>24525208853358621
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208853358618)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get username cookie'
,p_static_id=>'get-username-cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P9999_USERNAME := apex_authentication.get_login_username_cookie;',
':P9999_REMEMBER := case when :P9999_USERNAME is not null then ''Y'' end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>24525208853358618
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208853358620)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Login'
,p_static_id=>'login'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_authentication.login(',
'  p_username => :P9999_USERNAME,',
'  p_password => :P9999_PASSWORD);'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208853358418)
,p_internal_uid=>24525208853358620
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24525208853358619)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set username cookie'
,p_static_id=>'set-username-cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_authentication.send_login_username_cookie(',
'  p_username => lower(:P9999_USERNAME),',
'  p_consent  => :P9999_REMEMBER = ''Y'');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(24525208853358418)
,p_internal_uid=>24525208853358619
);
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
