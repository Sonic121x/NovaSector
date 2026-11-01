#!/usr/bin/env python3
"""Subset the pixel CJK font to the characters the escape menu shows.

The escape menu (tgui/packages/tgui-escape-menu) is a browser page with its own pixel fonts
(Pixellari, Grand9K Pixel) that have no CJK glyphs. Sending the whole Fusion Pixel font would
cost every client ~7 MB, so only the characters in strings/i18n/escape_menu_labels.json go in.
A character missing from the subset falls back to the system font; nothing breaks.

Run after changing that table (needs fontTools + brotli):
	nix-shell -p 'python3.withPackages (ps: [ps.fonttools ps.brotli])' --run 'python3 tools/i18n/escape-menu-font.py'
"""
import json
import pathlib

from fontTools import subset

ROOT = pathlib.Path(__file__).resolve().parents[2]
TABLE = ROOT / "strings/i18n/escape_menu_labels.json"
SOURCE = ROOT / "modular_zh/modules/i18n/fonts/fusion_pixel_12px_zh_hans.ttf"
OUTPUT = ROOT / "modular_zh/modules/i18n/fonts/escape_menu_zh.woff2"

table = json.loads(TABLE.read_text(encoding="utf-8"))
chars = set()
for locale, labels in table.items():
	if locale.startswith("_"):
		continue
	for text in labels.values():
		chars.update(c for c in text if ord(c) > 0x7F)

options = subset.Options()
options.flavor = "woff2"
options.layout_features = []
options.name_IDs = ["*"]
options.notdef_outline = True
font = subset.load_font(str(SOURCE), options)
subsetter = subset.Subsetter(options)
subsetter.populate(text="".join(sorted(chars)))
subsetter.subset(font)
subset.save_font(font, str(OUTPUT), options)
print(f"{len(chars)} characters -> {OUTPUT.relative_to(ROOT)} ({OUTPUT.stat().st_size} bytes)")
