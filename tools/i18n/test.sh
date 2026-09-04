#!/usr/bin/env bash
# 可选本地 i18n 测试。不是 git hook，小改动不必跑。
#
#   bash tools/i18n/test.sh              # 快：覆盖率分栏（默认）
#   bash tools/i18n/test.sh coverage     # 同上
#   bash tools/i18n/test.sh catalog      # 长：真 zh-Hans 全量单测（落地层真目录）
#   bash tools/i18n/test.sh harvest      # 更长：漏翻采集（结束时带基线跑 miss-scan）
#   bash tools/i18n/test.sh miss-scan    # 有 data/logs/ci/i18n_misses.log 才扫；没有则跳过、0 退出
#   bash tools/i18n/test.sh all          # catalog + harvest
#
# catalog 走 pseudo-test.sh zh-Hans：会编 UNIT_TESTS 并跑整套单测。
# i18n_real_catalog / i18n_html_tag_keys 在 locale=en 或 qps-ploc 下会跳过；
# 只有这条路径会真正加载 zh-Hans 并执行它们。
# 默认只跑 coverage，不是 git hook。
set -euo pipefail
cd "$(dirname "$0")/../.."

usage() {
	cat <<'EOF'
可选本地 i18n 测试。不是 git hook，提交前不必跑。

用法：
  bash tools/i18n/test.sh              # 快：覆盖率分栏
  bash tools/i18n/test.sh coverage     # 同上
  bash tools/i18n/test.sh catalog      # 长：真 zh-Hans 全量单测
  bash tools/i18n/test.sh harvest      # 更长：漏翻采集（结束时带基线跑 miss-scan）
  bash tools/i18n/test.sh miss-scan    # 有 harvest 日志才扫；没有则跳过、0 退出
  bash tools/i18n/test.sh all          # catalog + harvest
EOF
}

mode=${1:-coverage}
case "$mode" in
	-h | --help)
		usage
		exit 0
		;;
	coverage)
		node tools/i18n/coverage.mjs
		;;
	catalog)
		echo "==> 真 zh-Hans 目录门禁（全量单测，较久）"
		bash tools/i18n/pseudo-test.sh zh-Hans
		;;
	harvest)
		echo "==> 漏翻采集（全量单测 + I18N_LOG_MISSES，更久）"
		bash tools/i18n/miss-harvest.sh
		;;
	miss-scan)
		log=data/logs/ci/i18n_misses.log
		if [[ ! -f $log ]]; then
			echo "==> 没有 $log，跳过 miss-scan"
			exit 0
		fi
		echo "==> miss-scan 增量基线（只对新增 src+text 失败）"
		node tools/i18n/miss-scan.mjs --baseline tools/i18n/miss-baseline.txt "$log"
		;;
	all)
		echo "==> 真 zh-Hans 目录门禁"
		bash tools/i18n/pseudo-test.sh zh-Hans
		echo "==> 漏翻采集"
		bash tools/i18n/miss-harvest.sh
		;;
	*)
		usage >&2
		exit 1
		;;
esac
