#!/usr/bin/env python3
"""Generate the APEX 26.1 bootstrap export for Inventory Control (application 1301).

The generated file (apex/bootstrap/f1301_bootstrap.sql) is only used to create the app the
first time. The committed source of truth is the APEX_EXPORT output in apex/f1301.sql.
All business logic lives in the INV_API package; page processes only call it.
"""
from __future__ import annotations

import os
from pathlib import Path

APP_ID = 1301
ALIAS = "INVENTORY-CONTROL"
APP_NAME = "Inventory Control"
SCHEMA = "INVENTORY_CONTROL"
WORKSPACE_ID = int(os.environ.get("APEX_WORKSPACE_ID", "0"))  # target workspace id; apex_application_install.set_workspace overrides it
ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "apex" / "bootstrap" / "f1301_bootstrap.sql"
CSS_FILE = ROOT / "apex" / "static" / "inv-app.css"

# Universal Theme 42 (26.1) template IDs
T_PAGE_STD = 4072355960268175073
T_PAGE_LOGIN = 2101157952850466385
T_PAGE_DIALOG = 2100407606326202693
T_REGION_STD = 4072358936313175081
T_REGION_LOGIN = 2674157997338192145
T_REGION_TITLE_BAR = 2531463326621247859
T_REGION_BUTTONS = 2126429139436695430
T_REGION_BLANK = 4501440665235496320
T_BUTTON = 4072362960822175091
T_BUTTON_ICON_TEXT = 2082829544945815391
T_LABEL_OPT_FLOAT = 1609121967514267634
T_LABEL_REQ_FLOAT = 1609122147107268652
T_LABEL_OPTIONAL = 2318601014859922299
T_LABEL_HIDDEN = 2040785906935475274
T_REPORT_STD = 2538654340625403440
T_REPORT_BADGE = 2104643962563030528
T_NAV_LIST = 2467739217141810545
T_NAV_BAR = 2847543055748234966
T_BREADCRUMB = 4072363345357175094
T_LIST_LINKS = 4072361143931175087

BASE = 13010000000000000
AUTHN, NAV_MENU, NAV_BAR, UI, THEME, BREADCRUMB, STYLE, CSS_ID = (BASE + n for n in range(1, 9))
SALT = "9E3C1B7A5D2F4E6081A7C3B5D9E2F4A6C8B0D1E3F5A7C9B2D4E6F8A0C2B4D6E8"


def q(text: str) -> str:
    return text.replace("'", "''")


def join(lines: list[str]) -> str:
    return "wwv_flow_string.join(wwv_flow_t_varchar2(\n" + ",\n".join(f"'{q(l)}'" for l in lines) + "))"


def cid(page: int, seq: int) -> int:
    return BASE + 100000 + page * 1000 + seq


def html_attrs() -> str:
    return ("wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(\n  'expand_shortcuts', 'N',\n"
            "  'output_as', 'HTML',\n  'show_line_breaks', 'N')).to_clob")


def hidden_attrs() -> str:
    return "wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(\n  'value_protected', 'Y')).to_clob"


# ----------------------------------------------------------------------------- application
def emit_begin() -> list[str]:
    return [
        "prompt --application/set_environment",
        "set define off verify off feedback off",
        "whenever sqlerror exit sql.sqlcode rollback",
        "-- Inventory Control (apex-inventory-control) - APEX 26.1 bootstrap export, application 1301",
        "begin",
        "wwv_flow_imp.import_begin (",
        " p_version_yyyy_mm_dd=>'2024.11.30'",
        ",p_release=>'24.2.2'",
        f",p_default_workspace_id=>{WORKSPACE_ID}",
        f",p_default_application_id=>{APP_ID}",
        ",p_default_id_offset=>0",
        f",p_default_owner=>'{SCHEMA}'",
        ");",
        "end;",
        "/",
        f"prompt APPLICATION {APP_ID} - {APP_NAME}",
        "prompt --application/delete_application",
        "begin",
        "wwv_flow_imp.remove_flow(wwv_flow.g_flow_id);",
        "end;",
        "/",
        "prompt --application/create_application",
        "begin",
        "wwv_imp_workspace.create_flow(",
        " p_id=>wwv_flow.g_flow_id",
        f",p_owner=>nvl(wwv_flow_application_install.get_schema,'{SCHEMA}')",
        f",p_name=>nvl(wwv_flow_application_install.get_application_name,'{APP_NAME}')",
        f",p_alias=>nvl(wwv_flow_application_install.get_application_alias,'{ALIAS}')",
        ",p_page_view_logging=>'YES'",
        ",p_page_protection_enabled_y_n=>'Y'",
        f",p_checksum_salt=>'{SALT}'",
        ",p_bookmark_checksum_function=>'SH512'",
        ",p_compatibility_mode=>'26.1'",
        ",p_flow_language=>'en'",
        ",p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'",
        ",p_date_format=>'DD-MON-YYYY'",
        ",p_timestamp_format=>'DD-MON-YYYY HH24:MI'",
        ",p_timestamp_tz_format=>'DS'",
        ",p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')",
        f",p_authentication_id=>wwv_flow_imp.id({AUTHN})",
        ",p_application_tab_set=>1",
        ",p_logo_type=>'IT'",
        ",p_logo=>'fa-cubes'",
        f",p_logo_text=>'{APP_NAME}'",
        ",p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')",
        ",p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')",
        ",p_flow_version=>'1.0.0'",
        ",p_flow_status=>'AVAILABLE_W_EDIT_LINK'",
        ",p_exact_substitutions_only=>'Y'",
        ",p_browser_cache=>'N'",
        ",p_browser_frame=>'D'",
        ",p_deep_linking=>'Y'",
        ",p_rejoin_existing_sessions=>'N'",
        ",p_csv_encoding=>'Y'",
        ",p_auto_time_zone=>'N'",
        ",p_error_handling_function=>'inv_ui_error'",
        ",p_substitution_string_01=>'APP_NAME'",
        f",p_substitution_value_01=>'{APP_NAME}'",
        ",p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')",
        ",p_files_version=>1",
        ",p_version_scn=>1",
        ",p_print_server_type=>'INSTANCE'",
        ",p_file_storage=>'DB'",
        ",p_is_pwa=>'N'",
        ");",
        "end;",
        "/",
    ]


def emit_ui() -> list[str]:
    return [
        "prompt --application/user_interfaces",
        "begin",
        "wwv_flow_imp_shared.create_user_interface(",
        f" p_id=>wwv_flow_imp.id({UI})",
        ",p_theme_id=>42",
        ",p_home_url=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'",
        ",p_login_url=>'f?p=&APP_ID.:LOGIN:&APP_SESSION.::&DEBUG.:::'",
        ",p_theme_style_by_user_pref=>false",
        ",p_built_with_love=>false",
        f",p_navigation_list_id=>wwv_flow_imp.id({NAV_MENU})",
        ",p_navigation_list_position=>'SIDE'",
        f",p_navigation_list_template_id=>{T_NAV_LIST}",
        ",p_nav_list_template_options=>'#DEFAULT#:js-defaultCollapsed:js-navCollapsed--hidden:t-TreeNav--styleA'",
        ",p_nav_bar_type=>'LIST'",
        f",p_nav_bar_list_id=>wwv_flow_imp.id({NAV_BAR})",
        f",p_nav_bar_list_template_id=>{T_NAV_BAR}",
        ",p_nav_bar_template_options=>'#DEFAULT#'",
        ");",
        "end;",
        "/",
    ]


