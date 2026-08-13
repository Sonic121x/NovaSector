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
- **前端把 payload 的 `name` 拼进 act 动作串 = P1 一译按钮就哑火** — `payload_skip_keys` 只保护「值本身就是回传标识符」的键（`buttons`/`items`/`id`/`ref`…），`name` 不在其中且**本该不在**（绝大多数场合 name 就是纯显示）。危险形状在 TS 侧：``gear_action: `toggle_reagent_${reagent.name}` ``——P1 把 `name` 译成中文后回传 `toggle_reagent_生理盐水-葡萄糖溶液`，DM 侧 `action == ("toggle_reagent_" + known_reagents[i].name)` 拿英文比，永远不等 → 按钮点了没反应、无任何报错。**单词名（Epinephrine/Multiver）因多词门槛不被译而照常工作**，于是表现为「只有多词化合物坏」，极易被当成个别条目漏译。修法不是把 `name` 加进 skip keys（会让整界面回退英文），而是**另发一个 `id` 字段**（`id` 已在 skip keys 内，天然免疫）供拼动作串，`name` 继续只做显示。全仓扫法：``grep -rn '`[a-z_]*\${[a-zA-Z_.]*\.name}`' tgui/packages/tgui/interfaces/``（2026-08-13 只有机甲注射器枪/机甲睡眠舱三处）。
- **React 不渲染的 children 占了模板占位符 = 整类「目录有译文、界面永远英文」** — `<div>{text}{cond && <Divider/>}</div>` 在 cond 为假时 children 是 `[原文, false]`。`localizeChildrenTemplate` 旧实现按「非字符串 = 一个占位符」建模板，于是查的是 `…station.{0}`，目录里当然没有 → 未命中后又撞上「混排就整条保持英文」的保守分支，把它焊死。React 对 `null/undefined/boolean` 什么都不渲染，这类空位必须在建模板**之前**剔除。反派介绍 tooltip 整页英文即此（译文一直躺在 `tgui.json` 里）。判据：目录里有键有译文、但界面是英文，且该处 JSX 有 `{cond && …}` 兄弟节点。
- **拼句碎片进字面 AC 子串字典 = 从单词内部开火** — 反查表同时喂两条路：`lang_reverse_text` 的**整串精确**反查（碎片在那里无害）和字面 AC 的**子串替换**（碎片会在任意句子中间开火）。rustg 的 AC 没有词边界概念，LeftmostLongest 只管「同起点取最长」。旧闸门只要求「pattern 含空格」，于是 `"one of"→"其中一只"`（一条**没有调用点的悬空目录项**）把 `But n|one of| its eggs hatched!` 咬成「But n其中一只 its eggs hatched!」；`" and "→" 和 "`（靠首尾空格才含空格的单词碎片）污染整段 NPC 检查文本。闸门只能设在 `lang_fallback_setup` 建字典这一步（`lang_fallback_pattern_safe`：trim 后须多词；无句末标点的 ≤3 词短语若首/尾是虚词则拒收），碎片仍留在目录里供各自调用点精确查表。`i18n_ac_fragment` 守这条。
- **目录键里嵌着 HTML 标签 → 聊天落地层永远查不到** — 抽取器照抄源码字面量，标签就留在键里；而 `lang_fallback_apply_html` **按标签切块**、只把标签之间的纯文本送去查表。两种形态各需一处修：
  · **边缘标签**（整句被包住，`"<b>But none of its eggs hatched!</b>"`、`"<span class='notice ml-1'>Subject contains no neuroware…</span>"`）→ `lang_build_reverse` 登记**剥标签变体键**（值同样剥标签，外层标签由切块器自己保留）。与既有的剥宏/去转义/首字母大写变体同一条流水线、同一条「只做多词」安全线。
  · **句中内联标签**（`examine_text = "There is a sticker displaying the <b>Chief Engineer's SEAL OF APPROVAL.</b>"`）→ 切成两个半句，谁都不是键 → `lang_fallback_apply_html` 前置一遍 `lang_localize_inline_runs`：跨内联标签把整段文本连起来整段精确查表，命中才替换、未命中原样交还切块器（不新增误翻面）。含 `<script>/<style>/<textarea>` 的文档整个跳过这条前置 pass。
    **run 必须是元素的「内容」，不能跨过该元素自己的边界标签**：只靠 depth 计数不够——run 从外层 `<span class='notice'>` **之前**就开始的话，该 span 会被吸收进 run、它的闭合又把 depth 抵平，于是整条替换把 span 一起吃掉、聊天配色全丢。判据要加一条：run 至今没有任何非空白文本时遇到的**开标签**属于外壳，让它当边界、run 从它之后重新开始。这条是 `i18n_html_tag_keys` 实测抓出来的（译文正确但 span 没了），静态看代码看不出来。
  症状特征：整句英文，且句中某个专有名词被单独译成中文（AC 只咬中了那一个词组）。`i18n_html_tag_keys` 守这两条。
