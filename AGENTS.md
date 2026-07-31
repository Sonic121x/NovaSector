# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

NovaSector is a **downstream fork of /tg/station** (Space Station 13), a round-based multiplayer game written in **BYOND's Dream Maker (DM)** language. The frontend (TGUI) is React + TypeScript bundled with rspack. This repo carries adult content and follows tgstation's code direction, layering its own content on top in a strictly modular way (see Modularization below).

The whole game is one big DM project rooted at `tgstation.dme`, an auto-generated manifest of `#include`s. **Do not hand-edit the `BEGIN_/END_` blocks in `tgstation.dme`** — the build/CI manages file inclusion (and `code/genesis_call.dme` must remain the first include; see its comment).

## Build, run, test, lint

The canonical entrypoint is the Juke-based build script. On Linux:

```sh
tools/build/build.sh            # build everything (DM + tgui); skips steps whose inputs are unchanged
tools/build/build.sh --help     # list all targets
tools/build/build.sh tgui       # build only tgui
tools/build/build.sh tgui-test  # tgui bun tests
tools/build/build.sh lint       # tgui lint (biome + tsc)
tools/build/build.sh --ci lint tgui-test   # exactly what CI runs for tgui
```

In VSCode: `Ctrl+Shift+B` builds, `F5` builds + runs with the debugger. On Windows use `BUILD.bat` / the `bin/*.cmd` wrappers (`server.cmd`, `test.cmd`, `tgui-dev.cmd`, etc.). Building directly in DreamMaker is unsupported and errors out.

TGUI dev workflow (from `tgui/`, package manager is **bun**):

```sh
bun run tgui:dev    # hot-reloading dev server
bun run tgui:build
bun run tgui:test
bun run tgui:tsc
```

### Unit tests

DM unit tests live in `code/modules/unit_tests/` (one file per area, registered in `_unit_tests.dm`). They only run when compiled with `UNIT_TESTS` defined — uncomment `#define UNIT_TESTS` in `code/_compile_options.dm` (CI defines it automatically via `CIBUILDING`). A test run does a single full game setup → run tests → teardown.

**To run one test in isolation**, wrap its type in `TEST_FOCUS(...)` (e.g. `TEST_FOCUS(/datum/unit_test/math)`) — only focused tests execute. `code/modules/unit_tests/focus_only_tests.dm` exists for this. Assertion macros: `TEST_ASSERT`, `TEST_ASSERT_EQUAL`, `TEST_ASSERT_NOTNULL`, `TEST_FAIL`, etc.

### Linting (CI `run_linters.yml`)

CI runs **DreamChecker** (SpacemanDMM, config in `SpacemanDMM.toml`) and **OpenDream** as compile-time linters, plus a battery of Python/bash checks: grep checks (`tools/ci/check_grep.sh` **and** `modular_nova/tools/nova_check_grep.sh`), ticked-file enforcement, define sanity, trait validity, map lint, DMI tests, filedir and changelog checks. SpacemanDMM forbids relative type/proc definitions and the `:` type-override operator — cast instead.

## Modularization — the most important rule of this fork

To stay mergeable with upstream tgstation, **almost all NovaSector changes go in `modular_nova/`, not the core `code/` tree.** See `modular_nova/readme.md` (the full handbook) and `modular_nova/mirroring_guide.md`. Violating this gets PRs rejected.

- **New content** → `modular_nova/modules/<module_id>/`. Inside, separate by type: `code/` (`.dm`), `icons/` (`.dmi`), `sound/`. **Do NOT mirror the core folder structure** inside a module (`modular_nova/modules/foo/code/thing.dm`, not `.../code/modules/antagonists/...`). Non-trivial modules need a `readme.md` (template: `modular_nova/module_template.md`).
- **Overrides of core files** (overriding a core proc, adding vars to a core type) → `modular_nova/master_files/`, which **must mirror the core path** (`code/modules/mob/living/living.dm` → `modular_nova/master_files/code/modules/mob/living/living.dm`). Prefer extending via `. = ..()` over copy-pasting whole upstream procs.
- **Defines** used across more than one file → `code/__DEFINES/~nova_defines/`. Single-file defines should be declared at the top and `#undef`'d at the bottom of that file.
- **Maps**: never edit upstream `.dmm` maps directly (held to the same standard as icons). Use the **automapper** (`modular_nova/modules/automapper`, config in `automapper_config.toml`) — template automapper for rooms, simple area automapper for single items.
- **Binaries/assets**: never modify core binary files. New clothing icons go into the existing files in the `master_files` clothing section.