NAV = [  # (seq, label, page, icon, parent_seq)
    (10, "Home", 1, "fa-home", None),
    (20, "Items", 2, "fa-cube", None),
    (30, "Stock on Hand", 4, "fa-cubes", None),
    (40, "Stock Movements", 5, "fa-exchange", None),
    (50, "Setup", None, "fa-cog", None),
    (51, "Locations", 7, "fa-map-marker", 50),
    (52, "Categories", 9, "fa-tags", 50),
    (53, "Suppliers", 11, "fa-truck", 50),
]
# pages highlighted by each menu entry (detail pages light up their list)
NAV_CURRENT = {2: "2,3", 5: "5,6", 7: "7,8", 9: "9,10", 11: "11,12"}


def emit_nav() -> list[str]:
    out = [
        "prompt --application/shared_components/navigation/lists/navigation_menu",
        "begin",
        "wwv_flow_imp_shared.create_list(",
        f" p_id=>wwv_flow_imp.id({NAV_MENU})",
        ",p_name=>'Navigation Menu'",
        ",p_list_status=>'PUBLIC'",
        ");",
    ]
    for seq, label, page, icon, parent in NAV:
        target = f"f?p=&APP_ID.:{page}:&APP_SESSION.::&DEBUG.:::" if page else "#"
        out += [
            "wwv_flow_imp_shared.create_list_item(",
            f" p_id=>wwv_flow_imp.id({BASE + 1000 + seq})",
            f",p_list_item_display_sequence=>{seq}",
            f",p_list_item_link_text=>'{label}'",
            f",p_list_item_link_target=>'{target}'",
            f",p_list_item_icon=>'{icon}'",
        ]
        if parent:
            out.append(f",p_parent_list_item_id=>wwv_flow_imp.id({BASE + 1000 + parent})")
        if page in NAV_CURRENT:
            out += [",p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'",
                    f",p_list_item_current_for_pages=>'{NAV_CURRENT[page].replace(',', ':')}'"]
        elif page:
            out.append(",p_list_item_current_type=>'TARGET_PAGE'")
        out.append(");")
    out += [
        "end;", "/",
        "prompt --application/shared_components/navigation/lists/navigation_bar",
        "begin",
        "wwv_flow_imp_shared.create_list(",
        f" p_id=>wwv_flow_imp.id({NAV_BAR})",
        ",p_name=>'Navigation Bar'",
        ",p_list_status=>'PUBLIC'",
        ");",
        "wwv_flow_imp_shared.create_list_item(",
        f" p_id=>wwv_flow_imp.id({BASE + 2001})",
        ",p_list_item_display_sequence=>10",
        ",p_list_item_link_text=>'&APP_USER.'",
        ",p_list_item_link_target=>'#'",
        ",p_list_item_icon=>'fa-user'",
        ",p_list_text_02=>'has-username'",
        ",p_list_item_current_type=>'TARGET_PAGE'",
        ");",
        "wwv_flow_imp_shared.create_list_item(",
        f" p_id=>wwv_flow_imp.id({BASE + 2002})",
        ",p_list_item_display_sequence=>20",
        ",p_list_item_link_text=>'Sign Out'",
        ",p_list_item_link_target=>'&LOGOUT_URL.'",
        ",p_list_item_icon=>'fa-sign-out'",
        ",p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'",
        f",p_parent_list_item_id=>wwv_flow_imp.id({BASE + 2001})",
        ",p_list_item_current_type=>'TARGET_PAGE'",
        ");",
        "end;", "/",
    ]
    # breadcrumb: one entry per page
    crumbs = [  # page, label, parent page
        (1, "Home", None), (2, "Items", 1), (3, "Item", 2), (4, "Stock on Hand", 1),
        (5, "Stock Movements", 1), (6, "New Movement", 5), (7, "Locations", 1), (8, "Location", 7),
        (9, "Categories", 1), (10, "Category", 9), (11, "Suppliers", 1), (12, "Supplier", 11),
    ]
    out += [
        "prompt --application/shared_components/navigation/breadcrumbs/breadcrumb",
        "begin",
        "wwv_flow_imp_shared.create_menu(",
        f" p_id=>wwv_flow_imp.id({BREADCRUMB})",
        ",p_name=>'Breadcrumb'",
        ");",
    ]
    for page, label, parent in crumbs:
        out += [
            "wwv_flow_imp_shared.create_menu_option(",
            f" p_id=>wwv_flow_imp.id({BASE + 3000 + page})",
        ]
        if parent:
            out.append(f",p_parent_id=>wwv_flow_imp.id({BASE + 3000 + parent})")
        out += [
            f",p_short_name=>'{label}'",
            f",p_link=>'f?p=&APP_ID.:{page}:&APP_SESSION.::&DEBUG.:::'",
            f",p_page_id=>{page}",
            ");",
        ]
    out += ["end;", "/"]
    return out


def emit_theme_auth_files() -> list[str]:
    css = CSS_FILE.read_bytes()
    hx = css.hex()
    chunks = [hx[i:i + 200] for i in range(0, len(hx), 200)]
    out = [
        "prompt --application/shared_components/user_interface/themes",
        "begin",
        "wwv_flow_imp_shared.create_theme(",
        f" p_id=>wwv_flow_imp.id({THEME})",
        ",p_theme_id=>42",
        ",p_theme_name=>'Universal Theme'",
        ",p_theme_internal_name=>'UNIVERSAL_THEME'",
        ",p_version_identifier=>'26.1'",
        ",p_navigation_type=>'L'",
        ",p_nav_bar_type=>'LIST'",
        ",p_reference_id=>4072363937200175119",
        ",p_is_locked=>false",
        f",p_current_theme_style_id=>wwv_flow_imp.id({STYLE})",
        f",p_default_page_template=>{T_PAGE_STD}",
        f",p_default_dialog_template=>{T_PAGE_DIALOG}",
        f",p_error_template=>{T_PAGE_LOGIN}",
        f",p_login_template=>{T_PAGE_LOGIN}",
        f",p_default_button_template=>{T_BUTTON}",
        f",p_default_region_template=>{T_REGION_STD}",
        f",p_default_report_template=>{T_REPORT_STD}",
        f",p_default_label_template=>{T_LABEL_OPT_FLOAT}",
        f",p_default_menu_template=>{T_BREADCRUMB}",
        f",p_default_list_template=>{T_LIST_LINKS}",
        f",p_default_nav_list_template=>{T_NAV_LIST}",
        f",p_default_side_nav_list_temp=>{T_NAV_LIST}",
        f",p_default_navbar_list_template=>{T_NAV_BAR}",
        ",p_icon_library=>'FONTAPEX'",
        ",p_file_prefix=>'#APEX_FILES#themes/theme_42/26.1/'",
        ",p_files_version=>1",
        ",p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(",
        "'#APEX_FILES#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',",
        "'#THEME_FILES#js/theme42#MIN#.js?v=#APEX_VERSION#'))",
        ",p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(",
        "'#THEME_FILES#css/Core#MIN#.css?v=#APEX_VERSION#'))",
        ");",
        "wwv_flow_imp_shared.create_theme_style(",
        f" p_id=>wwv_flow_imp.id({STYLE})",
        ",p_theme_id=>42",
        ",p_name=>'Vita'",
        ",p_css_file_urls=>'#THEME_FILES#css/Vita#MIN#.css?v=#APEX_VERSION#'",
        ",p_is_current=>true",
        ",p_is_public=>true",
        ",p_is_accessible=>false",
        ",p_theme_roller_read_only=>true",
        ");",
        "end;",
        "/",
        "prompt --application/shared_components/security/authentications/oracle_apex_accounts",
        "begin",
        "wwv_flow_imp_shared.create_authentication(",
        f" p_id=>wwv_flow_imp.id({AUTHN})",
        ",p_name=>'Oracle APEX Accounts'",
        ",p_scheme_type=>'NATIVE_APEX_ACCOUNTS'",
        ",p_invalid_session_type=>'LOGIN'",
        ",p_use_secure_cookie_yn=>'Y'",
        ",p_ras_mode=>0",
        ");",
        "end;",
        "/",
        "prompt --application/shared_components/files/css_inv_app_css",
        "begin",
        "wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;",
    ]
    out += [f"wwv_flow_imp.g_varchar2_table({i}) := '{c}';" for i, c in enumerate(chunks, start=1)]
    out += [
        "wwv_flow_imp_shared.create_app_static_file(",
        f" p_id=>wwv_flow_imp.id({CSS_ID})",
        ",p_file_name=>'css/inv-app.css'",
        ",p_mime_type=>'text/css'",
        ",p_file_charset=>'utf-8'",
        ",p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)",
        ");",
        "end;",
        "/",
    ]
    return out


