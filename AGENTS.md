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
- **「混排就整条保持英文」把「运行期整条文案 + 装饰性兄弟节点」也一起焊死** — 上一条剔掉了 `false` 空位，但只救了**末段**；真正的漏洞在保守分支本身。`<Box>{icon}{tab.name}</Box>`（配装页分类页签）、`<div>{desc}<Divider/></div>`（反派介绍非末段）、`<>{name}<span>{n} slots available</span></>`（中途加入菜单部门标题）这三种形状里，字符串是**运行期数据**、整条模板永远不可能在目录里，于是全部回退英文——而它们各自的英文原文本来就是独立目录键、译文一直躺着。判据是「同一条 tooltip 第一段英文、第二段中文」这类**同形状不同待遇**的反差（末段 `false` 被剔除后走了纯文本路径）。修在 `localize.ts localizeChildrenSegments`：模板未命中后允许逐段翻，但闸门要双重——每个非空白字符串 child 都必须**整条精确命中目录**（拼句碎片按定义不是独立键，抽取器只存整条模板），且**首字符不是小写字母/标点**（目录里确实躺着 `and give it a`、`a mindshield.` 这类碰巧能命中的续接碎片）。`localize.test.ts` 正反三条守这条。
- **拼句碎片进字面 AC 子串字典 = 从单词内部开火** — 反查表同时喂两条路：`lang_reverse_text` 的**整串精确**反查（碎片在那里无害）和字面 AC 的**子串替换**（碎片会在任意句子中间开火）。rustg 的 AC 没有词边界概念，LeftmostLongest 只管「同起点取最长」。旧闸门只要求「pattern 含空格」，于是 `"one of"→"其中一只"`（一条**没有调用点的悬空目录项**）把 `But n|one of| its eggs hatched!` 咬成「But n其中一只 its eggs hatched!」；`" and "→" 和 "`（靠首尾空格才含空格的单词碎片）污染整段 NPC 检查文本。闸门只能设在 `lang_fallback_setup` 建字典这一步（`lang_fallback_pattern_safe`：trim 后须多词；无句末标点的 ≤3 词短语若首/尾是虚词则拒收），碎片仍留在目录里供各自调用点精确查表。`i18n_ac_fragment` 守这条。
- **目录键里嵌着 HTML 标签 → 聊天落地层永远查不到** — 抽取器照抄源码字面量，标签就留在键里；而 `lang_fallback_apply_html` **按标签切块**、只把标签之间的纯文本送去查表。两种形态各需一处修：
  · **边缘标签**（整句被包住，`"<b>But none of its eggs hatched!</b>"`、`"<span class='notice ml-1'>Subject contains no neuroware…</span>"`）→ `lang_build_reverse` 登记**剥标签变体键**（值同样剥标签，外层标签由切块器自己保留）。与既有的剥宏/去转义/首字母大写变体同一条流水线、同一条「只做多词」安全线。
  · **句中内联标签**（`examine_text = "There is a sticker displaying the <b>Chief Engineer's SEAL OF APPROVAL.</b>"`）→ 切成两个半句，谁都不是键 → `lang_fallback_apply_html` 前置一遍 `lang_localize_inline_runs`：跨内联标签把整段文本连起来整段精确查表，命中才替换、未命中原样交还切块器（不新增误翻面）。含 `<script>/<style>/<textarea>` 的文档整个跳过这条前置 pass。
    **run 必须是元素的「内容」，不能跨过该元素自己的边界标签**：只靠 depth 计数不够——run 从外层 `<span class='notice'>` **之前**就开始的话，该 span 会被吸收进 run、它的闭合又把 depth 抵平，于是整条替换把 span 一起吃掉、聊天配色全丢。判据要加一条：run 至今没有任何非空白文本时遇到的**开标签**属于外壳，让它当边界、run 从它之后重新开始。这条是 `i18n_html_tag_keys` 实测抓出来的（译文正确但 span 没了），静态看代码看不出来。
  症状特征：整句英文，且句中某个专有名词被单独译成中文（AC 只咬中了那一个词组）。`i18n_html_tag_keys` 守这两条。