### NOVA EDIT comments (when core edits are unavoidable)

When you must touch a core file, mark it precisely so merge conflicts stay tractable, and log the change in the module's `readme.md`:

```dm
// NOVA EDIT ADDITION START - MODULE_ID - (optional reason)
... added lines ...
// NOVA EDIT ADDITION END

something = 2 // NOVA EDIT CHANGE - ORIGINAL: something = 1

/* // NOVA EDIT REMOVAL START - MODULE_ID - (reason)
... removed lines ...
*/ // NOVA EDIT REMOVAL END
```

Avoid multiline single-`CHANGE` edits — use a REMOVAL block + ADDITION block instead. In **modular** files don't comment out dead code, delete it (git blame exists); this rule does not apply to core/NOVA-EDIT changes.

> **DM indentation is syntax — the `/* … */` REMOVAL block above is only safe at column 0, i.e. when removing whole top-level definitions.** To remove lines *inside a proc body*, use a single-line indented comment instead (`\t// NOVA EDIT REMOVAL - MODULE_ID - ORIGINAL: <the line>`). A `*/` sitting at column 0 **terminates the enclosing proc**, and every remaining body line is then parsed as a new type definition — producing dozens of misleading `duplicate definition` / `empty type name (indentation error?)` errors far from the real cause. Neither `nova-i18n extract` nor DreamChecker catches this (their parsers are more lenient); **only a real DreamMaker compile does**, so compile before you push.

### Modular TGUI

All TGUI lives in `tgui/packages/tgui/interfaces/` (and subdirs) — there is no separate Nova folder. **A brand-new Nova UI file must start with `// THIS IS A NOVA SECTOR UI FILE` on line 1** and needs no further edit comments. Editing an *upstream* `.tsx`/`.jsx` follows the same NOVA EDIT comment rules as DM (inline `// NOVA EDIT` or `/* NOVA EDIT */`).

## Conventions

- **Changelog**: player-facing PRs add a YAML file under `html/changelogs/` (copy `example.yml`); indent changes with **two spaces, not tabs**; valid prefixes include `bugfix`, `qol`, `rscadd`, `rscdel`, `balance`, `code_imp`, `refactor`, `imageadd`. CI checks this.
- **Indentation**: `.dm`, `.json`, `.md` use **tabs**; everything else (including JS/TS via biome) uses spaces. See `.editorconfig` and `biome.json`.
- **Security-sensitive DM** (from `.github/guides/STANDARDS.md`): treat all player input as malicious; re-validate context *after* any input/prompt resolves (input-stalling exploits); parameterize SQL queries and use `format_table_name()`; never `locate(ref)` without scoping to a list; validate all Topic href calls. New player-facing UIs must be TGUI.
- More guides live in `.github/guides/` (STYLE, STANDARDS, MAPS_AND_AWAY_MISSIONS, TICK_ORDER, HARDDELETES, atomization, etc.).

## Code layout (orientation)

- `code/` — core tgstation DM. Key subdirs: `controllers/` (subsystems & the master controller), `datums/`, `game/`, `modules/`, `__DEFINES/`, `__HELPERS/`, `_globalvars/`.
- `modular_nova/` — all NovaSector code (`modules/`, `master_files/`, `tools/`).
- `tgui/packages/` — frontend (`tgui` interfaces, `tgui-core`, dev/bench/sonar servers).
- `_maps/` — map definitions and map configs. `config/` — server config. `tools/` — Python/bash/C# tooling for CI, mapping, icons, changelogs.

## 国际化 / 汉化 (i18n)