# ----------------------------------------------------------------------------- page DSL
class Page:
    def __init__(self, pid: int, name: str, alias: str, *, login: bool = False, crumb: bool = True,
                 css_class: str = ""):
        self.pid, self.lines, self.submit, self.branch = pid, [], False, None
        self.lines += [
            f"prompt --application/pages/page_{pid:05d}",
            "begin",
            "wwv_flow_imp_page.create_page(",
            f" p_id=>{pid}",
            f",p_name=>'{q(name)}'",
            f",p_alias=>'{alias}'",
            f",p_step_title=>'{q(name)}'",
            ",p_autocomplete_on_off=>'OFF'",
            f",p_step_template=>{T_PAGE_LOGIN if login else T_PAGE_STD}",
            ",p_page_template_options=>'#DEFAULT#'",
            f",p_page_css_classes=>'inv-page {css_class}'",
            ",p_css_file_urls=>'#APP_FILES#css/inv-app.css'",
        ]
        if login:
            self.lines += [",p_page_is_public_y_n=>'Y'", ",p_protection_level=>'N'",
                           ",p_warn_on_unsaved_changes=>'N'", ",p_page_component_map=>'12'"]
        else:
            self.lines += [",p_protection_level=>'C'", ",p_page_component_map=>'11'"]
        self.lines.append(");")
        if crumb and not login:
            self.lines += [
                "wwv_flow_imp_page.create_page_plug(",
                f" p_id=>wwv_flow_imp.id({cid(pid, 990)})",
                ",p_plug_name=>'Breadcrumb'",
                ",p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'",
                ",p_component_template_options=>'#DEFAULT#'",
                f",p_plug_template=>{T_REGION_TITLE_BAR}",
                ",p_plug_display_sequence=>10",
                ",p_plug_display_point=>'REGION_POSITION_01'",
                f",p_menu_id=>wwv_flow_imp.id({BREADCRUMB})",
                ",p_plug_source_type=>'NATIVE_BREADCRUMB'",
                f",p_menu_template_id=>{T_BREADCRUMB}",
                ");",
            ]

    # regions ------------------------------------------------------------------
    def html(self, seq: int, name: str, html: list[str], *, template: int = T_REGION_STD,
             options: str = "#DEFAULT#", css: str = "", point: str = "BODY", icon: str = "",
             static_id: str = "") -> int:
        rid = cid(self.pid, seq)
        self.lines += [
            "wwv_flow_imp_page.create_page_plug(",
            f" p_id=>wwv_flow_imp.id({rid})",
            f",p_plug_name=>'{q(name)}'",
            f",p_region_template_options=>'{options}'",
            f",p_plug_template=>{template}",
            f",p_plug_display_sequence=>{seq * 10}",
            f",p_plug_display_point=>'{point}'",
        ]
        if static_id:
            self.lines.append(f",p_static_id=>'{static_id}'")
        if css:
            self.lines.append(f",p_region_css_classes=>'{css}'")
        if icon:
            self.lines.append(f",p_icon_css_classes=>'{icon}'")
        if html:
            self.lines.append(f",p_plug_source=>{join(html)}")
        self.lines += [f",p_attributes=>{html_attrs()}", ");"]
        return rid

    def report(self, seq: int, name: str, sql: list[str], cols: list[tuple], *,
               template: int = T_REPORT_STD, static_id: str = "", no_data: str = "No rows found.",
               rows: int = 25, options: str = "#DEFAULT#", comp_options: str = "#DEFAULT#:t-Report--stretch:t-Report--rowHighlight:t-Report--horizontalBorders",
               css: str = "", icon: str = "") -> int:
        """cols: (alias, heading, extra-dict) - extra keys: link=(page, items, values), hidden, align, fmt, html"""
        rid = cid(self.pid, seq)
        self.lines += [
            "wwv_flow_imp_page.create_report_region(",
            f" p_id=>wwv_flow_imp.id({rid})",
            f",p_name=>'{q(name)}'",
        ]
        if static_id:  # report regions: expose the key as a CSS class (used by inv-app.css)
            css = (css + " " + static_id.replace("_", "-")).strip()
        self.lines += [
            f",p_template=>{T_REGION_STD}",
            f",p_display_sequence=>{seq * 10}",
            f",p_region_template_options=>'{options}'",
            f",p_component_template_options=>'{comp_options}'",
        ]
        if css:
            self.lines.append(f",p_region_css_classes=>'{css}'")
        if icon:
            self.lines.append(f",p_icon_css_classes=>'{icon}'")
        self.lines += [
            ",p_display_point=>'BODY'",
            ",p_source_type=>'NATIVE_SQL_REPORT'",
            ",p_query_type=>'SQL'",
            f",p_source=>{join(sql)}",
            ",p_ajax_enabled=>'Y'",
            f",p_query_row_template=>{template}",
            f",p_query_num_rows=>{rows}",
            ",p_query_options=>'DERIVED_REPORT_COLUMNS'",
            ",p_query_show_nulls_as=>'-'",
            f",p_query_no_data_found=>'{q(no_data)}'",
            ",p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'",
            ",p_pagination_display_position=>'BOTTOM_RIGHT'",
            ",p_csv_output=>'N'",
            ",p_plug_query_strip_html=>'N'",
            ");",
        ]
        for i, (alias, heading, extra) in enumerate(cols, start=1):
            self.lines += [
                "wwv_flow_imp_page.create_report_columns(",
                f" p_id=>wwv_flow_imp.id({cid(self.pid, 300 + seq * 20 + i)})",
                f",p_query_column_id=>{i}",
                f",p_column_alias=>'{alias}'",
                f",p_column_display_sequence=>{i * 10}",
                f",p_column_heading=>'{q(heading)}'",
                f",p_column_alignment=>'{extra.get('align', 'LEFT')}'",
                f",p_heading_alignment=>'{extra.get('align', 'LEFT')}'",
                ",p_disable_sort_column=>'Y'",
                f",p_display_as=>'{'WITHOUT_MODIFICATION' if extra.get('html') else 'ESCAPE_SC'}'",
            ]
            if extra.get("fmt"):
                self.lines.append(f",p_column_format=>'{extra['fmt']}'")
            if alias == "SKU":  # SKUs never wrap mid-word (see .inv-sku in inv-app.css)
                self.lines.append(",p_column_css_class=>'inv-sku'")
            if extra.get("hidden"):
                self.lines.append(",p_hidden_column=>'Y'")
            if extra.get("link"):
                page, items, values = extra["link"]
                self.lines += [
                    f",p_column_link=>'f?p=&APP_ID.:{page}:&APP_SESSION.::&DEBUG.:{page}:{items}:{values}'",
                    f",p_column_linktext=>'#{alias}#'",
                    ",p_column_link_checksum_type=>'3'",
                ]
            self.lines.append(");")
        return rid

    # items ------------------------------------------------------------------------
    def item(self, seq: int, name: str, region: int, prompt: str | None, kind: str = "NATIVE_TEXT_FIELD", *,
             required: bool = False, lov: str | None = None, null_text: str | None = "- Select -",
             new_line: bool = True, size: int = 30, maxlength: int | None = None, height: int | None = None,
             default: str | None = None, help_text: str | None = None, submit_on_change: bool = False,
             submit_on_enter: bool = False, icon: str | None = None, tag: str | None = None,
             label_template: int | None = None, colspan: int | None = None, fmt: str | None = None) -> None:
        hidden = kind == "NATIVE_HIDDEN"
        self.lines += [
            "wwv_flow_imp_page.create_page_item(",
            f" p_id=>wwv_flow_imp.id({cid(self.pid, 100 + seq)})",
            f",p_name=>'{name}'",
            f",p_item_sequence=>{seq * 10}",
            f",p_item_plug_id=>wwv_flow_imp.id({region})",
        ]
        if prompt:
            self.lines.append(f",p_prompt=>'{q(prompt)}'")
        if default is not None:
            self.lines.append(f",p_item_default=>'{q(default)}'")
        self.lines.append(f",p_display_as=>'{kind}'")
        if hidden:
            self.lines += [f",p_field_template=>{T_LABEL_HIDDEN}", ",p_protection_level=>'S'",
                           f",p_attributes=>{hidden_attrs()}"]
        else:
            self.lines.append(f",p_begin_on_new_line=>'{'Y' if new_line else 'N'}'")
            if colspan:
                self.lines.append(f",p_colspan=>{colspan}")
            self.lines.append(f",p_cSize=>{size}")
            if maxlength:
                self.lines.append(f",p_cMaxlength=>{maxlength}")
            if height:
                self.lines.append(f",p_cHeight=>{height}")
            if fmt:
                self.lines.append(f",p_format_mask=>'{fmt}'")
            if icon:
                self.lines.append(f",p_item_icon_css_classes=>'{icon}'")
            if tag:
                self.lines.append(f",p_tag_attributes=>'{q(tag)}'")
            if lov:
                self.lines.append(f",p_lov=>'{q(lov)}'")
                if null_text is None:
                    self.lines.append(",p_lov_display_null=>'NO'")
                else:
                    self.lines += [",p_lov_display_null=>'YES'", f",p_lov_null_text=>'{q(null_text)}'"]
            tmpl = label_template or (T_LABEL_REQ_FLOAT if required else T_LABEL_OPT_FLOAT)
            self.lines += [f",p_field_template=>{tmpl}",
                           ",p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'"]
            if required:
                self.lines.append(",p_is_required=>true")
            if help_text:
                self.lines.append(f",p_inline_help_text=>'{q(help_text)}'")
            attrs = None
            if kind == "NATIVE_SELECT_LIST" and submit_on_change:
                attrs = "'page_action_on_selection', 'SUBMIT'"
            if kind == "NATIVE_TEXT_FIELD":
                attrs = ("'disabled', 'N', 'submit_when_enter_pressed', "
                         f"'{'Y' if submit_on_enter else 'N'}', 'trim_spaces', 'BOTH'")
            if kind == "NATIVE_NUMBER_FIELD":
                attrs = "'number_alignment', 'left', 'virtual_keyboard', 'decimal'"
            if kind == "NATIVE_TEXTAREA":
                attrs = "'auto_height', 'N', 'character_counter', 'N', 'resizable', 'Y', 'trim_spaces', 'BOTH'"
            if attrs:
                self.lines.append(f",p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2({attrs})).to_clob")
        self.lines += [",p_encrypt_session_state_yn=>'N'", ");"]

    def button(self, seq: int, region: int, name: str, label: str, *, hot: bool = False,
               action: str = "SUBMIT", url: str | None = None, position: str = "NEXT",
               icon: str | None = None, condition: str | None = None, options: str = "#DEFAULT#",
               confirm: str | None = None) -> int:
        bid = cid(self.pid, 600 + seq)
        if confirm:
            action, url = "REDIRECT_URL", f"javascript:apex.confirm('{confirm}','{name}');"
        self.lines += [
            "wwv_flow_imp_page.create_page_button(",
            f" p_id=>wwv_flow_imp.id({bid})",
            f",p_button_sequence=>{seq * 10}",
            f",p_button_plug_id=>wwv_flow_imp.id({region})",
            f",p_button_name=>'{name}'",
            f",p_button_action=>'{action}'",
            f",p_button_template_options=>'{options + (':t-Button--iconLeft' if icon else '')}'",
            f",p_button_template_id=>{T_BUTTON_ICON_TEXT if icon else T_BUTTON}",
            f",p_button_is_hot=>'{'Y' if hot else 'N'}'",
            f",p_button_image_alt=>'{q(label)}'",
            f",p_button_position=>'{position}'",
        ]
        if url:
            self.lines.append(f",p_button_redirect_url=>'{q(url)}'")
        if icon:
            self.lines.append(f",p_icon_css_classes=>'{icon}'")
        if condition:
            self.lines += [",p_button_condition_type=>'PLSQL_EXPRESSION'", f",p_button_condition=>'{q(condition)}'"]
        self.lines.append(");")
        return bid

    def process(self, seq: int, name: str, plsql: list[str], *, point: str = "AFTER_SUBMIT",
                button: int | None = None, success: str | None = None,
                condition: str | None = None) -> None:
        if point == "AFTER_SUBMIT":
            self.submit = True
        self.lines += [
            "wwv_flow_imp_page.create_page_process(",
            f" p_id=>wwv_flow_imp.id({cid(self.pid, 800 + seq)})",
            f",p_process_sequence=>{seq * 10}",
            f",p_process_point=>'{point}'",
            ",p_process_type=>'NATIVE_PLSQL'",
            f",p_process_name=>'{q(name)}'",
            f",p_process_sql_clob=>{join(plsql)}",
            ",p_process_clob_language=>'PLSQL'",
            ",p_error_display_location=>'INLINE_IN_NOTIFICATION'",
        ]
        if button:
            self.lines.append(f",p_process_when_button_id=>wwv_flow_imp.id({button})")
        if condition:
            self.lines += [",p_process_when_type=>'PLSQL_EXPRESSION'", f",p_process_when=>'{q(condition)}'"]
        if success:
            self.lines.append(f",p_process_success_message=>'{q(success)}'")
        self.lines.append(");")

    def validation(self, seq: int, name: str, expr: str, msg: str, item: str, button: int | None = None):
        self.lines += [
            "wwv_flow_imp_page.create_page_validation(",
            f" p_id=>wwv_flow_imp.id({cid(self.pid, 700 + seq)})",
            f",p_validation_name=>'{q(name)}'",
            f",p_validation_sequence=>{seq * 10}",
            f",p_validation=>'{q(expr)}'",
            ",p_validation_type=>'PLSQL_EXPRESSION'",
            f",p_error_message=>'{q(msg)}'",
            f",p_associated_item=>wwv_flow_imp.id({self.item_id(item)})",
            ",p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'",
        ]
        if button:
            self.lines.append(f",p_when_button_pressed=>wwv_flow_imp.id({button})")
        self.lines.append(");")

    def item_id(self, name: str) -> int:
        for i, line in enumerate(self.lines):
            if line == f",p_name=>'{name}'":
                return int(self.lines[i - 1].rsplit("(", 1)[1].rstrip(")"))
        raise KeyError(name)

    def go(self, page: int, items: str = "", values: str = "") -> None:
        self.branch = (page, items, values)

    def end(self) -> list[str]:
        if self.submit and self.branch:
            page, items, values = self.branch
            self.lines += [
                "wwv_flow_imp_page.create_page_branch(",
                f" p_id=>wwv_flow_imp.id({cid(self.pid, 999)})",
                f",p_branch_name=>'Go To Page {page}'",
                f",p_branch_action=>'f?p=&APP_ID.:{page}:&SESSION.::&DEBUG.:{page if items else ''}:{items}:{values}&success_msg=#SUCCESS_MSG#'",
                ",p_branch_point=>'AFTER_PROCESSING'",
                ",p_branch_type=>'REDIRECT_URL'",
                ",p_branch_sequence=>10",
                ");",
            ]
        return self.lines + ["end;", "/"]