- **`examine_tags` 是全仓唯一「assoc 键即文案」的合法形状** — 该 proc 返回的 list，**键**是检查面板上那颗标签的文字、**值**是它的悬停 tooltip。抽取器原本只抽值，于是直接写字面量当键的写法整类漏掉（`examine_list["partially EMP blocking"] = …`）；用 `EXAMINE_TAG_*` 宏的那批因为宏本身是标签文字而早就在目录里，对比之下更隐蔽。这条只能开在本 proc 语境内——别处的下标键一律是程序查表用的键名，`visit_expr` 对 `Follow::Index` 的整支跳过必须保留。
- **proc 形参默认值是 SINK_VARS 够不着的一类**（已修） — `Initialize(revive_title = "a recovered crewmember", spawn_text = "Recovered Crew", …)` 这种把玩家可见文案写在**形参默认值**里的组件（ghostrole_on_revive 等），SINK_VARS 走的是类型变量声明，一条都抽不到 → 玩家看到「你想扮演a recovered crewmember吗？」。放开时的误伤担忧是真的（`name`/`message` 作形参名时标识符浓度远高于作类型变量时，`proc/f(message = "some_key")`），解法是**在 SINK_VARS 之上再加一道多词闸门**（复用 LANG 实参的 `is_lang_arg_text`），单 token 默认值一律不收。实测全仓只新增 14 条、逐条人工过目零标识符混入——**先量化再决定**，这个量级本身也证明闸门没开太大。
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
- **`span_*()` 包裹的 LANG 实参，`lang_localize_arg` 每一步都 miss** — 改写后的调用形如 `LANG(key, list(span_bold("[read_only ? "protected" : "unprotected"]")))`，运行期传进来的是 `<b>unprotected</b>`：整串既不是状态词、也不是目录键，于是中文句子里嵌着一个英文状态词（软盘的「写保护标签设置为unprotected。」）。`lang_localize_arg` 现在会剥掉**首尾包裹标签**、对内层递归本地化，命中后把标签原样套回去（加粗等排版不丢；内层已无标签，递归必然终止）。
  另一半是数据：`protected`/`unprotected` 是**单词**，被 LANG 实参的多词闸门挡掉——那条闸门不能放开（单 token 实参里 act/topic/黑板键浓度极高）。这类「同形异义状态词」的正确去处是 `_state_words.json`，它只在 LANG 实参/模板捕获这个受限范围内生效，不会污染全局反查表。
- **整句在 TypeScript 里拼 = DM 侧模板再全也没用** — 偏好菜单的个性总结 `You are ${finalString}.` 完全由 TS 拼出（`PersonalityPage.tsx`）：整串是运行期产物、永远不是目录键，而个性名是**单词**（Compassionate/Diligent…）也进不了字面 AC → 两条落地路径都够不着。顺带一提 DM 侧那条 `You are {0}.` 的锚只有 8 字符、低于 `I18N_TPL_MIN_ANCHOR`，本来也进不了模板引擎。
  修法是让它走**既有机制**：名字逐个 `translateCurrent` 查表（`/datum/personality name` 早由 labels.rs 桥进前端目录），外框写成 **children 模板** `You are <span>{finalString}</span>.` —— 抽取器收成 `You are {0}.`、运行时 `localizeChildrenTemplate` 整条查表后按中文语序回填。
  **绝不能写成 `You are {finalString}.`**：那样三个 children 全是字符串、会被并成一整条查不到的文本（与 `{' '}` 那条同一个坑）——必须把它包进一个元素才算一个占位符。连接符也要按 locale 走（中文顿号、无 "and"），否则是「甲, 乙, and 丙」。
  另一种「整列英文」的成因完全不同：**该类型的 name 从没进过任何目录**。强化+ 页的体表标记名（`/datum/body_marking`）不是 SINK_VARS 覆盖的形状、也不在 `labels.rs TYPE_VAR_RULES` 里 → `en/datum.json` 与 `en/tgui.json` 都查不到。判据一步到位：拿一个界面上的英文名去 `grep strings/i18n/en/`，**一条都没有**就是整类漏抽（对比「个别条目漏译」是目录里有键、值等于原文）。补一条 TYPE_VAR_RULES 即可，前端已是对象选项时 value 保英文、只有 displayText 被翻。
  同类：船员名单的 `title={dept + \` (${open} positions open)\`}`（`CrewManifest.jsx`）。改法一样——部门名包进 `<span>` 当占位符（自身是独立目录键、auto-localize），外框整条抽成 `{0} ({1} positions open)`。**prop 值里的 JS 拼接一律是这个坑**，`title`/`content` 这些可翻 prop 只做整串精确查表，拼出来的串永远查不到。
  prop 拼接全仓 151 处，逐处改 children 模板并不通用（`placeholder`、`Window title` 只吃字符串），所以走**抽取模板 + 运行期逆匹配**：`tgui-catalog.mjs propTemplate` 把 `` `Reading: ${x}` `` 收成 `Reading: {0}`，`localize.ts matchPropTemplate` 在精确查表 miss 之后按字面段整串逆匹配、回填捕获值。三道闸门缺一不可，且都是实测逼出来的：
  · **准入面用 sidecar 隔离**（`strings/i18n/tgui-prop-templates.json`，每次抽取全量重写、**不合并**——它是误翻面不是译文）。目录里另有 590+ 条 children 模板，它们本就走整条精确查表；把 `- {0}, the {1}`、`{0} of 12 total` 这种泛化骨架放进逆匹配面就是 DM 侧「中文脚手架裹英文」那一跤。
  · **抽取期要求锚里有实词**：字面段全是虚词/标点的骨架（`{0} from {1}, {2}`，锚只有 `" from "` 与 `", "`）实测能吃掉目录里 27 条正常整句。
  · **运行期要求捕获值像「值」不像散文**（≤60 字符、不跨句、多词时不以小写开头、末尾不吞句号）。这条只能设在运行期：抽取期看不出 `Select {0}` 的 `{0}` 将来会被喂进什么，而 `Select ` 是正经实词却又是极常见的句子开头——目录里 17 条 `Select a policy to view. These policies are…` 全靠这条挡住。
  两道闸门加完，能被劫持的目录整句从 44 条降到 0（剩余匹配全是「本身就是目录键、精确查表先命中」的良性形状）。审计手法：拿目录里所有非模板 key 逐条过一遍逆匹配引擎，看有多少被吃掉。
