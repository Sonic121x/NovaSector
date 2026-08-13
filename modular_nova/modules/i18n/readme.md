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

1. **落地钩子**——把输出边界接进兜底层：`modules/tgchat/to_chat.dm`（聊天）、`datums/browser.dm`（browse）、
   `controllers/subsystem/statpanel.dm`（状态栏）、`_onclick/hud/screen_objects/new_player.dm`（大厅 maptext）、
   `__HELPERS/priority_announce.dm`（公告）、`modules/tgui/tgui.dm`（注入 `config.locale` + P1）。
2. **运行期拼串处的定点反查**——整串是运行期产物、不可能是目录键的地方（公告 `%VAR` 值、ID 卡职务、
   emote 派发、书本内容、`EXAMINE_HINT` 宏…）。

`modular_nova/master_files/` 下的 core override 走 `. = ..()` 覆盖而非复制上游 proc
（storage 的可容纳列表、PDA/便衣 ID 的显示名、config entries、atoms 的 name/desc 反查…）。

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
