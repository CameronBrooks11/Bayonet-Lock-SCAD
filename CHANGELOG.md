# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning is informal — no git tags have been applied yet.

---

## [0.5.0] - 2026-04-18

### Added

- 8 input range assertions in `bayonet`: `inner_radius > 0`, `outer_radius > inner_radius`, `pin_radius > 0`, `allowance >= 0`, `number_of_pins >= 1`, `channel_depth > 0`, `channel_depth < part_height`, `path_sweep_angle > 0`, and `path_sweep_angle < 360 / number_of_pins` (overlap guard).

### Fixed

- Removed `#` debug modifier from `tube`'s inner cylinder (caused bright-pink highlight in all previews and renders).
- Removed `color("Red")` from the channel cutout in the `bayonet` lock branch (same class of debug leak).
- `example_usage.scad`: `neck_outer_radius` now resolves to `mid_in_radius` when `pin_direction == "outer"`, matching the actual pin shell OD and eliminating the 2.6 mm neck/body step.
- `rotate_extrude` no longer receives a negative `angle`; a wrapping `rotate([0, 0, torus_angle])` pre-orients the sweep and `abs(torus_angle)` is passed to `rotate_extrude`, ensuring compatibility with OpenSCAD versions that require a positive angle argument.

### Changed

- `_bayonet_channel` signature: replaced `mid_radius` parameter with `mid_in_radius` and `mid_out_radius`; both call sites in `bayonet` now pass the already-computed values, eliminating the duplicate derivation inside the private module.
- Removed three redundant `assert` blocks from `_bayonet_channel`; all three parameters are already validated by the public `bayonet` module before the call.
- Added inline comments explaining the asymmetric angle-offset multipliers in `sweep_entry_angle` and `lock_notch_angle`, and the `allowance/2` radial correction asymmetry in `lock_pos`.

### Docs

- README: removed stale "two or four locking points" and FreeCAD detail-setting references; added Usage code block and full parameter reference table.

---

## [0.4.1] - 2026-04-18

### Added

- `tube(h, r_outer, r_inner)` primitive module encapsulating the repeated hollow-cylinder boolean pattern (outer shell minus triple-height centered bore). Used by `bayonet_neck`, and both pin/lock branches of `bayonet`, removing three instances of duplicated `difference()`/`cylinder` pairs.

---

## [0.4.0] - 2026-04-18

### Added

- `assert` guards on `part_to_render`, `pin_direction`, and `turn_direction` in `bayonet` and `_bayonet_channel` — invalid strings now produce a clear error instead of silent empty geometry.

### Changed

- `add_neck` renamed to `bayonet_neck` for consistent `bayonet_` public module prefix.
- `depth` parameter renamed to `channel_depth` across all modules and `example_usage.scad` for clarity (it is an axial Z-position, not a material depth).
- `bayonet_channel` renamed to `_bayonet_channel` (leading underscore signals internal/private by convention).
- Removed duplicate `pin_position` variable inside `_bayonet_channel`; replaced its sole use with the already-computed `interface_radius`.
- `lock_pos` computation replaced floating-point equality checks on derived radii with a direct `pin_direction` string comparison.
- `thorus_angle` typo corrected to `torus_angle`.
- `add_angle1` / `add_angle2` renamed to `sweep_entry_angle` / `lock_notch_angle`.
- All positional `cylinder(h, r, r)` calls converted to named-parameter form `cylinder(h=..., r=...)`.
- Removed unused `zFite` variable from `example_usage.scad`.

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
