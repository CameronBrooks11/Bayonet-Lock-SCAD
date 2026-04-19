# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning is informal — no git tags have been applied yet.

---

## [0.7.1] - 2026-04-19

### Changed

- Changed `tube(h, r_outer, r_inner)` to be an internal helper `_tube(h, r_outer, r_inner) ` to signal that it is not intended for public use. This is a minor API change but helps clarify the library's public interface and prevents accidental use of an internal module.

---

## [0.7.0] - 2026-04-18

### Added

- `assert(pin_radius > 0)` in `bayonet` module. Previously a zero pin_radius produced
  a degenerate sphere and silent zero-volume channel; the existing
  `shaft_radius <= shell_thickness` check did not catch it.

### Fixed

- `minimal.scad`: hardcoded `translate([29, 0, 0])` replaced with the computed
  expression `translate([(inner_radius + 2 * shell_thickness) * 2 + 5, 0, 0])`,
  consistent with all other example files.
- Removed stale `example_usage.scad` from repo root (v0.5.0 API, superseded by
  the `examples/` directory added in 0.5.1).

### Changed

- Inline comments on the two outer-direction `atan2` branches in `_bayonet_channel`
  now explicitly state that `allowance / 4` and `1.5 * allowance` are empirically
  tuned and give the validated parameter range (allowance ∈ [0.1, 0.4],
  pin_radius ∈ [0.5, 3.0]).
- README: updated features bullet to reference `shell_thickness` instead of the
  removed `outer_radius` parameter.

---

## [0.6.0] - 2026-04-18

### Breaking Changes

The `bayonet` module has a new signature. All named arguments must be updated.

| Old parameter                                 | New parameter               | Notes                                                                     |
| --------------------------------------------- | --------------------------- | ------------------------------------------------------------------------- |
| `part_to_render`                              | `half`                      | Same values: `"pin"` \| `"lock"`                                          |
| `outer_radius`                                | `shell_thickness`           | `shell_thickness = (outer_radius - inner_radius) / 2`                     |
| `path_sweep_angle`                            | `sweep_angle`               | Identical semantics                                                       |
| `channel_depth`                               | `entry_depth`               | Identical semantics                                                       |
| _(removed)_ `mid_in_radius`, `mid_out_radius` | _(internal)_ `_interface_r` | These were never intended as public params; now derived inside the module |

Parameter order has also changed to group geometry first, then count/angle, then mode flags.

### Changed

- Replaced `outer_radius` with `shell_thickness` (radial depth of each shell wall). The canonical mating surface is now `_interface_r = inner_radius + shell_thickness`, derived once inside the module. Previously callers had to know that `mid_radius = (inner_radius + outer_radius) / 2` was the operative surface.
- Renamed `part_to_render` → `half`, `path_sweep_angle` → `sweep_angle`, `channel_depth` → `entry_depth` for clarity.
- New validation asserts cover the rewritten constraints: `shell_thickness > 0`, `shaft_radius <= shell_thickness` (replaces `outer_radius > inner_radius`), `entry_depth > 0`, `entry_depth < part_height`, `sweep_angle` bounds.
- `_bayonet_channel` internal parameter `mid_in_radius`/`mid_out_radius` replaced by single canonical `interface_r` plus derived `pin_interface_r`.
- `lock_pos` inner-direction formula simplified: was `interface_radius - pin_radius - allowance/2`, now `interface_r - pin_radius` (the `allowance/2` offset cancels algebraically with the new derivation).
- atan2 denominators updated from `mid_in_radius + allowance/2` to `interface_r` (equivalent value, now expressed through the canonical reference).
- Example files updated: `outer_radius` variable replaced with `shell_thickness`, neck formula updated to `inner_radius + shell_thickness - allowance / 2`.
- README usage block and parameter table updated.

---

## [0.5.2] - 2026-04-18

### Fixed

- `rotate_extrude` pre-rotation was applied unconditionally, misaligning the torus arc for CCW locks. The `rotate([0,0,torus_angle])` wrapper is now conditional on `turn_direction == "CW"` only; CCW sweeps start at 0° and need no pre-rotation. This caused the channel arc to be offset from the entry shaft by exactly `path_sweep_angle` degrees for any CCW configuration.

---

## [0.5.1] - 2026-04-18

### Changed

- Replaced monolithic `example_usage.scad` with an `examples/` directory containing four focused, immediately-renderable files: `outer_3pin_with_neck.scad`, `inner_2pin_no_neck.scad`, `outer_4pin_ccw.scad`, and `minimal.scad`. Each renders both halves side-by-side and demonstrates a distinct combination of `pin_direction`, `number_of_pins`, `turn_direction`, and neck usage.
- README: replaced `example_usage.scad` reference with an examples table linking to each file.

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
