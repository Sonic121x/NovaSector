# nova-i18n —— NovaSector 全量汉化工具链

DM 字符串抽取/改写工具（Rust，基于 SpacemanDMM 的 `dreammaker` 解析器）+ 机翻流水线。
配套运行时见 `modular_nova/modules/i18n/`（其 readme 有**全部 i18n 文件地图**）。人工校对走自选的**在线**本地化平台（导入导出 `strings/i18n/<locale>/*.json`）。

## 端到端流程

```
                          tools/i18n (Rust)
  DM 源码 ──parse(dreammaker)──▶ 抽取玩家可见字符串 ──▶ strings/i18n/en/<ns>.json (英文主目录)
                                       │                          │
                            改写调用点为 LANG/LANGU                │ 导入(import)
                                                                   ▼
   tools/i18n/mt/i18n-mt.ts ◀──── Codex 机翻预填(配 glossary) ◀── 在线本地化平台(自选)
        │                                                          │ 人工校对
        ▼                                                          │ 导出(export)
  strings/i18n/zh-Hans/<ns>.json  ◀───────────────────────────────┘
        │
        ▼
  运行时 modular_nova/modules/i18n/code/runtime.dm 按 locale 查表 + {0}/{1} 填充
```

## 命令速查

除特别说明外，下面命令都在仓库根目录执行。NixOS / 本机开发推荐先进入 dev shell：

```sh
nix develop
```

### 构建、检查、启动

```sh
# 构建 TGUI + DM。构建 TGUI（tgui:build）会先跑 tgui-catalog.mjs extract（抽取新 JSX/DM 标签 +
# 复用译文 + 同步前端子集 tgui/packages/tgui/i18n/*.json），再 rspack 打包 —— 一条命令即含抽取+同步+编译。
# 注：extract 幂等；Juke 只在 tgui 输入（catalog/译文/.tsx/配置）变化时重跑该步，无变化的增量构建零额外开销。
tools/build/build.sh

# 只构建 TGUI
tools/build/build.sh tgui

# TGUI 类型检查 / 测试 / lint
tools/build/build.sh tgui-test
tools/build/build.sh lint
tools/build/build.sh --ci lint tgui-test

# 启动本地服务器。端口可换成你的服务器端口
DreamDaemon tgstation.dmb 1337 -trusted

# 一条命令构建并启动
tools/build/build.sh && DreamDaemon tgstation.dmb 1337 -trusted
```

### 配置全服中文

```sh
# config/game_options.txt 里应有：
I18N_SERVER_LOCALE zh-Hans
```

改完配置后需要重启服务器。TGUI 的 `config.locale` 跟随这个全服配置。

### 游戏文本：抽取 / 改写 / 同步源码

```sh
# 只刷新英文目录 strings/i18n/en/*.json
# 自带「译文迁移」（migrate.rs）：上游改文案导致 key 变化时，把各 locale 的孤儿译文接到
# 新 key——同值精确继承（含跨命名空间）自动完成；近似迁移（词级 Dice ≥0.95、占位符一致、
# 否定/极性词集一致）会写报告 tools/i18n/mt/.pending/migrate-report.<locale>.json 供人工复核。
# 阈值曾为 0.8：实测 0.8~0.89 会把「换一个实体词」（SOOC↔dead chat）、「语义反转」（now↔no
# longer）的译文接错——接错比漏译贵（漏译 MT 会补），故只放行标点/虚词级差异。
cargo run --release --manifest-path tools/i18n/Cargo.toml -- \
  extract --dme tgstation.dme --out strings/i18n/en
# 专项源（都无句末标点，激进 pass 抽不到，故各自登记）：`new /datum/stack_recipe*("标题",…)` 的第 0
# 构造实参（StackCrafting 菜单）、setup_access_descriptions 的 `desc_by_access[…] = "…"` 赋值
# （门禁权限显示名）、/datum/crafting_recipe 的 steps 列表、`.dmm` 里的 desc 覆盖（见 map-descs.mjs）。

# 只把新出现的消息调用点改成 LANG()/LANGU()
# 已知事项：rewrite 的语句遍历目前不进 for(x in list)/for(k,v in)/for(range)/do-while/try-catch
# 体（extract 曾同病，2026-07 已修——ForList 一修就多抽出 ~1400 条），即这些循环体内的 sink
# 不会被改写成 LANG，靠目录 + 聊天/浏览 AC 与模板引擎兜底显示。补齐 rewrite 遍历会一次性
# 产生数百处核心文件 codemod，需单独批次评审后再做。
cargo run --release --manifest-path tools/i18n/Cargo.toml -- \
  rewrite --dme tgstation.dme

# 推荐：合并上游后的一键重同步
# 会构建 nova-i18n、刷新游戏英文目录、刷新 TGUI tgui.json、再做 rewrite
bash tools/i18n/resync.sh
```

