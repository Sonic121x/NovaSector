## NovaSector 全量汉化 (i18n)

Module ID: I18N

> **这份文档只写「难以从代码复原」的东西：文件地图、核心改动面、运维知识。**
> 排查规律与已知陷阱见 `AGENTS.md` 的「Internationalization」节；命令速查见 `tools/i18n/README.md`；
> 历次收口的过程与取舍见 git log（不再抄进本文）。

### Description:

为 NovaSector 提供全量本地化（首发简体中文 zh-Hans）。四层架构：

1. **编译期（Rust）** `tools/i18n/`：基于 SpacemanDMM 的 `dreammaker` 解析器，把玩家可见字符串抽成带
   占位符（`{0}`/`{1}`…）的英文模板、改写调用点为 `LANG/LANGU(...)`，产出主目录 `strings/i18n/en/*.json`。
2. **运行时（DM + rust_g）** 本模块 `code/`：
   - `runtime.dm` —— 查表与占位符填充（`lang_format`/`lang_format_for`）、name/desc **反查表**
     （`lang_build_reverse`）、TGUI 负载本地化（P1，`lang_reverse_tree`/`lang_reverse_phrase_tgui`）。
   - `fallback.dm` —— 输出边界的兜底层：整串精确反查 → 模板逆匹配 → 字面 AC 子串替换。
   - `template_match.dm` —— **模板逆匹配引擎**：目录里已译的插值模板在输出边界整句命中
     （锚检测 → 逐字面段验证 → 捕获实参递归本地化 → 按 zh 模板重排填充）。
   - `miss_log.dm` —— 运行期漏翻采集（config `I18N_LOG_MISSES`，默认关）。
   - `fonts.dm` + `fonts/*.ttf` —— maptext 中文像素字体（见下「字体」）。
3. **TGUI（TypeScript）**：`packages/tgui` 的 JSX 静态文本与可翻 props 自动查前端目录；
   动态内容由 DM 端 P1 预本地化后经 props 传来。
4. **翻译**：机翻预填（`tools/i18n/mt/`）+ 人工校对（`strings/i18n/` 是扁平 JSON，可导入任意在线平台）。

**locale 解析**：`LANG(key, args)` 与 `LANGU(user, key, args)` 均使用**全服 locale**
（`GLOB.i18n_server_locale`）——广播类文本一条字符串展示给多名观察者，无法按单人区分。
TGUI 的 `config.locale` 同源注入。

**atom/turf name 与 desc 不原地翻译**：`name`、`desc` 都是 BYOND `appearance` 字段，在每个
`/atom/Initialize` 与 `/turf/Initialize` 里改写它们，等于让地图加载期对每个实例各做两次外观变更
（appearance 本身是内化 + 引用计数的，同型实例仍共享一份，所以代价是 **churn**，不是「每实例一份外观」）。
详见 `modular_nova/modules/lighting_desync_debug/readme.md`。实例因此保留 canonical English，
显示边界才翻：

- `/atom/get_examine_name`（examine 名）、`/atom/examine` 的 `desc`、`/atom/MouseEntered` 的 hover
  screentip，统一走 `lang_localize_name_for_display`（精确反查 → 复合名 AC）。
- `/mob` 覆盖该 proc：`name` 偏离 `initial(name)` 即视为**身份名**（角色名、宠物挂牌、赛博编号、
  ERT 头衔）一律不翻，哪怕撞上目录短语；仍等于 `initial(name)` 的才是类型标签。
- 普通 atom 的 `TRAIT_WAS_RENAMED` 继续保护 item/loadout 玩家改名。
- 其余 TGUI 显示字段仍由既有 P1（`lang_reverse_phrase_tgui`）与各界面定点 `lang_localize_display_name`
  负责，这次没有新增。

**聊天不受影响**（容易误判成缺口，写清楚免得下次又绕回来）：`[src]` 出现在句子里时，rewrite 已经把它
抬成 LANG 实参（`LANG("obj.…", list(src))`，仅 `list(src` 这一形状全仓 3000+ 处），运行期由
`lang_localize_arg` 逐个实参精确反查——**它没有多词门槛**，单词名照样命中。所以名字保持英文之后，
聊天/`visible_message`/balloon 反而走上了更干净的一条路（此前实例名已是中文，这一步是空转）。

**缺口的实际范围（比初判小）**：名字不作为 LANG 实参、而是整串出现在**非边界路径**时，只剩字面 AC
与 P1 兜，而这**两条都是多词门槛**（`lang_reverse_phrase_tgui` 见到无空格的值直接原样返回；
`lang_fallback_pattern_safe` 要求 trim 后多词）。但要分清两件事：

