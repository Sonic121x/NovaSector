## Deferred off-station loading

Module ID: DEFERRED_OFFSTATION

### Description:

Lavaland, the lava and space ruins and the roundstart away mission used to load and initialize
during Master init, before the lobby opened. On MetaStation with production ruin budgets that was
over half of init (98.6s → 34.2s without them). With `DEFER_OFFSTATION_LOAD` set
(`config/nova/config_nova.txt`), init skips them and they load in the lobby right after init:

1. **Placement** (a few seconds, does not yield): lavaland, the away mission, lava ruins, cave
   generation, rivers, reserved ruins and population, all in map loader mode so every new atom
   stays uninitialized, exactly as during init. Not yielding is required: the map loader state is
   global, and the cave generator replaces turfs with `new` on the assumption that they never
   initialized.
2. **Space ruins**: their levels already exist (created during init, so z-level transitions are
   unchanged); the ruins load the normal mid-round way.
3. **Initialization**: everything left uninitialized on the new levels is initialized in one
   `InitializeAtoms` call in `initTemplateBounds()` order (areas, turfs, objs, mobs), then
   lighting, power, atmos, weather, ore vents and mining camera consoles are set up the way their
   subsystems would have during init. With nobody connected this runs at init speed; with players
   in the lobby it yields every tick. Roundstart shuttles of deferred docks are queued and load
   after the batch (during init SSshuttle also loads them only after every atom exists); the round
   does not wait for them.

The load starts once the assets queued during init have generated (at most 60s later): holding the
MC right after init pushed their generation into the moment the first players connect.

The round start waits for the load if the lobby countdown ends first. The MC's
`sleep_offline_after_initializations` is held back until the load finishes, otherwise an empty
server would freeze it until the first player connects.

Covered by `/datum/unit_test/deferred_offstation`: unit tests start after the round starts, so the
whole suite runs on the deferred world.

### TG Proc/File Changes:

- `code/controllers/subsystem/mapping.dm`: `Initialize()`, `loadWorld()`, `proc/setup_ruins()`, `proc/setup_rivers()` (new include parameters)
- `code/controllers/master.dm`: `proc/Initialize()` starts the load
- `code/controllers/subsystem/ticker.dm`: `fire()` holds the round start
- `code/modules/library/bookcase.dm`: `proc/load_shelf()` skips books that have not initialized yet
- `code/game/turfs/open/lava.dm`: `initialize_occupant()` leaves occupants that are not initialized yet to `on_atom_inited()`
- `code/modules/shuttle/stationary_port/stationary_port.dm`: `LateInitialize()` queues the roundstart shuttle during the deferred batch
- `code/modules/asset_cache/spritesheet/batched/batched_spritesheet.dm`: `should_refresh()` counts its async cache check in `SSasset_loading.assets_generating`, so the queue-drained `rustg_iconforge_cleanup()` cannot drop it mid-wait ("cache check UNKNOWN ERROR: NO SUCH JOB")
- `code/__HELPERS/_planes.dm`: `check_topdown_validity()` judges a FLOAT_PLANE visual by the plane of the atom showing it (the deferred world surfaced this false positive in `plane_layer_sanity`)

### Modular Overrides:

- `modular_nova/master_files/code/controllers/subsystem/mapping.dm`: `setup_ruins()` signature

### Defines:

- N/A

### Included files that are not contained in this module:

- `code/modules/unit_tests/~zh/deferred_offstation.dm`

### Credits:

- sernseek
