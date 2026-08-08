# bayonet-Lock-SCAD

<!-- markdownlint-disable MD060 -->

This OpenSCAD library provides a parametric bayonet lock connector, inspired by designs used in aviation maintenance for their reliability and ease of use. It produces both the pin and lock halves of the mechanism with a fully configurable number of locking points and turn direction.

Key features:

- Configurable number of locking pins (2 or more).
- Configurable interface radius (`interface_radius`) with optional shell wall thickness (`shell_thickness`) for any coupling diameter.
- Optional `entry_depth`; when omitted it defaults to `part_height * 0.5`.
- `pin_direction` parameter selects whether the pin protrudes inward or outward.
- Adjustable `allowance` (clearance gap) for tuning fit tolerance.
- Preview-aware `$fn` (64 preview / 128 render) for fast iteration.
- Optional `shell_only` mode that drops the locking features for fast assembly previews.

The design improves upon earlier versions by modularizing the code and addressing issues from the original implementation. Contributions and feedback are welcome.

## Usage

```scad
use <bayonet_lock.scad>;

bayonet(
  half            = "pin",    // "pin" | "lock"
  interface_radius = 10,
  shell_thickness = 2.5,       // optional; defaults to pin_radius * 2
  allowance       = 0.2,
  part_height     = 10,
  // entry_depth  = 5,        // optional; defaults to part_height * 0.5
  number_of_pins  = 3,
  pin_radius      = 1,
  sweep_angle     = 30,       // degrees; must be < 360/number_of_pins
  pin_direction   = "outer",  // "inner" | "outer"
  turn_direction  = "CW",     // "CW" | "CCW"
  // shell_only   = false     // optional; omit the locking features, see below
);
```

## Fast assembly previews (`shell_only`)

The locking channel is a boolean-heavy cut, so an assembly holding several bayonets becomes
slow to pan long before it becomes slow to render. `shell_only` drops the pin and channel
features and emits just the bare coupling shell — same shell radii, same height, no locking
geometry.

The pin bosses are features, so they go too: a pin half previews `pin_radius` smaller in
radius than it prints. Preview the couplings this way to see where they sit, not to judge
clearance against whatever sits next to them. Rendering with `shell_only` still active echoes
a warning, since the emitted part would have nothing to lock with.

Because assemblies are previewed and only parts are rendered, the natural wiring is
`$preview`. `shell_only` falls back to the dynamically scoped `$bayonet_shell_only` special
variable, so an assembly opts in **once** at its top level rather than threading an argument
through every intermediate module:

```scad
$bayonet_shell_only = $preview;   // F5 previews bare shells, F6 renders the real geometry
```

That reaches every `bayonet()` call below it, including calls buried inside your own modules.
An explicit `shell_only=` argument always wins over the special variable, so a single joint
can stay fully detailed while the rest of the assembly stays light, and `let()` scopes it to
part of a tree:

```scad
let($bayonet_shell_only = true) my_subassembly();
```

Validation is unaffected: every parameter is checked in `shell_only` mode too, so a preview
that passes will not surprise you with an assertion at render time.

> **Note for forks:** setting `$bayonet_shell_only` in *your own* file is the intended usage
> above. What does not work is declaring a default at the top level of `bayonet_lock.scad`
> itself — a top-level assignment in a `use`d file shadows the consumer's value, silently
> pinning it to the library's default. The library resolves it with `is_undef` for that
> reason.

The saving scales with the number of joints. In
[`examples/assembly_shell_only_preview.scad`](examples/assembly_shell_only_preview.scad)
the mode cuts the CSG tree from 752 nodes to 240, and removes every `rotate_extrude` and
channel cut except those of the one joint that opts out. On a comparable eight-half assembly
at `$fn = 64`, the CGAL render drops from ~104 s to ~3.8 s.

## Mating the two halves

Both halves are authored in a single frame. Instantiated at a common origin with matching
parameters they are **in the locked position** — no translation or rotation needed:

```scad
bayonet(half = "lock", ...);
bayonet(half = "pin",  ...);   // same origin, same parameters => locked
```

To show them at the entry position instead — pins at the channel mouths, before the turn —
rotate the pin half by `sweep_angle`, negative for `"CW"` and positive for `"CCW"`:

```scad
rotate([0, 0, turn_direction == "CW" ? -sweep_angle : sweep_angle])
  bayonet(half = "pin", ...);
```

Any rotation between the two is a valid mid-travel position. All of this holds for any
`entry_depth`, and throughout that range the halves stay clear of each other, so an
`intersection()` of the two that is non-empty means the parameters do not match.

See the [`examples/`](examples/) directory for ready-to-render configurations:

| File                                                                  | What it shows                              |
| --------------------------------------------------------------------- | ------------------------------------------ |
| [`outer_3pin.scad`](examples/outer_3pin.scad)                         | Outer pin, 3 pins, CW, custom entry depth  |
| [`inner_2pin.scad`](examples/inner_2pin.scad)                         | Inner pin, 2 pins, CCW, default entry depth |
| [`inner_3pin_thick_shell.scad`](examples/inner_3pin_thick_shell.scad) | Inner pin, 3 pins, explicit thick shell    |
| [`outer_4pin_ccw.scad`](examples/outer_4pin_ccw.scad)                 | Outer pin, 4 pins, CCW, default entry depth |
| [`minimal.scad`](examples/minimal.scad)                               | Bare minimum call, default shell and entry depth |
| [`assembly_shell_only_preview.scad`](examples/assembly_shell_only_preview.scad) | Multi-joint assembly using `$bayonet_shell_only = $preview` |

The first five render the lock and pin side-by-side for visual inspection;
`assembly_shell_only_preview.scad` instead shows them assembled into a multi-joint model.

## Parameter reference

| Parameter          | Type                   | Description                                                                                                                   |
| ------------------ | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `half`             | `"pin"` \| `"lock"`    | Which half to generate                                                                                                        |
| `interface_radius` | mm > 0                 | Canonical mating radius where the pin centerline and lock channel are referenced                                              |
| `shell_thickness`  | mm > 0, optional       | Radial thickness from the interface to the inner or outer shell; defaults to `pin_radius * 2`                                 |
| `allowance`        | mm ≥ 0                 | Radial clearance applied ±allowance/2 around the mating surface                                                               |
| `part_height`      | mm                     | Total axial height of the connector                                                                                           |
| `entry_depth`      | mm, optional           | Insertion depth from the top face before the bayonet turn begins; defaults to `part_height * 0.5` and must be < `part_height` |
| `number_of_pins`   | int ≥ 1                | Number of locking points                                                                                                      |
| `pin_radius`       | mm                     | Radius of the locking pin sphere; explicit `shell_thickness` values must satisfy `pin_radius + allowance/2 ≤ shell_thickness` |
| `sweep_angle`      | degrees                | Arc the pin travels; must be > 0 and < 360/number_of_pins                                                                     |
| `pin_direction`    | `"inner"` \| `"outer"` | Whether the pin protrudes toward the bore or toward the OD                                                                    |
| `turn_direction`   | `"CW"` \| `"CCW"`      | Direction of the locking rotation                                                                                             |
| `shell_only`       | bool, optional         | Omit the pin/channel features and emit only the bare shell; defaults to `$bayonet_shell_only`, then `false`                    |

## License & Attribution

Originally developed by [xavierasx](https://www.thingiverse.com/xavierasx), this is a rewritten version of [bayonet Lock Connector library V2.1](https://www.thingiverse.com/thing:6536797) which is originally licensed under **CC BY**.
