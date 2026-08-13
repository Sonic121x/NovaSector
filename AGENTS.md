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
- **TGUI 下拉的英文是设计缺口、不是漏译** — P1（`lang_reverse_phrase_tgui`）对「本身就是 tgui 目录键」的负载值**故意保持英文**，把显示交给 TS 端 auto-localize，好让 `act()` 回传仍是英文标识符；单词串（`"Assistant"`）连多词门槛都过不了。但 `localizeOption` 又对**裸字符串选项**一律不翻（`m(o)=o`，翻了回传就变中文）。两侧各自正确、合起来就是「下拉永远英文」。修法在 `localize.ts localizeDropdownProps`：运行时把裸字符串升级成 `{value: 英文, displayText: 译文}`，并按 `selected` 补 `displayText`（Dropdown 收起时显示的是 value 不是 displayText）。识别靠 `type === Dropdown` 组件标识，**不能**按「有 options prop」猜——界面里自定义组件也叫 options（AdminFax/LogViewer 是 `string[]`）。
- **可翻 prop 名清单必须单一来源** — 抽取器与 `localize.ts` 各存一份时，新增 prop 只改一边 → 「目录有键界面不翻」或「界面翻了目录没键、MT 永远漏」。已收进 `strings/i18n/policy.json` 的 `translatable_props` / `option_text_props`。`Button.Confirm` 的 `confirmContent`（满屏「Confirm?」）就是这么漏了整整一类。
- **JSX 属性里的 `'A' + 'B'` 折行拼接**：JS 求值后是一整串，运行时按整串查表，逐个操作数抽出的半句是死键。`addDisplayExpr` 对 `+` 链做纯字面量折叠（`foldStringConcat`）；含表达式的拼接（`'Tank (' + moles + ')'`）形状不可复原，**整条不抽**——同混排 children 的道理。
- **`capitalize()` 显示层把整类译文打掉** — DM 惯例「小写存、显示时 `capitalize()`」（手术名、伤口/器官/试剂名、`"[capitalize(x.name)]"` 拼句），而目录键保留源码原样的小写 → 精确反查与 AC 字典双双 miss。`lang_build_reverse` 为**多词**小写键登记首字母大写变体；单词键**不登记**（`move`/`clear`/`ready` 是标识符形态，会把 `switch("Clear")` 拖进反查面——与 P1 多词门槛、AC 多词过滤同一条安全线）。单词类仍需落地点收口。改了这条变体规则要同步 `lint.rs` 的碰撞集合，否则门禁看不见新暴露面。
- **DM 单词显示名到不了前端** — P1 对「本身就是 tgui 目录键」的负载值故意保持英文（留给 TS 只翻显示、`act()` 回传仍是英文），而单词串连多词门槛都过不了。于是 `mutation.Name` 这种「前端既显示又当标识符用」的值，译文明明躺在 `datum.json` 里却永远显英文。修法不是改 P1，是把该类型的 name 经 `labels.rs TYPE_VAR_RULES` 桥进**前端目录**（按类型路径，覆盖全部子类型、上游移动文件不失效）。判据：前端是否拿它做比较/取 ref（`m.Name === name`、`Name !== 'Monkified'`）——是则必须走这条桥，绝不能让 P1 改数据。
- **AC 自动机一律要 LeftmostLongest，默认 Standard 取最短匹配** — 这条踩过两次，第二次代价大得多。字面 AC（fallback.dm）早就换了；**模板逆匹配引擎的锚自动机漏了**，还留着一句「重叠锚被遮蔽只是少收一个候选、不影响正确性」的注释——不成立，少收的正是对的那个：`" begins to make an incision in "` 把 `" begins to make an incision in the organs within "` 整个遮住，更短的通用锚还能把两条一起遮住，于是唯一匹配得上的模板根本不进候选，整句原样留英文。所有插值句（手术每一步的可见消息、examine 拼句…）都吃这一刀。`i18n_real_catalog` 守这条。
- **tgui.json 也在全局反查表里** — 「值兼标识符的显示词就抽进前端目录、让 TS 只翻显示」这条路对**多词**成立，对**单词**不成立：`build_i18n_cache` 扫 locale 目录下**全部** .json，tgui.json 也在内，所以往里塞 `blue`/`purple`/`gold` 等于毒化整个 DM 侧的 `lang_reverse_text`（P1 有 `i18n_tgui_strings` 守卫，`lang_reverse_text` 没有）。线缆颜色这么塞过一次，被 `i18n_real_catalog` 的「**不应**进反查表」断言当场抓住。单词类显示词要么走域内表（`lang_scoped_table`），要么在 ui_data 里另发一个显示字段（线缆最终用后者：`shownColor` 继续当 CSS 颜色名与 act 值，另加 `shownColorLabel` 供前端作 label）。
- **悬空 LANG key 比不翻译严重得多** — 抽取与改写是两条独立通道，任何「让 extract 跳过、rewrite 不跳过」的规则都会产出 `LANG("obj.b045da9c")` 而目录里没这条；`lang_resolve` 兜底**返回 key 本身**，玩家看到的就是这串乱码。一次实测全仓三万余处调用里有 76 个（耳机频率表、无人机分发器、血虫技能、雇佣合同…）。`nova-i18n lint` 现在把它当**错误**扫。要回填原文：`git log -S<key> -- <file>` 找引入 commit，从 diff 的 `-` 行取字面量，用 `nova-i18n key <ns> <tpl>` 的 hash **校验**再写回（76 条里 72 条能这么自动恢复，剩下的是多行续行串，手拼后同样按 hash 验）。注意占位符按**出现次数**编号：同一个 `[employee_name]` 出现两次就是 `{0}` 和 `{1}`。
- **假数据测不出真目录的坑** — `i18n_template_match` 注合成模板验证引擎逻辑、`i18n_unreverse` 验证反查往返，两者全绿，而真目录里那条就是翻不出来（锚遮蔽只在成千上万条真锚互为前缀时才发生）。要有一个**拿真目录、按真实渲染形态**跑落地层的测试（`i18n_real_catalog`），并且**分层断言**（目录 → 引擎就绪 → 锚命中 → 裸句 → 带 span 整条），否则只知道红了不知道断在哪一层。
- **改写把字面量抬成 LANG 实参后，没有任何抽取路径认得它们** — `"The [x ? "bolt" : "screw"] is …"` 改写成 `LANG(key, list(x ? "bolt" : "screw", …))` 之后，那两个字面量既不是 sink 实参也不是累加器右值。模板译了、`lang_localize_arg` 拿实参去查却查不到 → 整句里嵌着英文（全仓 800+ 调用点）。抽取时走 LANG 实参子树，但**必须绕开下标键**（不下探 `Follow::Index`，否则 `ded["name"]` 被译、取值 miss）和**嵌套 LANG 的 key**（按 `<ns>.<hash>` 形态挡）。同样**只收多词**：单 token 实参里 act/topic/wire 键、黑板键、全大写常量浓度极高，放开一次就是 12 条高置信碰撞。
- **运行期 `X.desc += 后缀` 会连基础句一起打掉** — 拼接后整串不是目录键，精确反查整条 miss（高优先级赏金三条整段英文即此，基础句本来早就译好）。两侧都要补：抽取侧认 `X.desc/description +=`（原有累加器规则只看裸标识符），运行侧把后缀登记进 `i18n_appended_suffixes`、由 `lang_reverse_suffixed` 拆开分别反查，并让 `lang_reverse_phrase_tgui` 兜住它。接缝空白是暗礁：有的后缀源码自带前导空格，有的靠 DM 续行（`"</br>\` + 换行 + 制表符），抽取器与 BYOND 未必逐字节一致 → 测试要**照抄源码的续行写法**构造被测串（`i18n_suffixed`），别手写等价物。
- **`lang_localize_arg` 的 capitalize 兜底会撞上同形异义词** — `smell`（名词，污染物 descriptor，`#define` 不在目录）→ 兜底 capitalize 成 `Smell` → 命中动词条目「闻」→「烟细微的闻让你的鼻子发痒」。同形异义的显示词要进 `_state_words.json`（查表第一步，先于兜底）钉死词性。
- **MT 会吃掉纯 ASCII 译文里的字符** — `H.A.R.S.` → `H..R.S.`、血型 `A+` → `+`。查法：扫「译文不含 CJK、比原文短、且是原文的字符子集」，全仓一遍只有个位数，其中冠词/复数类是有意的，缩写/型号类是 bug。
- **共享常量表住在 .ts 里，`walk()` 只扫 .tsx/.jsx** — `constants.ts` 的 `GASES` 经 `getGasLabel(gas_id)` 渲染进一整排大气界面，界面文件里没有任何字面量 → 整类漏抽。按「文件+表名+字段」定点登记（`CONSTANT_LABEL_TABLES`），不整体放开 .ts（backend/logging 里的 name/label 多是标识符）；`id`/`path` 是回传标识符，永不入表。
- **上游把逻辑搬进新组件文件 = 整类落地点静默回退英文** — 上游把板条箱隐私锁重构成 `/datum/component/locked_to_account` 后，消息经**项目自定义 proc**（`deny(source, user, msg)` → 内部 `to_chat(span_warning(msg))`）下发。extract 认得这些字面量（照常进 `datum.json` 并被翻译），rewrite 却不认 `deny` 这个非注册 sink → 源码留裸英文、目录里躺着永远查不到的译文。**「目录里有、且已翻译」不等于「玩家看得到」**：同文件里 `balloon_alert` 那行照常被改写，对比之下更隐蔽。上游同步后的排查手段是拿「不再被引用的旧 key」反查其英文原文在源码里是否又以裸字面量出现（仅凭 `nova-i18n lint` 查不出——它只查悬空 key，查不出「该 LANG 而没 LANG」）。
- **同一次 rewrite 可以既漏抽又生成悬空 key** — 上游把 cyborg examine 的盖板句拆成 `var/cover_message = "…" ` + 两段 `+=` 后：基础句因是**局部变量赋值**（非 `. +=` 累加器）整条没抽 → 裸英文；而 `+=` 的 href 段被 rewrite 改成了 `LANG("mob.4b3e8678")`，extract 却因含 `<a href=…>` 跳过 → **悬空 key，玩家直接看到 `mob.4b3e8678` 这串乱码**。两个方向的缺口出现在**相邻三行**里。`nova-i18n lint` 只抓得住后者，前者要靠回归门禁的裸英文反查。恢复悬空 key 的原文去 `git show upstream/master:<file>` 取（这类 key 是本次 rewrite 新生的，`git log -S` 查不到引入 commit）。
