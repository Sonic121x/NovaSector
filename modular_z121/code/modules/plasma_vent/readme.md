## Bluespace plasma vent

Module ID: PLASMA_VENT

### Description:

A station-goal machine shaped like the bluespace artillery, built and deployed in two stages:

1. **Build (one tile):** machine frame → `Bluespace Plasma Vent` board → **4× tier4 capacitor,
   2× tier4 servo, 4× tier4 scanning module, 1× subspace ansible, 15× cable coil, 5× bluespace
   crystal, 15× plastitanium sheet** → screwdriver. Stock parts are pinned to tier4: lower tiers are
   refused at the frame, exactly like the BSA boards. The result is a **compressed vent** — a one-tile
   crate with the whole 4×3 machine folded inside (`plasma_vent_pack.dmi`).
2. **Deploy:** the control console finds that crate within seven tiles and unfolds it: it checks the
   4×3 footprint, puffs smoke, spawns the full vent and deletes the crate. Until it is unfolded, the
   console's TGUI is the deployment screen; afterwards it switches to the operations screen.

Then two actions, deliberately unequal:

- **Objective (one-time):** *Establish bluespace channel*. The press starts a **5 s paced handshake**
  on the console (`handshaking` / `handshake_ends`, `addtimer`). During it the TGUI shows a progress
  bar and every action is locked out; a second press returns "A handshake is already in progress.".
  Two announcements bracket the handshake:
  1. on press — yellow stripe (`color_override = "yellow"`), subtitle `蓝空等离子矿井`, body
     `通路链接中…`, `notice3.ogg` plus a global `portal_travel.ogg` layer;
  2. on completion — green stripe (`color_override = "green"`), same subtitle, body
     `蓝空气体通路连接完成。`, `ANNOUNCER_INTERCEPT`.

  Transport to CentCom is theatre — the goal completes the moment the channel opens. The button is
  full-width and disappears once the channel is up.
- **Reward (repeatable, 5 min cooldown):** *Condense a canister*. A small `compact` secondary button
  next to a progress bar that fills over five minutes. This is the crew's cut, like the DNA vault's
  mutations: not the goal, just the perk.

The two actions are intentionally different sizes so the screen reads "this is the mission, that is
the bonus"; the confirmation state of each button keeps the same box, so it does not shrink when
armed.

### Console states

| State | Screen |
| --- | --- |
| OFFLINE | Grey/red state card, `NOT LINKED` badge; Deployment section ("no compressed vent" or the big **Unfold vent** button) |
| STANDBY | Amber state card, LINKED badge, telemetry grid; big **Establish bluespace channel** button |
| HANDSHAKE | Blue spinning icon, progress bar, all actions locked |
| CHANNEL OPEN | Green state card; telemetry grid plus the small **Condense** button and its 5-minute progress bar |

### Layout

- 4 tiles wide × 3 tall; the machine is anchored 1 in from the left edge and on the top row
  (`pixel_x = -32`, `pixel_y = -64`).
- The other ten tiles of the footprint are blocked with `/obj/structure/filler`.
- The open tile (`+1, -2`, bottom row, second column from the right) stays open: canisters land there
  and people can stand in it. The sprite's transparent cell is exactly that tile.

### Files

| Path | What |
| --- | --- |
| `code/plasma_vent.dm` | vent, compressed pack, console, both circuitboards, cargo crate, station goal, arrival flare |
| `icons/plasma_vent.dmi` | 128×96, state `plasma_vent`, 4 frames at delay 1 |
| `icons/plasma_vent_pack.dmi` | 32×32, state `pack`, 2 frames at delay 1 |
| `tgui/packages/tgui/interfaces/PlasmaVent.tsx` | console UI (four states) |

### TGUI

`PlasmaVent.tsx` reads `linked`, `pack`, `calibrated`, `channel`, `cooldown`, `cooldown_max`,
`handshaking`, `handshake_progress`, `notice` and `notice_type`, and sends `deploy` / `establish` /
`dispense`. The console pushes `ui_data` every half second during the handshake and once a second
while the five-minute cooldown runs, because the handshake hides every action button and the client
cannot refresh itself. The push stops as soon as the window is closed.

Layout, top to bottom:

1. **State card** — `OFFLINE` / `STANDBY` / `HANDSHAKE` / `CHANNEL OPEN`, with icon, colour and a
   `LINKED` tooltip badge.
2. **Telemetry grid** — calibration and channel state only; two columns of `Stack.Item grow basis={0}`,
   values bold and slightly larger. The condensed-canister counter was deliberately removed.
3. **Main action** — exactly one of: deployment (big *Unfold vent*), objective (big *Establish
   bluespace channel*), handshake progress bar, or the "transport running" note.
4. **Reward** — its own section, progress bar plus a small `compact` button.
5. **Notice** — `NoticeBox` coloured from `notice_type` (`success` / `danger` / `info`), never a bare
   red line.

