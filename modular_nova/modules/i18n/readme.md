## NovaSector 全量汉化 (i18n)

Module ID: I18N

### Description:

为 NovaSector 提供全量本地化（首发简体中文 zh-Hans）的运行时基础设施。架构分四层：

1. **编译期（Rust）** `tools/i18n/`：基于 SpacemanDMM 的 `dreammaker` 解析器，把玩家可见
   字符串抽取为带位置占位符（`{0}`/`{1}`…）的英文模板，改写调用点为 `LANG/LANGU(...)`，
   产出主英文目录 `strings/i18n/en/*.json`。
2. **运行时（DM + rust_g）** 本模块 `code/`：
   - `runtime.dm`：`lang_format` / `lang_format_for` 查表与占位符填充，惰性加载并缓存整个
     locale；复用 `code/__HELPERS/_string_lists.dm` 的 json/file2text 思路。
   - `fallback.dm`：基于 `rustg_acreplace`（Aho-Corasick）的英→中兜底，接住未抽取/无法
     静态抽取的残留英文。
3. **TGUI（TypeScript）**：`packages/tgui` 的 JSX 静态文本与常见文本 props 自动查前端目录；
   源翻译放在 `strings/i18n/<locale>/tgui.json`，构建前同步到 TGUI 包内；动态内容由 DM 端预本地化后经 props 传来。
4. **翻译**：Codex 机翻预填（`tools/i18n/mt/`）为主；人工校对走**自选的在线本地化平台**（译文是 `strings/i18n/` 下的扁平 JSON，Crowdin / Lokalise / Weblate / Tolgee Cloud 等都能导入导出。已移除自托管 Tolgee）。

locale 解析：
- `LANG(key, args)` —— 全服 locale（`GLOB.i18n_server_locale`），用于广播类文本
  （`visible_message` 等：一条字符串展示给多名观察者，无法按单人区分）。
- `LANGU(user, key, args)` —— 兼容旧调用的入口；当前部署模式同样使用全服 locale。
- TGUI 的 `config.locale` 也由 `GLOB.i18n_server_locale` 注入。

目录文件位于 `strings/i18n/<locale>/<namespace>.json`（`strings/` 已被 git 跟踪；不可用
`data/`，其被 .gitignore 忽略）。TGUI 使用同一目录下的 `tgui.json` 命名空间作为源。

### 文件地图（i18n 文件散落多处，多为运行时/打包器按固定路径加载，不可随意挪动）:

**运行时/打包器按固定路径加载——钉死，勿移动：**
- `strings/i18n/<locale>/*.json` —— 游戏端译文目录。DM 运行时从 `STRING_DIRECTORY("strings")/i18n/` 加载（见 `code/__DEFINES/text.dm` + `~nova_defines/i18n.dm`）。
- `strings/i18n/policy.json` —— **三端标识符策略单一来源**：DM（`i18n_payload_skip_keys`/`i18n_pref_desc_keys`，`build_i18n_policy_set`）、TS（`NO_AUTO_TRANSLATE`，经 `tgui-catalog.mjs sync` 复制到 `tgui/packages/tgui/i18n/policy.json` 供打包，两份都提交）、Rust（`identifier_dot_procs` 抽取/改写黑名单）共读；`nova-i18n lint` 校验其结构。新增「值兼标识符」登记只改这一个文件。
- `tgui/packages/tgui/i18n/` —— TGUI 前端运行时：`catalog.ts`/`localize.ts`/`jsx-runtime.ts`/`jsx-dev-runtime.ts` + 打包子集 `<locale>.json`。打包器靠 `tgui/i18n` 别名 + SWC `importSource` 解析，必须在 tgui 包内。
- `code/__DEFINES/~nova_defines/i18n.dm` —— `LANG`/`LANGU` 宏与 locale 常量（fork 规定 defines 进 `~nova_defines`）。
- `modular_nova/master_files/code/...` —— core override（必须镜像 core 路径）：`game/atoms.dm`（name/desc 反查）、`controllers/configuration/entries/config_entries.dm`（`I18N_SERVER_LOCALE` + `I18N_CHAT_FALLBACK` + `I18N_LOG_MISSES`）、`_onclick/hud/screen_objects/new_player.dm`（默认 HUD 大厅按钮全服中文换中文重绘 .dmi）。core NOVA EDIT：`code/modules/tgui/tgui.dm`（注入 `config.locale`）、`code/modules/discord/tgs_commands.dm` 与 `code/modules/admin/chat_commands.dm`（Discord/TGS 自定义命令中文化和状态卡片）、`code/controllers/subsystem/ticker.dm` 与 `code/__HELPERS/roundend.dm`（Discord 开局/结束通知中文化）。
- `modular_nova/modules/i18n/icons/lobby/*.dmi` —— 默认 HUD 大厅按钮中文重绘精灵（join/observe/ready/character_setup）；由 `tools/i18n/lobby-buttons/` 用 Fusion Pixel 字体逐帧生成。
- `modular_nova/modules/title_screen/code/title_screen_html.dm` —— `lang_localize_title_html`：title_screen 模块 HTML 菜单（raw browse 绕过 AC 钩子）的菜单文案专项本地化。
- `config/game_options.txt`（`I18N_SERVER_LOCALE`）—— 配置，位置固定。（**无 CI workflow**：原 `.github/workflows/i18n.yml` 已删，lint/重同步改本地手动跑。）

