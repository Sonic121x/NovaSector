#!/usr/bin/env python3
"""Compile the localization changelog (html/changelogs/localization/*.yml) into its monthly archive.

This is the fork's own changelog: localization work and fixes made in this repository, shown in the
in-game changelog under its own tab. It deliberately lives outside html/changelogs/archive so that
upstream's compiled archive files never conflict with ours on an upstream merge.

Entry files use the same format as upstream's (see html/changelogs/example.yml), with one optional
extra field, `date: YYYY-MM-DD`, for back-filling a change on the day it actually shipped. Without it
the entry is dated today, exactly like upstream's compiler.

The output format matches tools/ss13_genchangelog.py, except that non-ASCII text is written as-is
(upstream's yaml.dump escapes it to \\uXXXX, which makes Chinese entries unreviewable in a diff).

Usage: python3 tools/i18n/compile-localization-changelog.py [html/changelogs/localization]
"""

import datetime
import glob
import os
import sys

import yaml

# Keep in sync with validPrefixes in tools/ss13_genchangelog.py; the TGUI changelog maps these to icons.
VALID_PREFIXES = {
    "bugfix", "wip", "qol", "soundadd", "sounddel", "rscadd", "rscdel", "imageadd", "imagedel",
    "spellcheck", "experiment", "balance", "code_imp", "refactor", "config", "admin", "server",
    "sound", "image", "map",
}


def load_month(path):
    if not os.path.exists(path):
        return {}
    with open(path, encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def main():
    yml_dir = sys.argv[1] if len(sys.argv) > 1 else "html/changelogs/localization"
    archive_dir = os.path.join(yml_dir, "archive")
    os.makedirs(archive_dir, exist_ok=True)

    months = {}
    for file_name in sorted(glob.glob(os.path.join(yml_dir, "*.yml"))):
        name = os.path.splitext(os.path.basename(file_name))[0]
        if name.startswith(".") or name == "example":
            continue
        with open(file_name, encoding="utf-8") as f:
            entry = yaml.safe_load(f) or {}

        date = entry.get("date", datetime.date.today())
        if isinstance(date, str):
            date = datetime.date.fromisoformat(date)
        author = entry.get("author")
        changes = entry.get("changes") or []
        if not author:
            sys.exit(f"{file_name}: missing author")

        month_key = date.strftime("%Y-%m")
        month_path = os.path.join(archive_dir, month_key + ".yml")
        if month_key not in months:
            months[month_key] = load_month(month_path)
        author_entries = months[month_key].setdefault(date, {}).setdefault(author, [])

        added = 0
        for change in changes:
            (change_type, _), = change.items()
            if change_type not in VALID_PREFIXES:
                sys.exit(f"{file_name}: invalid prefix {change_type}")
            if change not in author_entries:
                author_entries.append(change)
                added += 1
        print(f"{file_name}: {added} new entries -> {month_key}")

        if entry.get("delete-after", False):
            os.remove(file_name)

    for month_key, entries in months.items():
        with open(os.path.join(archive_dir, month_key + ".yml"), "w", encoding="utf-8") as f:
            yaml.dump(entries, f, default_flow_style=False, allow_unicode=True, sort_keys=True, width=100)


if __name__ == "__main__":
    main()