全量本地化（首发 zh-Hans）。模块手册 `modular_nova/modules/i18n/readme.md`（含「文件地图」）；命令手册 `tools/i18n/README.md`。**全服语言由 config `I18N_SERVER_LOCALE` 控制；locale==en（默认）时所有翻译层 no-op。**

**运行时（DM）**：`LANG("key", args)` 按全服 locale 查 `strings/i18n/<locale>/<ns>.json`，位置占位符 `{0}/{1}`，缺失回退英文。**目录 key = 内容哈希，勿手改**（改 key 丢翻译）。改了玩家可见英文文案要跑 `nova-i18n extract` 刷新英文目录。`i18n.dm`（定义 LANG）必须在 `tgstation.dme` **极早**包含。运行时分层（均 gated locale≠en）：
- **P1（TGUI 负载反查）**：`get_payload`→`lang_reverse_tree`/`lang_reverse_phrase_tgui`（tgui.dm）对 `ui_data`/`ui_static_data` 的**多词字符串**反查（单词跳过防碰撞）；exact miss 且多词再过边界模板引擎。`i18n_payload_skip_keys`（id/buttons/列表等 act 标识符 key）整列表不反查。
- **反查表**：`lang_reverse_text`（整串精确、全量含单词）；`build_i18n_cache` 合并 locale 目录**所有** `*.json`，含手维护反查文件（en+zh 同 key）`_state_words`/`_fallback`(zh-only AC)/`_cargo_groups`/`_examine_tags`/`_paper_blanks`/`_root`/`_wires`(WIRE_* define 值：wires ui_data 显示字段反查、act 走 color)/`_templates`(运行期拼接 `{0}` 模板：DNA vault 报告行、电路板 `(Machine Board)` 后缀名、SM 完整性播报——边界模板引擎按锚命中) 等。`lang_unreverse_text` = zh→en（act 回传容错：`map[x] || map[lang_unreverse_text(x)]`）。
- **AC 子串兜底**（`lang_fallback_apply`，fallback.dm，rustg Aho-Corasick，**仅多词**）：挂 browse/状态栏/公告/maptext；聊天另受 config `I18N_CHAT_FALLBACK`（默认关）。AC 是**最短匹配**会把长句拆碎 → 长句在落地点先整串反查（`lang_localize_chat_sentence`）。
- **边界模板引擎**（`template_match.dm`）：目录已译 `{0}` 模板在输出边界整句命中（AC 锚→findtext 验证→捕获实参递归本地化）；挂 `lang_fallback_apply` 内、字面 AC 之前。单测 `i18n_template_match`。
- **LANG 实参链**（`lang_localize_arg`）：状态词表→`lang_pronoun`（代词/系动词 + `\the`/`\a` 冠词剥离 + `it's`/`they're` 缩写）→整串反查。文本宏（`\s`/`\he`…）由 `i18n_text_macro_regex` 剥。
- **落地反查钩子**：atom name/desc（`/atom/Initialize`；turf 另在 turf.dm；**排除 landmark**=出生点标识符）；datum 家族 New()（reagent/action/quirk/disease/material）；早于 i18n_cache 的 GLOBAL_LIST_INIT 母版表在 SS Init 补反查（gas/reagent…）；examine 显示点 `lang_reverse_text(desc)`。

**TGUI 前端**：JSX 静态文本经 `tgui/i18n` jsx-runtime `localizeProps` auto-localize（children + `TRANSLATABLE_PROPS`）按英文查 `tgui/packages/tgui/i18n/<locale>.json`（`tgui-catalog.mjs sync` 从 `strings/i18n/<locale>/tgui.json` 同步）。误翻豁免 `localize.ts` 的 `NO_AUTO_TRANSLATE`。**标识符耦合显示名**（职业/怪癖/选项/交互名，值兼 act/查表键）走 TS 端：act 回传英文 value、只翻 displayText；裸字符串下拉选项一律不翻（`localizeOption`），要中文用对象选项 `{value:英文, displayText:可翻}`。DM 名经 `DM_LABEL_SOURCES`（正则）/AST `nova-i18n labels`（choiced 下拉、类型作用域名）抽进 tgui.json。