- **`/datum` 的 name 从来不走 atom 那个钩子**（材料、试剂、设计、配方、货运包…），所以那些界面里的
  单词名是**既有状态**，与这次改动无关，历来靠逐界面定点本地化解决（`material_container.dm` 的
  `id`/`name` 分离、`_vending.dm` 的 `lang_reverse_text(record.name)` 等）。
- 这次改动真正影响的只有**「obj/turf 的 name 直接进 TGUI 负载」**这一小类；高流量的那些
  （售货机、LootPanel、MOD、传真、电梯、骡车、材料、手术、储物袋可容纳列表）早已有定点本地化。

**逐界面补齐（2026-08-17）**：按「该处 act 是否用 name」机械筛过全仓 181 个
`"name" = x.name` 形状的负载点，改掉 67 处、明确跳过其余。判据与常见误伤：

- **跳过**：管理/调试面板（MC、动态规则、事件日志、生成面板、外观调试、wiremod 端口——端口名在电路
  里当连接标识符）、身份名（角色/机组记录/通缉/囚犯 ID/pAI/虚拟宠物/赛博/无人机/soulcatcher 的灵魂）、
  玩家自己输入的文本（侦探板的案件名）、**日志负载**（`mob_helpers.dm` 的手持物名进的是
  `logger.Log`，不是 UI）、以及 name 本身就是回传标识符的（法架 `link_act(ref, name)`、
  机器人公告 `picked: button.name`、外星探索无人机的 `tool_type: cargo.name`、恶意 AI 模块选择器、
  街机装备、偏好菜单的个性/增强件——后两类已由 `labels.rs` 桥进前端目录）。
- **name 是 act 动作串又必须显示译文**的，另发字段：borg 注射器/调酒器前端写的是 `act(reagent.name)`，
  所以 DM 加发 `display_name`、TSX 渲染 `display_name ?? name`，`act()` 与选中态比较仍走英文
  （同 `medical_tools.dm` 的 `id`/`name` 拆法）。
- **同一负载里已有 id/ref 的**（材料容器、结晶器、弹药工作台、货运包、试剂查询…）直接翻 `name`；
  材料容器的 `id` 顺手从 `lang_unreverse_text(material.name)` 简化成 `material.name`——实例名现在
  本就是英文，不必再倒查。

**「name 兼作 act 标识符」的单词名走前端目录桥**（`labels.rs SINGLE_WORD_TYPE_VAR_RULES`）：
`/datum/vote`、`/datum/ai_module`、`/datum/chemical_reaction`、`/datum/design`、`/datum/material`、
`/datum/reagent` 的 name 在 TGUI 里既显示又当回传键/客户端比较键（`act('buy', {name})`、`voteName`、
置顶反应列表、`recipe.name === selected_recipe`、`MATERIAL_ICONS[name]`），所以 DM 端不能改数据。
落地路径按词数分叉，这条桥**只收单词**：

- **多词** name 由 P1 在负载里就地翻好，已经能显示中文。塞进前端目录只会让 P1 按「本身是 tgui 目录键」
  跳过、改由 TS 只翻显示；一旦某界面把它渲染在非可翻位置（模板串、非 translatable prop），就从中文退化成英文。
- **单词** name 连 P1 的多词门槛都过不了，本来恒为英文 → 进前端目录是纯增益（实测新增 545 条标签、
  目录新增 506 键）。

两道安全线：① 单词键的译文**只允许沿用其它命名空间的既有词对**（`tgui-catalog.mjs extract` 里
`reverseZh`；`phraseTranslation` 现编的值对单词键一律不收）——`tgui.json` 会被 `build_i18n_cache`
一并扫进 DM 侧**全局反查表**，凭空多出的单词词对等于扩大整个 DM 侧误翻面，而单词正是 act/topic/黑板键
浓度最高的形态；② 查不到译文就留英文，`sync()` 会把「值等于英文」的键滤掉，等于不存在。
落地实测：506 条新键里 462 条沿用既有译文、**0 条新造词对、0 条与既有译文冲突**，`nova-i18n lint`
告警数不变（27，全是既有 ident 碰撞基线）。

已补上的两处宽覆盖边界：

- `tgui_input_list`（`code/modules/tgui_input/list.dm`）：选项文本整串反查（无词数门槛），
  `items_map` 用**同一个显示串**作键，回传后取回原值；`default` 一并换成显示形态，否则前端预选落空。
  `items` 在 P1 的 `payload_skip_keys` 里，所以这里是唯一的本地化点。往返由 `i18n_display_boundary` 守。