游戏端运行时直接读取 `strings/i18n/<locale>/*.json`，所以游戏翻译本身不需要额外“生成前端包”。翻译更新后重新构建 / 重启服务即可生效。

> `extract` 除 name/desc 类 SINK_VARS + sink 消息外，还会抽：① **任意 proc 的「句子型」`return` 字面量**
> （多词 + 首字母大写 + 无占位符——覆盖「proc 返回玩家可见整句、经 to_chat/alert 变量参数发出、rewrite
> 够不着」的长尾，如穿梭机/天气/投票提示；靠聊天 AC 子串层显示，需 `I18N_CHAT_FALLBACK TRUE`）；
> ② **安全 verb 命令面板名**（见下「verb」）；③ 白名单 `strings/` flavor 数据文件。

### verb 命令面板名（编译期注入，特殊）

verb 的 `set name = "X"`（命令面板 / 右键菜单显示名）是 BYOND **编译期元数据**，无法像其它文本那样
运行时按 locale 切换——这是唯一不能 locale 门控的类别。方案：编译期把核心里**安全显示名**的 `set name`
字面量原地换成中文（含 ADMIN_VERB 宏的 verb_name 实参）。**只换字面量、不加行内 `//` 注释**（verb 名常是
宏实参/行中 token，行内注释会注释掉其后实参 → 编译失败）；NOVA 标记靠文件级 CORE_MARKER（与 LANG codemod 一致）。

**译文已固化在源码里**（`git grep 'set name = "[^"]*[一-龥]'` 能看到），因为本仓库走 TGS 自动部署——
TGS 直接编检出的仓库，没有「编译前注入、编译后还原」的插入点。所以仓库本身就是中文服源码。

```sh
# 1) 抽取已自动包含安全 verb 名：首字母大写的显示名（命令面板/右键可见、按名调用自洽）。
#    自动排除 .click / body-chest / quick-equip 等 keybind/宏按名调用的标识符 verb——改名会断快捷键/宏；
#    另排除纯 ASCII 之外的（见下「污染级联」）。即 extract / resync 就会把安全 verb 名抽进 en 目录。
# 2) 翻译 verb 名（同普通流程）
bun tools/i18n/mt/i18n-mt.ts
# 3) 注入核心 set name：读 strings/i18n/<locale>/*.json，仅注入「已译且安全」项；
#    内容守卫=源码原文须严格 == en（防错位/宏误改）；幂等（已是中文的跳过，只处理新增英文名）。
cargo run --release --manifest-path tools/i18n/Cargo.toml -- verbs --locale zh-Hans
#    先看会改多少处：加 --dry-run
```

**上游合并后**：resync 会把新 verb 名抽进目录，翻译完再跑一次上面第 3 步、提交即可（`resync.sh`
结尾有提示）。`verbs` 不放进 `resync.sh`，因为它必须在**翻译之后**跑。

⚠️ **不要跑 `verbs --revert`**：它按 zh→en 反查还原，是给「注入-编译-还原」旧流程用的。现在源码本身
就是中文，revert 会把整仓译名打回英文。需要英文构建就 checkout 一个注入前的提交。

⚠️ **污染级联（已修，勿再破坏）**：`is_safe_verb_name` 要求 `s.is_ascii()`。因为源码里的 verb 名现在是
中文，若没有这道闸，`extract` 会把**译文**当英文原文收进 en 目录、下一轮 MT 再译一遍——实测产生过
`"Fax 面板"` / `"End 弹"` / `"AI低温休眠"` 这类半中半英的「英文」值，还让 zh→en 一对多、revert 歧义
跳过把中文永久留在源码里。同理，`skin.dmf` 按连字符化 verb 名调用的（`Hotkeys-Help`、`Emote-Panel`、
`open-escape-menu`、`fullscreen`、`connect-to-relay`、`toggle-stat-panel`）在排除表里，改名即断按钮。

