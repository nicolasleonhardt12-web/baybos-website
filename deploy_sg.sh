#!/bin/bash
# Deploy baybos-website to SiteGround (baybosfoods.com). Creds: ~/.config/baybos/sg_ftp
python3 - <<'PY'
from ftplib import FTP
import pathlib
SRC = pathlib.Path(__file__ if '__file__' in dir() else '.').resolve()
SRC = pathlib.Path("/Users/leonhardt/Documents/CLAUDE SAP:THRIVE/baybos-website")
cfg = dict(l.split("=",1) for l in open(pathlib.Path.home()/".config/baybos/sg_ftp").read().splitlines() if "=" in l)
ftp = FTP(); ftp.connect(cfg["host"], 21, timeout=30); ftp.login(cfg["user"], cfg["pass"])
ROOT = "baybosfoods.com/public_html"
def put(local, remote):
    with open(local, "rb") as f: ftp.storbinary(f"STOR {remote}", f)
    print("up:", remote)
put(SRC/"index.html", f"{ROOT}/index.html")
try: ftp.mkd(f"{ROOT}/img")
except Exception: pass
for p in sorted((SRC/"img").iterdir()):
    if p.is_file() and not p.name.startswith("."): put(p, f"{ROOT}/img/{p.name}")
ftp.quit(); print("DEPLOY OK -> https://baybosfoods.com")
PY