def url(page: int, items: str = "", values: str = "", clear: str = "") -> str:
    return f"f?p=&APP_ID.:{page}:&SESSION.::&DEBUG.:{clear}:{items}:{values}"


YES_NO = "STATIC2:Yes;Y,No;N"
ACTIVE_LOV = "STATIC2:Active;Y,Inactive;N"
STATUS_HTML = ("case when {c} = 'Y' then '<span class=\"inv-pill inv-pill--ok\">Active</span>' "
               "else '<span class=\"inv-pill\">Inactive</span>' end")


def api(lines: list[str]) -> list[str]:
    return ["begin", *[f"  {l}" for l in lines], "end;"]


# ----------------------------------------------------------------------------- pages
def page_home() -> list[str]:
    p = Page(1, "Home", "HOME", crumb=False, css_class="inv-home")
    hero = p.html(1, "Inventory Control", [
        '<p class="inv-lead">Track items, stock on hand and every stock movement across your locations.</p>'],
        template=T_REGION_BLANK, css="inv-hero", point="REGION_POSITION_01")
    p.button(1, hero, "RECEIVE", "Receive stock", hot=True, action="REDIRECT_URL",
             url=url(6, "P6_TXN_TYPE", "RECEIPT", "6"), icon="fa-arrow-down", position="NEXT")
    p.button(2, hero, "ISSUE", "Issue stock", action="REDIRECT_URL",
             url=url(6, "P6_TXN_TYPE", "ISSUE", "6"), icon="fa-arrow-up", position="NEXT")
    p.button(3, hero, "TRANSFER", "Transfer", action="REDIRECT_URL",
             url=url(6, "P6_TXN_TYPE", "TRANSFER", "6"), icon="fa-exchange", position="NEXT")
    p.report(2, "Overview", [
        "select active_items, low_stock_items,",
        "       'R ' || to_char(stock_value, 'FM999G999G990D00') stock_value,",
        "       txns_7_days, active_locations",
        "  from inv_dashboard_v"],
        [("ACTIVE_ITEMS", "Active items", {}), ("LOW_STOCK_ITEMS", "Low stock", {}),
         ("STOCK_VALUE", "Stock value", {}), ("TXNS_7_DAYS", "Movements (7 days)", {}),
         ("ACTIVE_LOCATIONS", "Locations", {})],
        template=T_REPORT_BADGE, comp_options="#DEFAULT#:t-BadgeList--responsive:t-BadgeList--large:t-BadgeList--flex",
        options="#DEFAULT#:t-Region--removeHeader:t-Region--noBorder", static_id="inv_overview", rows=1)
    p.report(3, "Low Stock", [
        "select item_id, sku, name, qty_on_hand, reorder_level, suggested_order_qty",
        "  from inv_items_v",
        " where low_stock_yn = 'Y'",
        " order by qty_on_hand - reorder_level, sku"],
        [("ITEM_ID", "Item", {"hidden": True}), ("SKU", "SKU", {"link": (3, "P3_ITEM_ID", "#ITEM_ID#")}),
         ("NAME", "Item", {}), ("QTY_ON_HAND", "On hand", {"align": "RIGHT"}),
         ("REORDER_LEVEL", "Reorder at", {"align": "RIGHT"}), ("SUGGESTED_ORDER_QTY", "Order qty", {"align": "RIGHT"})],
        static_id="inv_low_stock", no_data="Nothing is below its reorder level.", icon="fa-warning", rows=10)
    p.report(4, "Recent Movements", [
        "select txn_id, txn_date, txn_type_label, sku, item_name,",
        "       case when txn_type in ('ISSUE') or quantity < 0 then '-' else '+' end || abs(quantity) quantity,",
        "       coalesce(to_location, from_location) location",
        "  from inv_transactions_v",
        " order by txn_date desc, txn_id desc",
        " fetch first 8 rows only"],
        [("TXN_ID", "Txn", {"hidden": True}), ("TXN_DATE", "Date", {"fmt": "DD-MON"}),
         ("TXN_TYPE_LABEL", "Type", {}), ("SKU", "SKU", {}), ("ITEM_NAME", "Item", {}),
         ("QUANTITY", "Qty", {"align": "RIGHT"}), ("LOCATION", "Location", {})],
        static_id="inv_recent", no_data="No stock movements yet.", icon="fa-history", rows=8)
    return p.end()