### 烤进资源 / HTML 的玩家文本：大厅按钮、标题界面、maptext、旧 browse

少数玩家可见文本不在「sink/目录反查」的常规路径上，单独处理：

- **大厅按钮**（默认 HUD）：文字**烤进** `icons/hud/lobby/*.dmi` 精灵，反查够不着。全服中文时由
  `modular_nova/master_files/code/_onclick/hud/screen_objects/new_player.dm` 的 `SlowInit` 换成中文重绘版
  （核心 .dmi 不动，上游友好）。重绘 / 新增按钮见 **`tools/i18n/lobby-buttons/readme.md`**。
- **标题界面**（`modular_nova/modules/title_screen` 的 HTML 菜单，raw `browse()` 绕过 `/datum/browser`
  的 AC 钩子）：`get_title_html` 返回前调 `lang_localize_title_html` 专项翻译菜单（加入游戏/旁观/准备就绪…）。
  改字样直接编辑该 proc。
- **maptext**（不过 AC）：少数 `MAPTEXT("…")` 标签全服中文时 gated 直给中文。
- **旧 `browse()` 弹窗**：`/datum/browser` 包装器本就已 AC 覆盖；raw `browse()` 里的玩家可见 prose
  复用同 proc 现成 LANG key 拼装。玩家书写内容（纸张/相机标签/照片）、内部数据（资产 JSON）不译。

### 游戏文本：Codex 批量翻译

```sh
# 看所有命名空间还有多少待译
bun tools/i18n/mt/i18n-mt.ts pending

# 看某个命名空间，例如 obj.json
bun tools/i18n/mt/i18n-mt.ts pending obj.json

# 看译文里哪些条目没有按术语表统一用词（不调用 Codex）
bun tools/i18n/mt/i18n-mt.ts terms obj.json

# 翻译全部游戏/TGUI 命名空间（默认单并发串行跑完整个待译队列）
bun tools/i18n/mt/i18n-mt.ts

# 翻译某个游戏命名空间
bun tools/i18n/mt/i18n-mt.ts obj.json

# 只让 Codex 修复术语表不一致的条目
bun tools/i18n/mt/i18n-mt.ts translate-terms obj.json

# 翻译后再检查剩余待译
bun tools/i18n/mt/i18n-mt.ts pending obj.json

# 显式清单翻译（I18N_ONLY_KEYS=<json>，格式 {"<ns>.json":[key...]}）：只翻清单内条目，
# 且清单内「缺失/占位」条目**绕过可译性启发式**（hasTranslatableEnglish 把单个全大写词判成
# 标识符跳过——但人工点名的词池条目如 ion 暗号池 "PRETZELS" 就是要翻；keep-english 仍豁免）
I18N_ONLY_KEYS=tools/i18n/mt/.pending/miss-priority.json bun tools/i18n/mt/i18n-mt.ts

# 深度复查（重判中英混杂）后，把「模型翻过仍保留英文」的条目批量登记保持英文——
# 拉丁彩蛋/@pick 模板/专名密集句反复重翻不收敛，登记后深度复查也放行；
# 删除 keep-english.<locale>.json 里对应条目即恢复重译
bun tools/i18n/mt/i18n-mt.ts accept-mixed
```

翻译脚本按批次顺序启动 Codex 调用，不做并行：一批结束并合并后，才会启动下一批。默认
`I18N_MAX_CODEX_CALLS=0`，表示不限批次数，串行跑到队列完成或失败。Codex 失败时默认立刻停止，避免额度 / 登录错误后继续开新
调用；重跑同一命令会重新计算 `pending`，从剩余待译继续，不会重翻已合并条目。

为省 token，翻译中间批次会使用临时数字 ID（例如 `{"0":"English text"}`），并把同批重复英文源合并成一个 ID；
Codex 输出后再由脚本映射回真实目录 key。这对 TGUI 尤其重要，因为很多 TGUI key 本身就是英文长句。脚本默认每批
只把“本批英文源里命中的术语”发送给 Codex，不再每批发送完整术语表。