- **`initial(x.name)` 拼出来的列表 = 只有多词项被译的「半译列表」** — 储物袋检查的「可以容纳:」每项是 `"\a [initial(valid_item.name)]"`：`initial()` 取**英文原名**（改成显示边界翻译之后，运行期 `name` 同样是英文），整条描述又是运行期拼的、不是目录键 → 落地只剩字面 AC，而 AC 按安全线**只收多词** → 多词名（circuit board→电路板）命中、单词名（limb/beaker/bottle/assembly）整类漏掉。玩家看到的「a limb / a 电路板 / a beaker」混排就是这条界线的直接投影，很容易被当成个别条目漏译。修法：在 `set_holdable()` 用 `. = ..()` 之后**重建**该描述，逐项走精确反查（单词也能命中、且不存在 AC 的词内开火风险），命中项**丢掉 `\a` 冠词**（中文无冠词，留着就是「a 电路板」）。同理适用于任何 `initial(name)` 拼列表的地方。
- **`%VAR` 宏占位公告：模板译了、值没译** — `announcement_system.dm` 的公告模板用 `%PERSON`/`%RANK` 而非 `{0}`，整条模板早有 Nova 反查编辑，但 `%VAR` 的**值**由调用方传入英文 → 「Feng Xin Zi 已注册为 Detective」。职位名多为单词（AC 够不着）、公告整串又是运行期拼的（不是目录键），两条路径都不行，只能在替换处逐个值过 `lang_localize_arg`。**必须在 proc 内部改**：`. = ..()` 拿到的是替换完的串，无法再区分哪段是值。公告是纯显示、无 `act()` 回传，值被译不破坏任何比较。
- **按序 `replacetext` 填占位符 = 实参自吞** — `lang_interpolate` 原本按序 `replacetext("{0}")`、`replacetext("{1}")`…，于是**上一轮写进串里的实参内容会被下一轮当成模板再扫一遍**：只要某个实参的值里恰好含 `{1}`（纸张文本、玩家自定义命名、任何玩家可控串都做得到），它就会被后一个实参顶掉。已改为单趟扫描（实参写进输出后不再参与匹配），顺带省掉「模板里没有该占位符时仍白跑一遍 `lang_localize_arg` + 全串 replacetext」的开销 —— LANG 是全仓三万余处调用的热点。`i18n_interpolate` 守这条。**测试实参必须用生造词**（Zxqv 系）：locale≠en 时 `lang_interpolate` 会对文本实参跑 `lang_localize_arg`，真实英文词（`stick`/`tail`）在真目录或伪 locale 下会被译掉，断言就从「测填充逻辑」变成「测目录内容」。
- **逐字节 `copytext(s, i, i+1)` 扫描在落地层是真开销** — `lang_fallback_apply_html` 是**每条 to_chat、每个浏览器页面**的必经路径，而它的内循环 `lang_html_tag_end`（找标签结束的 `>`，且要跳过引号里的 `>`）原本按字节推进，每字节分配一个新字符串；记录台/健康扫描那种几十 KB、上千标签的页面光这里就是几十万次分配，且**跑两遍**（内联 run 前置 pass + 切块器各一次）。DM 516 的原生 `spantext`/`nonspantext`（「从起点开始有多少个连续字符属/不属于某字符集」）与 `findtext` 直接顶掉这类循环，逐字节行为等价。同类还有 `lang_html_tag_parts`／`lang_html_raw_text_tag_name` 的标签名扫描、`lang_localize_inline_runs` 里「run 至今有没有非空白文本」的 `length(trim(copytext(...)))`（两次分配 → 一次 `spantext`）。注意 DM 字符串里**没有 `\r` 转义**（写了直接编译报错 undefined text macro）。另：`trim()` 上游已经委托给原生 `trimtext()`，不必再手工替换。
- **`name`/`desc` 是 `appearance` 字段，别在 `Initialize` 里原地反查** — 旧做法在 `/atom/Initialize` 与（不调父级的）`/turf/Initialize` 里把英文名/描述整串反查成译文，覆盖面最大，但代价是地图加载期对约 128 万实例各做两次外观变更（churn；appearance 内化+引用计数，同型实例仍共享一份，所以**不是**「每实例一份外观」——写文档时别把这点夸大成结论）。已改成实例保留 canonical English、只在显示边界翻：`/atom/get_examine_name`、`/atom/examine` 的 desc、`/atom/MouseEntered` 的 hover screentip，统一走 `lang_localize_name_for_display`。三条连带规律：
  · **分清「这次的回退」与「历来如此」**：`/datum` 的 name（材料/试剂/设计/配方/货运包）从不走 atom 的 Initialize 钩子，那些界面的单词名是既有状态；这次真正影响的只有「obj/turf 的 name 直接进 TGUI 负载」这一小类，而高流量那几处早有定点本地化。已补的两处宽覆盖边界：`tgui_input_list`（选项文本反查 + `items_map` 用显示串作键 + `default` 换显示形态，往返由 `i18n_display_boundary` 守）与径向菜单切片 `name`（标识符走 `E.choice`）。
  · **代价只在「名字不作 LANG 实参」的路径**：聊天不受影响——`[src]` 早被 rewrite 抬成 LANG 实参（`list(src` 一种形状全仓 3000+ 处），`lang_localize_arg` 是逐实参精确反查、**没有多词门槛**，单词名照样命中。真缺口是 TGUI 负载单词名、径向菜单 tooltip、状态栏、`tgui_input_list` 选项：那里只剩字面 AC 与 P1，两条都卡多词（`lang_reverse_phrase_tgui` 见无空格值直接返回；`lang_fallback_pattern_safe` 要求 trim 后多词）。量级：名字形已译条目里单词占约 10%（2122/21174），多词名仍被覆盖。补法是按类型桥进前端目录（`labels.rs TYPE_VAR_RULES`）或域内表 / ui_data 另发显示字段，**不是**把原地反查加回来。审计时别只看「界面英文」就判缺口，先确认该处名字是不是 LANG 实参。
  · **mob 的判据只用 `initial(name)`**：`name` 偏离即身份名（角色名/宠物挂牌/赛博编号/ERT 头衔）一律不翻，等于 `initial(name)` 才是类型标签。别另设「是否被改名」标志位——它只覆盖走 `fully_replace_character_name` 的那条路径，还得跟父级的 early-return 保持同步（父级 `oldname == newname` 时会 return FALSE，标志位却已经清了），比这条判据弱。
  · **`lang_reverse_text(initial(name))` 这类补偿代码分两种，别一刀切**（全仓 44 处，撤了 7 处、留了 37 处）：注释理由都是同一句「`initial(name)` 会覆盖掉 Initialize 反查好的中文名」，钩子删掉后该理由全部作废，但**去留看实例名有没有英文语义**。撤：名字参与英文解析/比较的（火警器与防火门的 `"[区域名] [类型名] [id_tag]"` 按英文解析区域前缀、异种的防重名重置）——留着就是 memory 里「机器丢区域前缀」那一类。留：**上游本来就在运行期写 `name`** 的（MMI/posibrain/礼物/尸袋/项圈挂牌/蜂/无人机…），那里不存在「多一次外观写入」的代价，而拼句碎片（`"casing"`、`" This one is spent."`）没有别的落地手段，撤掉纯亏。撤 mob 侧的之前先确认边界认得 `set_name()` 形态（`"类型名 (编号)"` 翻前缀留后缀），否则例检当场退回英文。
  · **注入 locale 的单测必须在 `Destroy()` 里恢复全局**：`TEST_ASSERT` 失败即 `return`，恢复写在 `Run()` 末尾就会把合成 locale 留在 `GLOB` 里，之后每个 i18n 测试连带染红。`i18n_display_boundary` 守这条边界（正反两向：静态类型名要翻、身份名与 `TRAIT_WAS_RENAMED` 不许翻）。
