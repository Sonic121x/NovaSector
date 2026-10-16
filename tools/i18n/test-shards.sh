#!/usr/bin/env bash
# Runs a UNIT_TESTS build as N parallel DreamDaemon servers and merges their results back into the
# single-run layout, so callers keep reading data/unit_tests.json and data/logs/ci/*.
#
#   bash tools/i18n/test-shards.sh <dmb> <shards> [extra world params]
#
# Each shard boots the full world, then runs only its slice of the suite (see
# code/modules/unit_tests/~zh/test_sharding.dm). Shards are balanced by the durations recorded
# in data/unit_test_durations.json, which this script refreshes after every run.
#
# Every shard gets its own working directory under data/test-shards/<k>/: symlinks to the repo for
# everything except data/ and the build itself (copied, see below). Sharing data/ would make N servers write the same asset cache,
# spritesheets and log files at once.
set -euo pipefail
shopt -s nullglob
cd "$(dirname "$0")/../.."

DMB=${1:?usage: test-shards.sh <dmb> <shards> [extra params]}
SHARDS=${2:?usage: test-shards.sh <dmb> <shards> [extra params]}
EXTRA_PARAMS=${3:-}
TIMEOUT=${TEST_SHARD_TIMEOUT:-1200}
ROOT=$(pwd)
SHARD_ROOT=data/test-shards
MAP_JSON=${TEST_MAP_JSON:-_maps/map_jsons/runtimestation_minimal.json}
DURATIONS=data/unit_test_durations.json

rm -rf "$SHARD_ROOT" data/logs/ci
rm -f data/unit_tests.json
mkdir -p "$SHARD_ROOT" data/logs/ci

pids=()
for ((k = 1; k <= SHARDS; k++)); do
	dir=$SHARD_ROOT/$k
	mkdir -p "$dir/data"
	for entry in "$ROOT"/* "$ROOT"/.[!.]*; do
		name=$(basename "$entry")
		case $name in
			# tmp/: rust_g writes GAGS icons to tmp/gags/ at runtime; shared, the servers delete each
			# other's files mid-run.
			data | tmp | .git | "$DMB" | "${DMB%.dmb}.rsc") continue ;;
		esac
		ln -s "$entry" "$dir/$name"
	done
	# BYOND resolves a symlinked .dmb to its real path and then resolves every relative path (data/,
	# strings/, config/) against that directory, which would put all shards back in the repo root.
	# A reflink copy is instant on btrfs/xfs and falls back to a plain copy elsewhere.
	cp --reflink=auto "$DMB" "${DMB%.dmb}.rsc" "$dir/"
	mkdir -p "$dir/tmp"
	# Start from a copy of the repo's data/ (minus logs), so a shard sees the same caches a
	# single-process run would: e.g. without data/condo_previews/ SScondos renders every condo
	# preview mid-suite, and the resulting runtimes are charged to whichever test is running.
	for entry in data/* data/.[!.]*; do
		case $(basename "$entry") in
			logs | test-shards | unit_tests.json | unit_tests.shard-*.json) continue ;;
		esac
		cp -r --reflink=auto "$entry" "$dir/data/"
	done
	cp "$MAP_JSON" "$dir/data/next_map.json"
	params="log-directory=ci&test-shard=$k&test-shards=$SHARDS"
	[[ -n $EXTRA_PARAMS ]] && params="$params&$EXTRA_PARAMS"
	(cd "$dir" && exec timeout -k 30 "$TIMEOUT" DreamDaemon "$DMB" -close -trusted -verbose -params "$params" > dd.out 2>&1) &
	pids+=($!)
done

failed_shards=()
for ((k = 1; k <= SHARDS; k++)); do
	if ! wait "${pids[$((k - 1))]}"; then
		failed_shards+=("$k")
	fi
done
for k in "${failed_shards[@]}"; do
	echo "!! shard $k exited abnormally or timed out (limit ${TIMEOUT}s); last lines:" >&2
	tail -3 "$SHARD_ROOT/$k/data/logs/ci/tests.log" 2>/dev/null | cut -c1-160 >&2 || true
done

# Logs: concatenate same-named files in shard order. clean_run.lk only if every shard was clean.
all_clean=1
for ((k = 1; k <= SHARDS; k++)); do
	logs=$SHARD_ROOT/$k/data/logs/ci
	[[ -f $logs/clean_run.lk ]] || all_clean=0
	[[ -d $logs ]] || continue
	for file in "$logs"/*; do
		[[ -f $file ]] || continue
		name=$(basename "$file")
		[[ $name == clean_run.lk ]] && continue
		cat "$file" >> "data/logs/ci/$name"
	done
done
if ((all_clean)); then
	cp "$SHARD_ROOT/1/data/logs/ci/clean_run.lk" data/logs/ci/clean_run.lk
fi

# Results: union of the shard files. A missing shard file means that shard never finished, so
# data/unit_tests.json is withheld and callers fail instead of reading a partial result.
python3 - "$SHARD_ROOT" "$SHARDS" "$DURATIONS" <<'EOF'
import json, os, sys
root, shards, durations_path = sys.argv[1], int(sys.argv[2]), sys.argv[3]
merged, missing = {}, []
for k in range(1, shards + 1):
    path = os.path.join(root, str(k), 'data', f'unit_tests.shard-{k}.json')
    if not os.path.exists(path):
        missing.append(k)
        continue
    merged.update(json.load(open(path)))
durations = json.load(open(durations_path)) if os.path.exists(durations_path) else {}
for name, result in merged.items():
    if result.get('duration'):
        durations[name] = result['duration']
json.dump(durations, open(durations_path, 'w'), indent='\t', sort_keys=True)
if missing:
    print(f'!! shards {missing} wrote no results; data/unit_tests.json not written', file=sys.stderr)
    sys.exit(0)
json.dump(merged, open('data/unit_tests.json', 'w'))
print(f'==> merged {len(merged)} test results from {shards} shards')
EOF
