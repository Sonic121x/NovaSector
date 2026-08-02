# AGENTS.md

## Project

NovaSector is a downstream fork of `/tg/station`: BYOND Dream Maker (DM) backend plus React/TypeScript TGUI.

- `tgstation.dme` is generated. Never hand-edit its `BEGIN_`/`END_` include blocks; `code/genesis_call.dme` must remain the first include.
- Follow upstream tgstation direction and keep Nova changes modular so upstream merges remain tractable.

## Build and validation

Use the Juke build entrypoint; direct DreamMaker builds are unsupported.

```sh
tools/build/build.sh                  # DM + TGUI
tools/build/build.sh dm               # DM only
tools/build/build.sh tgui             # TGUI only
tools/build/build.sh tgui-test        # TGUI tests
tools/build/build.sh lint             # lint and type checks
tools/build/build.sh --ci lint tgui-test
```

On NixOS, enter `nix develop` first. TGUI uses Bun. Windows uses `BUILD.bat` or `bin/*.cmd`.

- DM unit tests live in `code/modules/unit_tests/` and are registered in `_unit_tests.dm`.
- `TEST_FOCUS(/datum/unit_test/...)` isolates a test locally; never commit a focus marker.
- CI also runs DreamChecker/OpenDream and repository-specific checks. SpacemanDMM forbids relative type/proc definitions and `:` type overrides.

## Modularization

Almost all Nova changes belong under `modular_nova/`; see `modular_nova/readme.md` and `modular_nova/mirroring_guide.md` for the full rules.

- New content: `modular_nova/modules/<module_id>/`; do not reproduce the core directory tree inside a module.
- Core overrides or added vars/procs: `modular_nova/master_files/`, mirroring the original `code/` path. Prefer `. = ..()` over copied upstream procs.
- Shared defines: `code/__DEFINES/~nova_defines/`. Single-file defines belong at the top and must be `#undef`'d at the bottom.
- Maps: never edit upstream `.dmm` files directly; use `modular_nova/modules/automapper`.
- Binary assets: never modify upstream binaries. Put Nova assets in the appropriate modular/master files location.
- Non-trivial modules need a `readme.md` based on `modular_nova/module_template.md`.

### Unavoidable core edits

Mark core changes precisely and document them in the owning module readme:

```dm
// NOVA EDIT ADDITION START - MODULE_ID
// NOVA EDIT ADDITION END
value = 2 // NOVA EDIT CHANGE - ORIGINAL: value = 1
```

Use REMOVAL/ADDITION blocks for multiline replacements. DM indentation is syntax: inside a proc, record a removed line with an indented single-line `NOVA EDIT REMOVAL` comment; never place a column-zero block-comment terminator inside a proc. Confirm core DM edits with a real DM compile.

### TGUI

TGUI remains under `tgui/packages/tgui/interfaces/`; there is no modular Nova TGUI tree.

- A new Nova UI file starts with `// THIS IS A NOVA SECTOR UI FILE`.
- Edits to upstream JSX/TSX use precise `NOVA EDIT` markers.

## Conventions

- `.dm`, `.json`, and `.md` use tabs; JS/TS and other files use spaces. Follow `.editorconfig` and `biome.json`.
- Player-facing changes add `html/changelogs/*.yml`; copy `example.yml` and use two-space YAML indentation.
- Treat player input as hostile. Revalidate context after prompts, parameterize SQL with `format_table_name()`, scope `locate(ref)` to an allowlist, and validate Topic href actions.
- New player-facing interfaces must use TGUI.
- Detailed style/security/map rules live in `.github/guides/`.

## Commits

- Keep subjects concise and describe the delivered change, not the conversation that requested it.
- Use a short body only when it adds essential rationale or compatibility notes.
- Never copy user prompts, chat transcripts, investigation diaries, model attribution, or routine validation output into commit messages.

## Layout

- `code/`: upstream/core DM.
- `modular_nova/`: Nova modules, overrides, and tools.
- `tgui/packages/`: frontend packages.
- `_maps/`: map definitions and configs.
- `config/`: server configuration.
- `tools/`: build, CI, map, asset, changelog, and i18n tooling.

## Internationalization

Full documentation: `modular_nova/modules/i18n/readme.md`; command reference: `tools/i18n/README.md`.

