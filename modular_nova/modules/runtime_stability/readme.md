# Runtime stability fixes

Module ID: `RUNTIME_STABILITY`

## Description

Small defensive fixes for runtime storms that can stall a live server. These changes preserve normal lighting and positional-audio behavior while preventing repeated runtime logging from malformed transient state.

## TG Proc/File Changes

- `code/modules/lighting/lighting_turf.dm`: remove stale null dynamic-light keys before collecting nearby lights and skip light components already being deleted.
- `code/datums/3d_sounds/_3d_sound.dm`: when a sound source is also a listener, replace the overlapping listener movement/deletion callbacks before registering the source callbacks.
- `code/modules/unit_tests/_unit_tests.dm`: include the Nova runtime-stability regression tests.
- `code/modules/unit_tests/~nova/runtime_stability.dm`: cover stale spatial-grid light entries and source/listener signal overlap.

## Modular Overrides

- N/A

## Defines

- N/A

## Credits

- sernseek
