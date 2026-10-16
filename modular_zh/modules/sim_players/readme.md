## Simulated players

Module ID: SIM_PLAYERS

### Description:

An autopilot that plays as real connected clients, for local testing. Some bugs only happen with
a real DreamSeeker on the other end: asset delivery, chat, TGUI windows, browse() pages, a client
connecting while something else holds the MC. A mock client (`/datum/client_interface`) never
touches any of that, and BYOND has no Linux client, so the clients run in the Windows VM and the
server drives them.

Every action goes through the entry point the client's own input uses, so the same checks,
logging and rate limits run:

| Action | Entry point |
|---|---|
| lobby buttons (ready, character setup, game options, manifest, latejoin menu) | `client.Topic()` with the title screen's href |
| TGUI buttons (latejoin job pick) | `client.Topic()` with the message the TGUI frontend sends |
| walking | `client.Move()`, one key press at a time, waiting out the move delay |
| clicking map atoms (doors, machines, items, people) | `client.Click()` |
| talking, emotes, radio | `mob.say_verb()` (what the say box calls) |
| examining | the `examinate` verb |
| in-hand use, drop | `attack_self()`, `dropItemToGround()` |
| swap hands | the X key's keybinding (`swap_hands_row`) |
| preferences window | `prefs.ui_interact()` |

In the lobby it readies up (latejoins as an Assistant once the round is running). In the round
most of its time goes to a **map tour**: on first use the subsystem indexes every machine,
structure and loose item on the station's areas (doors, windows, grilles, cables, pipes and the
supermatter left out), and each driven player picks a type nobody has used yet, paths there with
`get_path_to()` using its ID's access, walks the path key press by key press (doors open by
bumping), examines the target and clicks it with the free hand or the held item. The rest is
talking, emotes, examining what is in view, using the held item, dropping it and opening the
preferences window. Dead, it ghosts after 30s and orbits people. Windows it opens close again
after 12s. Grenades, transfer valves and bomb cores are never used in hand.

### Turning it on

- `-params "sim-players=all"` (or a comma separated ckey list) on DreamDaemon drives the matching
  clients from the moment they connect. Without the param the subsystem does not initialize and
  the admin verb below does not exist. Only whoever launches DreamDaemon can set it; nothing a
  player sends reaches world params.
- A server managed by TGS (every production server) refuses the autopilot even with the param,
  so a stray launch param on production does nothing.
- `sim-access=all` gives driven crew station-wide access on their ID, so the tour reaches every
  room; without it they keep their job's access and the tour skips what it cannot path to.
- Admin verb 「自动驾驶接管自己」 (R_DEBUG, only on such a server) hands your own client to the
  autopilot, and back.

Every action is logged to `sim_players.log` in the round's log directory as
`ckey | action | target | mob type @ location`, so a runtime can be lined up with what the player
was doing.

### Running a round: `tools/zh/sim-players.sh`

```sh
tools/build/build.sh dm
tools/zh/sim-players.sh --minutes 10 --clients 1
```

Starts DreamDaemon on port 1337 (the port the host firewall opens to the VM) with the autopilot
on, launches DreamSeeker in the VM's desktop session through a scheduled task, lets it play,
takes VM screenshots halfway and at the end, stops only the DreamSeeker processes it started,
stops the server and writes `sim_report.txt` next to the round logs: logins, autopilot action
counts, how many object types the tour used, each distinct runtime with its count, first time
and the last autopilot action before it, and TGUI errors. `--connect init` waits for Master init before connecting (default: connect as
soon as the port listens, like players who join during init). `--job-access` drops
`sim-access=all`. `--attach` uses a server already running on the port instead.

Clients share the VM's BYOND key. A second connection with the same key takes over the first's
mob, so more than one client needs more keys (separate Windows users logged into BYOND, or guest
logins when the server allows guests).

### Included files that are not contained in this module:

- `tools/zh/sim-players.sh`