- `I18N_SERVER_LOCALE` selects the server locale; `en` is the no-op default.
- Runtime text uses `LANG("key", args)`. Catalog keys are content hashes: never edit them by hand. After changing player-visible English, run `nova-i18n extract`.
- `i18n.dm` must remain included early in `tgstation.dme`.
- Machine identifiers—IDs, action values, lookup keys, role names, icon states, refs—must stay canonical English. Send a separate localized display label and reject unknown submitted keys.
- `strings/i18n/policy.json` is the shared policy source for DM, TGUI, and Rust tooling. Sync TGUI after changing it.
- TGUI action values remain English. Localized choices use `{ value: englishId, displayText: localizedLabel }`; bare string options are intentionally not translated.
- Preserve `{0}` placeholders, HTML structure, and DM text macros in translations.

Primary commands:

```sh
nova-i18n extract
nova-i18n rewrite
nova-i18n labels
nova-i18n lint
nova-i18n pseudo
bash tools/i18n/pseudo-test.sh
bash tools/i18n/resync.sh       # after upstream merges; not CI
bun tools/i18n/mt/i18n-mt.ts
```

Debug i18n by category, not by patching isolated strings:

1. Run `nova-i18n lint` and the pseudo-locale checks first.
2. If translated UI text breaks an action, inspect identifier/display separation and `policy.json`.
3. If cataloged text stays English, identify whether the render path bypasses LANG/P1, extraction missed the source class, the translation is partial, or the build is stale.
4. Fix recurring misses in the extractor, rewrite rules, label sources, or policy rather than adding one-off entries.

Known trap classes:

- **Catalog entry exists but the UI still shows English** — compare the key byte-for-byte with what the runtime actually looks up. TGUI keys must be the *post-JSX-transform* string: `tgui-catalog.mjs` decodes HTML entities (`&apos;` `&nbsp;` `&ensp;` …) because `JsxText.text` keeps them raw while React does not. An entity in a catalog key is a dead key; an entity in a translation renders literally to the player. `tgui-catalog.mjs extract` warns on both.
- The TGUI English catalog is `new ∪ historical` and never prunes, so a bad-key class survives every re-extract until it is migrated explicitly.
- **按 proc 语义界定，不要按变量名穷举** — examine/`. +=` 类累加器原先靠一张手写变量名白名单，任何局部名（`how_cool_are_your_threads += "…"`）都会漏。`extract::ProcCtx` 改为按 proc 名判定 examine 家族；放宽准入时配一道整句闸门（`is_examine_sentence`），否则拼句碎片（`" and "`、`" (good)"`）会各自入目录，被 AC 层在半句处替换成语序错乱的中文。
- `. += span_notice("A") + "\n" + span_notice("B")` 这类**拼接链**，整条 `build_template` 会把兄弟片段变成 `{0}/{1}`，抽出改写侧永远跳过的废键（一行多个字面量无从定位）。按操作数拆开逐段抽。
- 英式/美式拼写会让 SINK_VARS 看着已覆盖实则全漏：`flavor_text` 在表里、`flavour_text`（幽灵角色入场文字）整类没抽到。
- 译文里的 DM 复数宏 `\s` 要**去掉**——中文名词后会渲染出多余的 "s"。目录既有约定即如此。
- **TGUI 混排 children 必须整条抽成模板** — `<Box>Reduced by {n}% when infected.</Box>` 的 children 是 `["Reduced by ", n, "% when infected."]`。逐段翻会按英文语序拼回去（「减少了 2 感染病毒时的%。」），中文语序不同 → 碎片翻译必错，比不翻更糟。`tgui-catalog.mjs childrenTemplate` 整条抽成 `Reduced by {0}% …`，`localize.ts localizeChildrenTemplate` 整条查表再回填占位符；占位符数量对不上就整条保持英文，绝不回退逐段翻。抽取期的空白处理要与 JSX transform 逐字节一致（`jsxTextValue`，Babel 同款规则）。
- `build_template` 对「去标签后不含字母」的表达式返回 `None`，这是一道**正经防线**（挡住 `VV_DROPDOWN_OPTION` 那种把 admin 操作标识符夹在 HTML 里的写法）。绕过它去拆内插时，必须限死「整条就是一个内插」的形状（lead 与各段尾巴皆空），否则会把 VV 面板的标识符抽进目录。
- 目录只合并、从不裁剪：跑坏一次抽取留下的脏键会一直留着（含新建的 `<ns>.json` 未跟踪文件）。改抽取规则时先 `git checkout strings/i18n/en` 再重抽，并用 `git status` 查未跟踪的新命名空间文件。
