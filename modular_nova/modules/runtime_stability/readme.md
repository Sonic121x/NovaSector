# Runtime stability fixes

Module ID: `RUNTIME_STABILITY`

## Description

Small fixes for runtime storms that can stall a live server. These changes preserve normal lighting and positional-audio behavior while preventing invalid component and signal state.

## TG Proc/File Changes

- `code/datums/components/overlay_lighting.dm`: when a light's range changes, unregister it from spatial-grid cells using the previous range before registering the new range. This prevents range reductions from leaving stale component keys behind.
- `code/datums/3d_sounds/_3d_sound.dm`: when a sound source is also a listener, replace the overlapping listener movement/deletion callbacks before registering the source callbacks.
- `code/modules/unit_tests/_unit_tests.dm`: include the Nova runtime-stability regression tests.
- `code/modules/unit_tests/~nova/runtime_stability.dm`: cover spatial-grid cleanup after reducing a light's range and source/listener signal overlap.

## Modular Overrides

- N/A

## Defines

- N/A

## Credits

- sernseek