def page_items() -> list[str]:
    p = Page(2, "Items", "ITEMS")
    r = p.html(1, "Search", [], template=T_REGION_BLANK, css="inv-toolbar")
    p.item(1, "P2_SEARCH", r, "Search SKU or name", submit_on_enter=True, size=40, maxlength=100,
           icon="fa-search", colspan=6)
    p.item(2, "P2_CATEGORY_ID", r, "Category", "NATIVE_SELECT_LIST", new_line=False, colspan=3,
           lov="select name d, category_id r from inv_categories order by name", null_text="All categories",
           submit_on_change=True)
    p.item(3, "P2_STATUS", r, "Show", "NATIVE_SELECT_LIST", new_line=False, colspan=3,
           lov="STATIC2:Active items;Y,Low stock;LOW,Inactive items;N", null_text="All items",
           submit_on_change=True, default="Y")
    rep = p.report(2, "Items", [
        "select item_id, sku, name, category, qty_on_hand || ' ' || uom on_hand, reorder_level,",
        "       case when active_yn = 'N' then '<span class=\"inv-pill\">Inactive</span>'",
        "            when low_stock_yn = 'Y' then '<span class=\"inv-pill inv-pill--warn\">Low</span>'",
        "            else '<span class=\"inv-pill inv-pill--ok\">OK</span>' end status",
        "  from inv_items_v",
        " where (:P2_SEARCH is null",
        "        or upper(sku) like '%' || upper(:P2_SEARCH) || '%'",
        "        or upper(name) like '%' || upper(:P2_SEARCH) || '%')",
        "   and (:P2_CATEGORY_ID is null or category_id = :P2_CATEGORY_ID)",
        "   and (:P2_STATUS is null",
        "        or (:P2_STATUS = 'LOW' and low_stock_yn = 'Y')",
        "        or (:P2_STATUS in ('Y','N') and active_yn = :P2_STATUS))",
        " order by sku"],
        [("ITEM_ID", "ID", {"hidden": True}), ("SKU", "SKU", {"link": (3, "P3_ITEM_ID", "#ITEM_ID#")}),
         ("NAME", "Name", {}), ("CATEGORY", "Category", {}), ("ON_HAND", "On hand", {"align": "RIGHT"}),
         ("REORDER_LEVEL", "Reorder at", {"align": "RIGHT"}), ("STATUS", "Status", {"html": True})],
        static_id="inv_items", no_data="No items match your search.", css="inv-rpt", icon="fa-cube")
    p.button(1, rep, "CREATE", "Add Item", hot=True, action="REDIRECT_URL", url=url(3, "", "", "3"),
             icon="fa-plus", position="RIGHT_OF_TITLE")
    return p.end()