The window is 520×470 with `scrollable`, so it degrades gracefully at small viewports. A new interface
file needs a TGUI rebuild (`tools/build/build.sh tgui`) before the server can serve it.

### Deployment rules

- Both the pack and the vent are found with `range(7, src)`, never the bare `range(7)` — the bare
  form centres on `usr`, which drifts when `ui_data` refreshes outside a Topic call. Candidates are
  also filtered by `can_see(src, target, 7)`, and a vent already claimed by another console is
  skipped unless that console can no longer reach it.
- Unfolding refuses when any footprint tile is space, has dense content, or is the console's own
  turf. The check marks offending turfs with the temporary point effect.
- `build_fillers()` blocks every footprint tile except the vent's own and the outlet. It does **not**
  skip turfs that happen to hold a non-dense machine (pipes, cables): those passed the deployment
  check, and skipping them left walkable holes in the 4×3 body.
- The compressed pack takes all three tools: screwdriver opens the maintenance panel, crowbar pulls
  it back into a machine frame and returns the board plus the parts it was built with, and wrench
  toggles whether it is anchored. The deployed vent has **no** tool interactions at all — it is a
  goal structure, not a machine to be taken apart.

### Edge cases

- **Power** — a dispense first calls `use_energy(active_power_usage, force = FALSE)`. If the area's
  APC is off or cannot pay, the cycle is refused with "The vent has no power." and the cooldown is
  not consumed, so nothing is handed out for free.
- **Outlet blocked** — dense contents on the outlet tile refuse the cycle before any power is spent.
- **Vent destroyed** — `Destroy()` deletes the fillers, clears `dispense_turf`, and the console's
  weakref stops resolving, so the TGUI falls back to `OFFLINE` on the next push (mid-handshake or
  mid-cooldown) or when the window is reopened.
- **Console destroyed mid-handshake** — the `addtimer` callback starts with `QDELETED(src)` and
  bails out; the vent is simply left untouched (`channel_active` stays FALSE).
- **Vent destroyed mid-handshake** — the weakref fails to resolve, the console reports "The vent was
  lost during the handshake." and keeps the channel closed.
- **Second vent nearby** — `unfold_vent()` does a raw `locate()` over seven tiles and refuses while
  any vent exists there, even one claimed by another console, so packs cannot be stacked into the
  same area.

### TG Proc/File Changes:

- N/A

### Modular Overrides:

- N/A

### Defines:

- `PLASMA_VENT_CANISTER_COOLDOWN`, `PLASMA_VENT_HANDSHAKE_TIME`, `PLASMA_VENT_PLASMA_MOLES`,
  `PLASMA_VENT_LEFT`, `PLASMA_VENT_RIGHT`, `PLASMA_VENT_DOWN`, `PLASMA_VENT_OUTLET_DX`,
  `PLASMA_VENT_OUTLET_DY` — module-local, `#undef`'d at the bottom of `code/plasma_vent.dm`.

### Included files that are not contained in this module:

- `/obj/structure/filler` — `modular_nova/modules/bsa_overhaul/code/bsa_cannon.dm` (the original
  `code/modules/station_goals/bsa.dm` is commented out upstream); reused for the solid footprint.
- `sound/announcer/notice/notice3.ogg`, `sound/effects/portal/portal_travel.ogg`,
  `ANNOUNCER_INTERCEPT` (announcer key), `sound/machines/mining/auto_teleport.ogg`,
  `icons/effects/effects.dmi` (`phasein` state), `icons/obj/machines/particle_accelerator.dmi`
  (console body, same as the BSA console).
- `priority_announce()`, `do_smoke()` — shared helpers.

### Sprites

`icons/plasma_vent.dmi` holds two states, both 128×96:

- `plasma_vent` — 4 frames at delay 1, the powered vent (art_b8 frames).
- `plasma_vent_off` — 1 static frame, the unpowered/broken vent. Hand-drawn art reconstructed on a
  128×96 grid with its own 17-colour palette, outlet tile forced transparent.

`update_icon_state()` swaps between them on `machine_stat & (NOPOWER | BROKEN)`; `power_change()`
already calls `update_appearance()` when the power state flips. Swap art by keeping the sheet layout:
state 1 is four frames across the top row, state 2 is one frame at the bottom-left, metadata
`width = 128`, `height = 96`.

`icons/plasma_vent_pack.dmi` is assembled from the two 32×32 frames of `art_b11` (variant B: bulged
corners, plates wider than the crate, straps, bluespace leak). Metadata `width = 32`,
`height = 32`, state `pack`, `frames = 2`, `delay = 1,1`.

### Localization

The two announcements are written in Simplified Chinese on purpose (subtitle `蓝空等离子矿井`), so
they are **not** catalog candidates and will pass through `lang_reverse_text` untouched. The console
strings and the rest of the module are still bare English; run `nova-i18n extract` (and the usual
`rewrite` pass) before shipping if those need catalog keys.

### Credits:

Sprite and code: generated for this fork's prototype pass.
