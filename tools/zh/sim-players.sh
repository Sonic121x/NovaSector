#!/usr/bin/env bash
# Plays a local round with real DreamSeeker clients running in the Windows VM, driven by the
# server-side autopilot (modular_zh/modules/sim_players), then summarizes the round's runtimes.
#
#   tools/zh/sim-players.sh [--minutes 10] [--clients 1] [--port 1337] [--connect listen|init]
#                           [--attach] [--job-access] [--no-screenshots] [--vm user@host] [--host-ip ip]
#
# Without --attach it starts DreamDaemon on tgstation.dmb itself (build first) with
# -params sim-players=all&sim-access=all and stops it at the end: driven crew get station-wide
# access so the map tour reaches every room (--job-access keeps the job's own access). With --attach it uses a server you started
# yourself; start that one with `-params sim-players=all` (or run the in-game admin verb
# 「自动驾驶接管自己」 on the client) or the clients just sit there.
#
# The report lands in the round's log directory as sim_report.txt, with VM screenshots next to it.
set -euo pipefail

ROOT=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
cd "$ROOT"

if ! command -v DreamDaemon >/dev/null; then
	exec nix develop -c "$0" "$@"
fi

MINUTES=10
CLIENTS=1
PORT=1337
CONNECT=listen
ATTACH=0
ACCESS=all
SHOTS=1
VM=LocalUser@192.168.77.133
HOST_IP=192.168.77.1

while [ $# -gt 0 ]; do
	case "$1" in
		--minutes) MINUTES=$2; shift 2 ;;
		--clients) CLIENTS=$2; shift 2 ;;
		--port) PORT=$2; shift 2 ;;
		--connect) CONNECT=$2; shift 2 ;;
		--attach) ATTACH=1; shift ;;
		--job-access) ACCESS=job; shift ;;
		--no-screenshots) SHOTS=0; shift ;;
		--vm) VM=$2; shift 2 ;;
		--host-ip) HOST_IP=$2; shift 2 ;;
		-h|--help) sed -n '2,14p' "$0"; exit 0 ;;
		*) echo "unknown argument: $1" >&2; exit 2 ;;
	esac
done

WORK=$(mktemp -d "${TMPDIR:-/tmp}/sim-players.XXXXXX")
VM_DIR='$env:USERPROFILE\sim_players'
DD_PID=
CLIENTS_UP=0

log() { printf '[sim %s] %s\n' "$(date +%H:%M:%S)" "$*"; }

# ------------------------------------------------------------------ VM helpers

ssh_vm() { ssh -o BatchMode=yes -o ConnectTimeout=8 -o LogLevel=ERROR "$VM" "$@"; }

# Runs PowerShell on the VM (SSH session, no desktop). UTF-8 output.
vm_ps() {
	local script="\$ProgressPreference='SilentlyContinue'; [Console]::OutputEncoding=[Text.Encoding]::UTF8; $1; exit 0"
	ssh_vm "powershell -NoProfile -NonInteractive -EncodedCommand $(printf '%s' "$script" | iconv -t UTF-16LE | base64 -w0)"
}

# Runs one of the uploaded scripts in the logged-in desktop session (GUI apps, screenshots need it)
# and waits for it to finish.
vm_desktop() {
	local name=$1 task="SimPlayers_$1"
	vm_ps "schtasks /Create /F /TN $task /SC ONCE /ST 00:00 /IT /RL LIMITED /RU \$env:USERNAME /TR \"powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File $VM_DIR\\$name.ps1\" | Out-Null; Start-ScheduledTask -TaskName $task" >/dev/null
	for _ in $(seq 1 60); do
		sleep 2
		if ! vm_ps "(Get-ScheduledTask -TaskName $task).State -eq 'Running'" | grep -q True; then
			break
		fi
	done
	vm_ps "Unregister-ScheduledTask -TaskName $task -Confirm:\$false" >/dev/null || true
}

write_vm_scripts() {
	cat >"$WORK/launch.ps1" <<'EOF'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg = Get-Content "$dir\launch.txt"
$exe = Join-Path ${env:ProgramFiles(x86)} 'BYOND\bin\dreamseeker.exe'
for ($i = 0; $i -lt [int]$cfg[1]; $i++) {
	$p = Start-Process -FilePath $exe -ArgumentList $cfg[0] -PassThru
	Add-Content -Path "$dir\pids.txt" -Value $p.Id
	Start-Sleep -Seconds 8
}
EOF
	cat >"$WORK/shot.ps1" <<'EOF'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
Add-Type 'using System.Runtime.InteropServices; public static class SimDpi { [DllImport("user32.dll")] public static extern bool SetProcessDPIAware(); }'
[SimDpi]::SetProcessDPIAware() | Out-Null
$b = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bmp = New-Object System.Drawing.Bitmap $b.Width, $b.Height
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($b.Location, [System.Drawing.Point]::Empty, $b.Size)
$bmp.Save("$dir\shot.png", [System.Drawing.Imaging.ImageFormat]::Png)
EOF
	printf 'byond://%s:%s\r\n%s\r\n' "$HOST_IP" "$PORT" "$CLIENTS" >"$WORK/launch.txt"
	vm_ps "New-Item -ItemType Directory -Force -Path \"$VM_DIR\" | Out-Null; Remove-Item -ErrorAction SilentlyContinue \"$VM_DIR\\pids.txt\", \"$VM_DIR\\shot.png\"" >/dev/null
	local remote
	remote=$(vm_ps "Write-Output \"$VM_DIR\"" | tr -d '\r')
	scp -q -o BatchMode=yes -o LogLevel=ERROR "$WORK/launch.ps1" "$WORK/shot.ps1" "$WORK/launch.txt" "$VM:$(printf '%s' "$remote" | tr '\\' '/')/"
}

