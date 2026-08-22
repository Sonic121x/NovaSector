#!/bin/bash
# TGUI 前端漏翻的**离线扫掠**：把每个界面在 happy-dom 里渲染一遍，收「查遍前端目录仍是英文」的串。
#
# 为什么单独有这一条：TGUI 是 DM 侧完全看不见的一面（静态 JSX 文本、可翻 prop、children 模板都在
# 浏览器里查表，服务端毫无痕迹）。`miss-harvest.sh` 跑一整轮单测，`tgui-ui` 那一栏恒为 0 —— 那是
# 「测试套件没有浏览器」，不是「前端没有漏翻」。这个脚本补上那一面，且**不需要 BYOND、不需要真人**。
#
# 三者的分工：
#   pseudo-test.sh   伪 locale + 真单测  → 抓「标识符被反查变异 → 功能坏」
#   miss-harvest.sh  真译文 + 真单测     → 抓「DM 侧玩家还能看到英文」
#   tgui-sweep.sh    真译文 + 离线渲染   → 抓「前端界面上玩家还能看到英文」
#
# 用法：bash tools/i18n/tgui-sweep.sh
set -euo pipefail
cd "$(dirname "$0")/../.."

cd tgui
# 文件名不含 `.test`，默认的 `bun test` 不会跑它（它比整个前端测试套件慢一个量级）；
# 但 bun 要求显式给 `./` 前缀的路径才肯把它当测试文件跑。
bun test ./packages/tgui/i18n/render-sweep.sweep.tsx
cd ..

echo
echo "==> 归类：node tools/i18n/miss-scan.mjs data/logs/tgui_misses.log"
echo "    只翻玩家真的看到的那批："
echo "      node tools/i18n/miss-scan.mjs --emit-pending data/logs/tgui_misses.log \\"
echo "        && I18N_ONLY_KEYS=tools/i18n/mt/.pending/miss-priority.json bun tools/i18n/mt/i18n-mt.ts"
