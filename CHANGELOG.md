# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning is informal — no git tags have been applied yet.

---

## [0.3.0] - 2026-04-18

### Changed

- Unified `inner_bayonet` and `outer_bayonet` into a single `bayonet` module. The existing `pin_direction` parameter controls shell assignment via four derived radius variables (`pin_ext_r`, `pin_int_r`, `lock_ext_r`, `lock_int_r`), removing ~130 lines of duplicate geometry code.
- Simplified `example_usage.scad` call site: the `if/else` branch dispatching to two module names is replaced by a single `bayonet(...)` call.

### Fixed

- `bayonet_channel` was called without the `part_height` argument inside the old `inner_bayonet`, causing `depth` to be assigned to the wrong positional slot and producing an `undef` translate warning.

---

## [0.2.0] - 2026-04-18

### Added

- `example_usage.scad`: all user settings and top-level render invocation moved here, leaving `bayonet_lock.scad` as a pure module library.

### Changed

- `bayonet_channel` now receives `part_height` and `depth` as explicit parameters instead of referencing top-level variables.
- Reorganized `bayonet_lock.scad` into labeled sections (global settings, user settings, derived values).
- Reduced z-fighting preview offset (`zFite`) from `0.1` to `0.05`.

### Fixed

- `$fn` preview/render selection was inverted (`$preview ? 128 : 64`); corrected to `$preview ? 64 : 128` so previews are fast and final renders are high-resolution.

---

## [0.1.0] - 2025-02-07

### Added

- Initial OpenSCAD library with four modules: `add_neck`, `inner_bayonet`, `outer_bayonet`, `bayonet_channel`.
- `manual_pin_radius` parameter with automatic fallback: `(outer_radius - inner_radius) / 4` when set to `0`.
- README with project description and source attribution links.

### Changed

- Tolerance variable renamed from `gap` to `allowance` throughout all module signatures and calculations.
- Default dimensions updated: `inner_radius 15→10`, `outer_radius 20→15`, `part_height 20→10`, `depth 8→5`.
- Tessellation control changed from `detail = 48` to preview-aware `$fn = $preview ? 64 : 128`.
