#!/bin/bash
# 漏翻采集器：拿**单元测试套件当交互驱动**，跑一遍真 locale（默认 zh-Hans）并开启 I18N_LOG_MISSES，
# 把所有「过完全部翻译层仍是英文」的串收进 data/logs/ci/i18n_misses.log，再离线聚合。
#
# 解决的问题：examine 可以靠抽样实例化枚举（见 i18n_display_leaks 那轮），但 visible_message、
# balloon、各种交互消息**必须有人去触发**，而生产日志又不记录它们的渲染结果（attack.log 记的是
# 日志自己的措辞）。测试套件恰好会大量创建 atom、打架、开机器、跑手术——它就是现成的交互驱动。
#
# 与 pseudo-test.sh 的区别：那个用伪 locale 抓「标识符被反查变异 → 功能坏」；这个用**真译文**
# 抓「玩家还能看到英文」。两者互补，都不能替代对方。
#
# 用法（NixOS 在 nix develop 里跑）：
#   bash tools/i18n/miss-harvest.sh              # zh-Hans
#   bash tools/i18n/miss-harvest.sh zh-Hans      # 显式指定
# 结束后（含中断）自动还原 config 与 _compile_options.dm。
set -euo pipefail
cd "$(dirname "$0")/../.."

CONFIG=config/game_options.txt
COMPILE_OPTS=code/_compile_options.dm
GAGS_DEFINE='#define USE_RUSTG_ICONFORGE_GAGS'
HARVEST_LOCALE=${1:-zh-Hans}
MISS_LOG=data/logs/ci/i18n_misses.log

if pgrep -x DreamDaemon > /dev/null; then
	echo "!! 已有 DreamDaemon 在跑（会争抢 .rsc/日志），先停掉" >&2
	exit 1
fi

ORIG_LOCALE=$(sed -n 's/^I18N_SERVER_LOCALE //p' "$CONFIG")
ORIG_MISSES=$(sed -n 's/^I18N_LOG_MISSES //p' "$CONFIG" || true)
restore() {
	sed -i "s/^I18N_SERVER_LOCALE .*/I18N_SERVER_LOCALE ${ORIG_LOCALE:-en}/" "$CONFIG"
	if [[ -n ${ORIG_MISSES:-} ]]; then
		sed -i "s/^I18N_LOG_MISSES .*/I18N_LOG_MISSES $ORIG_MISSES/" "$CONFIG"
	else
		sed -i '/^I18N_LOG_MISSES /d' "$CONFIG"
	fi
	sed -i "s@^// MISS-HARVEST-DISABLED $GAGS_DEFINE@$GAGS_DEFINE@" "$COMPILE_OPTS"
	rm -f tgstation.test.dme tgstation.test.dmb tgstation.test.rsc
	rm -f data/next_map.json # 单测地图指定，别留给正常起服用
	# 禁掉 rustg iconforge 之后地图预览图标改由 DM 回退生成，像素与已提交 .dmi 有差 —— 不还原
	# 就会把它们当成本次改动一起提交（pseudo-test.sh 早就在还原，这里漏了）。
	git checkout --quiet -- icons/map_icons/ 2>/dev/null || true
	echo "==> 已还原 $CONFIG、$COMPILE_OPTS 与 icons/map_icons/"
}
trap restore EXIT

sed -i "s/^I18N_SERVER_LOCALE .*/I18N_SERVER_LOCALE $HARVEST_LOCALE/" "$CONFIG"
if grep -q '^I18N_LOG_MISSES ' "$CONFIG"; then
	sed -i "s/^I18N_LOG_MISSES .*/I18N_LOG_MISSES 1/" "$CONFIG"
else
	printf 'I18N_LOG_MISSES 1\n' >> "$CONFIG"
fi
# 本机 32 位 rust_g 的 iconforge GAGS 在 UNIT_TESTS 构建下必崩，与 pseudo-test.sh 同样处理。
sed -i "s@^$GAGS_DEFINE@// MISS-HARVEST-DISABLED $GAGS_DEFINE@" "$COMPILE_OPTS"