def form_buttons(p: Page, region: int, key_item: str, back: int, noun: str) -> tuple[int, int, int]:
    cancel = p.button(1, region, "CANCEL", "Cancel", action="REDIRECT_URL", url=url(back), position="PREVIOUS")
    delete = p.button(2, region, "DELETE", "Delete", confirm=f"Delete this {noun}?", position="DELETE",
                      condition=f":{key_item} is not null", options="#DEFAULT#:t-Button--danger:t-Button--simple")
    save = p.button(3, region, "SAVE", "Save", hot=True, position="NEXT")
    return cancel, delete, save


def page_item_form() -> list[str]:
    p = Page(3, "Item", "ITEM", css_class="inv-form")
    r = p.html(1, "Item Details", [], css="inv-form-region", icon="fa-cube")
    p.item(1, "P3_ITEM_ID", r, None, "NATIVE_HIDDEN")
    p.item(2, "P3_SKU", r, "SKU", required=True, maxlength=40, colspan=6)
    p.item(3, "P3_NAME", r, "Name", required=True, maxlength=150, new_line=False, colspan=6)
    p.item(4, "P3_CATEGORY_ID", r, "Category", "NATIVE_SELECT_LIST", colspan=6,
           lov="select name d, category_id r from inv_categories where active_yn = 'Y' or category_id = :P3_CATEGORY_ID order by name")
    p.item(5, "P3_SUPPLIER_ID", r, "Supplier", "NATIVE_SELECT_LIST", new_line=False, colspan=6,
           lov="select name d, supplier_id r from inv_suppliers where active_yn = 'Y' or supplier_id = :P3_SUPPLIER_ID order by name")
    p.item(6, "P3_UOM", r, "Unit of measure", required=True, maxlength=20, default="EA", colspan=3,
           help_text="EA, M, PR, RL, KG ...")
    p.item(7, "P3_UNIT_COST", r, "Unit cost", "NATIVE_NUMBER_FIELD", new_line=False, colspan=3, default="0",
           fmt="FM999G999G990D00")
    p.item(8, "P3_REORDER_LEVEL", r, "Reorder level", "NATIVE_NUMBER_FIELD", new_line=False, colspan=3, default="0")
    p.item(9, "P3_REORDER_QTY", r, "Reorder quantity", "NATIVE_NUMBER_FIELD", new_line=False, colspan=3, default="1",
           required=True, help_text="Ordered when stock is low (> 0)")
    p.item(10, "P3_DESCRIPTION", r, "Description", "NATIVE_TEXTAREA", maxlength=1000, height=3, size=60)
    p.item(11, "P3_ACTIVE_YN", r, "Status", "NATIVE_SELECT_LIST", lov=ACTIVE_LOV, null_text=None, default="Y", colspan=6)
    p.item(12, "P3_QTY_ON_HAND", r, "On hand (all locations)", "NATIVE_DISPLAY_ONLY", new_line=False, colspan=6)
    _, delete, save = form_buttons(p, r, "P3_ITEM_ID", 2, "item")
    p.validation(1, "Reorder quantity > 0", "to_number(:P3_REORDER_QTY) > 0",
                 "Reorder quantity must be greater than 0.", "P3_REORDER_QTY", button=save)
    p.process(1, "Load item", [
        "select sku, name, category_id, supplier_id, uom, unit_cost, reorder_level, reorder_qty,",
        "       description, active_yn, qty_on_hand || ' ' || uom",
        "  into :P3_SKU, :P3_NAME, :P3_CATEGORY_ID, :P3_SUPPLIER_ID, :P3_UOM, :P3_UNIT_COST,",
        "       :P3_REORDER_LEVEL, :P3_REORDER_QTY, :P3_DESCRIPTION, :P3_ACTIVE_YN, :P3_QTY_ON_HAND",
        "  from inv_items_v",
        " where item_id = :P3_ITEM_ID;"], point="BEFORE_HEADER", condition=":P3_ITEM_ID is not null")
    p.process(2, "Save item", ["declare", "  l_id inv_items.item_id%type := :P3_ITEM_ID;", "begin",
        "  inv_api.save_item(p_item_id => l_id, p_sku => :P3_SKU, p_name => :P3_NAME,",
        "    p_description => :P3_DESCRIPTION, p_category_id => :P3_CATEGORY_ID,",
        "    p_supplier_id => :P3_SUPPLIER_ID, p_uom => :P3_UOM, p_unit_cost => :P3_UNIT_COST,",
        "    p_reorder_level => :P3_REORDER_LEVEL, p_reorder_qty => :P3_REORDER_QTY,",
        "    p_active_yn => :P3_ACTIVE_YN);", "  :P3_ITEM_ID := l_id;", "end;"],
        button=save, success="Item saved.")
    p.process(3, "Delete item", api(["inv_api.delete_item(p_item_id => :P3_ITEM_ID);"]),
              button=delete, success="Item deleted (or made inactive if it has stock history).")
    p.go(2)
    return p.end()


def page_stock() -> list[str]:
    p = Page(4, "Stock on Hand", "STOCK")
    r = p.html(1, "Filter", [], template=T_REGION_BLANK, css="inv-toolbar")
    p.item(1, "P4_LOCATION_ID", r, "Location", "NATIVE_SELECT_LIST", colspan=6,
           lov="select code || ' - ' || name d, location_id r from inv_locations order by code",
           null_text="All locations", submit_on_change=True)
    p.item(2, "P4_SEARCH", r, "Search SKU or name", submit_on_enter=True, new_line=False, colspan=6,
           icon="fa-search", maxlength=100)
    p.report(2, "Stock on Hand", [
        "select item_id, sku, item_name, location_code, qty_on_hand || ' ' || uom qty,",
        "       'R ' || to_char(stock_value, 'FM999G999G990D00') value",
        "  from inv_stock_v",
        " where (:P4_LOCATION_ID is null or location_id = :P4_LOCATION_ID)",
        "   and (:P4_SEARCH is null",
        "        or upper(sku) like '%' || upper(:P4_SEARCH) || '%'",
        "        or upper(item_name) like '%' || upper(:P4_SEARCH) || '%')",
        "   and qty_on_hand <> 0",
        " order by sku, location_code"],
        [("ITEM_ID", "ID", {"hidden": True}), ("SKU", "SKU", {"link": (3, "P3_ITEM_ID", "#ITEM_ID#")}),
         ("ITEM_NAME", "Item", {}), ("LOCATION_CODE", "Location", {}), ("QTY", "On hand", {"align": "RIGHT"}),
         ("VALUE", "Value", {"align": "RIGHT"})],
        static_id="inv_stock", no_data="No stock at this location.", css="inv-rpt", icon="fa-cubes", rows=50)
    return p.end()


def page_movements() -> list[str]:
    p = Page(5, "Stock Movements", "MOVEMENTS")
    r = p.html(1, "Filter", [], template=T_REGION_BLANK, css="inv-toolbar")
    p.item(1, "P5_TXN_TYPE", r, "Type", "NATIVE_SELECT_LIST", colspan=4,
           lov="STATIC2:Receipt;RECEIPT,Issue;ISSUE,Transfer;TRANSFER,Adjust;ADJUST", null_text="All types",
           submit_on_change=True)
    p.item(2, "P5_SEARCH", r, "Search SKU, item or reference", submit_on_enter=True, new_line=False, colspan=8,
           icon="fa-search", maxlength=100)
    rep = p.report(2, "Stock Movements", [
        "select txn_id, txn_date, txn_type_label, sku, item_name,",
        "       case when txn_type = 'ISSUE' or quantity < 0 then '-' else '+' end || abs(quantity) quantity,",
        "       case txn_type when 'TRANSFER' then from_location || ' > ' || to_location",
        "                     else coalesce(to_location, from_location) end location,",
        "       reference, created_by",
        "  from inv_transactions_v",
        " where (:P5_TXN_TYPE is null or txn_type = :P5_TXN_TYPE)",
        "   and (:P5_SEARCH is null",
        "        or upper(sku) like '%' || upper(:P5_SEARCH) || '%'",
        "        or upper(item_name) like '%' || upper(:P5_SEARCH) || '%'",
        "        or upper(reference) like '%' || upper(:P5_SEARCH) || '%')",
        " order by txn_date desc, txn_id desc"],
        [("TXN_ID", "No.", {"hidden": True}), ("TXN_DATE", "Date", {"fmt": "DD-MON-YY"}),
         ("TXN_TYPE_LABEL", "Type", {}), ("SKU", "SKU", {}), ("ITEM_NAME", "Item", {}),
         ("QUANTITY", "Qty", {"align": "RIGHT"}), ("LOCATION", "Location", {}),
         ("REFERENCE", "Reference", {}), ("CREATED_BY", "By", {})],
        static_id="inv_moves", no_data="No stock movements match.", css="inv-rpt", icon="fa-exchange", rows=50)
    p.button(1, rep, "NEW", "New Movement", hot=True, action="REDIRECT_URL", url=url(6, "", "", "6"),
             icon="fa-plus", position="RIGHT_OF_TITLE")
    return p.end()


