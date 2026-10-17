#!/usr/bin/env python3
"""Headless check of every Inventory Control page at 390x844 and 1280x800 ."""
import json, os, sys, re, getpass
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
PAGES = [("home", "Home"), ("items", "Items"), ("item", "Item (new)"), ("stock", "Stock on Hand"),
         ("movements", "Stock Movements"), ("new-movement", "New Movement"), ("locations", "Locations"),
         ("location", "Location (new)"), ("categories", "Categories"), ("category", "Category (new)"),
         ("suppliers", "Suppliers"), ("supplier", "Supplier (new)")]
LAYOUT_JS = r"""() => {
  const vw = window.innerWidth, de = document.documentElement;
  const bad = [];
  document.querySelectorAll('input:not([type=hidden]), select, textarea, button, .t-Button, .t-Region').forEach(el => {
    const r = el.getBoundingClientRect(); const cs = getComputedStyle(el);
    if (r.width === 0 || cs.visibility === 'hidden' || cs.display === 'none') return;
    if (el.closest('.t-Report-tableWrap')) return;
    if (r.right > vw + 1 || r.left < -1) bad.push((el.id || el.className || el.tagName).toString().slice(0,60) + ' ' + Math.round(r.left) + '-' + Math.round(r.right));
  });
  // inputs in the same form row should share left edges per column: report widths of form fields
  const fields = [...document.querySelectorAll('.t-Form-fieldContainer:not(.t-Form-fieldContainer--hiddenLabel) .t-Form-inputContainer')]
     .filter(e => e.offsetParent).map(e => { const r = e.getBoundingClientRect(); return [Math.round(r.left), Math.round(r.width)]; });
  const tw = [...document.querySelectorAll('.t-Report-tableWrap')].map(w => [w.scrollWidth, w.clientWidth]);
  return {vw, scrollW: de.scrollWidth, bodyScrollW: document.body.scrollWidth, overflow: de.scrollWidth > vw + 1, bad, fields, tables: tw,
          errors: [...document.querySelectorAll('.t-Alert--danger, .a-Notification--error, #t_Alert_Notification .htmldbUlErr li')].map(e => e.innerText.trim()).filter(Boolean)};
}"""
def main(tag=""):
    res = {}
    with sync_playwright() as p:
        b = p.chromium.launch(executable_path=os.environ.get('PW_CHROMIUM') or None)
        for vpname, vp in (("phone", {"width": 390, "height": 844}), ("desktop", {"width": 1280, "height": 800})):
            ctx = b.new_context(viewport=vp, device_scale_factor=2 if vpname == "phone" else 1,
                                is_mobile=vpname == "phone", has_touch=vpname == "phone")
            ctx.add_init_script(MASK_JS)
            pg = ctx.new_page()
            pg.goto(H + "login", wait_until="networkidle")
            res[f"{vpname}/login"] = pg.evaluate(LAYOUT_JS)
            pg.screenshot(path=f"{SHOTS}/{vpname}-00-login{tag}.png", full_page=True)
            pg.fill("#P9999_USERNAME", creds["username"]); pg.fill("#P9999_PASSWORD", creds["password"])
            with pg.expect_navigation(wait_until="networkidle", timeout=60000):
                pg.click("button:has-text('Sign In')")
            pg.wait_for_timeout(500)
            if "login" in pg.url.lower() and pg.locator("#P9999_PASSWORD").count():
                print("LOGIN FAILED", pg.url); pg.screenshot(path=f"{SHOTS}/{vpname}-login-failed.png"); sys.exit(2)
            session = re.search(r"session=(\d+)", pg.url)
            sess = session.group(1) if session else None
            for i, (alias, label) in enumerate(PAGES, start=1):
                pg.goto(H + alias + (f"?session={sess}" if sess else ""), wait_until="networkidle")
                pg.wait_for_timeout(300)
                r = pg.evaluate(LAYOUT_JS); r["title"] = pg.title()
                res[f"{vpname}/{alias}"] = r
                pg.screenshot(path=f"{SHOTS}/{vpname}-{i:02d}-{alias}{tag}.png", full_page=True)
            ctx.close()
        b.close()
    ok = True
    for k, v in res.items():
        flag = "FAIL" if (v["overflow"] or v["bad"] or v["errors"]) else "ok"
        ok &= flag == "ok"
        print(f"{flag:4} {k:28} vw={v['vw']} scrollW={v['scrollW']} title={v.get('title','')!r} bad={v['bad'][:4]} err={v['errors'][:2]} tables={v['tables']}")
    json.dump(res, open(f"{SHOTS}/layout-report{tag}.json", "w"), indent=1)
    return ok
if __name__ == "__main__":
    sys.exit(0 if main(sys.argv[1] if len(sys.argv) > 1 else "") else 1)