**本模块（DM 运行时实现）：**
- `modular_nova/modules/i18n/code/{runtime,fallback}.dm` —— 查表 / 占位符格式化 / name-desc 反查表 + AC 兜底。
- `modular_nova/modules/i18n/code/fonts.dm` + `modular_nova/modules/i18n/fonts/fusion_pixel_8px_zh_hans.ttf`（OFL-1.1，`OFL.txt`）—— **maptext 中文像素字体**：核心 maptext 字体（Grand9K Pixel 等）只含拉丁字形，汉字回退到系统字体微缩 → 模糊。`/datum/font/fusion_pixel_8px` 注册该 .ttf（产生资源引用使 BYOND 打包发给客户端），`interface/skin.dmf` 的 `.maptext`/`.context`/`.subcontext`/`.small`/`.italics` 字体族**追加它为回退**——BYOND 按字形回退：拉丁字仍走原像素字体、汉字落到它（8px=6pt 锐利，整数倍 12/18pt 仍锐利）。无需 locale 门控（英文服永不请求汉字字形=零视觉变化，仅多打包 3.4MB）。
- `modular_nova/modules/i18n/code/template_match.dm` —— **边界模板逆匹配引擎**：目录里已翻译的插值模板（`{0}` 句式）在输出边界整句命中（AC 锚检测 → 逐字面段验证 → 捕获实参反查 → 按 zh 模板重排填充），挂在 `lang_fallback_apply` 内、字面 AC 之前；聊天/browse/状态栏/公告/maptext 全部边界共享。运行期拼接/插值的英文句子（②③类长尾）由此系统性覆盖，无需逐点改写。回归测试：`code/modules/unit_tests/~nova/i18n_template.dm`。
- `modular_nova/modules/i18n/code/miss_log.dm` —— **运行期漏翻采集器**：config `I18N_LOG_MISSES`（默认关）+ 全服 locale≠en 时，在 `lang_fallback_apply` 出口与 `lang_reverse_phrase_tgui` miss 分支记录**经过所有翻译层后仍是英文**的多词串，去重计数写 `[log_directory]/i18n_misses.log`（首次 + 10/100/1000 次各一行）。离线聚合归类 `tools/i18n/miss-scan.mjs`（按排查规律自动分桶：已译未接通/在目录未译/目录片段/没进目录）。把「玩家截图上报漏翻」变成「日志收割」。单测：`code/modules/unit_tests/~nova/i18n_miss_log.dm`。
	采集收满 4096 条后停止扫描，避免长局继续产生正则/分词临时分配。
	运行时另有有界 fallback/TGUI 短语缓存（满后不淘汰），复用状态栏和 UI 的重复文本；开启 miss 采集时绕过缓存以保留频次。
	`_fallback.json` 中无空白条目会自动进独立 AC，以后只改 JSON；P1 同时按 policy 跳过 `id/ref/ckey/icon/icon_state/path` 等非显示子树。

**构建 / 翻译工具——都在 `tools/i18n/`（**未移动**：移动需改 ~71 处构建/CI/脚本引用，风险高）：**
- `tools/i18n/src/*.rs` —— Rust 抽取（`extract`，含通用 proc-return 句子 + 安全 verb 名）/ 改写（`rewrite`）/ verb 编译期注入（`verbs`）/ 门禁（`lint`）/ 伪 locale（`pseudo`），基于 SpacemanDMM 的 dreammaker。
- `tools/i18n/src/lint.rs` + `tools/i18n/identifier-baseline.txt` —— **编译期门禁**：目录卫生（占位符 parity / 控制字符）+ 标识符碰撞静态分析（`==`/`switch`/下标 ∩ en 目录可翻译值，基线增量，新增高置信即报错）。**本地手动跑**（无 CI workflow）。详见 `tools/i18n/README.md`「门禁与回归检测」。
- `tools/i18n/src/pseudo.rs` + `tools/i18n/pseudo-scan.mjs` —— **伪 locale**：`pseudo` 从 en/ 生成 `qps-ploc`（值包 `⟦原文⟧`，不入库），`I18N_SERVER_LOCALE qps-ploc` 跑一圈后用 `pseudo-scan.mjs` 找 ⟦⟧ 外残留英文 = 未接通翻译通道的路径。
- `code/modules/unit_tests/~nova/i18n_unreverse.dm` —— `lang_reverse_text ↔ lang_unreverse_text` 往返不变量测试（守护 chem dispenser 等「UI 回传译名查英文键表」解药）。
- `tools/i18n/lobby-buttons/` —— 默认 HUD 大厅按钮中文重绘脚本（`gen_dmi.py`）+ 字体/重生成说明。
- `tools/i18n/tgui-catalog.mjs` —— TGUI 静态文本抽取 + 同步前端子集（`tgui:build` 会自动 `sync`）。合并两层 DM 显示标签：AST（下方 dm_labels.json）+ 残留正则 `DM_LABEL_SOURCES`。
- `tools/i18n/src/labels.rs` + `tools/i18n/dm_labels.json` —— **AST 显示标签抽取**（`nova-i18n labels`）：按类型路径/proc 语义抽 name/title/category_name/explanation/`init_possible_values()` 选项/全局 list，产物 JSON 由 tgui-catalog 合并进前端目录。`init_possible_values` 经预处理器展开 → 自动覆盖所有 choiced 下拉（含 #define 选项），新增下拉无需再加规则。`resync.sh` 刷新。
- `tools/i18n/resync.sh` —— 合并上游后一键重同步（extract + rewrite + tgui 同步）。
- `tools/i18n/mt/` —— 机翻（`i18n-mt.ts`，后端 codex/claude/openai）+ 术语表 `glossary.zh-Hans.json` + 候选发现 `glossary-sync.ts suggest`。
- `tools/i18n/README.md` —— 命令速查。