`terms` / `translate-terms` 使用同一份 `tools/i18n/mt/glossary.zh-Hans.json`：如果英文源里出现术语表 key，
但现有中文译文没有包含对应译名，就会被筛进 `tools/i18n/mt/.pending/glossary-mismatches.<locale>.json`。
`translate-terms` 只重翻这些条目，用来统一术语，不会处理普通缺译项。

`I18N_CHUNK` 控制每批喂给 Codex 的条数，默认 `200`；调小更稳但调用更多，调大能减少调用数但更容易输出不完整。
翻译脚本默认把 Codex 输出写到 `tools/i18n/mt/.pending/*.codex.log`，终端只显示批次进度条和合并数量。相关环境变量：

```sh
# 默认 0：不限批次数，但仍然单并发串行
I18N_MAX_CODEX_CALLS=0

# 兼容旧名：同义于 I18N_MAX_CODEX_CALLS
I18N_MAX_AGENTS=0
I18N_MAX_BATCHES=0

# 可选：限制一次命令只跑 4 批
I18N_MAX_CODEX_CALLS=4

# 可选：失败后继续；默认失败即停，避免 usage limit / reauth 错误时继续开调用
I18N_CONTINUE_ON_FAIL=1

# 可选：每个 Codex 调用之间等待，单位毫秒
I18N_CODEX_DELAY_MS=2000

# 可选：每批发送完整术语表；默认只发送本批命中的术语，更省 token
I18N_FULL_GLOSSARY=1

# 默认 low，覆盖用户全局 xhigh，翻译任务没必要高推理
I18N_CODEX_REASONING=low

# 可选：指定 Codex 模型
I18N_CODEX_MODEL=gpt-5.5

# 可选：调试时恢复旧行为，把 Codex 输出直接打到终端
I18N_CODEX_STDIO=inherit
```

### TGUI 文本：抽取 / 翻译 / 同步前端

「标识符耦合的 DM 显示名」（职业/怪癖/精灵配件/choiced 下拉选项…，**既是显示又是 act() 标识符**）
经两层进入前端 tgui 目录、由 TS runtime **只翻显示**（act 用原英文值，安全）：

- **AST 层（`nova-i18n labels`，推荐主力）**：按**类型路径 / proc 语义**抽取，产物 `tools/i18n/dm_labels.json`
  由 `tgui-catalog.mjs extract` 合并进 tgui 目录。优势——`init_possible_values()` 返回值经预处理器展开
  → **自动覆盖所有 choiced 下拉（含 #define 定义的选项）**，新增下拉**不必再加规则**；类型作用域的
  name/title 对上游移动文件免疫。`resync.sh` 会刷新它。
- **正则层（`tgui-catalog.mjs` 的 `DM_LABEL_SOURCES`，残留/兜底）**：覆盖 AST 够不着的路径作用域数据
  （配装/服装 obj 名按目录界定）与无法枚举的宏（DefineMap 无公开迭代器 → JOB_*/AUGMENT_SLOT_* 等
  #define 值仍走正则文件扫描）。两层 **addText 合并去重**，正则保证零回归。

```sh
# 刷新 AST 显示标签（resync.sh 已含；单独跑）
cargo run --release --manifest-path tools/i18n/Cargo.toml -- labels --dme tgstation.dme

# 抽取 TGUI 静态 JSX 文本到 strings/i18n/en/tgui.json（合并上面的 AST 标签 + JSX 文本），
# 复用已有中文译文/术语，并同步 tgui/packages/tgui/i18n/*.json
node tools/i18n/tgui-catalog.mjs extract

# 只同步：strings/i18n/<locale>/tgui.json -> tgui/packages/tgui/i18n/<locale>.json
node tools/i18n/tgui-catalog.mjs sync

# 查看 TGUI 待译
bun tools/i18n/mt/i18n-mt.ts pending tgui.json

# 查看 TGUI 术语不一致
bun tools/i18n/mt/i18n-mt.ts terms tgui.json

# 翻译 TGUI 命名空间
bun tools/i18n/mt/i18n-mt.ts tgui.json

# 只修 TGUI 术语
bun tools/i18n/mt/i18n-mt.ts translate-terms tgui.json

# TGUI 翻译完或从在线平台导回译文后，都要同步前端运行时目录
node tools/i18n/tgui-catalog.mjs sync

# 验证前端构建
tools/build/build.sh tgui
```

