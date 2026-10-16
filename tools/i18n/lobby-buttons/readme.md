# 大厅按钮中文重绘（lobby buttons i18n）

大厅(加入界面)的几个按钮把文字**烤进了精灵图**(`icons/hud/lobby/*.dmi`)，运行时反查翻译够不着。
本工具用**像素 CJK 字体**逐帧把英文字区替换成中文，生成中文版 `.dmi` 到
`modular_zh/modules/i18n/icons/lobby/`，由 `master_files/.../new_player.dm` 的 `SlowInit` 覆盖在
**全服中文(I18N_SERVER_LOCALE≠en)时换图**——核心 `.dmi` 不动，上游合并友好。

## 覆盖的按钮（文字按钮）

| 源 `.dmi` | 中文 | 备注 |
| --- | --- | --- |
| `join.dmi` | 加入游戏 | |
| `observe.dmi` | 旁观 | 默认/悬停双色自动匹配 |
| `ready.dmi` | 未准备 / 准备就绪 | not_ready→未准备(粉)、ready→准备就绪(绿) |
| `character_setup.dmi` | 角色 / 设置 | 两行 |
| `start_now.dmi` | —（不处理） | 木牌喷漆手绘体 + 仅 localhost，留英文 |

底部图标按钮(设置/变更日志/名册/投票)是象形图标、无文字，不需处理。

## 字体

中文用 **Fusion Pixel Font**（10px proportional, zh_hans），开源 **SIL OFL-1.1**：
<https://github.com/TakWolf/fusion-pixel-font> 。**只用其渲染出的位图**(烤进 `.dmi`)，不分发字体文件本身
（OFL 不约束字体渲染产物）。脆像素质感与原按钮的 LCD 点阵一致。

## 重新生成

上游改了这些按钮、或想改中文字样时：

```sh
cd tools/i18n/lobby-buttons
# 下载 Fusion Pixel 10px proportional BDF，解压出 fusion-pixel-10px-proportional-zh_hans.bdf 到本目录
curl -sL https://github.com/TakWolf/fusion-pixel-font/releases/latest/download/... -o fusion.zip && unzip fusion.zip
# 在仓库根目录跑（需 PIL；NixOS: nix-shell -p python3Packages.pillow）
cd ../../.. && nix-shell -p python3Packages.pillow --run "python3 tools/i18n/lobby-buttons/gen_dmi.py"
```

脚本逻辑：读原 `.dmi` 的 zTXt 元数据(状态名/帧数)→ 逐帧检测文字区(按饱和度找彩色像素簇)+ 采样原文字
颜色 → 擦底重绘中文(空屏动画帧自动留空，保住淡入动画)→ 重打包 PNG 并**保留原 zTXt 元数据**(放回 IHDR 之后)。
新增按钮只需在脚本的按钮列表 + `textfor()` 加一行，并在 `master_files` 的换图表里加一条。
