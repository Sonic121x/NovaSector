#!/bin/bash
# 伪 locale 单测门禁：qps-ploc + UNIT_TESTS 跑全量单测。
#
# 目的：抓「标识符被反查变异 → 功能破坏」的运行期回归（lint 是静态、挡新增；此脚本抓
# 实际变异后的行为）。伪 locale 把 en 目录每个值包成 ⟦原文⟧——任何把 name/枚举当标识符
# 比较/查表的路径，变异后必 miss → 单测直接挂。上游合并后（resync.sh 之后）手动跑一次。
#
# 实现说明（为什么不走 `build.sh dm-test`）：
#   1. 本机 32 位 rust_g 的 `iconforge_load_gags_config_async` 在 UNIT_TESTS 构建
#      （REFERENCE_TRACKING + DO_NOT_DEFER_ASSETS 内存压力）下必崩（SIGABRT，
#      与 locale 无关；生产构建无此问题）→ 编译期临时禁用 USE_RUSTG_ICONFORGE_GAGS，
#      灰度回退 DM 端生成（慢但稳，门禁不关心图标产物）。
#   2. 直接调 DreamMaker/DreamDaemon（DM 516 支持 -D 定义），不经 juke。
#
# 用法（NixOS 在 nix develop 里跑，或 nix develop -c bash tools/i18n/pseudo-test.sh）：
#   bash tools/i18n/pseudo-test.sh              # qps-ploc 门禁
#   bash tools/i18n/pseudo-test.sh zh-Hans      # 可选：指定 locale 跑基线（区分本机既有失败）
#
# 退出码 0 = 单测在伪 locale 下全绿；非 0 = 有变异回归（看 data/logs/ci/tests.log）。
# 结束后（含中断）自动还原 config 与 _compile_options.dm；qps-ploc 目录不入库（已 gitignore）。
set -euo pipefail
cd "$(dirname "$0")/../.."

CONFIG=config/game_options.txt
COMPILE_OPTS=code/_compile_options.dm
NOVA_I18N=tools/i18n/target/release/nova-i18n
GAGS_DEFINE='#define USE_RUSTG_ICONFORGE_GAGS'
GATE_LOCALE=${1:-qps-ploc}

if [[ ! -x $NOVA_I18N ]]; then
	cargo build --release --manifest-path tools/i18n/Cargo.toml
fi

if pgrep -x DreamDaemon > /dev/null; then
	echo "!! 已有 DreamDaemon 在跑（会争抢 .rsc/日志），先停掉再跑门禁" >&2
	exit 1
fi

if [[ $GATE_LOCALE == qps-ploc ]]; then
	echo "==> 生成伪 locale 目录 strings/i18n/qps-ploc/"
	"$NOVA_I18N" pseudo --catalog strings/i18n --locale qps-ploc
fi

ORIG_LOCALE=$(sed -n 's/^I18N_SERVER_LOCALE //p' "$CONFIG")
restore() {
	sed -i "s/^I18N_SERVER_LOCALE .*/I18N_SERVER_LOCALE ${ORIG_LOCALE:-en}/" "$CONFIG"
	sed -i "s@^// PSEUDO-TEST-DISABLED $GAGS_DEFINE@$GAGS_DEFINE@" "$COMPILE_OPTS"
	rm -f tgstation.test.dme tgstation.test.dmb tgstation.test.rsc
	rm -f data/next_map.json # 单测地图指定（见下），别留给正常起服用
	# 测试运行会用 DM 回退生成的地图预览图标覆盖已提交 .dmi（与 rustg 生成版像素有差，勿保留）
	git checkout --quiet -- icons/map_icons/ 2>/dev/null || true
	echo "==> 已还原 $CONFIG（I18N_SERVER_LOCALE ${ORIG_LOCALE:-en}）、$COMPILE_OPTS 与 icons/map_icons/"
}
trap restore EXIT

sed -i "s/^I18N_SERVER_LOCALE .*/I18N_SERVER_LOCALE $GATE_LOCALE/" "$CONFIG"
sed -i "s@^$GAGS_DEFINE@// PSEUDO-TEST-DISABLED $GAGS_DEFINE@" "$COMPILE_OPTS"
echo "==> config 已切 $GATE_LOCALE；USE_RUSTG_ICONFORGE_GAGS 已临时禁用"

echo "==> 编译（-DCBT -DCIBUILDING = UNIT_TESTS）"
cp tgstation.dme tgstation.test.dme
DreamMaker -DCBT -DCIBUILDING tgstation.test.dme