TGUI 动态文本如果带变量，应显式写成 `useT()` + `{0}/{1}` 参数；静态 JSX 文本由自动 runtime 查目录。例：

```tsx
const t = useT();

return <Button>{t('tgui.print_amount', [amount])}</Button>;
```

对应目录：

```json
"tgui.print_amount": "打印 {0} 个"
```

### 人工校对：在线本地化平台（自选）

译文就是 `strings/i18n/<locale>/*.json`（含 `tgui.json`）—— 扁平的 `{"key": "译文"}`。这是平台无关的标准
格式，可导入任意**在线**平台（Crowdin / Lokalise / Weblate / Tolgee Cloud 等）做团队校对，再导出回原文件。
运行时只读本地 JSON，**不联网连平台**。（旧版自托管 Tolgee 的 docker-compose 已移除。）

典型流程：

```sh
# 1) 机翻预填（Codex），先把英文目录翻一遍 / 补译；默认单并发串行跑完整个队列
bun tools/i18n/mt/i18n-mt.ts

# 2) 把 strings/i18n/<locale>/*.json 导入你选的平台 → 人工校对 → 导出回这些文件
#    （各平台用自带 CLI / 网页上传下载，格式选「扁平 JSON / key-value JSON」）

# 3) 导回后，若改了 tgui.json，需同步前端运行时子集
node tools/i18n/tgui-catalog.mjs sync

# 4) 重建生效
tools/build/build.sh
```

### 术语表

```sh
# 从英文目录挑高频候选术语（人工择入 tools/i18n/mt/glossary.zh-Hans.json）
bun tools/i18n/mt/glossary-sync.ts suggest
```

术语表本体 `tools/i18n/mt/glossary.zh-Hans.json`（英文->中文；保持英文则 value 同 key）由 Codex 机翻直接套用；
上线在线平台后，多数平台自带术语表/词汇表功能，可把这份 JSON 导入平台维护。

Codex 翻译时可以把本批新发现的固定专名写入 `.pending/*.glossary.json`，但合并阶段会保守过滤：
只自动收录缩写、带型号/符号的名称、明确的多词专名、少量显式允许的一词专名，以及 `LOWERCASE_TERM_ALLOWLIST` 里的小写游戏术语。
颜色、方向、大小、普通形容词、普通地点词、普通职业泛称、多义词等不会自动进入术语表；这类词应交给正文上下文翻译。

### 同步上游

本仓库的 `master` 在 GitHub 上自动跟随上游 NovaSector，所以本地**只需合并 `origin/master`**，
不必再配 `upstream` 远端。日常一条命令搞定（脏树检查只放过 `.vscode/settings.json`、`config/admins.txt`
这类机器本地文件）：

```sh
bash tools/i18n/sync-upstream.sh        # SYNC_BUILD=0 可跳过末尾编译
```

它依次做：`git fetch` → 把 `origin/master` 合进当前 i18n 分支 → `resync.sh`（重抽取英文目录 +
幂等改写新字符串）→ `tools/build/build.sh` 编译验证。

**用 merge 不用 rebase**：本分支提交多、改了大量 NOVA EDIT 核心文件，rebase 会强推 + 把每个上游冲突
在所有提交上反复重放；merge 每次只解一次，且 `resync.sh` 的重收敛策略就是为 merge 设计的。

**冲突分辨**（脚本撞冲突会停下并列出冲突文件，按这条手动解）：

| 冲突 hunk 里是什么 | 怎么办 |
| --- | --- |
| codemod 行 `LANG("ns.hash", …)`，或你没改过的上游逻辑 | **取上游**：`git checkout --theirs <文件> && git add <文件>`。LANG 行交给 resync 重新加回，上游逻辑本就该采纳。 |
| 你手写的 i18n 逻辑（`lang_reverse_*()` 包裹、手加的 NOVA EDIT） | **留自己的**（或两边都留）。这些 resync **不会**重新生成，盲取 theirs 会永久丢掉。常见于 `code/` 下 `book.dm` / `say.dm` / `chat.dm` / `atom_examine.dm` / `_bodyparts.dm` / `preferences/species.dm`。 |