- **`examine_tags` 是全仓唯一「assoc 键即文案」的合法形状** — 该 proc 返回的 list，**键**是检查面板上那颗标签的文字、**值**是它的悬停 tooltip。抽取器原本只抽值，于是直接写字面量当键的写法整类漏掉（`examine_list["partially EMP blocking"] = …`）；用 `EXAMINE_TAG_*` 宏的那批因为宏本身是标签文字而早就在目录里，对比之下更隐蔽。这条只能开在本 proc 语境内——别处的下标键一律是程序查表用的键名，`visit_expr` 对 `Follow::Index` 的整支跳过必须保留。
- **proc 形参默认值是 SINK_VARS 够不着的一类** — `Initialize(revive_title = "a recovered crewmember", spawn_text = "Recovered Crew", …)` 这种把玩家可见文案写在**形参默认值**里的组件（ghostrole_on_revive 等），SINK_VARS 走的是类型变量声明，一条都抽不到。想按「形参名在 SINK_VARS 里就抽」放开要先解决误伤：`name`/`message` 作形参名时标识符浓度远高于作类型变量时（`proc/f(message = "some_key")`）。需要比 SINK_VARS 更窄的判据再动。
- **`{' '}` 被当成占位符 = 一次毒掉 90 条模板 key** — prettier 换行时到处插 `{' '}`（`The <b>Linguist</b>{' '}` + 换行 + `neutral quirk …`）。React 把它渲染成一个**字符串** child，运行时 `localizeChildrenTemplate` 会把它并进模板文本；而抽取器 `templateChildren` 原本对 `ts.isJsxExpression` 一律记 `{slot:true}` → 算出的 key 比运行时多一个 `{N}`（`The {0}{1}neutral quirk` vs 运行时的 `The {0} neutral quirk`）→ 整条模板永远查不到 → **整段回退英文**。判据/症状：整段英文，但段落里的 `<b>`/`<span>` 词是中文（它们是独立 jsx 节点、各自 auto-localize 命中）——与「AC 只咬中一个词组」的 HTML 标签类症状很像，区别在这里被译的是**元素子节点**而非任意词组。修在抽取侧：JSX 表达式里是字符串字面量（`StringLiteral`/`NoSubstitutionTemplateLiteral`）时按**文本**处理。旧的错误 key 会永远留在只增不减的目录里，新 key 需重新翻译。`localize.test.ts` 用「按源码 JSX 形状独立构造 children、断言命中真目录条目」的方式守这条（不从 key 反推，否则是循环论证）。
- **落地层的层序：整串精确反查必须排在模板引擎之前** — `lang_fallback_apply` 原本是「模板逆匹配 → 字面 AC」，没有独立的整串精确反查那一步（整句只能靠 AC 顺带命中）。于是目录里那些「三两个词 + 占位符」的**泛化骨架模板**会抢在前面把整句劫持，把捕获到的英文原样塞回中文脚手架：`It appears to {0}`→`它看起来像{0}` 把「It appears to be completely inactive. The reset light is blinking.」吃成「它看起来像be completely inactive.」；`{0} produces a {1}.`→`{0}产出{1}。` 把「Fully heals the target and produces a random coin.」吃成「Fully heals the target and产出random coin。」。**两句的整句译文一直都在目录里**，只是永远轮不到。这比不翻更难看（中文脚手架裹着英文、语序还错），而且**不能靠收紧模板锚解决**：真正该留的手术类锚（`" begins to make an incision in "`）同样以介词结尾、词数门槛也会误杀 `{0} succeeds!` 与 `Prevent {0} from escaping alive.`。正解是让最具体的证据优先——整串命中就直接返回，模板与 AC 都不再跑。症状特征：中文句式里裹着成段英文（区别于 AC 碎片类的「英文句里嵌一个中文词」）。`i18n_real_catalog` ①c 守这条。
- **模板的字面段里嵌着 HTML 标签 = 整条在聊天路径上永远验证不过（全仓 859 条）** — `lang_fallback_apply_html` **先按标签切块**，送进模板引擎的是**纯文本块**；而 `lang_tpl_match` 要求逐段 `findtext` 命中**带标签的**字面段，于是这类模板一条都匹配不上。译文早就在目录里，只是这条通道走不通。实测：15906 条已译插值模板里 859 条（5.4%）是这形状——高级健康扫描仪整页（`<span class='info ml-1'>Genetic Stability: {0}%.</span><br>`）、回合总结经济行（`There were {0} {1} collected by crew this shift.<br>`）皆在其中。解法是在 `lang_tpl_setup` 里给这类模板**额外登记一条剥标签变体记录**去匹配切块后的纯文本，外层标签由切块器自己保留、排版不丢。两条硬约束：
  · **含 `<a>` 的一律不登记剥标签变体**（71 条）：剥掉链接会把功能弄没（`<a href='byond://…'>here</a>` 是投票入口）。这批改走**整行作用域**——`lang_fallback_apply_html` 在**切块之前**先对整行跑一遍 `lang_template_apply`，那时字面段里的标签与原文逐字节对得上，zh 模板连同自己的 `<a href>` 一起填回去，链接与排版都保住。**作用域选错才是原来的死结**，不是「剥不剥标签」的取舍。整行 pass 同样让 788 条纯排版模板优先在完整形态下命中，剥标签变体退化为切块后的兜底。
  · 剥标签时**不能 trim/折叠空白**（要另写 raw 版，别复用给反查变体用的那个）：字面段靠精确 `findtext` 定位，段首那个分隔占位符与词的空格一旦被 trim，整条模板反而再也匹配不上。
  `i18n_html_tag_keys` ③④ 正反两面都守（③ 断言剥标签变体命中，④ 反向断言投票行**必须**保持英文）。