- **「name 兼作 act 标识符」的单词显示名：走前端目录桥，且只收单词** — 这类 name（`/datum/vote`、`/datum/ai_module`、`/datum/chemical_reaction`、`/datum/design`、`/datum/material`、`/datum/reagent`）在 TGUI 里既显示又当回传键/客户端比较键，DM 端不能改数据，只能进前端目录让 TS 只翻显示（`labels.rs SINGLE_WORD_TYPE_VAR_RULES`）。**按词数分叉是硬约束**：多词 name 本来就被 P1 在负载里翻好了，塞进前端目录反而让 P1 按「本身是 tgui 目录键」跳过、改由 TS 翻，一旦该界面把它渲染在非可翻位置（模板串、非 translatable prop）就从中文退化成英文；单词 name 连 P1 的多词门槛都过不了、本来恒为英文，进目录是纯增益。配套安全线在 `tgui-catalog.mjs extract`：单词键的译文**只许沿用其它命名空间的既有词对**（`reverseZh`），`phraseTranslation` 现编的值一律不收——`tgui.json` 会被 `build_i18n_cache` 扫进 DM 侧**全局反查表**，凭空多出的单词词对就是扩大全局误翻面。审计手法：抽取后逐条比对「新键的 en→zh 是否已存在于其它命名空间」，实测 506 条新键里 462 条沿用既有、0 条新造。
- **撤掉 Initialize 反查会「暴露」原本靠两侧同时被译而侥幸自洽的查表键** — 出生管理器（`spawners_menu.dm`）的负载 `name` 既是显示名、又是 `GLOB.mob_spawners`/`GLOB.joinable_mobs` 的**查表键**；而该 GLOB 的键是在 `/obj/effect/mob_spawn/ghost_role/Initialize` 里 `. = ..()` **之后**用 `format_text(name)` 注册的。旧钩子时代父级已把 `name` 就地反查成中文 → **键是中文、P1 译过的负载也是中文，两侧同型、按钮照常工作**；显示边界化之后键回到英文、P1 仍把负载 `name` 译成中文 → `if (group_name in GLOB.mob_spawners)` 永不相等、`ui_act` 静默 `return`，表现为「点了没反应、无任何报错」，且**只有多词名坏**（单词名过不了 P1 多词门槛），极易被当成个别条目漏译。判据：`act()` 回传的那个字段的值，是不是某个 GLOB assoc 的键，而该键由 atom 的 `name` 在 Initialize 期注册。修法同「name 拼进 act 动作串」那条：另发 `id`（已在 `payload_skip_keys`）供回传，`name` 继续只做显示——**不要**把 `name` 加进 skip keys（整个菜单会退回英文）。排查同类：`grep -rn "GLOB\.[a-z_]*\[\(format_text(\)\?name" --include=*.dm code modular_nova`，其余命中多是 datum name（从不经 atom 钩子，历来如此，不属这次回退面）。
- **类型显示名表（`strings/i18n/type_vars.json`）：把「按文本倒查」换成「按类型取键」** — `nova-i18n extract` 顺带产出 `type → 目录 key`（name 31798 条 / desc 26431 条，DM 继承在 build 期用 `parent_type_without_root` 展开）。显示边界（`/atom/lang_localize_name_for_display`、`lang_localize_desc_for_display`）在 `display_name == initial(name)` 时按类型直接取键走**正向目录**，miss 才回落原有反查链。收益不是「等价替换」而是**严格更强**：没有多词门槛（单词名 4994 条、其中 4867 条早有译文，此前两条落地路径都够不到）、没有同形异义碰撞（键由类型决定）、O(1) 不经模板引擎与字面 AC。三条实现约束都是踩出来的：
  · **继承必须可截断**：子类型自己声明了 `name` 但抽不出键（非字面量/含占位符）时，继承链在该类型**中止**——沿用祖先的键会把父类型的名字挂到子类型上，而 `initial(name)` 取的是子类型自己的值。`TypeVarKeys::opaque` 守这条。
  · **表与目录必须同源**：表里的 key 由与 `emit` 完全相同的 `build_template` + `var_scope` 算出；两边算法一旦漂移，运行期是**静默永不命中**（不是报错）。`i18n_type_labels` ① 拿真表逐条断言 key 在 en 目录里存在。
  · **单测 fixture 不进目录**：`/obj/item/xxx_test` 这类声明在 `unit_tests/` 里但类型路径不在 `/datum/unit_test` 下，`suppress_aggressive` 挡不住 → 「Welding Fuel」这种纯测试串会进只增不减的目录。extract 按**声明所在文件路径**排除（`in_unit_tests`；注意 DM 的 file list 用反斜杠，`Path::components()` 认不出，要先归一）。连带后果：fixture 类型不在表里，所以行为层断言只能注入合成条目，真表只验完整性。