echo "==> 运行全量单测"
rm -rf data/logs/ci
# **必须指定单测地图**（与 tools/ci/run_server.sh 同款做法）。绝大多数单测的 test_flags 默认是
# UNIT_TEST_BASIC，而 UNIT_TEST_BASIC == UNIT_TEST_DEBUG_MAP_ONLY（见 _unit_tests.dm:75-77），
# 不在 is_unit_test_map 的地图上会被整批跳过。漏了这一步的话只跑得到十几个地图/基建类测试，
# 全部 i18n 单测（i18n_unreverse / i18n_template / i18n_phobia …）一个都不会执行——而门禁仍报
# 「单测失败 0 个」，是**假绿**。
mkdir -p data
cp _maps/runtimestation_minimal.json data/next_map.json
# 清掉上一轮的单测结果。**不清就是假红/假绿**：下面的门禁直接读 data/unit_tests.json，而这个文件
# 只在单测跑完时才被覆盖 —— 本轮若因任何原因没写出它，门禁就会**拿上一轮的结果当本轮的**。
# 2026-07-31 实测：本轮 i18n_ac_longest / i18n_template_match 在日志里都是 PASS，门禁却报这两条
# 失败，因为读到的是 10 分钟前那次失败运行留下的 json。
rm -f data/unit_tests.json
DreamDaemon tgstation.test.dmb -close -trusted -verbose -params "log-directory=ci"

if [[ -f data/logs/ci/clean_run.lk ]]; then
	cat data/logs/ci/clean_run.lk
	echo "==> 伪 locale 门禁通过：单测全绿、零 runtime"
	exit 0
fi

# clean_run.lk 缺失 ≠ 必然是 i18n 回归：本机已知基建噪音（GAGS 走 DM 回退时地图预览
# 图标与 rustg 生成的已提交版本像素有差）会产生 runtime 但与 locale 无关。
# 判定：单测失败数 + 非白名单 runtime 数，两者皆零则视为通过。
TEST_FAILS=$(python3 -c "
import json
# 已知失败白名单：**必须逐条写明为何与 i18n 回归无关**，否则就是在掩盖问题。
# 新增条目前先确认它在 locale=en 下也失败（或纯属 i18n 设计的既定后果）。
KNOWN = set()
# 白名单**必须为空或逐条写明为何与 i18n 回归无关**。历史条目 spare_id_name 已随
# 「name 不再原地反查」一起解决（`/obj/item/card/id/advanced/update_label()` 的
# lang_reverse_text 包裹已撤回上游写法，name 保持 canonical English），不要再加回来。
import os, sys
if not os.path.exists('data/unit_tests.json'):
    print('data/unit_tests.json 不存在——单测没跑完/没写出结果，判失败（绝不沿用上一轮结果）', file=sys.stderr)
    print('999')
    raise SystemExit(0)
d = json.load(open('data/unit_tests.json'))
fails = sorted(k for k, v in d.items() if v.get('status') == 1)
unknown = [k for k in fails if k not in KNOWN]
import sys
if fails:
    print('已知失败: %s' % sorted(set(fails) & KNOWN), file=sys.stderr)
    if unknown:
        print('未知失败: %s' % unknown, file=sys.stderr)
print(len(unknown))
" || echo 1)
ALL_RUNTIMES=$(grep -c "runtime error" data/logs/ci/runtime.log || true)
# 良性 runtime = 本机 GAGS 走 DM 回退产生的地图预览噪音，两种消息都算：像素对不上，以及
# GAGS 配置缺 icon state。**都与 locale 无关**——已用 `pseudo-test.sh en` 基线证实两次运行
# 完全一致。只认第一种的话，门禁在本机恒定退出 1，等于没有门禁。
BENIGN_RUNTIMES=$(grep -cE "Generated map icons were different|GAGS configuration missing icon state" data/logs/ci/runtime.log || true)
echo "==> 单测失败 $TEST_FAILS 个（已扣除白名单；明细见上）；runtime ${ALL_RUNTIMES:-0} 条（其中已知地图图标噪音 ${BENIGN_RUNTIMES:-0} 条）"
if [[ ${TEST_FAILS:-1} -eq 0 && $((${ALL_RUNTIMES:-0} - ${BENIGN_RUNTIMES:-0})) -eq 0 ]]; then
	echo "==> 伪 locale 门禁通过（仅余已知基建噪音）"
	exit 0
fi
echo "==> 伪 locale 门禁失败：见 data/logs/ci/tests.log 与 data/unit_tests.json" >&2
exit 1