- **LANG 实参里「本身就是插值句」的那类，抽取器整段丢弃** — `collect_lang_arg_literals` 对 `Term::InterpString` **只下探内插表达式、把字面文本全丢掉**，于是 `ask_role ? "Personality requested: \[[ask_role]\]" : ""` 这种被改写抬成 LANG 实参的插值句，一个字都进不了目录：外层模板译好了、句子中间嵌着一截英文。修法是加一条平行的**模板**收集器，按 `Personality requested: {0}` 的形态入目录，运行期由整行模板引擎命中并递归本地化捕获值。安全线：**只收带占位符的模板**（永不进反查表，且要求全部字面段按序命中，比裸串反查安全得多）+「去占位符后须多词」挡掉 act/黑板键。全仓 87 条。
  连带坑：抽出的是 `Personality requested: \[{0}\]` —— DM 源码里 `\[` `\]` 是「字面方括号」的转义（否则被当成内插），而运行时是裸括号。`lang_tpl_normalize` 原本只归一 `\"` `\n` `\t` 与文法宏，**漏了这两个**，不补则字面段照样对不上、等于白抽。
- **地图里定义的 `desc` 覆盖，整类不在目录** — `.dmm` 里的 `desc = "…"` 是**实例变量覆盖**，不在任何 `.dm` 源码里，dreammaker 解析器（`nova-i18n extract`）根本看不到 → 整类漏抽。**迷惑性极强**：物体的 **name 是中文**（地图名早就手工收进 `_map_names.json`）、**desc 却是英文**，看着像「这一条漏译」，实际是「这一整类从没进过目录」；而且在 `.dm` 里怎么 grep 都找不到那句英文（线上实例：heretic.dmm 的「充满恐惧的人」）。判据：`grep -rl "<那句英文>" _maps/`。产物由 `node tools/i18n/map-descs.mjs` 生成 `strings/i18n/en/_map_descs.json`（identity 表，与 `_map_names.json` 同形态，只合并不裁剪），resync 之后跑一次。
- **P1（TGUI 负载）缺字面 AC 兜底 → 「基础句 + 运行期后缀」整段英文** — `lang_reverse_phrase_tgui` 的链是「精确反查（含 `lang_reverse_suffixed`）→ 模板引擎」，**没有 AC**。而 TGUI 负载里的追加后缀不止可枚举那种：幽灵生成器的 `flavour_text` 是`基础句` + `switch(rand(1,4))` 四选一的身世段（其中一段还带 `pick(...)` 内插），后缀根本没法手工登记进 `i18n_appended_suffixes`。**两半各自都是目录键、也都译好了**，字面 AC 的子串替换正好能分别换掉、接缝原样保留——聊天路径一直这么做，P1 少了这一步。症状：生成器菜单里「来源」是中文、「指令」整段英文（同一条负载两个字段待遇不同，这个反差就是判据）。闸门必须严：AC 是子串替换，**长度 ≥ 80 且含句末标点**（散文形态，不可能是 act 回传标识符）才放行，短值一律不走——那是标识符浓度最高的区间。