- **「数据不许被翻」现在是编译期门禁（`nova-i18n lint` 规则 C）** — 整条显示边界方案的地基是「实例的 name/desc 永远是 canonical English」，今天靠 rewrite 的结构（只遍历 `ty.procs`，够不到类型变量声明）保证——那是**碰巧成立**，不是设计。C1 禁止类型变量声明含 LANG；C2 的 proc 体内 `name = LANG(...)` 只放行 `NAME_LANG_ASSIGN_ALLOWLIST`（`edible.dm` 的 `"slice of [x]"`、`mail.dm` 的 `"[name] for [收件人] ([职位])"`，都是上游本就在运行期拼的复合身份名）。两个坑：
  · **AST 里没有 "LANG"**：`LANG`/`LANGU` 是 `#define`，预处理器建 AST 前已展开成 `lang_format`/`lang_format_for`，按 "LANG" 匹配永远 0 命中。
  · **判据必须是「值位置」而非「出现过」**：`name = tgui_input_text(user, LANG(提示), LANG(标题), …)` 里 LANG 只是别人的实参，赋进 name 的是玩家输入。按「出现过 LANG」判会误报（`admin_verbs.dm:387` 当场中招）。`expr_yields_lang` 只认 LANG 本身、`+` 拼接的分支、三元的分支、内插串里的内插项。
  · 门禁写完要**造一次违规验证它真的开火**（两条规则各造一处，确认报错后还原）——不会开火的门禁等于没有。
