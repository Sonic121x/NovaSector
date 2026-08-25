# Nova Sector — Simplified Chinese Localization Fork

> 🇨🇳 简体中文说明见 [README.zh-Hans.md](./README.zh-Hans.md)。

[![CI Suite](https://github.com/sernseek/NovaSector/workflows/CI%20Suite/badge.svg)](https://github.com/sernseek/NovaSector/actions?query=workflow%3A%22CI+Suite%22)
[![Upstream](https://img.shields.io/badge/upstream-NovaSector%2FNovaSector-blue)](https://github.com/NovaSector/NovaSector)
[![Locale](https://img.shields.io/badge/locale-zh--Hans-red)](./strings/i18n/zh-Hans)
[![made in byond](.github/images/badges/made-in-byond.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

This is a downstream of [**NovaSector**](https://github.com/NovaSector/NovaSector) (itself a downstream of
[/tg/station](https://github.com/tgstation/tgstation)) whose sole purpose is a **full-stack Simplified Chinese
localization layer**. Gameplay content is not forked or modified here — upstream is merged in regularly, and
everything this repository adds is translation infrastructure and translation data.

**Please note that this repository contains sexually explicit content and is not suitable for those under the age of 18.**

## What this fork adds

A localization system covering the text players actually see: chat, `examine`, TGUI interfaces, station
announcements, the verb command panel, balloon alerts, and radial menus.

| | |
| --- | --- |
| Catalog entries (English) | 128,753 |
| Translated (zh-Hans) | 126,913 (98%) |
| TGUI frontend catalog | 13,942 entries |
| Localization regression tests | 16 DM unit tests |

Language is selected by a single server config key:

```
I18N_SERVER_LOCALE zh-Hans
```

With the default `en`, the entire translation layer is a **no-op** — no behavior change and no measurable cost.
A pseudo-locale (`qps-ploc`) is shipped for testing that identifiers never get mutated by translation.

### Design constraints

These are the rules the layer is built around, and the reason it can be dropped on top of upstream safely:

- **Machine identifiers stay canonical English.** Action values, `icon_state`s, lookup keys, role names, and
  refs are never translated; only display text is. TGUI payload values are left untouched and translations
  ride along in a separate overlay, so anything a UI sends back to the server round-trips byte-identically.
- **Catalog keys are content hashes**, so upstream rewording invalidates exactly the affected strings rather
  than silently shipping a stale translation.
- **Core file edits are minimized and marked.** Nearly all of this fork lives in `modular_nova/modules/i18n/`
  and generated catalogs; edits inside `code/` are mechanical `LANG()` call sites produced by a codemod.

## Repository layout

| Path | Contents |
| --- | --- |
| [`strings/i18n/<locale>/`](./strings/i18n) | Translation catalogs — flat JSON, importable into Crowdin / Weblate / Lokalise |
| [`modular_nova/modules/i18n/`](./modular_nova/modules/i18n/readme.md) | Runtime: `LANG()`, reverse lookup, display boundaries, fallback layers |
| [`tools/i18n/`](./tools/i18n/README.md) | Rust + Node toolchain: extract, rewrite, resync, lint, machine translation |
| [`tgui/packages/tgui/i18n/`](./tgui/packages/tgui) | Frontend auto-localization and its bundled catalog |
| [`AGENTS.md`](./AGENTS.md) | Architecture notes and the running log of localization failure modes |

Common commands:

```sh
nova-i18n extract          # refresh the English catalog after changing player-visible text
nova-i18n lint             # dangling keys, identifier collisions, bare English
bash tools/i18n/resync.sh  # after an upstream merge
```

## Translating

Catalogs are plain flat JSON keyed by content hash, so they drop straight into any standard localization
platform. Corrections are welcome by pull request against `strings/i18n/zh-Hans/`.

The current Chinese text is largely machine-translated with rule-based guards and ongoing human correction —
treat it as a working draft rather than a finished translation, and please report anything that reads wrong.

## Upstream documentation

Building, running a server, and contribution rules are unchanged from upstream:

| | |
| --- | --- |
| Downloading | [.github/guides/DOWNLOADING.md](.github/guides/DOWNLOADING.md) |
| Running a server | [.github/guides/RUNNING_A_SERVER.md](.github/guides/RUNNING_A_SERVER.md) |
| Compiling | [tools/build/README.md](tools/build/README.md) |
| Modularization guide | [modular_nova/readme.md](./modular_nova/readme.md) |
| Mirroring guide | [modular_nova/mirroring_guide.md](./modular_nova/mirroring_guide.md) |
| Contribution guide | [.github/CONTRIBUTING.md](./.github/CONTRIBUTING.md) |
| Nova Sector Discord | [discord.gg/novasector](https://discord.gg/novasector) |

Build with `tools/build/build.sh` (or `BUILD.bat` on Windows). Building in DreamMaker directly is deprecated
and may fail with errors such as `'tgui.bundle.js': cannot find file`.

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/12/31 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/12/31 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI is licensed as a subproject under the MIT license.

See the footer of [code/\_\_DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

Translation catalogs under `strings/i18n/` are derived works of the upstream text and are covered by the same licenses.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