解决后 `git commit`，再次运行 `bash tools/i18n/sync-upstream.sh`（检测到已无未合提交，直接续跑 resync + 编译）。

> 别完全信 IDE 的一键「接受当前/传入」：它可能保留你旧行又取上游行，把上游真重构丢掉。冲突涉及非 LANG 的逻辑
> 改动时，先看两边再定：`git show :2:<文件>`（ours/你的）对比 `git show :3:<文件>`（theirs/上游）。

所有 i18n 产物都可提交：`strings/i18n/en/**`、`strings/i18n/zh-Hans/**`、术语表
`tools/i18n/mt/glossary.zh-Hans.json`，以及同步出的 `tgui/packages/tgui/i18n/*.json`。只排除机器本地文件
`.vscode/settings.json`、`config/admins.txt`。`tgui-catalog.mjs extract` 会把新英文键以 `zh == en` 写入
中文源目录作为待译占位值；玩家可见文案需要翻译，路径、代码 token、专名等可审核后保持英文。处理后运行
`node tools/i18n/tgui-catalog.mjs sync`，并把中文源目录与前端运行时目录一起提交。

### 统计和排查

```sh
# 统计 TGUI 源目录总数、已译、待译、前端运行时子集数量
node - <<'NODE'
const fs = require('fs');
const en = JSON.parse(fs.readFileSync('strings/i18n/en/tgui.json'));
const zh = JSON.parse(fs.readFileSync('strings/i18n/zh-Hans/tgui.json'));
const runtimeZh = JSON.parse(fs.readFileSync('tgui/packages/tgui/i18n/zh-Hans.json'));
const pending = Object.keys(en).filter((key) => zh[key] === en[key]).length;
console.log({
  sourceTotal: Object.keys(en).length,
  sourceTranslated: Object.keys(en).length - pending,
  sourcePending: pending,
  runtimeZh: Object.keys(runtimeZh).length,
});
NODE

# JSON 格式检查
jq empty strings/i18n/en/*.json strings/i18n/zh-Hans/*.json

# 前端目录格式 / 类型 / 打包
./node_modules/.bin/biome check tgui/packages/tgui/i18n tools/i18n/tgui-catalog.mjs
cd tgui && ./node_modules/.bin/tsc && ./node_modules/.bin/rspack build
```

## 门禁与回归检测（lint / 伪 locale）—— 把「玩家踩到才发现」变成「编译期/本地挡住」

`AGENTS.md` 的「i18n 排查规律」清单长期只增不减，根因有二：① **值匹配反查的本质歧义**（一个串
是显示文本还是标识符，反查机制无法从值本身区分 → 误翻 act 键/枚举 → StripMenu 蓝屏、出生点错位、
查表静默失效）；② **译文多出占位符**（运行时无实参 → 显示生 `{N}`）。这两类以前全靠玩家上报。
现在有两道系统性防线：

### `nova-i18n lint` —— 编译期门禁（本地手动跑；无 CI workflow，i18n.yml 已删）

```sh
# 目录卫生 + 标识符碰撞静态分析（基线增量；新增高置信碰撞→非零退出）
cargo run --release --manifest-path tools/i18n/Cargo.toml -- lint \
  --dme tgstation.dme --catalog strings/i18n --locale zh-Hans \
  --baseline tools/i18n/identifier-baseline.txt

# 只跑目录卫生（不解析 DM，秒级；纯目录 PR 用）
… -- lint --catalog strings/i18n --locale zh-Hans --no-ast

# 首次采纳 / 修复碰撞后刷新基线
… -- lint --update-baseline
```

两类检查：

- **目录卫生**（零误报，硬错误）：
  - **占位符 parity**：locale 译文不得含 en 没有的 `{N}`（那个占位符永远没实参填充 → 显示生串）。
    locale **少**用占位符是合法的（中文省代词/语序重排，那次 `replacetext` 只是 no-op）——只查「多出」。
  - **裸控制字符**：locale 侧报错（译文是我们写的）；en 侧仅告警（多来自上游原文，extract 会重生）。
  - 手写 locale-only 文件（`_state_words.json` / `_fallback.json`）不参与 parity（它们本无英文源串）。