def page_new_movement() -> list[str]:
    p = Page(6, "New Movement", "NEW-MOVEMENT", css_class="inv-form")
    r = p.html(1, "Stock Movement", [], css="inv-form-region", icon="fa-exchange")
    p.item(1, "P6_TXN_TYPE", r, "Movement type", "NATIVE_SELECT_LIST", required=True, colspan=6,
           lov="STATIC2:Receipt (stock in);RECEIPT,Issue (stock out);ISSUE,Transfer between locations;TRANSFER,Adjustment (count correction);ADJUST",
           default="RECEIPT", null_text=None)
    p.item(2, "P6_ITEM_ID", r, "Item", "NATIVE_SELECT_LIST", required=True, new_line=False, colspan=6,
           lov="select sku || ' - ' || name || ' (' || qty_on_hand || ' ' || uom || ')' d, item_id r from inv_items_v where active_yn = 'Y' order by sku")
    p.item(3, "P6_FROM_LOCATION_ID", r, "From location", "NATIVE_SELECT_LIST", colspan=6,
           lov="select code || ' - ' || name d, location_id r from inv_locations where active_yn = 'Y' order by code",
           help_text="Issue and Transfer")
    p.item(4, "P6_TO_LOCATION_ID", r, "To location", "NATIVE_SELECT_LIST", new_line=False, colspan=6,
           lov="select code || ' - ' || name d, location_id r from inv_locations where active_yn = 'Y' order by code",
           help_text="Receipt, Transfer and Adjustment")
    p.item(5, "P6_QUANTITY", r, "Quantity", "NATIVE_NUMBER_FIELD", required=True, colspan=6,
           help_text="Adjustments may be negative (shrinkage).")
    p.item(6, "P6_REFERENCE", r, "Reference", new_line=False, colspan=6, maxlength=100,
           help_text="PO, job or count number")
    p.item(7, "P6_NOTES", r, "Notes", "NATIVE_TEXTAREA", maxlength=1000, height=2, size=60)
    p.button(1, r, "CANCEL", "Cancel", action="REDIRECT_URL", url=url(5), position="PREVIOUS")
    post = p.button(2, r, "POST", "Post Movement", hot=True, position="NEXT")
    p.process(1, "Post movement", ["declare", "  l_txn_id inv_transactions.txn_id%type;", "begin",
        "  inv_api.post_transaction(", "    p_txn_type         => :P6_TXN_TYPE,",
        "    p_item_id          => :P6_ITEM_ID,", "    p_quantity         => :P6_QUANTITY,",
        "    p_from_location_id => :P6_FROM_LOCATION_ID,", "    p_to_location_id   => :P6_TO_LOCATION_ID,",
        "    p_reference        => :P6_REFERENCE,", "    p_notes            => :P6_NOTES,",
        "    p_txn_id           => l_txn_id);", "end;"], button=post, success="Stock movement posted.")
    p.go(5)
    return p.end()


def simple_list(pid: int, form: int, name: str, alias: str, key: str, sql: list[str], cols: list[tuple],
                icon: str, noun: str) -> list[str]:
    p = Page(pid, name, alias)
    cols = [(c[0], c[1], dict(c[2])) for c in cols]
    rep = p.report(1, name, sql, cols, static_id=f"inv_{alias.lower()}", no_data=f"No {name.lower()} yet.",
                   css="inv-rpt", icon=icon, rows=50)
    p.button(1, rep, "CREATE", f"Add {noun}", hot=True, action="REDIRECT_URL", url=url(form, "", "", str(form)),
             icon="fa-plus", position="RIGHT_OF_TITLE")
    return p.end()


def page_locations() -> list[str]:
    return simple_list(7, 8, "Locations", "LOCATIONS", "LOCATION_ID", [
        "select l.location_id, l.code, l.name,",
        "       (select count(*) from inv_stock s where s.location_id = l.location_id and s.qty_on_hand > 0) items,",
        "       " + STATUS_HTML.format(c="l.active_yn") + " status",
        "  from inv_locations l order by l.code"],
        [("LOCATION_ID", "ID", {"hidden": True}), ("CODE", "Code", {"link": (8, "P8_LOCATION_ID", "#LOCATION_ID#")}),
         ("NAME", "Name", {}), ("ITEMS", "Items stocked", {"align": "RIGHT"}), ("STATUS", "Status", {"html": True})],
        "fa-map-marker", "Location")


def page_categories() -> list[str]:
    return simple_list(9, 10, "Categories", "CATEGORIES", "CATEGORY_ID", [
        "select c.category_id, c.name, c.description,",
        "       (select count(*) from inv_items i where i.category_id = c.category_id) items,",
        "       " + STATUS_HTML.format(c="c.active_yn") + " status",
        "  from inv_categories c order by c.name"],
        [("CATEGORY_ID", "ID", {"hidden": True}), ("NAME", "Name", {"link": (10, "P10_CATEGORY_ID", "#CATEGORY_ID#")}),
         ("DESCRIPTION", "Description", {}), ("ITEMS", "Items", {"align": "RIGHT"}), ("STATUS", "Status", {"html": True})],
        "fa-tags", "Category")


def page_suppliers() -> list[str]:
    return simple_list(11, 12, "Suppliers", "SUPPLIERS", "SUPPLIER_ID", [
        "select s.supplier_id, s.name, s.contact_name, s.email, s.phone,",
        "       " + STATUS_HTML.format(c="s.active_yn") + " status",
        "  from inv_suppliers s order by s.name"],
        [("SUPPLIER_ID", "ID", {"hidden": True}), ("NAME", "Name", {"link": (12, "P12_SUPPLIER_ID", "#SUPPLIER_ID#")}),
         ("CONTACT_NAME", "Contact", {}), ("EMAIL", "Email", {}), ("PHONE", "Phone", {}),
         ("STATUS", "Status", {"html": True})],
        "fa-truck", "Supplier")


