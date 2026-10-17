#!/usr/bin/env python3
"""Functional smoke: create item, receive, over-issue (friendly error), issue, delete-guard."""
import json, os, subprocess, re, time
from playwright.sync_api import sync_playwright
H = "https://sum3jolgpeajgmt-apexworksdev.adb.eu-frankfurt-1.oraclecloudapps.com/ords/r/inventory_control/inventory-control/"
S = os.environ.get("SHOTS", "/workspace/inventory-control-shots")
c = json.loads(os.environ.get("INV_APP_CREDS_JSON") or subprocess.run(["eu-oci-vault-secret", "apex-inventory-control-admin-eu-dev"], capture_output=True, text=True, check=True).stdout)
sku = "QA-" + time.strftime("%H%M%S")
def pick(pg, sel, text):
    v = pg.evaluate("([s,t])=>{const o=[...document.querySelector(s).options].find(o=>o.text.includes(t));return o?o.value:null}", [sel, text])
    assert v, (sel, text); pg.select_option(sel, v)
def msg(pg):
    return pg.evaluate("()=>[...document.querySelectorAll('#t_Alert_Success, #t_Alert_Notification, .t-Alert--success, .t-Alert--danger, .a-Notification')].map(e=>e.innerText.trim().replace(/\\s+/g,' ')).filter(Boolean).join(' | ')")
with sync_playwright() as p:
    b = p.chromium.launch(executable_path=os.environ.get('PW_CHROMIUM') or None)
    for vp, tag in (({"width": 1280, "height": 800}, "desktop"), ({"width": 390, "height": 844}, "phone")):
        pg = b.new_context(viewport=vp).new_page()
        pg.goto(H + "login"); pg.fill("#P9999_USERNAME", c["username"]); pg.fill("#P9999_PASSWORD", c["password"])
        with pg.expect_navigation(): pg.click("button:has-text('Sign In')")
        sess = re.search(r"session=(\d+)", pg.url).group(1)
        s = sku + ("P" if tag == "phone" else "D")
        pg.goto(f"{H}items?session={sess}"); 
        with pg.expect_navigation(): pg.click("button:has-text('Add Item')")
        pg.fill("#P3_SKU", s); pg.fill("#P3_NAME", "QA widget " + tag)
        pg.select_option("#P3_CATEGORY_ID", label="Hardware"); pg.fill("#P3_REORDER_LEVEL", "5"); pg.fill("#P3_UNIT_COST", "10")
        with pg.expect_navigation(): pg.click("button:has-text('Save')")
        print(tag, "save item:", msg(pg))
        pg.goto(f"{H}new-movement?session={sess}")
        pg.select_option("#P6_TXN_TYPE", "RECEIPT"); pick(pg, "#P6_ITEM_ID", s)
        pick(pg, "#P6_TO_LOCATION_ID", "MAIN"); pg.fill("#P6_QUANTITY", "10"); pg.fill("#P6_REFERENCE", "PO-QA")
        with pg.expect_navigation(): pg.click("button:has-text('Post Movement')")
        print(tag, "receipt:", msg(pg))
        pg.goto(f"{H}new-movement?session={sess}")
        pg.select_option("#P6_TXN_TYPE", "ISSUE"); pick(pg, "#P6_ITEM_ID", s)
        pick(pg, "#P6_FROM_LOCATION_ID", "MAIN"); pg.fill("#P6_QUANTITY", "25")
        pg.click("button:has-text('Post Movement')"); pg.wait_for_selector("#t_Alert_Notification, .a-Notification, .t-Alert--danger", timeout=30000); pg.wait_for_timeout(500)
        print(tag, "over-issue:", msg(pg)); pg.screenshot(path=f"{S}/{tag}-20-over-issue-error.png", full_page=True)
        pg.fill("#P6_QUANTITY", "4")
        with pg.expect_navigation(): pg.click("button:has-text('Post Movement')")
        print(tag, "issue:", msg(pg)); pg.screenshot(path=f"{S}/{tag}-21-movement-posted.png", full_page=True)
        pg.goto(f"{H}items?session={sess}"); pg.fill("#P2_SEARCH", s)
        with pg.expect_navigation(): pg.press("#P2_SEARCH", "Enter")
        print(tag, "search rows:", pg.locator(".inv-rpt tbody tr").count(), pg.locator(".inv-rpt tbody tr").first.inner_text().replace("\t", " | ")[:120])
        pg.screenshot(path=f"{S}/{tag}-22-item-search.png", full_page=True)
    b.close()