**人工校对平台：** 自选**在线**本地化平台（导入导出 `strings/i18n/<locale>/*.json`；Crowdin / Lokalise / Weblate / Tolgee Cloud 等）。自托管 Tolgee 已移除。

### TG Proc/File Changes:

- **身体部位名 / 代词 / 自我体检（`runtime.dm` 加 `lang_zone`/`lang_pronoun` **专用映射**，零全局碰撞）**：
  - **部位名**（chest/head…）：`lang_zone(text)` 硬编码 zh 专用表——避开「chest=胸部 vs 储物箱」单词全局碰撞（只在部位语境调用）。`parse_zone`（mobs.dm，改 `. =` 后 `return lang_zone(.)`）+ `check_for_injuries`/embed 的 `plaintext_zone`（_bodyparts.dm）显示处包裹。
  - **代词**（He/is/him…）：`lang_pronoun(word)` 硬编码 zh 专用表（he→他、is→是、himself→他自己；does/do/s/es 等语法后缀保持英文）——不走全局反查（it/is/his 是常见短词会误伤动态数据）。在高价值模板实参处包裹：atom examine 描述符（`p_They()`/`p_are()`，atom_examine.dm）、自我检查（`p_them()`，human_defense.dm）。**模板译文里占位符就位即成中文**（如 atom.0e340ddb 译为「这是一个{2}…」）。
  - **自我体检累加器**：`is_examine_accumulator` 增 `combined_msg`/`check_list`（extract.rs）→ 「You check yourself for injuries.」「Your {0} looks {1}.」等进 LANG（重写 14 处/4 文件）。残留：状态词 OK/no damage 与 has/looks 连接词是实参短词、仍英文（伤情词表是更深一层 vocab）。
- **方法调用形式的汇聚点接入（重大覆盖修复，`tools/i18n/src/extract.rs` + `rewrite.rs`）**：此前抽取/改写只检测**裸调用** `Term::Call`（`visible_message(...)`、隐式 src），**完全漏掉方法调用** `X.visible_message(...)`/`src.say(...)`/`M.balloon_alert(...)`（AST 里是 `Follow::Call`，在 follow 链上）——而战斗/交互的可见消息绝大多数是这种形式。修复：两个 `recurse_follow` 对 `Follow::Call(_, name, args)` 也查 `sink_message_args(name)`；rewrite 用 follow 自身的 `Spanned` Location 定位，并让 `find_open_paren` 跳过方法调用的前导属性访问标点（`.`/`:`/`?.`）。一次重抽 **+6375 条**、重写 **7560 处 / 1504 文件**（如 `user.visible_message(span_danger("[user] fires [src]!"))` → `LANG`）。DM 全量编译 0 errors、tg/nova grep 通过。

- **叛徒暗号全中文**（显示/说出/聊天高亮三处同源一份值，正则是纯 alternation 无 \b → 中文不破功能）：
  - 生成器 `code/__HELPERS/names.dm`：职业分支 `lang_reverse_text(job.title)`；地点分支中文时反查区域原名（跳过 LOWER_TEXT——小写形对不上目录键）；ion 词池分支靠 strings 加载反查天然中文。
  - `lang_reverse_text` 新增**成对单引号剥离重试**（ion 词池值 "'PRETZELS'" vs 目录去引号形——与 trim 兜底同款 miss-path 修复）。
  - ion 词池 450 个全大写单词此前被 MT 标识符启发式跳过 → `I18N_ONLY_KEYS` 显式清单现在**绕过可译性闸门**（人工点名即翻），已全部补译。