- 径向菜单（`code/_onclick/hud/screen_objects/radial.dm`）：切片 `name` 只当 tooltip 标题
  （标识符走 `E.choice`），在 `setup_menu` 里过 `lang_localize_display_name`。

量级参考：obj/mob/turf/atom/area 命名空间下「名字形」（无句末标点、≤4 词、≤40 字符）已译条目中
单词占 **约 10%**（2122 / 21174）；多词名（"cable coil"、"medical kit"，SS13 的绝对多数）在这些路径上
仍由 AC/P1 覆盖。剩余长尾的补法是**逐界面**在 ui_data 里过 `lang_localize_display_name`（前提：该处
act 走 ref/id，不拿 name 拼动作串），或按类型桥进前端目录（`labels.rs TYPE_VAR_RULES`）。
**不要**为此放宽 P1 的多词门槛或往字面 AC 字典里塞单词——那两条是安全线。往前端目录桥单词时还要确认
该英文串**已在 DM 侧目录里有译文**：`tgui.json` 同样被 `build_i18n_cache` 扫进全局反查表，塞进从未
出现过的新词对等于扩大 DM 侧的误翻面（线缆颜色那次就是被 `i18n_real_catalog` 当场抓住的）。

**目录位置**：`strings/i18n/<locale>/<namespace>.json`。必须在 `strings/`（已被 git 跟踪）；
不可用 `data/`（被 .gitignore 忽略）。

### 文件地图（按固定路径加载，**不可随意挪动**）:

**译文与策略**
- `strings/i18n/<locale>/*.json` —— 译文目录。DM 运行时从 `STRING_DIRECTORY/i18n/` 加载。
  `_` 前缀的是**手维护**表（`_state_words` 状态词、`_fallback` 人工 AC 补充、`_map_names` 地图名、
  `_map_descs` 地图 desc、`_wires` 电线名…）。
- `strings/i18n/policy.json` —— **三端标识符策略单一来源**：DM（`payload_skip_keys`/`pref_desc_keys`）、
  TS（`translatable_props`/`option_text_props`/`no_auto_translate`，经 `tgui-catalog.mjs sync` 复制到
  `tgui/packages/tgui/i18n/policy.json`，两份都提交）、Rust（`identifier_dot_procs`）共读。
  **新增「值兼标识符」登记只改这一个文件。**

**运行时（钉死路径）**
- `code/__DEFINES/~nova_defines/i18n.dm` —— `LANG`/`LANGU` 宏与 locale 常量。
- `tgui/packages/tgui/i18n/` —— 前端运行时：`catalog.ts`/`localize.ts`/`jsx-runtime.ts` + 打包子集
  `<locale>.json`。靠 `tgui/i18n` 别名 + SWC `importSource` 解析，**必须在 tgui 包内**。
- `modular_nova/modules/i18n/icons/lobby/*.dmi` —— 大厅按钮中文重绘（由 `tools/i18n/lobby-buttons/` 生成）。
- `config/game_options.txt` —— `I18N_SERVER_LOCALE` / `I18N_CHAT_FALLBACK` / `I18N_LOG_MISSES`。
  **无 CI workflow**：lint 与重同步均本地手动跑。

**工具链**（都在 `tools/i18n/`，**勿移动**：移动需改 ~71 处构建/脚本引用）
- `src/*.rs` —— `extract` / `rewrite` / `labels` / `verbs` / `lint` / `pseudo`。
- `src/labels.rs` + `dm_labels.json` —— 按类型路径抽 DM **显示名**桥进前端目录
  （职业/怪癖/物种/配装/个性…，供 TS 端只翻显示、`act()` 回传仍用英文）。
- `tgui-catalog.mjs` —— TGUI 静态文本抽取 + 同步前端子集（`tgui:build` 自动跑）。
- `map-descs.mjs` —— 收集 `.dmm` 里的 `desc` 实例变量覆盖（解析器看不到这类，须单独扫）。
- `resync.sh` —— 合并上游后一键重同步。`mt/` —— 机翻 + 术语表 + keep-english 白名单。
- `pseudo-test.sh` —— **伪 locale 门禁**（跑全量单测，抓「标识符被反查变异 → 功能破坏」）。

### 核心（非模块化）改动面:

绝大多数汉化逻辑在 `tools/i18n/`、本模块与 `modular_nova/master_files/`。核心 `code/` 的改动只有两类，
都带 `NOVA EDIT` 标记：