def page_location_form() -> list[str]:
    p = Page(8, "Location", "LOCATION", css_class="inv-form")
    r = p.html(1, "Location Details", [], css="inv-form-region", icon="fa-map-marker")
    p.item(1, "P8_LOCATION_ID", r, None, "NATIVE_HIDDEN")
    p.item(2, "P8_CODE", r, "Code", required=True, maxlength=20, colspan=4)
    p.item(3, "P8_NAME", r, "Name", required=True, maxlength=100, new_line=False, colspan=8)
    p.item(4, "P8_DESCRIPTION", r, "Description", "NATIVE_TEXTAREA", maxlength=500, height=2, size=60)
    p.item(5, "P8_ACTIVE_YN", r, "Status", "NATIVE_SELECT_LIST", lov=ACTIVE_LOV, null_text=None, default="Y", colspan=6)
    _, delete, save = form_buttons(p, r, "P8_LOCATION_ID", 7, "location")
    p.process(1, "Load location", [
        "select code, name, description, active_yn into :P8_CODE, :P8_NAME, :P8_DESCRIPTION, :P8_ACTIVE_YN",
        "  from inv_locations where location_id = :P8_LOCATION_ID;"],
        point="BEFORE_HEADER", condition=":P8_LOCATION_ID is not null")
    p.process(2, "Save location", ["declare", "  l_id inv_locations.location_id%type := :P8_LOCATION_ID;", "begin",
        "  inv_api.save_location(p_location_id => l_id, p_code => :P8_CODE, p_name => :P8_NAME,",
        "    p_description => :P8_DESCRIPTION, p_active_yn => :P8_ACTIVE_YN);", "end;"],
        button=save, success="Location saved.")
    p.process(3, "Delete location", api(["inv_api.delete_location(p_location_id => :P8_LOCATION_ID);"]),
              button=delete, success="Location deleted.")
    p.go(7)
    return p.end()


def page_category_form() -> list[str]:
    p = Page(10, "Category", "CATEGORY", css_class="inv-form")
    r = p.html(1, "Category Details", [], css="inv-form-region", icon="fa-tags")
    p.item(1, "P10_CATEGORY_ID", r, None, "NATIVE_HIDDEN")
    p.item(2, "P10_NAME", r, "Name", required=True, maxlength=100, colspan=8)
    p.item(3, "P10_ACTIVE_YN", r, "Status", "NATIVE_SELECT_LIST", lov=ACTIVE_LOV, null_text=None, default="Y",
           new_line=False, colspan=4)
    p.item(4, "P10_DESCRIPTION", r, "Description", "NATIVE_TEXTAREA", maxlength=500, height=2, size=60)
    _, delete, save = form_buttons(p, r, "P10_CATEGORY_ID", 9, "category")
    p.process(1, "Load category", [
        "select name, description, active_yn into :P10_NAME, :P10_DESCRIPTION, :P10_ACTIVE_YN",
        "  from inv_categories where category_id = :P10_CATEGORY_ID;"],
        point="BEFORE_HEADER", condition=":P10_CATEGORY_ID is not null")
    p.process(2, "Save category", ["declare", "  l_id inv_categories.category_id%type := :P10_CATEGORY_ID;", "begin",
        "  inv_api.save_category(p_category_id => l_id, p_name => :P10_NAME,",
        "    p_description => :P10_DESCRIPTION, p_active_yn => :P10_ACTIVE_YN);", "end;"],
        button=save, success="Category saved.")
    p.process(3, "Delete category", api(["inv_api.delete_category(p_category_id => :P10_CATEGORY_ID);"]),
              button=delete, success="Category deleted.")
    p.go(9)
    return p.end()


def page_supplier_form() -> list[str]:
    p = Page(12, "Supplier", "SUPPLIER", css_class="inv-form")
    r = p.html(1, "Supplier Details", [], css="inv-form-region", icon="fa-truck")
    p.item(1, "P12_SUPPLIER_ID", r, None, "NATIVE_HIDDEN")
    p.item(2, "P12_NAME", r, "Name", required=True, maxlength=150, colspan=6)
    p.item(3, "P12_CONTACT_NAME", r, "Contact name", maxlength=150, new_line=False, colspan=6)
    p.item(4, "P12_EMAIL", r, "Email", maxlength=255, colspan=6, tag='type="email" autocomplete="email"')
    p.item(5, "P12_PHONE", r, "Phone", maxlength=50, new_line=False, colspan=6, tag='type="tel"')
    p.item(6, "P12_ACTIVE_YN", r, "Status", "NATIVE_SELECT_LIST", lov=ACTIVE_LOV, null_text=None, default="Y", colspan=6)
    _, delete, save = form_buttons(p, r, "P12_SUPPLIER_ID", 11, "supplier")
    p.process(1, "Load supplier", [
        "select name, contact_name, email, phone, active_yn",
        "  into :P12_NAME, :P12_CONTACT_NAME, :P12_EMAIL, :P12_PHONE, :P12_ACTIVE_YN",
        "  from inv_suppliers where supplier_id = :P12_SUPPLIER_ID;"],
        point="BEFORE_HEADER", condition=":P12_SUPPLIER_ID is not null")
    p.process(2, "Save supplier", ["declare", "  l_id inv_suppliers.supplier_id%type := :P12_SUPPLIER_ID;", "begin",
        "  inv_api.save_supplier(p_supplier_id => l_id, p_name => :P12_NAME,",
        "    p_contact_name => :P12_CONTACT_NAME, p_email => :P12_EMAIL, p_phone => :P12_PHONE,",
        "    p_active_yn => :P12_ACTIVE_YN);", "end;"], button=save, success="Supplier saved.")
    p.process(3, "Delete supplier", api(["inv_api.delete_supplier(p_supplier_id => :P12_SUPPLIER_ID);"]),
              button=delete, success="Supplier deleted.")
    p.go(11)
    return p.end()


def page_login() -> list[str]:
    p = Page(9999, "Sign In", "LOGIN", login=True, css_class="inv-login")
    r = p.html(1, APP_NAME, ['<p class="inv-login-tagline">Sign in to manage stock</p>'],
               template=T_REGION_LOGIN, icon="fa-cubes")
    p.item(1, "P9999_USERNAME", r, "Username", size=40, maxlength=100, icon="fa-user",
           tag='autocomplete="username" autocapitalize="none"')
    p.item(2, "P9999_PASSWORD", r, "Password", "NATIVE_PASSWORD", size=40, maxlength=100, icon="fa-key",
           tag='autocomplete="current-password"')
    p.item(3, "P9999_REMEMBER", r, "Remember username", "NATIVE_SINGLE_CHECKBOX", label_template=T_LABEL_OPTIONAL)
    login = p.button(1, r, "LOGIN", "Sign In", hot=True, position="NEXT",
                     options="#DEFAULT#:t-Button--large:t-Button--stretch")
    p.process(1, "Get username cookie", [
        ":P9999_USERNAME := apex_authentication.get_login_username_cookie;",
        ":P9999_REMEMBER := case when :P9999_USERNAME is not null then 'Y' end;"], point="BEFORE_HEADER")
    p.process(2, "Set username cookie", [
        "apex_authentication.send_login_username_cookie(",
        "  p_username => lower(:P9999_USERNAME),",
        "  p_consent  => :P9999_REMEMBER = 'Y');"], button=login)
    p.process(3, "Login", ["apex_authentication.login(", "  p_username => :P9999_USERNAME,",
                           "  p_password => :P9999_PASSWORD);"], button=login)
    p.process(4, "Clear page cache", ["apex_util.clear_page_cache(:APP_PAGE_ID);"], button=login)
    return p.end()


def emit_end() -> list[str]:
    return [
        "prompt --application/end_environment",
        "begin",
        "wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));",
        "commit;",
        "end;",
        "/",
        "set verify on feedback on define on",
        "prompt  ...done",
    ]


def main() -> None:
    out: list[str] = []
    out += emit_begin() + emit_ui() + emit_nav() + emit_theme_auth_files()
    for fn in (page_home, page_items, page_item_form, page_stock, page_movements, page_new_movement,
               page_locations, page_location_form, page_categories, page_category_form,
               page_suppliers, page_supplier_form, page_login):
        out += fn()
    out += emit_end()
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(out) + "\n")
    print(f"wrote {OUT} ({len(out)} lines)")


if __name__ == "__main__":
    main()
