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
	echo "==> 已还原 $CONFIG 与 $COMPILE_OPTS"
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
# **必须指定单测地图**：多数单测的 test_flags 是 UNIT_TEST_BASIC == UNIT_TEST_DEBUG_MAP_ONLY，
# 不在 is_unit_test_map 的地图上会被整批跳过 —— 那样采集到的交互面只剩十几个基建测试，
# 看着"没几条漏翻"其实是根本没跑（与 pseudo-test.sh 里那条假绿注释同一个坑）。
mkdir -p data
cp _maps/runtimestation_minimal.json data/next_map.json
DreamDaemon tgstation.test.dmb -close -trusted -verbose -params "log-directory=ci" 2>&1 | tail -3 || true

if [[ ! -f $MISS_LOG ]]; then
	echo "==> 没有产出 $MISS_LOG（可能一条漏翻都没有，或采集未生效）"
	exit 0
fi
echo "==> 漏翻 $(wc -l < "$MISS_LOG") 行，按来源聚合："
awk -F'src=' '{split($2,a," "); print a[1]}' "$MISS_LOG" | sort | uniq -c | sort -rn
echo
echo "==> 明细见 $MISS_LOG；离线归类：node tools/i18n/miss-scan.mjs"