- **TGUI 负载改成「不动数据 + overlay」之后，覆盖面要靠三条各自独立的补丁撑住** — P1 不再就地改写负载值（只剩 `payload_prose_keys` 那批散文），译文改随 `json_data["i18n"]` 下发、TS 渲染期查表。回传值与服务端逐字节相同，「显示文本当标识符回传」整类静默故障结构性消失；但**从前"值到浏览器时已经是中文"顺带覆盖掉的位置**会一次性退回英文，实测三类，都补在 `catalog.ts`/`localize.ts` 而不是逐个界面改（静态扫描只认 JSX 里的 `X.prop`，经解构/中间变量到达渲染点的一概看不见，逐处改必漏）：
  · **大小写包装**（`capitalize(x)`/`toTitleCase(x)`/`capitalizeAll(x)`，约 29 处）：包装后的串与负载原值只差大小写，精确查表必 miss → overlay 额外建一张**小写归一化索引**。只对 overlay 建、不碰静态目录：overlay 的条目都是本次负载里已确认的显示值，静态目录里混着标识符形态的短键。
  · **拼进更大的串**（`` {`${x.name} - ${x.desc}`} ``、`` title={`${name} (${n})`} ``，五十余处）：整串永远不是目录键 → `substituteOverlay` 做**子串替换**。子串替换在 DM 侧（字面 AC）出过事，这里安全线是**结构性**的而非约定：overlay 的键全部经 P1 而 P1 有多词门槛（`findtext(text, " ")`），单词碎片根本进不了表；匹配面只有本次负载的几十条。再加词边界检查（前后不得是字母/数字，挡 `Water Bottle` 咬进 `Water Bottled`）与最长优先（正则交替按顺序试，短键排前面会遮住长键——DM 侧 LeftmostLongest 踩过两次）。
  · **混排 children 的碎片闸门连坐**：`localizeChildrenSegments` 原本「任一字符串 child 查不到 → 整条保持英文」。负载值现在也走这条路，于是 `["某物名", " costs ", 5, " credits"]` 会因为 `" costs "` 不是目录键而整条退回英文——而从前那个名字本来就是中文的。改成两遍：overlay 替换（永远安全、不动语序）与逐段查表（受闸门约束、全有或全无）分开，闸门中止时**回退到只做了替换的版本**，不把已替换的成果一起丢掉。这条是测试逼出来的：只在替换分支上放行不够，中止路径才是丢覆盖的地方。
  `localize.test.ts` 的「负载 overlay」一组守这三条（含词边界与最长优先的反例）。DM 侧 `i18n_payload_overlay` 守「值不动 / 散文键就地翻 / skip keys 不碰 / 不传 overlay 时行为不变」。
  仍未覆盖、需实测确认的只剩 `dangerouslySetInnerHTML`（5 处：赏金说明、证物、PDA/新闻正文）——HTML 注入 auto-localize 够不到，其中散文类走 DM 侧 `payload_prose_keys`（`description` 已在表内），玩家自写内容本就不该翻。
