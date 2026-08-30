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
   - `fallback.dm` —— 输出边界的落地层：整串精确反查 → 剥冠词再精确 → 模板逆匹配。
     （曾有第四层「字面 AC 子串替换」，已整层删除，理由见 `lang_localize_chain` 的注释。）
   - `template_match.dm` —— **模板逆匹配引擎**：目录里已译的插值模板在输出边界整句命中
     （锚检测 → 逐字面段验证 → 捕获实参递归本地化 → 按 zh 模板重排填充）。
   - `miss_log.dm` —— 运行期漏翻采集（config `I18N_LOG_MISSES`，默认关）。
   - `fonts.dm` + `fonts/*.ttf` —— maptext 中文像素字体（见下「字体」）。
3. **TGUI（TypeScript）**：`packages/tgui` 的 JSX 静态文本、可翻 props 与显式 `defineMessage(context, source)`
   消息查前端目录；动态 DM 负载保持 canonical 值，译文通过 `json_data["i18n"]` overlay 只作用于显示。
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
  screentip，统一走 `lang_localize_name_for_display`（**按类型取键** → 精确反查 → 「区域名 + 类型名」
  分段翻；显示边界不过字面 AC）。
- `/mob` 覆盖该 proc：`name` 偏离 `initial(name)` 即视为**身份名**（角色名、宠物挂牌、赛博编号、
  ERT 头衔）一律不翻，哪怕撞上目录短语；仍等于 `initial(name)` 的才是类型标签。
- 普通 atom 的 `TRAIT_WAS_RENAMED` 继续保护 item/loadout 玩家改名。
- TGUI 负载不再被就地改写：P1（`lang_reverse_phrase_tgui`）只把「英文 → 译文」收进 overlay
  （`json_data["i18n"]`），值保持 canonical English，由前端渲染期查表。只有 `payload_prose_keys`
  那批散文仍就地翻。

**聊天曾经有一处结构性缺口，2026-08-20 才修**（这里原来写着「聊天不受影响」，是错的，留作教训）：
`[src]` 出现在句子里时 rewrite 会把它抬成 LANG 实参（`LANG("obj.…", list(src))`，仅 `list(src` 这一
形状全仓 3000+ 处），但 `lang_interpolate` **只对 `istext(arg)` 的实参**调 `lang_localize_arg` ——
atom 实参走的是 `"[arg]"`，插进去的是**英文名**，还会被 BYOND 自动补一个 "The "。所以真实表现是
「你仔细查看The floor，但没发现什么值得注意的……」，只能指望聊天层字面 AC 去捞，而 AC 有多词门槛、
单词名永远捞不着。现在 atom 实参统一走显示边界 `lang_localize_name_for_display`。

**其余缺口的范围**：名字不作为 LANG 实参、而是整串出现在**非边界路径**时，只剩字面 AC 与 P1 兜。
P1 的多词门槛已随「不动数据」一起撤掉（单词值只走整串精确反查），AC 仍要求 trim 后多词。
但要分清两件事：

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

**标识符兼作显示值时，翻译只作用于显示契约**：

- 常规 DM 负载由 `lang_reverse_tree` 收集 overlay；原值逐字节不变，`act()`、比较与查表继续使用 canonical
  English。散文键只有在 `policy.json` 的 `payload_prose_keys` 显式登记后才允许就地翻译。
- 静态标签由 `labels.rs` 按类型/proc 语义桥进前端目录。单词值与多词值都可进入 overlay 的整串精确查表，
  但子串替换仍只接收多词 key，防止单词从标识符或其它单词内部开火。
- 新代码需要消歧时使用 `defineMessage(context, source)`；需要“值不动、标签翻译”时使用
  `localizedOption` / `localizedDropdownOption`。上下文 key 与普通 source key 分开编译，payload overlay
  不能覆盖显式消息。
- 运行时域由 `strings/i18n/catalog-domains.json` 声明。`tgui.json` 属于 `tgui` 域，不再进入 DM
  `global_reverse`；`_state_words.json` 等域内表也不会扩大全局反查面。

已补上的两处宽覆盖边界：