# Only the DreamSeeker processes this run started; never the user's own client.
stop_clients() {
	[ "$CLIENTS_UP" = 1 ] || return 0
	CLIENTS_UP=0
	vm_ps "\$f = \"$VM_DIR\\pids.txt\"; if (Test-Path \$f) { foreach (\$id in Get-Content \$f) { \$p = Get-Process -Id \$id -ErrorAction SilentlyContinue; if (\$p -and \$p.ProcessName -eq 'dreamseeker') { Stop-Process -Id \$id -Force } }; Remove-Item \$f }" >/dev/null || true
	log "clients stopped"
}

screenshot() {
	[ "$SHOTS" = 1 ] && [ -n "${ROUND_DIR:-}" ] || return 0
	vm_desktop shot
	local remote
	remote=$(vm_ps "Write-Output \"$VM_DIR\"" | tr -d '\r' | tr '\\' '/')
	if scp -q -o BatchMode=yes -o LogLevel=ERROR "$VM:$remote/shot.png" "$ROUND_DIR/sim_shot_$1.png" 2>/dev/null; then
		log "screenshot: $ROUND_DIR/sim_shot_$1.png"
	fi
}

# ------------------------------------------------------------------ server

stop_server() {
	[ -n "$DD_PID" ] || return 0
	kill "$DD_PID" 2>/dev/null || true
	for _ in $(seq 1 20); do
		kill -0 "$DD_PID" 2>/dev/null || break
		sleep 0.5
	done
	kill -9 "$DD_PID" 2>/dev/null || true
	DD_PID=
	log "server stopped"
}

cleanup() {
	stop_clients
	stop_server
	rm -rf "$WORK"
}
trap cleanup EXIT
trap 'exit 130' INT TERM

port_listening() { ss -Htln "sport = :$PORT" | grep -q .; }

find_round_dir() {
	# The newest round directory created at or after $1 (epoch seconds); with $2 = any, the newest.
	local d
	for d in $(ls -td data/logs/*/*/*/round-* 2>/dev/null | head -5); do
		if [ "${2:-}" = any ] || [ "$(stat -c %Y "$d")" -ge "$1" ]; then
			echo "$d"
			return
		fi
	done
}

# ------------------------------------------------------------------ run

vm_ps "Write-Output ok" >/dev/null || { echo "cannot reach the VM at $VM" >&2; exit 1; }

START=$(date +%s)
if [ "$ATTACH" = 0 ]; then
	if port_listening; then
		echo "port $PORT is already in use: stop that server, or pass --attach to use it" >&2
		exit 1
	fi
	[ -f tgstation.dmb ] || { echo "tgstation.dmb missing: build first (tools/build/build.sh dm)" >&2; exit 1; }
	log "starting DreamDaemon on port $PORT"
	DreamDaemon tgstation.dmb "$PORT" -trusted -params "sim-players=all&sim-access=$ACCESS" >"$WORK/dd.log" 2>&1 &
	DD_PID=$!
	for _ in $(seq 1 240); do
		port_listening && break
		kill -0 "$DD_PID" 2>/dev/null || { cat "$WORK/dd.log" >&2; exit 1; }
		sleep 0.5
	done
	port_listening || { echo "DreamDaemon never listened on $PORT" >&2; exit 1; }
else
	port_listening || { echo "nothing listens on port $PORT" >&2; exit 1; }
fi

for _ in $(seq 1 60); do
	ROUND_DIR=$(find_round_dir "$START" "$([ "$ATTACH" = 1 ] && echo any)")
	[ -n "$ROUND_DIR" ] && [ -f "$ROUND_DIR/runtime.log" ] && break
	sleep 1
done
[ -n "${ROUND_DIR:-}" ] || { echo "no round log directory appeared" >&2; exit 1; }
log "round logs: $ROUND_DIR"

if [ "$CONNECT" = init ]; then
	log "waiting for init to finish"
	until grep -q "Initializations complete" "$ROUND_DIR/runtime.log" 2>/dev/null; do
		[ -z "$DD_PID" ] || kill -0 "$DD_PID" 2>/dev/null || { echo "server exited" >&2; exit 1; }
		sleep 2
	done
fi

write_vm_scripts
log "launching $CLIENTS DreamSeeker client(s) to byond://$HOST_IP:$PORT"
CLIENTS_UP=1
vm_desktop launch &
LAUNCH_PID=$!

