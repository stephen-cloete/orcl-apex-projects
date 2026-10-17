prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
-- Inventory Control (apex-inventory-control) - APEX 26.1 bootstrap export, application 1301
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.2'
,p_default_workspace_id=>0
,p_default_application_id=>1301
,p_default_id_offset=>0
,p_default_owner=>'INVENTORY_CONTROL'
);
end;
/
prompt APPLICATION 1301 - Inventory Control
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
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_authentication_id=>wwv_flow_imp.id(13010000000000001)
,p_application_tab_set=>1
,p_logo_type=>'IT'
,p_logo=>'fa-cubes'
,p_logo_text=>'Inventory Control'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'1.0.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_deep_linking=>'Y'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_auto_time_zone=>'N'
,p_error_handling_function=>'inv_ui_error'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'Inventory Control'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>1
,p_version_scn=>1
,p_print_server_type=>'INSTANCE'
,p_file_storage=>'DB'
,p_is_pwa=>'N'
);
end;
/
prompt --application/user_interfaces
begin
wwv_flow_imp_shared.create_user_interface(
 p_id=>wwv_flow_imp.id(13010000000000004)
,p_theme_id=>42
,p_home_url=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_login_url=>'f?p=&APP_ID.:LOGIN:&APP_SESSION.::&DEBUG.:::'
,p_theme_style_by_user_pref=>false
,p_built_with_love=>false
,p_navigation_list_id=>wwv_flow_imp.id(13010000000000002)
,p_navigation_list_position=>'SIDE'
,p_navigation_list_template_id=>2467739217141810545
,p_nav_list_template_options=>'#DEFAULT#:js-defaultCollapsed:js-navCollapsed--hidden:t-TreeNav--styleA'
,p_nav_bar_type=>'LIST'
,p_nav_bar_list_id=>wwv_flow_imp.id(13010000000000003)
,p_nav_bar_list_template_id=>2847543055748234966
,p_nav_bar_template_options=>'#DEFAULT#'
);
end;
/
prompt --application/shared_components/navigation/lists/navigation_menu
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(13010000000000002)
,p_name=>'Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000001010)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000001020)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Items'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-cube'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2:3'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000001030)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Stock on Hand'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-cubes'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000001040)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Stock Movements'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-exchange'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'5:6'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000001050)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Setup'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-cog'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000001051)
,p_list_item_display_sequence=>51
,p_list_item_link_text=>'Locations'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-map-marker'
,p_parent_list_item_id=>wwv_flow_imp.id(13010000000001050)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'7:8'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000001052)
,p_list_item_display_sequence=>52
,p_list_item_link_text=>'Categories'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-tags'
,p_parent_list_item_id=>wwv_flow_imp.id(13010000000001050)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'9:10'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000001053)
,p_list_item_display_sequence=>53
,p_list_item_link_text=>'Suppliers'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-truck'
,p_parent_list_item_id=>wwv_flow_imp.id(13010000000001050)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'11:12'
);
end;
/
prompt --application/shared_components/navigation/lists/navigation_bar
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(13010000000000003)
,p_name=>'Navigation Bar'
,p_list_status=>'PUBLIC'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000002001)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'&APP_USER.'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user'
,p_list_text_02=>'has-username'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13010000000002002)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Sign Out'
,p_list_item_link_target=>'&LOGOUT_URL.'
,p_list_item_icon=>'fa-sign-out'
,p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'
,p_parent_list_item_id=>wwv_flow_imp.id(13010000000002001)
,p_list_item_current_type=>'TARGET_PAGE'
);
end;
/
prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(13010000000000006)
,p_name=>'Breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003001)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003002)
,p_parent_id=>wwv_flow_imp.id(13010000000003001)
,p_short_name=>'Items'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003003)
,p_parent_id=>wwv_flow_imp.id(13010000000003002)
,p_short_name=>'Item'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003004)
,p_parent_id=>wwv_flow_imp.id(13010000000003001)
,p_short_name=>'Stock on Hand'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003005)
,p_parent_id=>wwv_flow_imp.id(13010000000003001)
,p_short_name=>'Stock Movements'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003006)
,p_parent_id=>wwv_flow_imp.id(13010000000003005)
,p_short_name=>'New Movement'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003007)
,p_parent_id=>wwv_flow_imp.id(13010000000003001)
,p_short_name=>'Locations'
,p_link=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003008)
,p_parent_id=>wwv_flow_imp.id(13010000000003007)
,p_short_name=>'Location'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003009)
,p_parent_id=>wwv_flow_imp.id(13010000000003001)
,p_short_name=>'Categories'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003010)
,p_parent_id=>wwv_flow_imp.id(13010000000003009)
,p_short_name=>'Category'
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003011)
,p_parent_id=>wwv_flow_imp.id(13010000000003001)
,p_short_name=>'Suppliers'
,p_link=>'f?p=&APP_ID.:11:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13010000000003012)
,p_parent_id=>wwv_flow_imp.id(13010000000003011)
,p_short_name=>'Supplier'
,p_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>12
);
end;
/
prompt --application/shared_components/user_interface/themes
begin
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(13010000000000005)
,p_theme_id=>42
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_version_identifier=>'26.1'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>4072363937200175119
,p_is_locked=>false
,p_current_theme_style_id=>wwv_flow_imp.id(13010000000000007)
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
,p_default_nav_list_template=>2467739217141810545
,p_default_side_nav_list_temp=>2467739217141810545
,p_default_navbar_list_template=>2847543055748234966
,p_icon_library=>'FONTAPEX'
,p_file_prefix=>'#APEX_FILES#themes/theme_42/26.1/'
,p_files_version=>1
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APEX_FILES#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_FILES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#THEME_FILES#css/Core#MIN#.css?v=#APEX_VERSION#'))
);
wwv_flow_imp_shared.create_theme_style(
 p_id=>wwv_flow_imp.id(13010000000000007)
,p_theme_id=>42
,p_name=>'Vita'
,p_css_file_urls=>'#THEME_FILES#css/Vita#MIN#.css?v=#APEX_VERSION#'
,p_is_current=>true
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_read_only=>true
);
end;
/
prompt --application/shared_components/security/authentications/oracle_apex_accounts
begin
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(13010000000000001)
,p_name=>'Oracle APEX Accounts'
,p_scheme_type=>'NATIVE_APEX_ACCOUNTS'
,p_invalid_session_type=>'LOGIN'
,p_use_secure_cookie_yn=>'Y'
,p_ras_mode=>0
);
end;
/
prompt --application/shared_components/files/css_inv_app_css
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2f2a20496e76656e746f727920436f6e74726f6c2028617070203133303129202d20736d616c6c206c61796572206f6e20746f70206f6620556e6976657273616c205468656d652032362e31202f20566974612e0a202020476f616c3a206e6f20686f72';
wwv_flow_imp.g_varchar2_table(2) := '697a6f6e74616c2070616765206f766572666c6f772061742033393070782c20696e707574732074686174206c696e652075702c20636f6d70616374207461626c65732e202a2f0a68746d6c2c20626f6479207b206d61782d77696474683a2031303025';
wwv_flow_imp.g_varchar2_table(3) := '3b206f766572666c6f772d783a2068696464656e3b207d0a2e742d426f64792d636f6e74656e742c202e742d426f64792d636f6e74656e74496e6e6572207b206d696e2d77696474683a20303b207d0a0a2f2a206865726f206f6e20686f6d65202a2f0a';
wwv_flow_imp.g_varchar2_table(4) := '2e696e762d6865726f207b2070616464696e673a20313670782031367078203470783b207d0a2e696e762d6865726f202e742d526567696f6e2d7469746c652c202e696e762d6865726f206832207b20666f6e742d73697a653a20312e3572656d3b207d';
wwv_flow_imp.g_varchar2_table(5) := '0a2e696e762d6c656164207b206d617267696e3a2030203020313270783b20636f6c6f723a20766172282d2d75742d626f64792d746578742d636f6c6f722c2023343434293b206f7061636974793a202e383b207d0a2e696e762d6865726f202e742d52';
wwv_flow_imp.g_varchar2_table(6) := '6567696f6e2d6865616465724974656d732d2d627574746f6e732c0a2e696e762d6865726f202e742d427574746f6e526567696f6e2d627574746f6e73207b20646973706c61793a20666c65783b20666c65782d777261703a20777261703b206761703a';
wwv_flow_imp.g_varchar2_table(7) := '203870783b207d0a0a2f2a206261646765206c69737420737461797320696e73696465207468652076696577706f7274202a2f0a2e696e762d6f76657276696577202e742d42616467654c697374207b20666c65782d777261703a20777261703b207d0a';
wwv_flow_imp.g_varchar2_table(8) := '2e696e762d6f76657276696577202e742d42616467654c6973742d6974656d207b206d696e2d77696474683a20303b20666c65783a203120312031343070783b207d0a2e696e762d6f76657276696577202e742d42616467654c6973742d76616c756520';
wwv_flow_imp.g_varchar2_table(9) := '7b20666f6e742d73697a653a20312e323572656d3b2077686974652d73706163653a206e6f777261703b207d0a0a2e696e762d6f76657276696577202e742d5265706f72742d706167696e6174696f6e2c202e696e762d6f76657276696577202e742d52';
wwv_flow_imp.g_varchar2_table(10) := '65706f72742d6c696e6b732c0a2e696e762d6c6f772d73746f636b202e742d5265706f72742d706167696e6174696f6e2c202e696e762d726563656e74202e742d5265706f72742d706167696e6174696f6e207b20646973706c61793a206e6f6e653b20';
wwv_flow_imp.g_varchar2_table(11) := '7d0a0a2f2a207374617475732070696c6c73202a2f0a2e696e762d70696c6c207b20646973706c61793a20696e6c696e652d626c6f636b3b2070616464696e673a20327078203870783b20626f726465722d7261646975733a2039393970783b20666f6e';
wwv_flow_imp.g_varchar2_table(12) := '742d73697a653a202e373572656d3b0a202020202020202020202020666f6e742d7765696768743a203630303b206261636b67726f756e643a20236536653665363b20636f6c6f723a20233434343b2077686974652d73706163653a206e6f777261703b';
wwv_flow_imp.g_varchar2_table(13) := '207d0a2e696e762d70696c6c2d2d6f6b207b206261636b67726f756e643a20236466663365363b20636f6c6f723a20233164366233613b207d0a2e696e762d70696c6c2d2d7761726e207b206261636b67726f756e643a20236664653764363b20636f6c';
wwv_flow_imp.g_varchar2_table(14) := '6f723a20233961336430373b207d0a0a2f2a207461626c6573206e657665722070757368207468652070616765207769646572207468616e207468652073637265656e202a2f0a2e742d5265706f72742d777261702c202e742d5265706f72742d746162';
wwv_flow_imp.g_varchar2_table(15) := '6c6557726170207b206d61782d77696474683a20313030253b206f766572666c6f772d783a206175746f3b207d0a2e742d5265706f72742d7265706f72742074642c202e742d5265706f72742d7265706f7274207468207b2077686974652d7370616365';
wwv_flow_imp.g_varchar2_table(16) := '3a206e6f777261703b207d0a2e742d5265706f72742d7265706f7274202e696e762d736b75207b2077686974652d73706163653a206e6f777261703b206f766572666c6f772d777261703a206e6f726d616c3b207d0a2e742d5265706f72742d7265706f';
wwv_flow_imp.g_varchar2_table(17) := '72742074645b686561646572733d224e414d45225d2c202e742d5265706f72742d7265706f72742074645b686561646572733d224954454d5f4e414d45225d2c0a2e742d5265706f72742d7265706f72742074645b686561646572733d22444553435249';
wwv_flow_imp.g_varchar2_table(18) := '5054494f4e225d207b2077686974652d73706163653a206e6f726d616c3b206d696e2d77696474683a203872656d3b207d0a0a2f2a20746f6f6c62617273202f20666f726d733a206669656c6473207374726574636820746f2074686569722067726964';
wwv_flow_imp.g_varchar2_table(19) := '20636f6c756d6e20616e64206c696e65207570202a2f0a2e696e762d746f6f6c626172207b206d617267696e2d626f74746f6d3a203870783b207d0a2e696e762d70616765202e742d466f726d2d6669656c64436f6e7461696e65722d2d737472657463';
wwv_flow_imp.g_varchar2_table(20) := '68496e70757473202e742d466f726d2d696e707574436f6e7461696e65722c0a2e696e762d70616765202e742d466f726d2d6669656c64436f6e7461696e65722d2d73747265746368496e70757473202e742d466f726d2d6974656d5772617070657220';
wwv_flow_imp.g_varchar2_table(21) := '7b2077696474683a20313030253b207d0a2e696e762d706167652073656c6563742e73656c6563746c6973742c202e696e762d7061676520696e7075742e746578745f6669656c642c202e696e762d7061676520696e7075742e6e756d6265725f666965';
wwv_flow_imp.g_varchar2_table(22) := '6c642c0a2e696e762d706167652074657874617265612e7465787461726561207b2077696474683a20313030253b206d61782d77696474683a20313030253b20626f782d73697a696e673a20626f726465722d626f783b207d0a0a2f2a2070686f6e653a';
wwv_flow_imp.g_varchar2_table(23) := '2068696465207365636f6e6461727920636f6c756d6e732c207469676874656e2070616464696e67202a2f0a406d6564696120286d61782d77696474683a20363430707829207b0a20202e742d426f64792d636f6e74656e74496e6e6572207b20706164';
wwv_flow_imp.g_varchar2_table(24) := '64696e672d6c6566743a203870783b2070616464696e672d72696768743a203870783b207d0a20202e696e762d7270742074682343415445474f52592c202e696e762d7270742074645b686561646572733d2243415445474f5259225d2c0a20202e696e';
wwv_flow_imp.g_varchar2_table(25) := '762d7270742074682352454f524445525f4c4556454c2c202e696e762d7270742074645b686561646572733d2252454f524445525f4c4556454c225d2c0a20202e696e762d7270742074682356414c55452c202e696e762d7270742074645b6865616465';
wwv_flow_imp.g_varchar2_table(26) := '72733d2256414c5545225d2c0a20202e696e762d727074207468235245464552454e43452c202e696e762d7270742074645b686561646572733d225245464552454e4345225d2c0a20202e696e762d72707420746823435245415445445f42592c202e69';
wwv_flow_imp.g_varchar2_table(27) := '6e762d7270742074645b686561646572733d22435245415445445f4259225d2c0a20202e696e762d727074207468234954454d5f4e414d452c202e696e762d7270742074645b686561646572733d224954454d5f4e414d45225d2c0a20202e696e762d72';
wwv_flow_imp.g_varchar2_table(28) := '7074207468234445534352495054494f4e2c202e696e762d7270742074645b686561646572733d224445534352495054494f4e225d2c0a20202e696e762d72707420746823434f4e544143545f4e414d452c202e696e762d7270742074645b6865616465';
wwv_flow_imp.g_varchar2_table(29) := '72733d22434f4e544143545f4e414d45225d2c0a20202e696e762d7270742074682350484f4e452c202e696e762d7270742074645b686561646572733d2250484f4e45225d2c0a20202e696e762d727074207468234954454d532c202e696e762d727074';
wwv_flow_imp.g_varchar2_table(30) := '2074645b686561646572733d224954454d53225d2c0a20202e696e762d726563656e74207468234954454d5f4e414d452c202e696e762d726563656e742074645b686561646572733d224954454d5f4e414d45225d2c0a20202e696e762d726563656e74';
wwv_flow_imp.g_varchar2_table(31) := '207468234c4f434154494f4e2c202e696e762d726563656e742074645b686561646572733d224c4f434154494f4e225d2c0a20202e696e762d6d6f766573207468234c4f434154494f4e2c202e696e762d6d6f7665732074645b686561646572733d224c';
wwv_flow_imp.g_varchar2_table(32) := '4f434154494f4e225d2c0a20202e696e762d6c6f772d73746f636b207468234e414d452c202e696e762d6c6f772d73746f636b2074645b686561646572733d224e414d45225d2c0a20202e696e762d6c6f772d73746f636b2074682352454f524445525f';
wwv_flow_imp.g_varchar2_table(33) := '4c4556454c2c202e696e762d6c6f772d73746f636b2074645b686561646572733d2252454f524445525f4c4556454c225d207b20646973706c61793a206e6f6e653b207d0a20202e742d5265706f72742d63656c6c2c202e742d5265706f72742d636f6c';
wwv_flow_imp.g_varchar2_table(34) := '48656164207b2070616464696e673a20387078203570783b207d0a20202e742d5265706f72742d7265706f72742074642c202e742d5265706f72742d7265706f7274207468207b20666f6e742d73697a653a202e3831323572656d3b207d0a20202e742d';
wwv_flow_imp.g_varchar2_table(35) := '5265706f72742d7265706f7274207464207b2077686974652d73706163653a206e6f726d616c3b206f766572666c6f772d777261703a20616e7977686572653b207d0a20202e742d5265706f72742d7265706f72742074645b686561646572733d224e41';
wwv_flow_imp.g_varchar2_table(36) := '4d45225d2c202e742d5265706f72742d7265706f72742074645b686561646572733d224954454d5f4e414d45225d2c0a20202e742d5265706f72742d7265706f72742074645b686561646572733d224445534352495054494f4e225d207b206d696e2d77';
wwv_flow_imp.g_varchar2_table(37) := '696474683a20303b207d0a20202e742d5265706f72742d7265706f72742074645b686561646572733d225155414e54495459225d2c202e742d5265706f72742d7265706f72742074645b686561646572733d224f4e5f48414e44225d2c0a20202e742d52';
wwv_flow_imp.g_varchar2_table(38) := '65706f72742d7265706f72742074645b686561646572733d22515459225d2c202e742d5265706f72742d7265706f72742074645b686561646572733d22535441545553225d2c0a20202e742d5265706f72742d7265706f72742074645b68656164657273';
wwv_flow_imp.g_varchar2_table(39) := '3d2254584e5f44415445225d2c202e742d5265706f72742d7265706f72742074645b686561646572733d2254584e5f545950455f4c4142454c225d2c0a20202e742d5265706f72742d7265706f72742074645b686561646572733d22534b55225d2c202e';
wwv_flow_imp.g_varchar2_table(40) := '742d5265706f72742d7265706f7274202e696e762d736b75207b2077686974652d73706163653a206e6f777261703b206f766572666c6f772d777261703a206e6f726d616c3b207d0a20202e742d526567696f6e2d6865616465724974656d732d2d6275';
wwv_flow_imp.g_varchar2_table(41) := '74746f6e73202e742d427574746f6e207b2070616464696e672d6c6566743a20313070783b2070616464696e672d72696768743a20313070783b207d0a20202e742d526567696f6e2d6865616465724974656d732d2d7469746c65207b206d696e2d7769';
wwv_flow_imp.g_varchar2_table(42) := '6474683a20303b207d0a7d0a0a2f2a206c6f67696e202a2f0a2e696e762d6c6f67696e202e742d4c6f67696e2d6c6f676f207b20646973706c61793a20666c65783b20616c69676e2d6974656d733a2063656e7465723b206a7573746966792d636f6e74';
wwv_flow_imp.g_varchar2_table(43) := '656e743a2063656e7465723b0a202077696474683a20363470783b206865696768743a20363470783b206d617267696e3a2030206175746f203870783b20626f726465722d7261646975733a20313670783b0a20206261636b67726f756e643a20766172';
wwv_flow_imp.g_varchar2_table(44) := '282d2d75742d70616c657474652d7072696d6172792c2023326536626432293b20636f6c6f723a20236666663b20666f6e742d73697a653a20333270783b207d0a2e696e762d6c6f67696e2d7461676c696e65207b20746578742d616c69676e3a206365';
wwv_flow_imp.g_varchar2_table(45) := '6e7465723b206d617267696e3a20302030203870783b206f7061636974793a202e37353b207d0a';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(13010000000000008)
,p_file_name=>'css/inv-app.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page inv-home'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000101001)
,p_plug_name=>'Inventory Control'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_region_css_classes=>'inv-hero'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p class="inv-lead">Track items, stock on hand and every stock movement across your locations.</p>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000101601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000101001)
,p_button_name=>'RECEIVE'
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
 p_id=>wwv_flow_imp.id(13010000000101602)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(13010000000101001)