- **全角标点触发喊话/疑问**（中文输入法默认全角，原判定只认半角）：`lang_yell_ending`（！！/!!/混排）接入 `say.dm` 的 `say_mod`+`say_quote`、`chatmessage.dm`（runechat 大字）；`？`/`！` 单结尾等价接入 `say_mod`/`say_test`。均 NOVA EDIT CHANGE。
- **回合结束报告收口（同 examine：browse 大块 HTML，模板引擎无法整句命中 → 拼接行 LANG 化；玩家回合报告截图实证）**：
  - `code/__HELPERS/roundend.dm`：首位死亡行（含遗言嵌套模板）/无人死亡行/AI 下属单位头/无 AI 赛博格存亡行/成就行（成就名经 LANG 实参链整串反查——坏译已修 datum.83529008）/`printobjectives` 的 `objective_name` 补反查/「乘紧急穿梭机」标签 inline gate。
  - `carbon/examine.dm` 补收三处裸拼接：手持物行（`{0} {1} holding {2} in {3} {4}.`，手名 `lang_zone`）/义肢行/被铐行（handcuffed/restrained with cable 进 `_state_words`）。
  - `code/modules/antagonists/_common/antag_datum.dm`：基类成败行 → LANG `The {0} was successful!/has failed!`（实参角色名反查；`lang_localize_arg` 新增 **capitalize 重试**——`LOWER_TEXT` 小写角色名对目录大写形）；`roundend_report_header` 改 LANG 模板 `The {0} were:`（原整串反查组合命不中）。
  - `antag_team.dm`/`ashwalker.dm`/`primitive_catgirls`：队伍头 `The {0}s were:` + 灰/冰行者部落头 → LANG。
  - `datum_traitor.dm`：暗号/应答块（原 `\` 续行拼接）与成败行 → LANG。`pirate.dm`：海盗头/战利品总价值/`loot_listing` 的 "Nothing" inline gate。`station_goal.dm`：目标 `<li>` 成败行 → LANG。
  - OPFOR 模块（Nova）：报告头/背景故事/目标/标题/描述/获批装备 → LANG。
- **人体 examine 状态句收口（miss 日志实证：examine 是多行大块文本，边界模板引擎无法整句命中，裸拼接句永远残留英文 → 必须 LANG 化）**：
  - `code/modules/mob/living/carbon/examine.dm`：流血段原「前缀 + english_list + 条件后缀」三段拼接改整句 LANG（死亡淤血/流血/大量失血三模板，NOVA EDIT CHANGE），部位列表 locale≠en 时逐词 `lang_zone` + 顿号连接（NOVA EDIT ADDITION）；按压止血行、伤残肢体行（`{0} {1} looks {2}!`，伤情词 mangled 等进 `_state_words`）、断头行、死亡检视三变体 → LANG（codemod 同款替换）。
  - `code/datums/wounds/_wounds.dm`：无纱布分支 `"[Their] [zone] [examine_desc]"` → LANG `datum.e4bf1a90`（degenerate 模板 `{0} {1} {2}`，模板引擎锚门槛自动跳过、仅 LANG 直查使用）；两分支部位实参包 `lang_zone`。
  - `code/datums/elements/decals/blood.dm`：examine 前缀 override `"[descriptor]-stained"` 经 `lang_reverse_text` 反查（`_state_words` 收 blood-stained→染血的；NOVA EDIT CHANGE）。
  - `modular_nova/master_files/.../human_helpers.dm`：Nova 版死亡检视两变体 → LANG（模块文件直改）。
  - 手工 LANG 化工作流：`nova-i18n key <ns> <template>` 算稳定 key → en/zh 目录手写同 key 条目 → 源码 `LANG("<key>", args)`（args 经 `lang_localize_arg` 自动走状态词/代词/反查链；部位词显式 `lang_zone`）。
- **首字母大小写失配（`capitalize()` 显示层）**：DM 惯例是「小写存、显示时 `capitalize()`」，目录键保留源码原样的小写形态 → 运行期送来的首字母大写串在精确反查与 AC 字典双双 miss，整类「目录里有译文却显英文」。`lang_build_reverse` 为**多词**小写键额外登记首字母大写变体（单词键不登记：`move`/`clear`/`ready` 之流是标识符形态，见 `nova-i18n lint` 的碰撞门禁，该门禁已同步这条变体规则）。仍需逐点收口的落地点：`code/modules/surgery/surgery_tools.dm` 外科处理机 examine（单词手术名 `Lobotomize` 过不了多词门槛）—— `capitalize(lang_localize_display_name(name))`，NOVA EDIT CHANGE。
- `code/game/machinery/computer/arcade/battle.dm`: `make_boss_name` —— NOVA EDIT ADDITION：全服 locale≠en 时敌名按 `lang_reverse_text` 反查碎片（形容词/敌名池 `strings/arcade.json` 经 flavor 白名单入目录）、省 The 冠词直拼中文名。离子法则（`strings/ion_laws.json` 池 + `generate_ion_law` 的 166 条模板句）为纯数据/抽取器接入，无核心改动：模板由抽取器专项抽（`walk_ion_templates`）、显示端边界模板引擎收口。
- `code/modules/tgui/tgui.dm`: `/datum/tgui/proc/get_payload` —— ① 在 config 负载注入 `"locale"`（供 TGUI 读 `config.locale`）；② 全服 locale≠en 时对 `ui_data`/`ui_static_data` 跑 `lang_reverse_tree`，把负载里**含空白的多词字符串**反查为译文（接入非 atom datum 的 name/desc/说明等动态内容）。均 NOVA EDIT ADDITION。
- **标识符耦合显示名走 TS 端 + P1 跳过（避免破坏 act，零上游 .tsx 改动）**：职业/怪癖/食物类别/精灵配件的 `name`/`title` 在 TGUI 里既是显示又是 `act()` 标识符——P1 改 ui_data 值会破坏操作（多词名翻了 act 就坏）。机制：① `tgui-catalog.mjs` 的 `DM_LABEL_SOURCES` 把这些 DM 名读进 `tgui.json` 前端目录——已接 food 全局列表、`code/__DEFINES/jobs.dm` 的 `#define JOB_X "…"`（职业/部门）、`code/datums/quirks` 的 `name`、`code/datums/sprite_accessories.dm`（发型/渐变/纹身…）、`code/modules/language`（语言名）、`code/modules/loadout/categories`（配装物品名，偏好按 item_path 存=安全）、species_types（物种名）；TS 端 auto-localize 只翻**显示**（act/dropdown value 用原英文值，安全；`FeatureDropdownInput` 用 `{displayText, value}` 选项，`localizeOption` 只翻 displayText、value 不动；TS 端无多词门槛，单词类如 Meat/Cursed 也翻）。**加新面只需在 `DM_LABEL_SOURCES` 加一行**。**`addText` 全局剥 `\improper`/`\proper` 宏**：物种名 `name = "\improper Human"` 抽出为 `Human`，与运行时 TGUI 收到的（宏已解析）对齐。② `runtime.dm` 的 `GLOB.i18n_tgui_strings`（en/tgui.json 的 key 集，启动加载）+ `lang_reverse_phrase_tgui` 让 `lang_reverse_tree`（P1）**跳过出现在 tgui 目录里的串**，不改数据=保住标识符。descriptions 等非标识符长文本仍走 P1。**反派名待接**：散在 `code/modules/antagonists` 各处，整目录抽会混入目标/技能等海量非偏好名，需专门源。
- **`strings/` flavor 数据文件并入主目录（统一体系，取代旧平行副本）**：抽取器 `extract` 的 flavor pass（`tools/i18n/src/extract.rs` 的 `FLAVOR_FILES`/`FLAVOR_DIRS` 白名单）把玩家可见 flavor（tips/ion_laws/junkmail/抗体/伤痕描述等）逐字抽进 `strings.json` 命名空间（保留 `@pick`/`@`/HTML token；排除口音表/人名/词频/名字生成器/关键词表）。运行时在 load 处反查落地（均 NOVA EDIT ADDITION，gated 全服 locale≠en，多词门槛，**无需运行时白名单**——只有目录内 flavor 会被改写）：
  - `code/__HELPERS/_string_lists.dm` 的 `load_strings_file`（`.json`）：照常 `json_load` 英文文件后跑 `lang_reverse_tree` 递归反查字符串叶子。
  - `code/__HELPERS/type2type.dm` 的 `/world/proc/file2list`（`.txt`）：构建行列表后逐行 `lang_reverse_phrase`（早期 GLOBAL_LIST_INIT 时 locale 仍为默认 en，跳过）。
  - 译文填进 `strings/i18n/<locale>/strings.json` 即生效。
