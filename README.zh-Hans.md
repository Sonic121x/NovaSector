# Nova Sector 简体中文汉化分支

> English: see [README.md](./README.md).

[![CI Suite](https://github.com/sernseek/NovaSector/workflows/CI%20Suite/badge.svg)](https://github.com/sernseek/NovaSector/actions?query=workflow%3A%22CI+Suite%22)
[![Upstream](https://img.shields.io/badge/upstream-NovaSector%2FNovaSector-blue)](https://github.com/NovaSector/NovaSector)
[![Locale](https://img.shields.io/badge/locale-zh--Hans-red)](./strings/i18n/zh-Hans)

本仓库是 [**NovaSector**](https://github.com/NovaSector/NovaSector)（[/tg/station](https://github.com/tgstation/tgstation) 的下游 fork，BYOND 引擎）的**简体中文汉化分支**，只做一件事：在上游之上叠加一套全量本地化系统。

这里**不修改游戏内容**——上游定期合并进来，本仓库新增的全部是翻译基础设施与译文数据。

**请注意：本仓库包含成人／露骨内容，不适合未满 18 周岁者。**

## 这个分支做了什么

覆盖玩家真正看得到的文本：聊天、检视（examine）、TGUI 界面、station 公告、命令面板（verb）、气泡提示、径向菜单。

| | |
| --- | --- |
| 英文目录条目 | 128,753 |
| 已译（zh-Hans） | 126,913（98%） |
| TGUI 前端目录 | 13,942 条 |
| 本地化回归测试 | 16 个 DM 单元测试 |

语言由一个服务端配置项切换：

```
I18N_SERVER_LOCALE zh-Hans
```

保持默认 `en` 时，整条翻译层是 **no-op**：零行为变化、无可测开销。另附一个伪 locale（`qps-ploc`）用于验证标识符不会被翻译层改坏。

### 设计约束

以下几条是这套层能安全叠在上游之上的原因：

- **机器标识符恒为英文。** act 回传值、`icon_state`、查表键、职位名、ref 一律不翻，只翻显示文本。TGUI 负载值**不做就地改写**，译文经独立 overlay 下发，因此界面回传给服务端的值逐字节不变。
- **目录 key 是内容哈希**，上游改词只会让受影响的那几条失效，而不会悄悄沿用过期译文。
- **核心文件改动极少且有标记。** 绝大部分实现在 `modular_nova/modules/i18n/` 与生成的目录里；`code/` 内的改动是 codemod 产出的机械 `LANG()` 调用点。

## 仓库结构

| 路径 | 内容 |
| --- | --- |
| [`strings/i18n/<locale>/`](./strings/i18n) | 译文目录，扁平 JSON，可直接导入 Crowdin / Weblate / Lokalise |
| [`modular_nova/modules/i18n/`](./modular_nova/modules/i18n/readme.md) | 运行时：`LANG()`、反查、显示边界、落地兜底层 |
| [`tools/i18n/`](./tools/i18n/README.md) | Rust + Node 工具链：抽取、改写、重同步、lint、机器翻译 |
| [`tgui/packages/tgui/i18n/`](./tgui/packages/tgui) | 前端自动本地化与随包目录 |
| [`AGENTS.md`](./AGENTS.md) | 架构说明，以及持续记录的本地化陷阱清单 |

常用命令：

```sh
nova-i18n extract          # 改动玩家可见英文后刷新目录
nova-i18n lint             # 悬空 key、标识符碰撞、裸英文
bash tools/i18n/resync.sh  # 上游合并之后
```

## 参与翻译

目录是按内容哈希索引的扁平 JSON，可直接放进任何标准本地化平台校对后导回。欢迎对 `strings/i18n/zh-Hans/` 提 PR 修正。

当前中文以机器翻译加规则守卫为主，人工校对仍在持续进行——请当作**工作草稿**而非成品，读着别扭的地方欢迎报告。

## 构建与上游文档

构建、开服、贡献规范与上游一致：

| | |
| --- | --- |
| 下载 | [.github/guides/DOWNLOADING.md](.github/guides/DOWNLOADING.md) |
| 运行服务器 | [.github/guides/RUNNING_A_SERVER.md](.github/guides/RUNNING_A_SERVER.md) |
| 编译 | [tools/build/README.md](tools/build/README.md) |
| 模块化指南 | [modular_nova/readme.md](./modular_nova/readme.md) |
| 镜像指南 | [modular_nova/mirroring_guide.md](./modular_nova/mirroring_guide.md) |
| 贡献指南 | [.github/CONTRIBUTING.md](./.github/CONTRIBUTING.md) |

用 `tools/build/build.sh` 构建（Windows 用 `BUILD.bat`）。直接在 DreamMaker 里编译已废弃，可能报 `'tgui.bundle.js': cannot find file` 之类错误。

## 许可

与上游一致，详见英文 [README.md](./README.md) 的 LICENSE 段与仓库内 [LICENSE](./LICENSE)、`GPLv3.txt`。

`strings/i18n/` 下的译文目录是上游文本的衍生作品，适用相同许可。