LOGINS=0
for _ in $(seq 1 90); do
	LOGINS=$(grep -c "GAME-ACCESS: Login:" "$ROUND_DIR/game.log" 2>/dev/null || true)
	[ "${LOGINS:-0}" -ge "$CLIENTS" ] && break
	sleep 2
done
log "logins so far: ${LOGINS:-0}"
wait "$LAUNCH_PID"

END=$(( $(date +%s) + MINUTES * 60 ))
HALF=$(( $(date +%s) + MINUTES * 30 ))
SHOT_HALF=0
while [ "$(date +%s)" -lt "$END" ]; do
	sleep 30
	if [ -n "$DD_PID" ] && ! kill -0 "$DD_PID" 2>/dev/null; then
		log "server exited early"
		break
	fi
	actions=$(grep -c " | " "$ROUND_DIR/sim_players.log" 2>/dev/null || true)
	errors=$(grep -c "RUNTIME: runtime error:" "$ROUND_DIR/runtime.log" 2>/dev/null || true)
	log "autopilot actions ${actions:-0}, runtimes ${errors:-0}, $(( (END - $(date +%s)) / 60 )) min left"
	if [ "$SHOT_HALF" = 0 ] && [ "$(date +%s)" -ge "$HALF" ]; then
		SHOT_HALF=1
		screenshot mid
	fi
done
screenshot end
stop_clients
stop_server

python3 - "$ROUND_DIR" <<'EOF' | tee "$ROUND_DIR/sim_report.txt"
import collections, os, re, sys

round_dir = sys.argv[1]
TS = re.compile(r'^\[([0-9-]+ [0-9:.]+)\] ')

def read(name):
    path = os.path.join(round_dir, name)
    return open(path, encoding='utf-8', errors='replace').read().split('\n') if os.path.exists(path) else []

# autopilot actions: "[ts] ckey | action | target | where"
actions = []
for line in read('sim_players.log'):
    m = TS.match(line)
    if m and ' | ' in line:
        parts = [p.strip() for p in line[m.end():].split(' | ')]
        actions.append((m.group(1), parts))

# runtimes: "[ts] RUNTIME: runtime error: msg" then " - proc name: ..." / " -   source file: f,l"
groups = collections.OrderedDict()
lines = read('runtime.log')
for i, line in enumerate(lines):
    m = TS.match(line)
    if not m or 'RUNTIME: runtime error: ' not in line:
        continue
    msg = line.split('RUNTIME: runtime error: ', 1)[1].strip()
    proc = source = ''
    frames = []
    for follow in lines[i + 1:i + 40]:
        if TS.match(follow) or not follow.startswith(' -'):
            break
        if 'proc name:' in follow:
            proc = follow.split('proc name:', 1)[1].strip()
        elif 'source file:' in follow:
            source = follow.split('source file:', 1)[1].strip()
        elif not follow.startswith(' -  ') and follow.strip(' -'):
            frames.append(follow.strip(' -'))
    # stack_trace() warnings: the interesting proc is the caller
    if 'stack_trace' in proc and frames:
        proc = frames[0]
    key = (msg, source)
    g = groups.setdefault(key, {'count': 0, 'first': m.group(1), 'proc': proc})
    g['count'] += 1

def last_action_before(ts):
    best = None
    for t, parts in actions:
        if t <= ts:
            best = (t, parts)
        else:
            break
    return best

logins = [l for l in read('game.log') if 'GAME-ACCESS: Login:' in l]
print(f'round: {round_dir}')
print(f'client logins: {len(logins)}')
for l in logins:
    print('  ' + l.split('Login: ', 1)[1].split(' from ')[0])
print(f'autopilot actions: {len(actions)}')
counts = collections.Counter(parts[1] for _, parts in actions if len(parts) > 1 and parts[0] != 'map index')
for action, n in counts.most_common():
    print(f'  {n:5}  {action}')
index = [parts for _, parts in actions if parts and parts[0] == 'map index']
visited = {re.sub(r'.*\((/[^)]+)\)$', r'\1', parts[2]) for _, parts in actions if len(parts) > 2 and parts[1] == 'visit'}
if index:
    print(f'map tour: used {len(visited)} object types ({index[0][1]})')
print(f'runtimes: {sum(g["count"] for g in groups.values())} total, {len(groups)} distinct')
for (msg, source), g in sorted(groups.items(), key=lambda kv: kv[1]['first']):
    print(f'\n  x{g["count"]}  first {g["first"]}  {msg}')
    print(f'       {g["proc"]}  ({source})')
    near = last_action_before(g['first'])
    if near:
        print(f'       last autopilot action: {near[0]}  {" | ".join(near[1])}')
tgui = [l for l in read('tgui.log') if re.search(r'error|fatal', l, re.I)]
if tgui:
    print(f'\ntgui errors: {len(tgui)}')
    for l in tgui[:15]:
        print('  ' + l[:300])
EOF
log "report: $ROUND_DIR/sim_report.txt"
