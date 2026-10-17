#!/usr/bin/env python3
"""Functional smoke: create item, receive, over-issue (friendly error), issue, reorder rule.
Teardown always calls the test-only inv_api.qa_purge (database/tests/qa_purge.sql) so no QA-% rows remain."""
import json, os, subprocess, re, sys, time, getpass
from playwright.sync_api import sync_playwright
# Config (environment): APP_URL or ADB_ORDS_URL, APP_USER, APP_PASSWORD (prompted when unset),
#                       SHOTS (screenshot folder, default ./shots), PW_CHROMIUM (optional browser path)
H = os.environ.get("APP_URL") or (os.environ.get("ADB_ORDS_URL", "").rstrip("/") + "/ords/r/inventory_control/inventory-control/")
if not H.startswith("http"): sys.exit("set APP_URL or ADB_ORDS_URL")
H = H.rstrip("/") + "/"
SHOTS = os.environ.get("SHOTS") or os.path.join(os.getcwd(), "shots"); os.makedirs(SHOTS, exist_ok=True)
creds = {"username": os.environ.get("APP_USER") or input("APP_USER: "),
         "password": os.environ.get("APP_PASSWORD") or getpass.getpass("APP_PASSWORD: ")}
# keep the signed-in user name out of screenshots
MASK_JS = "document.addEventListener('DOMContentLoaded',()=>{const s=document.createElement('style');s.textContent='.t-NavigationBar .t-Button-label{visibility:hidden!important}';document.head.appendChild(s)})"
S, c = SHOTS, creds
sku = "QA-" + time.strftime("%H%M%S")
def pick(pg, sel, text):
    v = pg.evaluate("([s,t])=>{const o=[...document.querySelector(s).options].find(o=>o.text.includes(t));return o?o.value:null}", [sel, text])
    assert v, (sel, text); pg.select_option(sel, v)
def msg(pg):
    return pg.evaluate("()=>[...document.querySelectorAll('#t_Alert_Success, #t_Alert_Notification, .t-Alert--success, .t-Alert--danger, .a-Notification')].map(e=>e.innerText.trim().replace(/\\s+/g,' ')).filter(Boolean).join(' | ')")
HERE = os.path.dirname(os.path.abspath(__file__))
def teardown():
    sql = "alter session set current_schema = inventory_control;\n" + open(os.path.join(HERE, "..", "database", "tests", "qa_purge.sql")).read()
    out = subprocess.run([os.path.join(HERE, "ords_sql.py"), "-"], input=sql, capture_output=True, text=True).stdout
    for line in out.splitlines():
        if "qa_purge deleted" in line or line.startswith("qa_items="):
            print("teardown:", line.split("] ")[-1])
    assert "qa_items=0 | qa_stock_rows=0 | qa_transactions=0" in out, out[-500:]
def run():
  with sync_playwright() as p:
      b = p.chromium.launch(executable_path=os.environ.get('PW_CHROMIUM') or None)
      for vp, tag in (({"width": 1280, "height": 800}, "desktop"), ({"width": 390, "height": 844}, "phone")):
          ctx = b.new_context(viewport=vp); ctx.add_init_script(MASK_JS); pg = ctx.new_page()
          pg.goto(H + "login"); pg.fill("#P9999_USERNAME", c["username"]); pg.fill("#P9999_PASSWORD", c["password"])
          with pg.expect_navigation(): pg.click("button:has-text('Sign In')")
          sess = re.search(r"session=(\d+)", pg.url).group(1)
          s = sku + ("P" if tag == "phone" else "D")
          pg.goto(f"{H}items?session={sess}"); 
          with pg.expect_navigation(): pg.click("button:has-text('Add Item')")
          pg.fill("#P3_SKU", s); pg.fill("#P3_NAME", "QA widget " + tag)
          pg.select_option("#P3_CATEGORY_ID", label="Hardware"); pg.fill("#P3_REORDER_LEVEL", "5"); pg.fill("#P3_UNIT_COST", "10")
          print(tag, "reorder qty default:", pg.input_value("#P3_REORDER_QTY"))
          pg.fill("#P3_REORDER_QTY", "0")
          pg.click("button:has-text('Save')"); pg.wait_for_selector("#t_Alert_Notification, .a-Notification, .t-Alert--danger", timeout=30000); pg.wait_for_timeout(500); pg.wait_for_selector(".u-Processing", state="detached", timeout=15000)
          print(tag, "reorder qty 0:", msg(pg)); pg.screenshot(path=f"{S}/{tag}-19-reorder-qty-zero.png", full_page=True)
          assert "greater than 0" in msg(pg)
          pg.fill("#P3_REORDER_QTY", "8")
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
          pg.click("button:has-text('Post Movement')"); pg.wait_for_selector("#t_Alert_Notification, .a-Notification, .t-Alert--danger", timeout=30000); pg.wait_for_timeout(500); pg.wait_for_selector(".u-Processing", state="detached", timeout=15000)
          print(tag, "over-issue:", msg(pg)); pg.screenshot(path=f"{S}/{tag}-20-over-issue-error.png", full_page=True)
          pg.fill("#P6_QUANTITY", "4")
          with pg.expect_navigation(): pg.click("button:has-text('Post Movement')")
          print(tag, "issue:", msg(pg)); pg.screenshot(path=f"{S}/{tag}-21-movement-posted.png", full_page=True)
          pg.goto(f"{H}items?session={sess}"); pg.fill("#P2_SEARCH", s)
          with pg.expect_navigation(): pg.press("#P2_SEARCH", "Enter")
          print(tag, "search rows:", pg.locator(".inv-rpt tbody tr").count(), pg.locator(".inv-rpt tbody tr").first.inner_text().replace("\t", " | ")[:120])
          pg.screenshot(path=f"{S}/{tag}-22-item-search.png", full_page=True)
          pg.goto(f"{H}home?session={sess}")
          rows = pg.evaluate("()=>[...document.querySelectorAll('.inv-low-stock tbody tr')].filter(r=>r.querySelector('td[headers=SKU]')).map(r=>[r.querySelector('td[headers=SKU]').innerText, r.querySelector('td[headers=SUGGESTED_ORDER_QTY]').innerText])")
          print(tag, "low stock order qty:", rows)
          assert rows and all(q and float(q) > 0 for _, q in rows), rows
          pg.screenshot(path=f"{S}/{tag}-23-low-stock-order-qty.png", full_page=True)
      b.close()

if __name__ == "__main__":
    try:
        run()
    finally:
        teardown()