echo "==> 编译（-DCBT -DCIBUILDING = UNIT_TESTS）"
cp tgstation.dme tgstation.test.dme
DreamMaker -DCBT -DCIBUILDING tgstation.test.dme

echo "==> 跑测试套件（locale=$HARVEST_LOCALE，漏翻采集开）"
rm -rf data/logs/ci
rm -f data/unit_tests.json  # 不清就会拿上一轮的结果当本轮的（pseudo-test.sh 里那条假绿注释同源）
# **必须指定单测地图**：多数单测的 test_flags 是 UNIT_TEST_BASIC == UNIT_TEST_DEBUG_MAP_ONLY，
# 不在 is_unit_test_map 的地图上会被整批跳过 —— 那样采集到的交互面只剩十几个基建测试，
# 看着"没几条漏翻"其实是根本没跑（与 pseudo-test.sh 里那条假绿注释同一个坑）。
mkdir -p data
cp _maps/runtimestation_minimal.json data/next_map.json
# **硬超时**：开了 I18N_LOG_MISSES 之后 P1 短语缓存被关掉、每条串还要多跑一遍 miss 扫描，整轮
# 比 pseudo-test 慢得多；万一套件卡住（实测遇到过一次，测试停在 screenshot 之后、游戏却还在 tick），
# 没有超时就会无声无息地挂上几十分钟。超时后打印最后进展，方便直接定位卡在哪。
if ! timeout -k 30 1200 DreamDaemon tgstation.test.dmb -close -trusted -verbose -params "log-directory=ci" 2>&1 | tail -3; then
	echo "!! 测试套件超时或异常退出（上限 20 分钟）"
	echo "   tests.log 最后写入：$(stat -c %y data/logs/ci/tests.log 2>/dev/null || echo 无)"
	echo "   最后几行："
	tail -3 data/logs/ci/tests.log 2>/dev/null | cut -c1-140
	pkill -9 -f "tgstation.test.dmb" 2>/dev/null || true
fi
if [[ ! -f data/unit_tests.json ]]; then
	echo "!! 单测结果未产出 —— 套件没跑完，下面的漏翻数据是**不完整**的，别拿它下结论"
fi

if [[ ! -f $MISS_LOG ]]; then
	echo "==> 没有产出 $MISS_LOG（可能一条漏翻都没有，或采集未生效）"
	exit 0
fi
echo "==> 漏翻 $(wc -l < "$MISS_LOG") 行，按来源聚合："
awk -F'src=' '{split($2,a," "); print a[1]}' "$MISS_LOG" | sort | uniq -c | sort -rn
echo
echo "   来源含义（见 miss_log.dm）："
echo "     fallback  聊天/浏览器/公告/状态栏/气泡整行里残留的英文 run（多词门槛）"
echo "     arg       LANG 实参整条链 miss —— 模板译了、填进去的值是英文（单词也收）"
echo "     capture   模板逆匹配命中了、捕获值没翻"
echo "     display   examine 名/悬停/径向菜单/tgui_input_list 的显示边界 miss（带调用点类型）"
echo "     desc      examine 描述的显示边界 miss（带调用点类型）"
echo "     namespan  聊天里 span_name() 包着的说话者/emote 名字整块没翻"
echo "     tgui      TGUI **负载值**（服务端 P1）miss"
echo "     tgui-ui   TGUI **前端**查表 miss —— 只有真人开界面才会产生，单测跑不出来"
echo
echo "==> 明细见 $MISS_LOG；离线归类：node tools/i18n/miss-scan.mjs $MISS_LOG"
echo "    只翻玩家真的看到的那批：node tools/i18n/miss-scan.mjs --emit-pending $MISS_LOG \\"
echo "      && I18N_ONLY_KEYS=tools/i18n/mt/.pending/miss-priority.json bun tools/i18n/mt/i18n-mt.ts"