,p_button_name=>'ISSUE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'N'
,p_button_image_alt=>'Issue stock'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_TXN_TYPE:ISSUE'
,p_icon_css_classes=>'fa-arrow-up'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000101603)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(13010000000101001)
,p_button_name=>'TRANSFER'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'N'
,p_button_image_alt=>'Transfer'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_TXN_TYPE:TRANSFER'
,p_icon_css_classes=>'fa-exchange'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(13010000000101002)
,p_name=>'Overview'
,p_template=>4072358936313175081
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder'
,p_component_template_options=>'#DEFAULT#:t-BadgeList--responsive:t-BadgeList--large:t-BadgeList--flex'
,p_region_css_classes=>'inv-overview'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select active_items, low_stock_items,',
'       ''R '' || to_char(stock_value, ''FM999G999G990D00'') stock_value,',
'       txns_7_days, active_locations',
'  from inv_dashboard_v'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>2104643962563030528
,p_query_num_rows=>1
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No rows found.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101341)
,p_query_column_id=>1
,p_column_alias=>'ACTIVE_ITEMS'
,p_column_display_sequence=>10
,p_column_heading=>'Active items'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101342)
,p_query_column_id=>2
,p_column_alias=>'LOW_STOCK_ITEMS'
,p_column_display_sequence=>20
,p_column_heading=>'Low stock'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101343)
,p_query_column_id=>3
,p_column_alias=>'STOCK_VALUE'
,p_column_display_sequence=>30
,p_column_heading=>'Stock value'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101344)
,p_query_column_id=>4
,p_column_alias=>'TXNS_7_DAYS'
,p_column_display_sequence=>40
,p_column_heading=>'Movements (7 days)'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101345)
,p_query_column_id=>5
,p_column_alias=>'ACTIVE_LOCATIONS'
,p_column_display_sequence=>50
,p_column_heading=>'Locations'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(13010000000101003)
,p_name=>'Low Stock'
,p_template=>4072358936313175081
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_region_css_classes=>'inv-low-stock'
,p_icon_css_classes=>'fa-warning'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select item_id, sku, name, qty_on_hand, reorder_level, suggested_order_qty',
'  from inv_items_v',
' where low_stock_yn = ''Y''',
' order by qty_on_hand - reorder_level, sku'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'Nothing is below its reorder level.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101361)
,p_query_column_id=>1
,p_column_alias=>'ITEM_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Item'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_hidden_column=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101362)
,p_query_column_id=>2
,p_column_alias=>'SKU'
,p_column_display_sequence=>20
,p_column_heading=>'SKU'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_css_class=>'inv-sku'
,p_column_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:3:P3_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#SKU#'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101363)
,p_query_column_id=>3
,p_column_alias=>'NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Item'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101364)
,p_query_column_id=>4
,p_column_alias=>'QTY_ON_HAND'
,p_column_display_sequence=>40
,p_column_heading=>'On hand'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101365)
,p_query_column_id=>5
,p_column_alias=>'REORDER_LEVEL'
,p_column_display_sequence=>50
,p_column_heading=>'Reorder at'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101366)
,p_query_column_id=>6
,p_column_alias=>'SUGGESTED_ORDER_QTY'
,p_column_display_sequence=>60
,p_column_heading=>'Order qty'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(13010000000101004)
,p_name=>'Recent Movements'
,p_template=>4072358936313175081
,p_display_sequence=>40
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_region_css_classes=>'inv-recent'
,p_icon_css_classes=>'fa-history'
,p_display_point=>'BODY'
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
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>8
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No stock movements yet.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101381)
,p_query_column_id=>1
,p_column_alias=>'TXN_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Txn'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_hidden_column=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101382)
,p_query_column_id=>2
,p_column_alias=>'TXN_DATE'
,p_column_display_sequence=>20
,p_column_heading=>'Date'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_format=>'DD-MON'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101383)
,p_query_column_id=>3
,p_column_alias=>'TXN_TYPE_LABEL'
,p_column_display_sequence=>30
,p_column_heading=>'Type'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101384)
,p_query_column_id=>4
,p_column_alias=>'SKU'
,p_column_display_sequence=>40
,p_column_heading=>'SKU'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_css_class=>'inv-sku'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101385)
,p_query_column_id=>5
,p_column_alias=>'ITEM_NAME'
,p_column_display_sequence=>50
,p_column_heading=>'Item'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101386)
,p_query_column_id=>6
,p_column_alias=>'QUANTITY'
,p_column_display_sequence=>60
,p_column_heading=>'Qty'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000101387)
,p_query_column_id=>7
,p_column_alias=>'LOCATION'
,p_column_display_sequence=>70
,p_column_heading=>'Location'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page '
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000102990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000102001)
,p_plug_name=>'Search'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_region_css_classes=>'inv-toolbar'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000102101)
,p_name=>'P2_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13010000000102001)
,p_prompt=>'Search SKU or name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>40
,p_cMaxlength=>100
,p_item_icon_css_classes=>'fa-search'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'Y', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000102102)
,p_name=>'P2_CATEGORY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13010000000102001)
,p_prompt=>'Category'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_cSize=>30
,p_lov=>'select name d, category_id r from inv_categories order by name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All categories'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('page_action_on_selection', 'SUBMIT')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000102103)
,p_name=>'P2_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13010000000102001)
,p_prompt=>'Show'
,p_item_default=>'Y'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_cSize=>30
,p_lov=>'STATIC2:Active items;Y,Low stock;LOW,Inactive items;N'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All items'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('page_action_on_selection', 'SUBMIT')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(13010000000102002)
,p_name=>'Items'
,p_template=>4072358936313175081
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_region_css_classes=>'inv-rpt inv-items'
,p_icon_css_classes=>'fa-cube'
,p_display_point=>'BODY'
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
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>25
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No items match your search.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000102341)
,p_query_column_id=>1
,p_column_alias=>'ITEM_ID'
,p_column_display_sequence=>10
,p_column_heading=>'ID'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_hidden_column=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000102342)
,p_query_column_id=>2
,p_column_alias=>'SKU'
,p_column_display_sequence=>20
,p_column_heading=>'SKU'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_css_class=>'inv-sku'
,p_column_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:3:P3_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#SKU#'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000102343)
,p_query_column_id=>3
,p_column_alias=>'NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Name'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000102344)
,p_query_column_id=>4
,p_column_alias=>'CATEGORY'
,p_column_display_sequence=>40
,p_column_heading=>'Category'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000102345)
,p_query_column_id=>5
,p_column_alias=>'ON_HAND'
,p_column_display_sequence=>50
,p_column_heading=>'On hand'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000102346)
,p_query_column_id=>6
,p_column_alias=>'REORDER_LEVEL'
,p_column_display_sequence=>60
,p_column_heading=>'Reorder at'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000102347)
,p_query_column_id=>7
,p_column_alias=>'STATUS'
,p_column_display_sequence=>70
,p_column_heading=>'Status'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000102601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000102002)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Item'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3::'
,p_icon_css_classes=>'fa-plus'
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page inv-form'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000103990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000103001)
,p_plug_name=>'Item Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-cube'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103101)
,p_name=>'P3_ITEM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_display_as=>'NATIVE_HIDDEN'
,p_field_template=>2040785906935475274
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103102)
,p_name=>'P3_SKU'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'SKU'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_cMaxlength=>40
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103103)
,p_name=>'P3_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_cSize=>30
,p_cMaxlength=>150
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103104)
,p_name=>'P3_CATEGORY_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'Category'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'select name d, category_id r from inv_categories where active_yn = ''Y'' or category_id = :P3_CATEGORY_ID order by name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103105)
,p_name=>'P3_SUPPLIER_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'Supplier'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'select name d, supplier_id r from inv_suppliers where active_yn = ''Y'' or supplier_id = :P3_SUPPLIER_ID order by name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103106)
,p_name=>'P3_UOM'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'Unit of measure'
,p_item_default=>'EA'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'Y'
,p_colspan=>3
,p_cSize=>30
,p_cMaxlength=>20
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_inline_help_text=>'EA, M, PR, RL, KG ...'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103107)
,p_name=>'P3_UNIT_COST'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'Unit cost'
,p_item_default=>'0'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_cSize=>30
,p_format_mask=>'FM999G999G990D00'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('number_alignment', 'left', 'virtual_keyboard', 'decimal')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103108)
,p_name=>'P3_REORDER_LEVEL'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'Reorder level'
,p_item_default=>'0'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('number_alignment', 'left', 'virtual_keyboard', 'decimal')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103109)
,p_name=>'P3_REORDER_QTY'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'Reorder quantity'
,p_item_default=>'1'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_cSize=>30
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_inline_help_text=>'Ordered when stock is low (> 0)'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('number_alignment', 'left', 'virtual_keyboard', 'decimal')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103110)
,p_name=>'P3_DESCRIPTION'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'Description'
,p_display_as=>'NATIVE_TEXTAREA'
,p_begin_on_new_line=>'Y'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('auto_height', 'N', 'character_counter', 'N', 'resizable', 'Y', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103111)
,p_name=>'P3_ACTIVE_YN'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'Status'
,p_item_default=>'Y'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'STATIC2:Active;Y,Inactive;N'
,p_lov_display_null=>'NO'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000103112)
,p_name=>'P3_QTY_ON_HAND'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_prompt=>'On hand (all locations)'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000103601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'N'
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000103602)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'N'
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(''Delete this item?'',''DELETE'');'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_button_condition=>':P3_ITEM_ID is not null'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000103603)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(13010000000103001)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(13010000000103701)
,p_validation_name=>'Reorder quantity > 0'
,p_validation_sequence=>10
,p_validation=>'to_number(:P3_REORDER_QTY) > 0'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Reorder quantity must be greater than 0.'
,p_associated_item=>wwv_flow_imp.id(13010000000103109)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_when_button_pressed=>wwv_flow_imp.id(13010000000103603)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000103801)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load item'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sku, name, category_id, supplier_id, uom, unit_cost, reorder_level, reorder_qty,',
'       description, active_yn, qty_on_hand || '' '' || uom',
'  into :P3_SKU, :P3_NAME, :P3_CATEGORY_ID, :P3_SUPPLIER_ID, :P3_UOM, :P3_UNIT_COST,',
'       :P3_REORDER_LEVEL, :P3_REORDER_QTY, :P3_DESCRIPTION, :P3_ACTIVE_YN, :P3_QTY_ON_HAND',
'  from inv_items_v',
' where item_id = :P3_ITEM_ID;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'PLSQL_EXPRESSION'
,p_process_when=>':P3_ITEM_ID is not null'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000103802)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save item'
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
,p_process_when_button_id=>wwv_flow_imp.id(13010000000103603)
,p_process_success_message=>'Item saved.'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000103803)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete item'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  inv_api.delete_item(p_item_id => :P3_ITEM_ID);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(13010000000103602)
,p_process_success_message=>'Item deleted (or made inactive if it has stock history).'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(13010000000103999)
,p_branch_name=>'Go To Page 2'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page '
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000104990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000104001)
,p_plug_name=>'Filter'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_region_css_classes=>'inv-toolbar'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000104101)
,p_name=>'P4_LOCATION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13010000000104001)
,p_prompt=>'Location'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'select code || '' - '' || name d, location_id r from inv_locations order by code'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All locations'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('page_action_on_selection', 'SUBMIT')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000104102)
,p_name=>'P4_SEARCH'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13010000000104001)
,p_prompt=>'Search SKU or name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_cSize=>30
,p_cMaxlength=>100
,p_item_icon_css_classes=>'fa-search'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'Y', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(13010000000104002)
,p_name=>'Stock on Hand'
,p_template=>4072358936313175081
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_region_css_classes=>'inv-rpt inv-stock'
,p_icon_css_classes=>'fa-cubes'
,p_display_point=>'BODY'
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
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No stock at this location.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000104341)
,p_query_column_id=>1
,p_column_alias=>'ITEM_ID'
,p_column_display_sequence=>10
,p_column_heading=>'ID'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_hidden_column=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000104342)
,p_query_column_id=>2
,p_column_alias=>'SKU'
,p_column_display_sequence=>20
,p_column_heading=>'SKU'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_css_class=>'inv-sku'
,p_column_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:3:P3_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#SKU#'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000104343)
,p_query_column_id=>3
,p_column_alias=>'ITEM_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Item'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000104344)
,p_query_column_id=>4
,p_column_alias=>'LOCATION_CODE'
,p_column_display_sequence=>40
,p_column_heading=>'Location'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000104345)
,p_query_column_id=>5
,p_column_alias=>'QTY'
,p_column_display_sequence=>50
,p_column_heading=>'On hand'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000104346)
,p_query_column_id=>6
,p_column_alias=>'VALUE'
,p_column_display_sequence=>60
,p_column_heading=>'Value'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page '
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000105990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000105001)
,p_plug_name=>'Filter'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_region_css_classes=>'inv-toolbar'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000105101)
,p_name=>'P5_TXN_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13010000000105001)
,p_prompt=>'Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'Y'
,p_colspan=>4
,p_cSize=>30
,p_lov=>'STATIC2:Receipt;RECEIPT,Issue;ISSUE,Transfer;TRANSFER,Adjust;ADJUST'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All types'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('page_action_on_selection', 'SUBMIT')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000105102)
,p_name=>'P5_SEARCH'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13010000000105001)
,p_prompt=>'Search SKU, item or reference'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>8
,p_cSize=>30
,p_cMaxlength=>100
,p_item_icon_css_classes=>'fa-search'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'Y', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(13010000000105002)
,p_name=>'Stock Movements'
,p_template=>4072358936313175081
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_region_css_classes=>'inv-rpt inv-moves'
,p_icon_css_classes=>'fa-exchange'
,p_display_point=>'BODY'
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
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No stock movements match.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000105341)
,p_query_column_id=>1
,p_column_alias=>'TXN_ID'
,p_column_display_sequence=>10
,p_column_heading=>'No.'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_hidden_column=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000105342)
,p_query_column_id=>2
,p_column_alias=>'TXN_DATE'
,p_column_display_sequence=>20
,p_column_heading=>'Date'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_format=>'DD-MON-YY'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000105343)
,p_query_column_id=>3
,p_column_alias=>'TXN_TYPE_LABEL'
,p_column_display_sequence=>30
,p_column_heading=>'Type'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000105344)
,p_query_column_id=>4
,p_column_alias=>'SKU'
,p_column_display_sequence=>40
,p_column_heading=>'SKU'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_css_class=>'inv-sku'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000105345)
,p_query_column_id=>5
,p_column_alias=>'ITEM_NAME'
,p_column_display_sequence=>50
,p_column_heading=>'Item'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000105346)
,p_query_column_id=>6
,p_column_alias=>'QUANTITY'
,p_column_display_sequence=>60
,p_column_heading=>'Qty'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000105347)
,p_query_column_id=>7
,p_column_alias=>'LOCATION'
,p_column_display_sequence=>70
,p_column_heading=>'Location'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000105348)
,p_query_column_id=>8
,p_column_alias=>'REFERENCE'
,p_column_display_sequence=>80
,p_column_heading=>'Reference'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000105349)
,p_query_column_id=>9
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>90
,p_column_heading=>'By'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000105601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000105002)
,p_button_name=>'NEW'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Movement'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6::'
,p_icon_css_classes=>'fa-plus'
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page inv-form'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000106990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000106001)
,p_plug_name=>'Stock Movement'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-exchange'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000106101)
,p_name=>'P6_TXN_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13010000000106001)
,p_prompt=>'Movement type'
,p_item_default=>'RECEIPT'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'STATIC2:Receipt (stock in);RECEIPT,Issue (stock out);ISSUE,Transfer between locations;TRANSFER,Adjustment (count correction);ADJUST'
,p_lov_display_null=>'NO'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000106102)
,p_name=>'P6_ITEM_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13010000000106001)
,p_prompt=>'Item'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'select sku || '' - '' || name || '' ('' || qty_on_hand || '' '' || uom || '')'' d, item_id r from inv_items_v where active_yn = ''Y'' order by sku'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000106103)
,p_name=>'P6_FROM_LOCATION_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13010000000106001)
,p_prompt=>'From location'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'select code || '' - '' || name d, location_id r from inv_locations where active_yn = ''Y'' order by code'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_inline_help_text=>'Issue and Transfer'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000106104)
,p_name=>'P6_TO_LOCATION_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(13010000000106001)
,p_prompt=>'To location'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'select code || '' - '' || name d, location_id r from inv_locations where active_yn = ''Y'' order by code'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_inline_help_text=>'Receipt, Transfer and Adjustment'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000106105)
,p_name=>'P6_QUANTITY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(13010000000106001)
,p_prompt=>'Quantity'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_inline_help_text=>'Adjustments may be negative (shrinkage).'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('number_alignment', 'left', 'virtual_keyboard', 'decimal')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000106106)
,p_name=>'P6_REFERENCE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(13010000000106001)
,p_prompt=>'Reference'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_inline_help_text=>'PO, job or count number'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000106107)
,p_name=>'P6_NOTES'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(13010000000106001)
,p_prompt=>'Notes'
,p_display_as=>'NATIVE_TEXTAREA'
,p_begin_on_new_line=>'Y'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('auto_height', 'N', 'character_counter', 'N', 'resizable', 'Y', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000106601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000106001)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'N'
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000106602)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(13010000000106001)
,p_button_name=>'POST'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Post Movement'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000106801)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Post movement'
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
,p_process_when_button_id=>wwv_flow_imp.id(13010000000106602)
,p_process_success_message=>'Stock movement posted.'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(13010000000106999)
,p_branch_name=>'Go To Page 5'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page '
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000107990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(13010000000107001)
,p_name=>'Locations'
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_region_css_classes=>'inv-rpt inv-locations'
,p_icon_css_classes=>'fa-map-marker'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select l.location_id, l.code, l.name,',
'       (select count(*) from inv_stock s where s.location_id = l.location_id and s.qty_on_hand > 0) items,',
'       case when l.active_yn = ''Y'' then ''<span class="inv-pill inv-pill--ok">Active</span>'' else ''<span class="inv-pill">Inactive</span>'' end status',
'  from inv_locations l order by l.code'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No locations yet.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000107321)
,p_query_column_id=>1
,p_column_alias=>'LOCATION_ID'
,p_column_display_sequence=>10
,p_column_heading=>'ID'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_hidden_column=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000107322)
,p_query_column_id=>2
,p_column_alias=>'CODE'
,p_column_display_sequence=>20
,p_column_heading=>'Code'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:8:P8_LOCATION_ID:#LOCATION_ID#'
,p_column_linktext=>'#CODE#'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000107323)
,p_query_column_id=>3
,p_column_alias=>'NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Name'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000107324)
,p_query_column_id=>4
,p_column_alias=>'ITEMS'
,p_column_display_sequence=>40
,p_column_heading=>'Items stocked'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000107325)
,p_query_column_id=>5
,p_column_alias=>'STATUS'
,p_column_display_sequence=>50
,p_column_heading=>'Status'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000107601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000107001)
,p_button_name=>'CREATE'
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page inv-form'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000108990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000108001)
,p_plug_name=>'Location Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-map-marker'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000108101)
,p_name=>'P8_LOCATION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13010000000108001)
,p_display_as=>'NATIVE_HIDDEN'
,p_field_template=>2040785906935475274
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000108102)
,p_name=>'P8_CODE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13010000000108001)
,p_prompt=>'Code'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'Y'
,p_colspan=>4
,p_cSize=>30
,p_cMaxlength=>20
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000108103)
,p_name=>'P8_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13010000000108001)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>8
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000108104)
,p_name=>'P8_DESCRIPTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(13010000000108001)
,p_prompt=>'Description'
,p_display_as=>'NATIVE_TEXTAREA'
,p_begin_on_new_line=>'Y'
,p_cSize=>60
,p_cMaxlength=>500
,p_cHeight=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('auto_height', 'N', 'character_counter', 'N', 'resizable', 'Y', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000108105)
,p_name=>'P8_ACTIVE_YN'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(13010000000108001)
,p_prompt=>'Status'
,p_item_default=>'Y'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'STATIC2:Active;Y,Inactive;N'
,p_lov_display_null=>'NO'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000108601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000108001)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'N'
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000108602)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(13010000000108001)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'N'
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(''Delete this location?'',''DELETE'');'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_button_condition=>':P8_LOCATION_ID is not null'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000108603)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(13010000000108001)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000108801)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load location'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select code, name, description, active_yn into :P8_CODE, :P8_NAME, :P8_DESCRIPTION, :P8_ACTIVE_YN',
'  from inv_locations where location_id = :P8_LOCATION_ID;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'PLSQL_EXPRESSION'
,p_process_when=>':P8_LOCATION_ID is not null'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000108802)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save location'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_id inv_locations.location_id%type := :P8_LOCATION_ID;',
'begin',
'  inv_api.save_location(p_location_id => l_id, p_code => :P8_CODE, p_name => :P8_NAME,',
'    p_description => :P8_DESCRIPTION, p_active_yn => :P8_ACTIVE_YN);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(13010000000108603)
,p_process_success_message=>'Location saved.'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000108803)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete location'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  inv_api.delete_location(p_location_id => :P8_LOCATION_ID);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(13010000000108602)
,p_process_success_message=>'Location deleted.'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(13010000000108999)
,p_branch_name=>'Go To Page 7'
,p_branch_action=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page '
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000109990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(13010000000109001)
,p_name=>'Categories'
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_region_css_classes=>'inv-rpt inv-categories'
,p_icon_css_classes=>'fa-tags'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select c.category_id, c.name, c.description,',
'       (select count(*) from inv_items i where i.category_id = c.category_id) items,',
'       case when c.active_yn = ''Y'' then ''<span class="inv-pill inv-pill--ok">Active</span>'' else ''<span class="inv-pill">Inactive</span>'' end status',
'  from inv_categories c order by c.name'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No categories yet.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000109321)
,p_query_column_id=>1
,p_column_alias=>'CATEGORY_ID'
,p_column_display_sequence=>10
,p_column_heading=>'ID'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_hidden_column=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000109322)
,p_query_column_id=>2
,p_column_alias=>'NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Name'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:10:P10_CATEGORY_ID:#CATEGORY_ID#'
,p_column_linktext=>'#NAME#'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000109323)
,p_query_column_id=>3
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>30
,p_column_heading=>'Description'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000109324)
,p_query_column_id=>4
,p_column_alias=>'ITEMS'
,p_column_display_sequence=>40
,p_column_heading=>'Items'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000109325)
,p_query_column_id=>5
,p_column_alias=>'STATUS'
,p_column_display_sequence=>50
,p_column_heading=>'Status'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000109601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000109001)
,p_button_name=>'CREATE'
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page inv-form'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000110990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000110001)
,p_plug_name=>'Category Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-tags'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000110101)
,p_name=>'P10_CATEGORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13010000000110001)
,p_display_as=>'NATIVE_HIDDEN'
,p_field_template=>2040785906935475274
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000110102)
,p_name=>'P10_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13010000000110001)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'Y'
,p_colspan=>8
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000110103)
,p_name=>'P10_ACTIVE_YN'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13010000000110001)
,p_prompt=>'Status'
,p_item_default=>'Y'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_cSize=>30
,p_lov=>'STATIC2:Active;Y,Inactive;N'
,p_lov_display_null=>'NO'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000110104)
,p_name=>'P10_DESCRIPTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(13010000000110001)
,p_prompt=>'Description'
,p_display_as=>'NATIVE_TEXTAREA'
,p_begin_on_new_line=>'Y'
,p_cSize=>60
,p_cMaxlength=>500
,p_cHeight=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('auto_height', 'N', 'character_counter', 'N', 'resizable', 'Y', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000110601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000110001)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'N'
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000110602)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(13010000000110001)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'N'
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(''Delete this category?'',''DELETE'');'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_button_condition=>':P10_CATEGORY_ID is not null'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000110603)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(13010000000110001)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000110801)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load category'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name, description, active_yn into :P10_NAME, :P10_DESCRIPTION, :P10_ACTIVE_YN',
'  from inv_categories where category_id = :P10_CATEGORY_ID;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'PLSQL_EXPRESSION'
,p_process_when=>':P10_CATEGORY_ID is not null'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000110802)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save category'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_id inv_categories.category_id%type := :P10_CATEGORY_ID;',
'begin',
'  inv_api.save_category(p_category_id => l_id, p_name => :P10_NAME,',
'    p_description => :P10_DESCRIPTION, p_active_yn => :P10_ACTIVE_YN);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(13010000000110603)
,p_process_success_message=>'Category saved.'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000110803)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete category'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  inv_api.delete_category(p_category_id => :P10_CATEGORY_ID);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(13010000000110602)
,p_process_success_message=>'Category deleted.'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(13010000000110999)
,p_branch_name=>'Go To Page 9'
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page '
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000111990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(13010000000111001)
,p_name=>'Suppliers'
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_region_css_classes=>'inv-rpt inv-suppliers'
,p_icon_css_classes=>'fa-truck'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select s.supplier_id, s.name, s.contact_name, s.email, s.phone,',
'       case when s.active_yn = ''Y'' then ''<span class="inv-pill inv-pill--ok">Active</span>'' else ''<span class="inv-pill">Inactive</span>'' end status',
'  from inv_suppliers s order by s.name'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No suppliers yet.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000111321)
,p_query_column_id=>1
,p_column_alias=>'SUPPLIER_ID'
,p_column_display_sequence=>10
,p_column_heading=>'ID'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_hidden_column=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000111322)
,p_query_column_id=>2
,p_column_alias=>'NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Name'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
,p_column_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:12:P12_SUPPLIER_ID:#SUPPLIER_ID#'
,p_column_linktext=>'#NAME#'
,p_column_link_checksum_type=>'3'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000111323)
,p_query_column_id=>3
,p_column_alias=>'CONTACT_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Contact'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000111324)
,p_query_column_id=>4
,p_column_alias=>'EMAIL'
,p_column_display_sequence=>40
,p_column_heading=>'Email'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000111325)
,p_query_column_id=>5
,p_column_alias=>'PHONE'
,p_column_display_sequence=>50
,p_column_heading=>'Phone'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'ESCAPE_SC'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(13010000000111326)
,p_query_column_id=>6
,p_column_alias=>'STATUS'
,p_column_display_sequence=>60
,p_column_heading=>'Status'
,p_column_alignment=>'LEFT'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000111601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000111001)
,p_button_name=>'CREATE'
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page inv-form'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000112990)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(13010000000000006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000000112001)
,p_plug_name=>'Supplier Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_region_css_classes=>'inv-form-region'
,p_icon_css_classes=>'fa-truck'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000112101)
,p_name=>'P12_SUPPLIER_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13010000000112001)
,p_display_as=>'NATIVE_HIDDEN'
,p_field_template=>2040785906935475274
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000112102)
,p_name=>'P12_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13010000000112001)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_cMaxlength=>150
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_required=>true
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000112103)
,p_name=>'P12_CONTACT_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13010000000112001)
,p_prompt=>'Contact name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_cSize=>30
,p_cMaxlength=>150
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000112104)
,p_name=>'P12_EMAIL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(13010000000112001)
,p_prompt=>'Email'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_cMaxlength=>255
,p_tag_attributes=>'type="email" autocomplete="email"'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000112105)
,p_name=>'P12_PHONE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(13010000000112001)
,p_prompt=>'Phone'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_cSize=>30
,p_cMaxlength=>50
,p_tag_attributes=>'type="tel"'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000000112106)
,p_name=>'P12_ACTIVE_YN'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(13010000000112001)
,p_prompt=>'Status'
,p_item_default=>'Y'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_cSize=>30
,p_lov=>'STATIC2:Active;Y,Inactive;N'
,p_lov_display_null=>'NO'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000112601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000000112001)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'N'
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000112602)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(13010000000112001)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'N'
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(''Delete this supplier?'',''DELETE'');'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_button_condition=>':P12_SUPPLIER_ID is not null'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000000112603)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(13010000000112001)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000112801)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load supplier'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name, contact_name, email, phone, active_yn',
'  into :P12_NAME, :P12_CONTACT_NAME, :P12_EMAIL, :P12_PHONE, :P12_ACTIVE_YN',
'  from inv_suppliers where supplier_id = :P12_SUPPLIER_ID;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'PLSQL_EXPRESSION'
,p_process_when=>':P12_SUPPLIER_ID is not null'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000112802)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save supplier'
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
,p_process_when_button_id=>wwv_flow_imp.id(13010000000112603)
,p_process_success_message=>'Supplier saved.'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000000112803)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete supplier'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  inv_api.delete_supplier(p_supplier_id => :P12_SUPPLIER_ID);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(13010000000112602)
,p_process_success_message=>'Supplier deleted.'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(13010000000112999)
,p_branch_name=>'Go To Page 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
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
,p_name=>'Sign In'
,p_alias=>'LOGIN'
,p_step_title=>'Sign In'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2101157952850466385
,p_page_template_options=>'#DEFAULT#'
,p_page_css_classes=>'inv-page inv-login'
,p_css_file_urls=>'#APP_FILES#css/inv-app.css'
,p_page_is_public_y_n=>'Y'
,p_protection_level=>'N'
,p_warn_on_unsaved_changes=>'N'
,p_page_component_map=>'12'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13010000010099001)
,p_plug_name=>'Inventory Control'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2674157997338192145
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_icon_css_classes=>'fa-cubes'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p class="inv-login-tagline">Sign in to manage stock</p>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000010099101)
,p_name=>'P9999_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13010000010099001)
,p_prompt=>'Username'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_begin_on_new_line=>'Y'
,p_cSize=>40
,p_cMaxlength=>100
,p_item_icon_css_classes=>'fa-user'
,p_tag_attributes=>'autocomplete="username" autocapitalize="none"'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('disabled', 'N', 'submit_when_enter_pressed', 'N', 'trim_spaces', 'BOTH')).to_clob
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000010099102)
,p_name=>'P9999_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13010000010099001)
,p_prompt=>'Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_begin_on_new_line=>'Y'
,p_cSize=>40
,p_cMaxlength=>100
,p_item_icon_css_classes=>'fa-key'
,p_tag_attributes=>'autocomplete="current-password"'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13010000010099103)
,p_name=>'P9999_REMEMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13010000010099001)
,p_prompt=>'Remember username'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_begin_on_new_line=>'Y'
,p_cSize=>30
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_encrypt_session_state_yn=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13010000010099601)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(13010000010099001)
,p_button_name=>'LOGIN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--stretch'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Sign In'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000010099801)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get username cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P9999_USERNAME := apex_authentication.get_login_username_cookie;',
':P9999_REMEMBER := case when :P9999_USERNAME is not null then ''Y'' end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000010099802)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set username cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_authentication.send_login_username_cookie(',
'  p_username => lower(:P9999_USERNAME),',
'  p_consent  => :P9999_REMEMBER = ''Y'');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(13010000010099601)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000010099803)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Login'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_authentication.login(',
'  p_username => :P9999_USERNAME,',
'  p_password => :P9999_PASSWORD);'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(13010000010099601)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13010000010099804)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Clear page cache'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_util.clear_page_cache(:APP_PAGE_ID);'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(13010000010099601)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