**工具（Rust `tools/i18n/`，dreammaker 解析器）**：
- `nova-i18n extract` — 抽玩家可见英文到 `strings/i18n/en/`。覆盖：sink/`SINK_VARS`（type 变量 name/desc/message/`description`/taste_description/gain_text/lose_text/playstyle_string/singular_name/placeholder_*…）、**激进 pass**（proc 体/初值里**带句末标点**的句子，含插值模板——句末标点=排除 act/枚举/路径/SQL 标识符的安全闸）、proc 句子型 `return`、flavor 数据文件、verb 显示名、config 数据（`flavor.rs` 的 blanks/interactions）。抑制：日志/管理员 sink、`/datum/unit_test`。
- `nova-i18n rewrite` — 幂等改写 sink 字符串为 `LANG()`（to_chat/visible_message/audible_message/balloon_alert/say/manual_emote/examine `.+=`/alert/input/tgui_*；只改消息+标题，**不动**选项/返回值/`==` 比较）。核心文件首行加 `// NOVA EDIT - I18N CODEMOD`。公告 sink 走 `interp_only`（只改插值）。
- `nova-i18n labels`（AST→tgui.json）/`nova-i18n verbs`（编译期注入 verb 名，中文构建走 `build-verbs-zh.sh`、不入库）/`nova-i18n lint`（标识符碰撞门禁）/`nova-i18n pseudo`（伪 locale 查未接通路径）；`tgui-catalog.mjs extract/sync`。
- 上游合并后 `bash tools/i18n/resync.sh`（本地手动，**无 CI**）。
- 翻译：`bun tools/i18n/mt/i18n-mt.ts`（后端 codex/claude/openai，配置 `tools/i18n/mt/.env`）；术语 `glossary.zh-Hans.json`；故意保持英文白名单 `keep-english.<locale>.json`（`mark-english` 种子）；保留 `{0}`/HTML/DM 宏。

**运行（NixOS）**：`nix develop`→`tools/build/build.sh`→`DreamDaemon tgstation.dmb <port> -trusted`；`librust_g.so` 自动软链（缺它卡死）；`RAYON_NUM_THREADS=2`（防 32 位 iconforge OOM——表现停大厅、服务端不刷日志，**非 i18n bug**）。

**覆盖现状**（勿误解为「全已汉化」）：抽取 ~74k 条（TGUI ~4.9k）；运行时 LANG ~16k 处。未接：纸张书写（不该译）、verb keybind 标识符、摄像头/地图 c_tag（地图数据）、极少数动态拼接（聊天 AC 兜底）。实际覆盖仍需人工校对（在线平台导入导出扁平 JSON）。

