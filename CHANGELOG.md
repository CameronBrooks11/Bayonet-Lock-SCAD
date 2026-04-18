# Changelog

All notable changes are documented here.
This file is reconstructed from the real commit history (`git rev-list --reverse HEAD`) as of 2026-04-18.
The repository has no git tags yet, so this changelog is commit-ordered.

## 2026-04-18 - d6103dc - Unify inner/outer bayonet into single bayonet module

- Repository state at this commit: `CHANGELOG.md`, `LICENSE`, `README.md`, `bayonet_lock.scad`, `example_usage.scad`.
- API change: `inner_bayonet(...)` and `outer_bayonet(...)` were replaced with a unified `bayonet(...)` module.
- Added radius-mapping logic (`pin_ext_r`, `pin_int_r`, `lock_ext_r`, `lock_int_r`) so `pin_direction` controls shell assignment without duplicate geometry code.
- Updated `example_usage.scad` to call `bayonet(...)` directly instead of branching between two module names.
- Updated `CHANGELOG.md` with the prior `v0.3.0` summary note.

## 2026-04-18 - 2fab27f - split into usage example

- Repository state at this commit: `CHANGELOG.md`, `LICENSE`, `README.md`, `bayonet_lock.scad`, `example_usage.scad`.
- Added `example_usage.scad` and moved all top-level "user settings + render invocation" out of `bayonet_lock.scad`.
- Converted `bayonet_lock.scad` into a module library file (no top-level execution path).
- Changed `bayonet_channel(...)` to accept `part_height` and `depth` explicitly, removing hidden dependence on top-level variables.
- Updated inner/outer bayonet call sites to pass through `part_height` and `depth`.
- Simplified `add_neck(...)` by removing the z-fighting offset cut in this commit.
- Added the first `CHANGELOG.md` (`v0.2.0`, `v0.1.0`).

## 2026-04-05 - 6d29df2 - fix fn preview order

- Repository state at this commit: `LICENSE`, `README.md`, `bayonet_lock.scad`.
- Corrected global tessellation selection from `$fn = $preview ? 128 : 64` to `$fn = $preview ? 64 : 128`.
- Effective behavior after this commit: preview uses fewer fragments, final render uses more.

## 2026-04-05 - 48e455f - minor revisions

- Repository state at this commit: `LICENSE`, `README.md`, `bayonet_lock.scad`.
- Added file header comments in `bayonet_lock.scad` (project description, author attribution, MIT license note).
- No geometry, API, or parameter behavior change.

## 2026-04-05 - 51f8768 - revise parameter set and clean up

- Repository state at this commit: `LICENSE`, `README.md`, `bayonet_lock.scad`.
- Reorganized the file into labeled sections: global settings, user settings, derived values.
- Updated global defaults to preview-aware values: introduced `$fn = $preview ? 128 : 64` and changed `zFite` from `0.1` to `0.05`.
- Performed substantial formatting/cleanup refactor while keeping the dual-module API (`inner_bayonet`, `outer_bayonet`).
- Top-level execution flow still lived inside `bayonet_lock.scad` at this point.

## 2025-02-07 - 482b3a7 - updated for use in pbr pbr project

- Repository state at this commit: `LICENSE`, `README.md`, `bayonet_lock.scad`.
- Renamed tolerance variable from `gap` to `allowance` and propagated the rename through all module signatures and calculations.
- Added `manual_pin_radius` with computed fallback (`manual_pin_radius == 0 ? (outer_radius - inner_radius) / 4 : manual_pin_radius`).
- Adjusted default dimensions for the intended project profile: `inner_radius 15 -> 10`, `outer_radius 20 -> 15`, `part_height 20 -> 10`, `conn_height 8 -> 5`.
- Replaced `detail = 48` with `_fn = 32` and wired `$fn` to `_fn`.

## 2025-02-04 - 1757aa2 - initial commit

- Repository state at this commit: `LICENSE`, `README.md`, `bayonet_lock.scad`.
- Added initial OpenSCAD implementation in `bayonet_lock.scad`.
- Initial API/module state introduced in this commit: `add_neck(...)`, `inner_bayonet(...)`, `outer_bayonet(...)`, `bayonet_channel(...)`.
- Initial defaults in code at this point included `inner_radius=15`, `outer_radius=20`, `gap=0.2`, `part_height=20`, `conn_height=8`, `detail=48`.
- Expanded `README.md` from title-only to a full project description with source attribution links.

## 2025-02-04 - 5100bd1 - Initial commit

- Repository state at this commit: `LICENSE`, `README.md`.
- Bootstrapped repository with MIT license text.
- Added initial placeholder README (`# Bayonet-Lock-SCAD`).
- No OpenSCAD source file existed yet at this point.