- **P1b 关键 datum 家族 New() 反查**（NOVA EDIT ADDITION，全服 locale≠en 时用全量 `lang_reverse_text` 反查 name/desc，覆盖聊天 `[名]` 单词类插值）：`code/modules/reagents/chemistry/reagents.dm`（`/datum/reagent/New`：name/**description/taste_description**）、`code/datums/actions/action.dm`（`/datum/action/New`：name/desc）、`code/datums/quirks/_quirk.dm`（`/datum/quirk/New`：name/desc）。
- **`SINK_VARS` 白名单扩展**（`tools/i18n/src/extract.rs`，纯抽取，无 DM 改动）：除 name/desc/message/title/flavor_text 外补 `description`（试剂等用此非 desc——**曾完全漏抽**，加入后解锁数千条试剂/datum 描述）、`taste_description`、`display_name`、`wiki_desc`、`war_declaration`、`explanation_text`、`cure_text`/`spread_text`，及 ② 类经 to_chat 的整条消息 type 变量 `gain_text`/`lose_text`/`playstyle_string`。后者多为 `span_*()` 包裹（抽内层文本），显示靠聊天 AC 子串层（`I18N_CHAT_FALLBACK`）——整串反查会因 span 包裹不命中。
- **P4 表情（emote）反查**（NOVA EDIT ADDITION）：`code/datums/emotes.dm` 的 `/datum/emote/New()` 反查 name 与全部 message 形态变量（`message`/`message_mime`/`message_alien`/`message_larva`/`message_robot`/`message_AI`/`message_monkey`/`message_animal_or_basic`/`message_param`）。配套抽取器 `SINK_VARS` 增列这些变体（`tools/i18n/src/extract.rs`），`message_param` 译文须保留 `%t`。emote 每类型仅 New 一次，开销可忽略。
- **P5 数据 datum 家族反查**（NOVA EDIT ADDITION，全服 locale≠en 时）：gas —— `code/controllers/subsystem/air.dm` 的 `SSair.Initialize()` 遍历 `GLOB.meta_gas_info` 反查 name/desc（gas datum 从不实例化；放 SS Init 是因为 `meta_gas_info` 是 GLOBAL_LIST_INIT，早于 `i18n_cache` 不能在 `meta_gas_list` 内反查）；disease —— `code/datums/diseases/_disease.dm` 新增 `/datum/disease/New()` 反查 name/desc；material —— `code/controllers/subsystem/materials.dm` 的 `initialize_material` 反查 name/desc。
- **P1 跳过 act 标识符回传列表（修 tgui_alert/list 崩溃）**：`runtime.dm` 的 `GLOB.i18n_payload_skip_keys`（`buttons`/`items`/`init_value`）让 `lang_reverse_tree` **跳过这些键的值**。这些 list 的字符串元素会原样回传给服务端校验（tgui_alert：`act('choose',{choice:button})` 校验 `in buttons`；tgui_input_list：`act('choose',{entry})` 校验 `in items`）。若 P1 把它们译成中文，前端回传中文、服务端用英文校验 → **tgui_alert CRASH「non-existent button choice」、list 静默无法选择**。跳过后值保持英文（回传校验通过），显示交给 TS 端 auto-localize（`AlertModal.tsx` 的 `{button}` 文本节点过前端目录）。新增同类回传列表键在此登记即可。
- **P7 书本内容反查**（NOVA EDIT CHANGE）：`code/modules/library/book.dm` 的 `/obj/item/book/Initialize` 构建 `book_data` 时对 `starting_title`/`starting_content` 整串 `lang_reverse_text`（author 是人名不译；不动 `starting_*` 实例变量，read-tracking 仍用英文标题作键）。配套 `SINK_VARS` 增列 `starting_title`/`starting_content`（`tools/i18n/src/extract.rs`）——食谱手册/核弹手册等 `/obj/item/book/manual` 的整篇 HTML 正文抽为单条目，译文填进 `strings/i18n/<locale>/obj.json` 即生效。
- **EXAMINE_HINT 提示词反查**（NOVA EDIT CHANGE）：`code/__HELPERS/chat.dm` 的 `#define EXAMINE_HINT(text)` 改为 `("<b>" + lang_reverse_text(text) + "</b>")`——examine 里的工具/构造提示词（welded/screwed/bolted/pried/wrenched/anchored/crowbar/wrench…）整串精确反查。词表手工维护在 `strings/i18n/<locale>/ui.json`（`hint_*` 键）。`lang_reverse_text` 整串匹配（非子串）、locale==en 原样返回；动态 `[var]` 插值的 hint 安全 no-op。配套 examine **tag 词**（renameable/conductive/holographic/insulated/重量级 tiny…gigantic 等）与既有 proof 标签同走 `ui.json`（`tag_*` 键），在 `atom_examine.dm` 的 examine_tags 渲染处已 `lang_reverse_text(atom_tag)`。
- **腿 B：AC 子串兜底层 `lang_fallback_apply` 挂接**（fallback.dm，NOVA EDIT ADDITION）。字典改为从内存反查表 `lang_build_reverse` 自动构建——**仅含空格的多词短语**（单词排除避免子串误伤），并合并可选人工 `strings/i18n/<locale>/_fallback.json`。挂接点（均 gated 全服 locale≠en）：
  - browse —— `code/datums/browser.dm` 的 `get_content()` 返回前走 `lang_fallback_apply_html`：仅对可见文本节点应用 AC，标签/属性/`script`/`style`/`textarea` 原样保留，避免翻译 `name`/`value`/href 等机器字段。`code/modules/admin/sql_ban_system.dm` 的职业封禁复选框另用 URL 编码的稳定字段名，提交后按服务端职业/角色清单解码校验，防止 `Head of Security` 被翻成 `安保主管` 后写入 `ban.role` 而绕过英文规范岗位检查。回归测试：`code/modules/unit_tests/~nova/i18n_roleban.dm`；
  - 聊天 —— `code/modules/tgchat/to_chat.dm` 的 `to_chat`/`to_chat_immediate`，**额外受 config `I18N_CHAT_FALLBACK` 开关控制（默认关）**；`html` 与 browse 一样走 `lang_fallback_apply_html`，只翻可见文本并保留操作链接属性，`text` 走纯文本 AC，覆盖「英文拼进变量再 to_chat」的长尾；
  - 状态栏 —— `code/controllers/subsystem/statpanel.dm` 的 `set_status_tab`：**顶部 `global_data`（Map/Round ID/Time Dilation/Round Timer/Server Time…）与角色 `other_str` 均过 AC**（经 `i18n_localize_stat_list` 返回本地化副本，不改共享 global_data、不动点击链接）；
  - maptext —— `code/_onclick/hud/screen_objects/new_player.dm`（大厅信息）、`code/modules/escape_menu/title.dm`（菜单标题）过 AC（maptext 不被抽取，相关 phrases 需进 `_fallback.json` 才生效）。
  - **已建 `strings/i18n/zh-Hans/_fallback.json` 起步清单**：覆盖上面这些「不被抽取但已挂 AC」的静态短语（Starting in / players ready / Another day on… / Round ID / Time Dilation / Map: / Round Timer / Server Time / (Feedback) 等）。译文可按需增改；只对**已挂 AC 的输出口**生效，往里塞没挂 AC 的（verb 面板/纸张）无效。
- **`lang_build_reverse` 早期调用加固**（runtime.dm）：`i18n_cache` 尚未就绪时返回空表但**不缓存**，避免极早期调用把空反查表钉死、毒化后续全部反查（gas/material 等 SS Init 期调用的前置保障）。
- `tgui/packages/tgui/events/types.ts`: `Config` 类型新增 `locale: string`（NOVA EDIT ADDITION）。
- `tgui/rspack.config.ts`: `packages/tgui` 使用 `tgui/i18n` JSX runtime，自动本地化静态 JSX 文本；
  `tgui-panel` / `tgui-say` 保持 React 原生 runtime。
- `tools/i18n/tgui-catalog.mjs`: 抽取 TGUI 静态文本到 `strings/i18n/en/tgui.json`，复用中文目录/术语，
  并同步 `tgui/packages/tgui/i18n/*.json`（构建脚本会自动执行 sync）。
- 大量 `code/**/*.dm`：由 `tools/i18n` 幂等改写工具批量将字符串字面量替换为 `LANG/LANGU`
  （分阶段进行，每个被改写文件顶部带统一标记注释）。
- **miss 日志第 3 批收口（2026-07，生产服 5 局日志聚合）**：
  - **emote 派发点整串反查**（NOVA EDIT ADDITION）：`code/datums/emotes.dm` `run_emote` 在日志之后、
    组句之前对 `msg` 过 `lang_reverse_text`——emote 下游拼成「[user] [msg]」整句动态、目录无法整句命中，
    这一处修好**全部无参 emote**（monkey 死亡喘息等）。带 %t 实参的仍靠 AC。
  - **电线检修名**（NOVA EDIT CHANGE + 手维护表）：`code/datums/wires/_wires.dm` ui_data 的 `wire` 字段
    反查（act 回传 color、名字纯显示）；词表 `strings/i18n/{en,zh-Hans}/_wires.json`（WIRE_* define 值，
    ~69 条）。lint 对 `== WIRE_*` 的 59 条碰撞告警已确认安全收进基线（比较链全在服务端内部值上）。
  - **门禁权限显示名**：抽取器新源 `setup_access_descriptions`（`desc_by_access[...] = "..."` 赋值，
    ~200 条）+ `code/controllers/subsystem/networks/id_access.dm` `setup_tgui_lists` 构建静态表时反查
    `desc`（act 走 `ref`）。原始权限 id 列表键 `accesses`（airlock_electronics/mecha 等）进
    `policy.json payload_skip_keys`（多词 id "external airlocks" 防误翻）。
  - **堆叠合成配方标题**：抽取器新源 `new /datum/stack_recipe*("标题",…)` 第 0 构造实参（+~640 条，
    StackCrafting 菜单全英文的根因；显示端 stack.dm 反查已在前批接好）。
  - **合成/烹饪步骤行**：`_crafting.dm` 三条运行期拼接步骤 LANG 化（容器名实参走反查）；
    `/datum/crafting_recipe` 的 `steps` 列表进抽取。菜谱图标键列表 `icon_data` 进 payload_skip_keys。
  - **邮件名**（NOVA EDIT CHANGE）：`code/game/objects/items/mail.dm` 收件人名/junk 名/important 前缀
    LANG 模板化（运行期拼接，绕过所有层）。
  - **警戒等级播报标题**（NOVA EDIT CHANGE）：`code/__HELPERS/priority_announce.dm` `level_announce`
    两条 title LANG 化（等级名实参反查）。
  - **死亡竞赛全套**（NOVA EDIT CHANGE）：`code/modules/deathmatch/` 开厅播报/GO!/修正条件/超时/AFK/
    死亡/胜负/active_mods LANG 化（修正条件名反查、中文顿号连接）。
  - **食物切片名**（NOVA EDIT CHANGE）：`edible.dm` `slice of [X]` → LANG 模板「{0}切片」。
  - **冰淇淋名/描述**（NOVA EDIT CHANGE）：`ice_cream_holder.dm` 口味词+基名逐个反查、多口味描述 LANG。
  - **猴子编号名**（NOVA EDIT CHANGE）：`code/modules/language/monkey.dm` `monkey ([N])` → LANG 模板
    （「The monkey」千次级 miss 的根因：编号后缀使 atom Init 反查失手）。
  - **机体日志**（NOVA EDIT CHANGE）：`code/modules/mob/living/silicon/silicon.dm` `logevent` 存入
    borglog 前反查消息体（时间戳前缀使整行 miss）。
  - **`lang_reverse_text` miss 链新增 span 剥壳重试**（runtime.dm）：`desc = span_alert("…")` 类编译期
    包裹值剥单层 `<span>` 查内层、命中回包（"Keep out of reach of children." 类）。
  - **聊天 AC 跳过 admin 消息类型**（runtime.dm）：`i18n_player_chat_types` 增列
    ADMINLOG/ATTACKLOG/DEBUG——管理员日志按政策保英文，且不再污染 miss 采集。
  - **13 条 keep-english 白名单改判**：菠萝油/猪血糕等罗马音菜名与酒名/装备名手工翻译并移出白名单
    （遵循「应该都为中文」方向）。

### Defines:

- `code/__DEFINES/~nova_defines/i18n.dm`: `LANGUAGE_LOCALE_EN`、`LANGUAGE_LOCALE_ZH_HANS`、
  `DEFAULT_UI_LOCALE`、`I18N_SUBDIRECTORY`、`LANG(key, args)`、`LANGU(user, key, args)`。

### Included files that are not contained in this module:

- `strings/i18n/<locale>/*.json` —— 翻译目录（由 Rust/TGUI 工具生成 / 在线平台导入导出）。
- `tools/i18n/` —— Rust 抽取/改写工具与机翻流水线。
- `tgui/packages/tgui/i18n/*.json` —— 前端打包目录，由 `strings/i18n/<locale>/tgui.json` 同步生成运行时子集；
  英文原文作 key，缺失时回退英文，未译静态英文不会打进 bundle。
- `tgui/packages/tgui/i18n/jsx-runtime.ts` —— TGUI JSX 自动本地化入口。

### 运行服务器 / 已知问题:

- **完整命令手册**：见 `tools/i18n/README.md` 的「命令速查」。常用入口：
  - 进入环境：`nix develop`
  - 游戏/TGUI 重同步：`bash tools/i18n/resync.sh`
  - 翻译游戏命名空间：`bun tools/i18n/mt/i18n-mt.ts obj.json`
  - 修复术语不一致：`bun tools/i18n/mt/i18n-mt.ts translate-terms obj.json`
  - 翻译 TGUI：`bun tools/i18n/mt/i18n-mt.ts tgui.json`
  - 人工校对：把 `strings/i18n/<locale>/*.json` 导入你选的在线平台，校对后导回；TGUI 改完后 `node tools/i18n/tgui-catalog.mjs sync`
  - 构建并启动：`tools/build/build.sh && DreamDaemon tgstation.dmb 1337 -trusted`
- **切全服中文**：配置项 `I18N_SERVER_LOCALE zh-Hans`（`config/`）。游戏文本、name/desc 反查、
  以及 `packages/tgui` 中已进入前端目录的静态文本都跟随这个全服 locale。
- **聊天层 AC 兜底（可选）**：
  - **AC = Aho-Corasick 子串替换层**（`fallback.dm` 的 `lang_fallback_apply`，基于 rust_g 的
    `rustg_acreplace`）。在文本输出口把一段文本里出现的英文短语一次性按字典换成中文。用于「不是
    `LANG()` 调用、整串反查也搞不定」的残留英文——主要是**英文先拼进变量再 `to_chat`**、browse 老网页文案。
  - **字典从哪来（重要）**：**不是独立文件**。运行时由 `lang_build_reverse` 从已加载的
    `strings/i18n/<locale>/*.json`（即你正常翻译的那套目录）现算——**只取含空格的多词短语**（单词排除，
    避免子串误伤）。所以**你翻 `strings/i18n/zh-Hans/*.json`，AC 字典就自动更新**，无需维护额外文件。
    可选人工补充 `strings/i18n/<locale>/_fallback.json`（扁平 `{"english":"中文"}`，默认不存在）。
  - **怎么开**：`config/game_options.txt` 写 `I18N_CHAT_FALLBACK 1`（flag，默认关；裸写名字或 `1`=开，
    `0`=关），重启 `DreamDaemon`（配置启动时读，**无需重新编译**）。
  - **范围**：此开关**只管聊天**（`to_chat`/`to_chat_immediate`）。browse / 状态栏 / 大厅 maptext 的 AC
    兜底「locale≠en 就一直开」，不受此开关控制（本就低频）。
  - **代价**：聊天是热路径，每行多一次 AC 扫描 + 多词短语偶尔误翻动态数据 → 默认关，翻好后开启实测。
- **NixOS 上启动**：`nix develop` 后 `tools/build/build.sh` 编译，`DreamDaemon tgstation.dmb <port> -trusted`
  运行。`librust_g.so` 由 devShell 自动软链（缺它日志子系统会卡死，见 `nix/rust_g.nix`）。
- **32 位 rust_g iconforge OOM 崩溃（重要）**：BYOND/rust_g 在 Linux 是 **32 位**进程（地址空间
  ~3GB）。客户端进大厅时服务端用 rust_g 的 iconforge（rayon 全核并行）生成精灵图集，峰值内存会
  撑爆 32 位地址空间 → Rust OOM `abort`（核心转储，表现为**客户端停在大厅按钮界面、服务端不再
  刷日志**）。**与 i18n 无关**。修复：限制 rayon 线程数压低峰值——`nix/byond.nix` 的 DreamDaemon
  包装器已默认 `RAYON_NUM_THREADS=2`（实测稳定，可用 `RAYON_NUM_THREADS=N DreamDaemon …` 覆盖）。
- **GAGS 异步加载并发上限（core edit）**：`code/controllers/subsystem/processing/greyscale.dm` 将
  `rustg_iconforge_load_gags_config_async` 按最多 16 个在途任务分批等待，避免数百个配置同时创建
  OS 线程，在 32 位 DreamDaemon 启动/换图时触发 `std::thread::spawn` panic → `SIGABRT`。

### Credits:

- NovaSector i18n 基础设施。DM 解析复用 SpaceManiac/SpacemanDMM 的 `dreammaker` crate (GPL-3.0)。