- **标识符碰撞**（AST 静态分析，根因①的系统性出口）：扫全树收集**标识符位置**的字符串字面量
  （`==`/`!=` 比较、`switch` case、`list` 下标键），与 en 目录的**可翻译值**取交集。命中 = 该串
  既被当标识符用、又会被反查表变异成译文 → 运行期比较/查表必然 miss。
  - **基线增量**（`identifier-baseline.txt`，~870 条）：冻结当前已知碰撞，CI 只对**新增**失败。
  - **置信分级**：含下划线/全大写的（`icon_state`/`render_target`/`HUMANS_ONLY`/`toggle_safety`）
    是无歧义代码 token → **新增即报错**；单词类（`acid`/`amber`，多为「被比较变量从不经翻译」的
    误报）→ **新增仅告警**。
  - 新碰撞的三条修法：① 把供给该串的变量排除出抽取（句末标点闸门 / SINK_VARS 黑名单）；
    ② 消费侧用 `lang_unreverse_text` 兜（见 chem dispenser 解药）；③ 确认安全后收进基线。

### 生产服漏翻采集（`I18N_LOG_MISSES`）—— 真实流量收割「汉化不完」

伪 locale 需要专人跑测试局；漏翻采集直接把**正式服玩家流量**变成探测器。config 开
`I18N_LOG_MISSES TRUE`（默认关）后，运行时在 `lang_fallback_apply` 出口与 TGUI 负载反查
miss 分支记录「经过所有翻译层后仍是英文」的多词串（≥3 词，或 2 词含小写开头——挡人名），
去重计数写 `data/logs/<round>/i18n_misses.log`。玩家自己输入的聊天不过这些层，不会被记录。

```sh
# 单回合或跨多回合聚合，按频次排序并自动归类到修复路径
node tools/i18n/miss-scan.mjs 'data/logs/<round>/i18n_misses.log' [更多日志...]
node tools/i18n/miss-scan.mjs --min 3 <logs>   # 只看总次数 ≥3（滤一次性噪音）
node tools/i18n/miss-scan.mjs --json <logs>    # 机器可读
```

六个分类桶直接对应 `AGENTS.md` 排查规律的处理动作：
**已译未接通**（在目录且 zh 已译 → 显示路径绕过翻译层，落地点补反查/接 sink）、
**在目录未译**（zh==en → 跑 MT 或确认 keep-english 白名单）、
**目录片段**（是某目录值的子串 → AC 最短匹配拆碎，落地点先整串反查）、
**没进目录**（抽取器漏抽 → 扩抽取源或手维护 `_<feature>.json`）、
**词池保英文**（`strings/*_replacement.json` 口音替换词池——奥克/鱼语/意式等逐词变换表，
翻译会破坏替换机制，按方针保英文；每局必刷 miss，自动归此桶降噪，无需处理）、
**噪音**（CSS 声明——用户自定义 MOTD 内联样式经 fallback 层被逐行记录；管理员日志印记——
JMP/FLW 链接括号、build mode、GC 硬删除告警、爆炸尺寸行等，保英文；无需处理）。
实现：`modular_nova/modules/i18n/code/miss_log.dm`；run 提取门槛单测
`TEST_FOCUS(/datum/unit_test/i18n_miss_log)`。

已知永久噪音（无需处理）：管理员/系统消息（`message_admins` 的 Autotransfer/jobconfig 警告
——按规范不译；2026-07 起运行时已按 MESSAGE_TYPE_ADMINLOG/ATTACKLOG/DEBUG 跳过聊天 AC，
新日志里这类会大幅减少）；服务器**本地魔改文本**（与仓库源码不一致的串永远反查不中——实测 Windows 服
把 Shadekin 词条改成了 Shadowkin，目录里的译文自然接不上；先 `git diff` 服务器部署树）。

### 伪 locale 单测门禁（`pseudo-test.sh`）—— 一键跑全量单测抓变异回归

```sh
# qps-ploc 下全量单测：任何「标识符被反查变异 → 功能破坏」直接挂测试
nix develop -c bash tools/i18n/pseudo-test.sh
# 可选：指定 locale 跑基线，区分「伪 locale 特有失败」vs「本机既有失败」
nix develop -c bash tools/i18n/pseudo-test.sh zh-Hans
```