**排查规律（先跑检测器，别凭经验逐条；新规律优先扩检测器 lint.rs/SINK_VARS/DM_LABEL_SOURCES）**：
- **检测器**：标识符被反查误翻（TGUI 蓝屏/出生错位/「按了没反应」/icon_state 中文）→ `nova-i18n lint`（扫 `==`/switch/下标位置碰撞，含目录卫生查多出占位符）+ `bash tools/i18n/pseudo-test.sh`（qps-ploc 下跑全量单测，抓运行期实际变异回归）；某路径没接通（selected 中文选项英文、漏接 raw browse/maptext/新 sink）→ `nova-i18n pseudo` + `pseudo-scan.mjs`；**生产服持续采集**（config `I18N_LOG_MISSES`，miss_log.dm）→ 经全部翻译层后残留的多词英文自动记 `i18n_misses.log`，`node tools/i18n/miss-scan.mjs <log>` 按频次聚合并自动分桶到下条①②③（口音替换词池 `*_replacement.json` 自动归「词池保英文」桶，无需处理）。抽取器漏一整类时先怀疑**遍历缺口**而非逐条补（实测 extract 的 visit_stmt 漏 ForList 分支 → 所有 for-in 循环体一个没抽，补一个分支多收 ~1400 条；rewrite.rs 同病未修，见 tools/i18n/README「已知事项」）。
- **「目录已译却显英文」先归类**：① **路径绕过 P1/sink**（静态 JSON asset `/datum/asset/json/*`、screentip maptext、非 sink 发送点如 `radio.talk_into`、运行期拼接/插值句、`print_command_report`）→ 落地点补反查（`lang_reverse_text`/`lang_localize_display_name`/`lang_fallback_apply`/`lang_localize_job_description`，注意同一文本多条渲染路径各自接）；② **没进目录**（源码外 config 数据、`new /datum/stack_recipe("title",…)` 构造参数、`#define` 值、`+" (Alt)"` 拼接名、proc-return 插值）→ 抽取器加源 或 手维护 `_<feature>.json`（稳定小集合）；③ **partial/bad MT**（grep zh 目录确认 zh 值本身含英文）→ 改译文；④ **陈旧构建**→重编。
- **标识符耦合（值兼 act/查表键/比较）一律保英文**（登记统一改 `strings/i18n/policy.json`——三端策略单一来源，DM `i18n_payload_skip_keys`/TS `NO_AUTO_TRANSLATE`/Rust `identifier_dot_procs` 都从它加载，lint 校验它；改完跑 `tgui-catalog.mjs sync` 刷前端副本）：服务端发的字符串列表进 `payload_skip_keys`（否则下拉**中英混排** + 发送/路由失败）；前端查英文常量表（MATERIAL_ICONS…）的发英文 `id`；UI 回传译名查英文键表用 `lang_unreverse_text` 兜（chem dispenser/cargo…）；`. +=` 在 update_overlays/StripMenu/key_name 等 proc 是 icon_state/act 键 → `is_identifier_dot_proc` 黑名单。判别：某「选择/发送」功能失效 + 下拉中英混排 → 服务端列表被 P1 译了多词项。
- **「键同时是显示文本」的字段，绝不能靠「假设 P1 不会翻它」**——必须把键挪进 `payload_skip_keys` 里已有的字段名（`id` 最省事），显示另发一份。地图投票踩过：选项键放在 `"name"` 里（`name` 不在跳过名单），多词 map_name（`Delta Station`/`Ice Box Station`）被 P1 译成中文 → act 回传中文 → `choices[中文]++` 建幽灵条目 → 真键**永远 0 票**、结束换不了图。**判别信号极其锐利：单词选项正常、多词选项失效**（`MetaStation`/`NebulaStation` 能投，`Delta Station` 不能）→ 一定是 P1 的多词反查动了 act 键。注意这类 bug 常由「往目录补词」引入（该案是补 17 个站点名进 `_map_names.json` 那次），改词表时要想一遍「这些词会不会正好是某处的 act 键」。另外**计票/查表侧应拒绝未知键**（`if(!(x in choices)) return`）而不是无条件 `++`，否则脏值会静默污染数据结构、把根因藏起来。
- **`payload_skip_keys` 是「整子树」跳过，会连坐纯显示字段**（→ 整个面板动态内容全英文）。典型：`items` 在跳过名单里（因为 `name` 是 `act('buy')` 的回传键），于是同一条目里的 `desc`/`tooltip` 也一并不反查——绑架者终端 12 件装备名+9 条描述**目录里全有译文却全显英文**就是这么来的。**判别：某 TGUI 面板「静态 JSX 都翻了、动态列表项全英文」→ 查该列表的键在不在 `payload_skip_keys`**（`grep` policy.json；别去查目录，目录里有译文会误导你以为已接通）。修法三件套：① DM 落地点显式 `lang_reverse_text(name/desc)`；② 另发一个英文 `id` 字段专供 act，前端 `item.id ?? item.name`（同 `Fabrication/Types.ts` 的 MATERIAL_ICONS 套路）；③ DM `ui_act` 用 `AG.name == x || AG.name == lang_unreverse_text(x)` 兜老客户端。**别直接把键从 `payload_skip_keys` 删掉**——那会让 act 回传值一起被译，功能直接坏。
- **碎片/连接词/状态词**：examine 的 `english_list` 连接词改顿号（**多处独立**，grep `english_list(` 逐处）；状态词/标签词/力量词/食物类别等有限集进 `_state_words`/`_examine_tags`/`_root`（落地点显式 `lang_reverse_text`，单词类天然不污染全局）。examine 残留多是**生成器**（english_list/bitfield_to_list/sink 漏网）而非个别串。
- **同一专名多个译名 = 术语表匹配大小写敏感，不是术语表漏收**：DM 里同一专名有两套写法——datum 显示名首字母大写（`Multiver`），obj 的 name/desc 按 SS13 惯例全小写（`multiver bottle`、`A small bottle of multiver.`）。术语表通常只收得到大写那条，`sourceTermPattern` 从前大小写敏感 → 小写那半**永远命中不了术语提示**，MT 每次现编 → 一个试剂六七种叫法（实测 syriniver 6 种、multiver 7 种）。**判别信号：`grep -i` 目录能查到同一英文的大小写两种写法，而术语表里只有一条。** 已改为大小写不敏感（`tools/i18n/mt/i18n-mt.ts` 的 `sourceTermPattern`，`iu`），一次把 `terms` 检出量从 1314 抬到 4456。两个例外必须保留大小写敏感：**全大写缩写**（AI/ID/NT，小写形式是别的词）与 `CASE_SENSITIVE_TERMS`（换个大小写就是普通英文词：Straight/Cream/Cook/Criminal/robust/byond…，否则 "ice cream" 被要求译成奶油）。**玩家报「译名不统一」时不要手改那几条**——先跑 `bun tools/i18n/mt/i18n-mt.ts terms` 看该词全部渲染点（实际数量通常是玩家报的两倍），定规范译名进 glossary（带 `note` 说明小写形式同此译名），再统一改全部条目。
- **一词多义靠「类型路径限定」，不靠 MT 猜**：`nova-i18n extract` 会额外产出 `strings/i18n/scopes.json`（key → 该串出现过的**完整 DM 类型路径**；覆盖 83%，缺的是 tgui.json 与手维护表这类本就没有 DM 类型的）。术语表条目因此可以按语境拆义项——`"Base": [{"scope":"/datum/reagent","zh":"碱"}, {"scope":["/area","/turf"],"zh":"基地"}, {"zh":"基础"}]`，**最长前缀命中优先，无 scope 的是兜底**，一个都不命中就不检查该词。这比往句子里猜上下文可靠：语境信号本来就在源码结构里。注意 `scopes.json` **必须放在 locale 目录之外**（与 `policy.json` 同级）——`build_i18n_cache` 会把 locale 目录里每个 `.json` 全量并进反查表，放进去等于让类型路径变成可反查的「译文」。已被 rewrite 改写的串源码里只剩 `LANG("key")`，其 scope 从**调用点**回收（`extract.rs` 匹配宏展开后的 `lang_format`/`lang_format_for`，AST 里没有 `LANG`）。**TGUI 侧暂无此机制**：tgui.json 以英文原文为 key，同一个 `"Basic"` 被化学反应室和设置面板共用，类型路径救不了，得靠按 interface 文件分域（未做）。
- **config 数据陷阱**：`config_entry` 的 `default` 进目录但**服务器 config/*.txt 设了同名键就用 config 值**（译 default 无效）→ 直接在 config 文件译。
- **maptext「模糊」= 字体/字号（非翻译）**：用打包的 Fusion Pixel 中文像素字体，**必须放 font-family 首位**（BYOND 不跨字体回退）；**字号必须整数 pt**（小数如 7.5pt→非整数 px→糊；6pt=8px/9pt=12px/12pt=16px/18pt=24px）；**runechat 字体来自外层 `.maptext` 类**（经 MAPTEXT 宏包裹）非 `.center`。skin.dmf 改完**重编**（先关服务器防 `.rsc` 锁致 icon-cutter 报 `invalid expression`；勿 `git reset --hard`，否则 `--force-recut`）。诊断渲染问题靠问玩家（无法渲染验证）。
- **输入框中文发不出** = `reject_bad_text(ascii_only=TRUE)` 拒非 ASCII（非 i18n bug）；**列表选项「少一个字」** = `tgui_input_list` 字符白名单 `[^ -耀]` 砍 U+8000 以上 CJK（已修 `￿`）→ 任何「中文少字」先查字符范围白名单。