- **负载不再被就地改写之后，一批「补偿性」结构随之失效，要主动拆掉** — 它们都是同一个前提的产物：「P1 会把负载值译成中文，所以消费侧得把它兜回英文」。前提没了，留着就是误导后来者（每一处都写着「P1 会翻，所以…」的注释）。已拆三类：
  · **`lang_unreverse_text` 调用点 55 → 3**。32 处是负载回传补偿（货运订单/异种控制台/承包商/投票/街机/传真/死斗/化学分配器/材料成本表…），20 处是 Initialize 时代「实例名可能是中文」的补偿（区域名解析、火警器与防火门的区域前缀、摄像机、太平间、异种改名…）——后者在显示边界化那次就已经是死代码，只是当时没扫。只剩 `chat_commands.dm` 两处防御性的（Discord 命令结果，与负载无关）。**判据**：注释里写「P1/Initialize 会把它翻成中文」的，一律是死代码。
  · 货运控制台那种**手工就地反查**（`"object" = lang_reverse_text(order.pack.name)` + 消费侧 `lang_unreverse_text` 还原）是 P1 的手写版，同样整套撤掉，显示交给 overlay。
  · P1 里**「值本身是 tgui 目录键就原样返回」**那条分支连同 `i18n_tgui_strings` 整张表退休：它的职责是「把显示权交给 TS 以保住数据」，而现在数据本来就不动，跳过只会让这批值进不了 overlay。
- **P1 的多词门槛可以放开，但子串替换的多词约束必须显式搬到 TS 侧** — `findtext(text, " ")` 那道闸门唯一的理由是「别把单词标识符改坏」；负载不动数据之后，猜错的代价从「按钮哑火」退回「某处显示错」。放开后「TGUI 里单词名恒为英文」那一整类（线缆颜色、突变名、试剂/材料/设计名…）第一次有解。两条配套约束缺一不可：
  · 单词值**只走整串精确反查**，模板逆匹配与字面 AC 都跳过（那两条是给句子用的，单词过去只会徒增误伤）；
  · TS 侧 `getOverlayMatcher` 必须**只收多词键**做子串替换。从前这条由 P1 的门槛顺带保证，门槛一放开就没人守了——单词从另一个词内部开火正是 DM 侧字面 AC 那些事故的形态。`localize.test.ts` 有一条正反例守它（单词 exact 命中、但在句中不替换）。