- `tgui_input_list`（`code/modules/tgui_input/list.dm`）：选项文本整串反查（无词数门槛），
  `items_map` 用**同一个显示串**作键，回传后取回原值；`default` 一并换成显示形态，否则前端预选落空。
  `items` 在 P1 的 `payload_skip_keys` 里，所以这里是唯一的本地化点。往返由 `i18n_display_boundary` 守。
- 径向菜单（`code/_onclick/hud/screen_objects/radial.dm`）：切片 `name` 只当 tooltip 标题
  （标识符走 `E.choice`），在 `setup_menu` 里过 `lang_localize_display_name`。

剩余长尾的补法是：在 ui_data 里保留 canonical value 并让 overlay 翻显示；或按类型桥进前端目录
（`labels.rs TYPE_VAR_RULES`）。不要为个别界面放宽聊天字面 AC：AC 的职责只剩运行期拼接且无法
LANG 化的散文，不适合短标签与标识符。

**目录位置**：`strings/i18n/<locale>/<namespace>.json`。必须在 `strings/`（已被 git 跟踪）；
不可用 `data/`（被 .gitignore 忽略）。

### 文件地图（按固定路径加载，**不可随意挪动**）:

**译文与策略**
- `strings/i18n/<locale>/*.json` —— 译文目录。DM 运行时从 `STRING_DIRECTORY/i18n/` 加载。
  `_` 前缀的是**手维护**表（`_state_words` 状态词、`_chrome` 大厅/状态栏/法则标签、`_map_names` 地图名、
  `_map_descs` 地图 desc、`_wires` 电线名…）。
- `strings/i18n/catalog-domains.json` —— **运行时域与文件所有权清单**。`forward`、`global_reverse`、
  `tgui` 与 named scoped domain 的边界以它为准；新增目录文件必须先登记。
- `strings/i18n/type_vars.json` —— **类型显示名/描述表**（`extract` 产出，勿手改）：`type → 目录 key`，
  DM 继承已在 build 期展开。显示边界（`lang_localize_name_for_display` / `lang_localize_desc_for_display`）
  在 `name/desc` 仍等于类型初值时按**类型**直取键走正向目录，不再拿运行期字符串倒查——没有多词门槛
  （单词名也能落地）、没有同形异义碰撞。miss 时回落原有反查链。**实例数据永不改写**，该不变量由
  `nova-i18n lint` 规则 C 守（类型变量声明不得含 LANG；运行期 `name = LANG(...)` 只放行白名单）。
- `strings/i18n/policy.json` —— **三端标识符策略单一来源**：DM（`payload_skip_keys`/`payload_prose_keys`）、
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
- `test.sh` —— **可选**本地测试入口（默认覆盖率分栏；`catalog` = 真 zh-Hans 单测）。不是 git hook。

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

**聊天落地层（两个开关）**
- **`I18N_CHAT_FALLBACK`**（本仓库 `1`）：聊天是否走 HTML 切块 + 整串精确反查 + 模板逆匹配。
  browse / 状态栏 / 大厅 maptext / 气泡在 locale≠en 时一直走这一层。
> **字面 AC 已整层删除**（原 `I18N_CHAT_AC` 开关、`lang_fallback_setup`、`lang_fallback_pattern_safe`
> 与 `_fallback.json` 一并移除）。两条理由：生产语料实测它只贡献 4.4% 覆盖且产物是「中文碎片嵌在
> 英文句里」，比全英文更难看；字典由反查表现算 93,039 条多词模式，每局 `world.Reboot()` 后重建一次，
> `json_encode` 出两个约 5 MB 的连续字符串，是 32 位 DreamDaemon 地址空间耗尽（SIGABRT in
> librust_g.so）的主要推手。原先靠它落地的 21 条大厅/状态栏/法则标签改为在渲染点整串精确反查
> （`_chrome.json`，译文逐字未变）；职业描述那类「基础句 + 整句后缀」改走
> `lang_localize_sentence_suffixes` 按句切分。模板引擎自己的锚自动机（`i18n_tpl_*`）不在此列。

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