1. **落地钩子**——把输出边界接进兜底层：`game/atom/atom_examine.dm`（examine name/desc）、
   `game/atom/_atom.dm`（hover screentip）、`modules/tgchat/to_chat.dm`（聊天）、`datums/browser.dm`（browse）、
   `controllers/subsystem/statpanel.dm`（状态栏）、`_onclick/hud/screen_objects/new_player.dm`（大厅 maptext）、
   `__HELPERS/priority_announce.dm`（公告）、`modules/tgui/tgui.dm`（注入 `config.locale` + P1）。
2. **运行期拼串处的定点反查**——整串是运行期产物、不可能是目录键的地方（公告 `%VAR` 值、ID 卡职务、
   emote 派发、书本内容、`EXAMINE_HINT` 宏…）。

`modular_nova/master_files/` 下的 core override 走 `. = ..()` 覆盖而非复制上游 proc
（storage 的可容纳列表、PDA/便衣 ID 的显示名、config entries 等）。

### Defines:

`code/__DEFINES/~nova_defines/i18n.dm`：`LANGUAGE_LOCALE_EN`、`LANGUAGE_LOCALE_ZH_HANS`、
`DEFAULT_UI_LOCALE`、`I18N_SUBDIRECTORY`、`LANG(key, args)`、`LANGU(user, key, args)`。

### Included files that are not contained in this module:

- `strings/i18n/<locale>/*.json` —— 译文目录。
- `tools/i18n/` —— 抽取/改写工具与机翻流水线。
- `tgui/packages/tgui/i18n/` —— 前端运行时与打包目录（英文原文作 key，缺失回退英文）。

### 运行服务器 / 已知问题:

**切全服中文**：`config/game_options.txt` 写 `I18N_SERVER_LOCALE zh-Hans`。配置启动时读，**无需重编译**。

**聊天层 AC 兜底（可选，默认关）**
- **AC = Aho-Corasick 子串替换**（`fallback.dm`，基于 `rustg_acreplace`）。用于「不是 `LANG()` 调用、
  整串反查也搞不定」的残留英文——主要是英文先拼进变量再 `to_chat`。
- **字典不是独立文件**：运行时由 `lang_build_reverse` 从已加载的译文目录现算，**只收多词短语**
  （单词会从词内开火、且污染 `name ==` 比较）。所以**你翻 `strings/i18n/zh-Hans/*.json`，字典自动更新**。
  可选人工补充 `_fallback.json`（扁平 `{"english":"中文"}`）。
- **开关**：`I18N_CHAT_FALLBACK 1`。**只管聊天**；browse / 状态栏 / 大厅 maptext 的兜底「locale≠en 就一直开」。
- **代价**：聊天是热路径，每行多一次扫描；默认关，翻好后开启实测。

**字体**：核心 maptext 字体只含拉丁字形，汉字会回退到系统字体微缩 → 模糊。`fonts.dm` 注册
Fusion Pixel 8px（OFL-1.1），`interface/skin.dmf` 把它**追加为回退字体**——拉丁字仍走原像素字体、
汉字落到它。无需 locale 门控（英文服永不请求汉字字形，仅多打包 3.4MB）。

**NixOS 启动**：`nix develop` → `tools/build/build.sh` → `DreamDaemon tgstation.dmb <port> -trusted`。
`librust_g.so` 由 devShell 自动软链（缺它日志子系统会卡死，见 `nix/rust_g.nix`）。

**前端依赖会静默陈旧（部署必看）**：跨过上游 tgui-core 升级的**老 checkout**，`bun install` 可能报
"no changes" 却把旧版本留在 `packages/*/node_modules/tgui-core` 里遮蔽根目录的正确版本 —— 构建出的
bundle 是旧的，且没有任何报错。全新 clone 不受影响。自检与修复：

```sh
python3 -c "import json;print(json.load(open('tgui/packages/tgui/node_modules/tgui-core/package.json'))['version'])" 2>/dev/null || echo "走根目录(正常)"
# 若打印的版本与 tgui/package.json 声明不符：
rm -rf tgui/node_modules && bun install
```

**32 位 rust_g iconforge OOM（与 i18n 无关）**：BYOND/rust_g 在 Linux 是 **32 位**进程（~3GB 地址空间），
iconforge 全核并行生成图集会撑爆 → Rust OOM `abort`（表现为**客户端停在大厅、服务端不再刷日志**）。
`nix/byond.nix` 的包装器已默认 `RAYON_NUM_THREADS=2`。另 `controllers/subsystem/processing/greyscale.dm`
把 GAGS 异步加载限流到 16 个在途任务，避免启动/换图时 `std::thread::spawn` panic → `SIGABRT`。

### Credits:

NovaSector i18n 基础设施。DM 解析复用 SpaceManiac/SpacemanDMM 的 `dreammaker` crate (GPL-3.0)。
