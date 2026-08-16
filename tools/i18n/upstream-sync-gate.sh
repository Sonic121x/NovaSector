#!/bin/sh
set -eu

# Which repository this gate is allowed to run against. The point of the check is to keep a
# sync from running inside a downstream consumer repo, and remote URLs identify a repository
# far better than a filesystem path does: the same clone passes wherever it lives, and a
# different repo sitting at the "expected" path is still caught. Overridable so a fork can
# use the gate without editing it.
EXPECTED_ORIGIN=${NOVA_SYNC_ORIGIN:-https://github.com/sernseek/NovaSector.git}
EXPECTED_UPSTREAM=${NOVA_SYNC_UPSTREAM:-https://github.com/NovaSector/NovaSector.git}

fail() {
  printf 'upstream-sync gate: %s\n' "$*" >&2
  exit 1
}

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || fail "not inside a Git worktree"
cd "$repo_root"

state_dir=$(git rev-parse --git-path nova-sync-gate)
mkdir -p "$state_dir"
lost_file="$state_dir/i18n-lost.txt"
stamp_file="$state_dir/verified"

check_remote() {
  remote_name=$1
  expected=$2
  actual=$(git remote get-url "$remote_name" 2>/dev/null) || fail "missing $remote_name remote"
  case "$actual" in
    "$expected"|git@github.com:${expected#https://github.com/}|ssh://git@github.com/${expected#https://github.com/}) ;;
    *) fail "$remote_name points to $actual, expected $expected" ;;
  esac
}

preflight() {
  check_remote origin "$EXPECTED_ORIGIN"
  check_remote upstream "$EXPECTED_UPSTREAM"

  [ -z "$(git diff --name-only --diff-filter=U)" ] || fail "unresolved merge conflicts remain"
  [ -z "$(git ls-files 'modular_z121/**' 'tools/tts-pocket/**')" ] || fail "forbidden downstream files are tracked"
  if git grep -n -E '^(<<<<<<< |>>>>>>> )' -- '*.dm' '*.dme' '*.tsx' '*.ts' '*.json' >/dev/null 2>&1; then
    fail "conflict markers remain in tracked source files"
  fi
}

write_lost_report() {
  base=$1
  git cat-file -e "$base^{commit}" 2>/dev/null || fail "invalid localization baseline: $base"
  git diff "$base" --unified=0 -- code/ html/ interface/ tgui/packages/ |
    awk '
      /^\+\+\+ b\// { file = substr($0, 7) }
      /^-/ && !/^---/ && ($0 ~ /lang_[a-z_]+\(|LANG\(|NOVA EDIT[^\n]*[Ii]18[Nn]|I18N/) {
        print file ": " substr($0, 2)
      }
    ' > "$lost_file"
}

check_lost_review() {
  review_file=${1:-}
  lost_count=$(awk 'END { print NR + 0 }' "$lost_file")
  [ "$lost_count" -eq 0 ] && return 0

  [ -n "$review_file" ] || fail "$lost_count lost localization lines require an ordered TSV review: $lost_file"
  [ -f "$review_file" ] || fail "lost-line review file does not exist: $review_file"
  reviewed_count=$(awk -F '\t' 'NF >= 2 && length($NF) > 0 { count++ } END { print count + 0 }' "$review_file")
  [ "$reviewed_count" -eq "$lost_count" ] ||
    fail "review has $reviewed_count dispositions for $lost_count lost lines; keep report order and use: <lost line><TAB><reason>"
}

run_verification() {
  base=$1
  review_file=${2:-}

  preflight
  [ -z "$(git status --porcelain)" ] || fail "commit or remove working-tree changes before verification"
  write_lost_report "$base"
  check_lost_review "$review_file"

  command -v dreamchecker >/dev/null 2>&1 || fail "dreamchecker is not on PATH; rebuild the NixOS/Home Manager configuration"
  ! pgrep -x DreamDaemon >/dev/null 2>&1 || fail "DreamDaemon is already running"

  nix develop -c bash tools/build/build.sh
  dreamchecker

  smoke_log="$state_dir/smoke.log"
  rm -f "$smoke_log"
  set +e
  timeout 150 nix develop -c DreamDaemon tgstation.dmb -port 34917 -trusted -verbose >"$smoke_log" 2>&1
  smoke_status=$?
  set -e
  case "$smoke_status" in
    0|124|143) ;;
    *) fail "DreamDaemon smoke command failed with status $smoke_status; see $smoke_log" ;;
  esac
  if pgrep -x DreamDaemon >/dev/null 2>&1; then
    pkill -x DreamDaemon
  fi

  grep -Fq 'Initializations complete within' "$smoke_log" ||
    fail "server initialization did not complete; see $smoke_log"
  error_count=$(grep -c 'with errors' "$smoke_log" || true)
  [ "$error_count" -eq 0 ] || fail "server initialized $error_count subsystem(s) with errors; see $smoke_log"

  head=$(git rev-parse HEAD)
  upstream_head=$(git rev-parse upstream/master 2>/dev/null || printf unknown)
  {
    printf 'head=%s\n' "$head"
    printf 'base=%s\n' "$base"
    printf 'upstream=%s\n' "$upstream_head"
    printf 'lost=%s\n' "$(awk 'END { print NR + 0 }' "$lost_file")"
    printf 'verified_at=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } > "$stamp_file"
  printf 'upstream-sync gate passed for %s\n' "$head"
}

check_stamp() {
  expected_head=$(git rev-parse "${1:-HEAD}^{commit}" 2>/dev/null) || fail "invalid commit to check: ${1:-HEAD}"
  [ -f "$stamp_file" ] || fail "no verification stamp for $expected_head"
  stamped_head=$(awk -F= '$1 == "head" { print $2 }' "$stamp_file")
  [ "$stamped_head" = "$expected_head" ] || fail "verification stamp belongs to $stamped_head, not $expected_head"
}

usage() {
  cat <<'EOF'
Usage:
  tools/i18n/upstream-sync-gate.sh preflight
  tools/i18n/upstream-sync-gate.sh verify BASE [lost-review.tsv]
  tools/i18n/upstream-sync-gate.sh check-stamp [HEAD]

The optional review TSV must contain one ordered row per line in the generated
.git/nova-sync-gate/i18n-lost.txt report: <lost line><TAB><disposition>.
EOF
}

case ${1:-} in
  preflight)
    preflight
    ;;
  verify)
    [ "$#" -ge 2 ] || { usage >&2; exit 2; }
    run_verification "$2" "${3:-}"
    ;;
  check-stamp)
    check_stamp "${2:-}"
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