上游合并（`resync.sh`）后手动跑一次。脚本自理：生成伪目录、临时切 config、临时禁用
`USE_RUSTG_ICONFORGE_GAGS`（本机 32 位 rust_g 在 UNIT_TESTS 构建下 iconforge GAGS 异步加载
必 SIGABRT，非 i18n 问题）、直调 DreamMaker/DreamDaemon（不经 juke）、结束自动还原。
判定放行已知基建噪音（DM 回退生成的地图预览图标与已提交版本像素有差的 runtime）。
**勿用 `build.sh dm-test`**（走 GAGS 异步路径，本机必崩）。

### 伪 locale（`qps-ploc`）—— 运行时动态检测（捕获静态分析够不着的路径）

```sh
# 1) 从 en/ 生成伪目录（每个值包成 ⟦原文⟧，保留占位符/标签；不入库，已 gitignore）
cargo run --release --manifest-path tools/i18n/Cargo.toml -- pseudo \
  --catalog strings/i18n --locale qps-ploc

# 2) config/game_options.txt 设 I18N_SERVER_LOCALE qps-ploc，跑一圈游戏 / 单元测试

# 3) 把聊天日志 / UI dump / 状态栏导出喂给爬取分析器：剥掉 ⟦⟧ 内已翻内容，
#    残留英文 = 没接进任何翻译通道的输出（漏接路径）
node tools/i18n/pseudo-scan.mjs data/logs/<round>/chat.log
some_command_that_dumps_ui | node tools/i18n/pseudo-scan.mjs --min 5
```

伪 locale 的独特价值（**无需任何真实译文**，纯靠 en 目录）：

- **抓「标识符被反查变异」的 gameplay 回归**：伪 locale 下任何被反查/P1/边界引擎处理的串都变成
  `⟦…⟧`。若某处把 `name`/枚举当标识符比较，变异后比较 miss → 现有单元测试 / 启动流程直接挂 →
  与 `lint` 的**静态**扫描互补（lint 挡新增、伪 locale 抓运行期实际变异）。
- **查漏未接通路径**：`pseudo-scan.mjs` 把「selected 中文/选项英文」「漏接的 raw browse」从
  「玩家截图上报」变成「grep 出来按频次排序」。合理噪音（ckey/缩写/代号/标识符）天然混入，先看高频。

### 运行时回归测试

- `TEST_FOCUS(/datum/unit_test/i18n_template_match)` —— 边界模板逆匹配引擎。
- `TEST_FOCUS(/datum/unit_test/i18n_unreverse)` —— `lang_reverse_text ↔ lang_unreverse_text` 往返
  不变量（守护 chem dispenser 等「UI 回传译名查英文键表」解药；回归即「中文名按了没反应」）。

> **早期初始化时序**（母版试剂表 / `meta_gas_info` 等 GLOBAL_LIST_INIT 早于 `i18n_cache`）：
> 既有方案是 `lang_build_reverse` 的「cache 未就绪返回空表且不缓存」加固 + **逐家族 SS Init 反查
> pass**（`SSair`/`SSmaterials`/`SSreagents` 等，幂等、locale==en 零开销）。这是规范模式：**新出现
> 一个早期 datum 家族就在其 SS Init 加一遍反查**（一行），不引入运行期 pending-replay 框架（会给
> 热路径 Initialize/New 加成本、且现有家族已覆盖）。

## 注意

- 目录文件放 `strings/i18n/`（`strings/` 已被 git 跟踪；`data/` 被 .gitignore 忽略）。TGUI 也使用
  `strings/i18n/<locale>/tgui.json` 作为在线平台/Codex 源目录；`tgui/packages/tgui/i18n/*.json` 是同步出的
  前端运行时子集，未译静态英文不打进 bundle。
- 占位符 `{0}/{1}` 在机翻时会被掩码保护；HTML 标签需保留。
- `dreammaker` 为 GPL-3.0，作为独立构建工具链接可接受（本项目已 GPLv3）。
- **服务端进大厅就崩（核心转储、停在按钮界面不刷日志）**：是 32 位 rust_g 的 iconforge 生成精灵图集
  时 OOM，**非 i18n**。`nix/byond.nix` 的 DreamDaemon 包装器已默认 `RAYON_NUM_THREADS=2` 压低峰值
  内存修复（详见 `modular_nova/modules/i18n/readme.md` 的「运行服务器 / 已知问题」）。
