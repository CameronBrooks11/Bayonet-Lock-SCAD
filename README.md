# bayonet-Lock-SCAD

This OpenSCAD library provides a parametric bayonet lock connector, inspired by designs used in aviation maintenance for their reliability and ease of use. It produces both the pin and lock halves of the mechanism with a fully configurable number of locking points and turn direction.

Key features:

- Configurable number of locking pins (2 or more).
- Configurable interface radius (`interface_radius`) with optional shell wall thickness (`shell_thickness`) for any coupling diameter.
- `pin_direction` parameter selects whether the pin protrudes inward or outward.
- Adjustable `allowance` (clearance gap) for tuning fit tolerance.
- Preview-aware `$fn` (64 preview / 128 render) for fast iteration.

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
  entry_depth     = 5,        // insertion depth from top before the turn begins
  number_of_pins  = 3,
  pin_radius      = 1,
  sweep_angle     = 30,       // degrees; must be < 360/number_of_pins
  pin_direction   = "outer",  // "inner" | "outer"
  turn_direction  = "CW"      // "CW" | "CCW"
);
```

See the [`examples/`](examples/) directory for ready-to-render configurations:

| File                                                                  | What it shows                              |
| --------------------------------------------------------------------- | ------------------------------------------ |
| [`outer_3pin.scad`](examples/outer_3pin.scad)                         | Default: outer pin, 3 pins, CW             |
| [`inner_2pin.scad`](examples/inner_2pin.scad)                         | Inner pin, 2 pins, CCW                     |
| [`inner_3pin_thick_shell.scad`](examples/inner_3pin_thick_shell.scad) | Inner pin, 3 pins, explicit thick shell    |
| [`outer_4pin_ccw.scad`](examples/outer_4pin_ccw.scad)                 | Outer pin, 4 pins, CCW, larger bore        |
| [`minimal.scad`](examples/minimal.scad)                               | Bare minimum call, default shell thickness |

Each file renders both the lock and pin side-by-side for visual inspection.

## Parameter reference

| Parameter          | Type                   | Description                                                                                                                   |
| ------------------ | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `half`             | `"pin"` \| `"lock"`    | Which half to generate                                                                                                        |
| `interface_radius` | mm > 0                 | Canonical mating radius where the pin centerline and lock channel are referenced                                              |
| `shell_thickness`  | mm > 0, optional       | Radial thickness from the interface to the inner or outer shell; defaults to `pin_radius * 2`                                 |
| `allowance`        | mm ≥ 0                 | Radial clearance applied ±allowance/2 around the mating surface                                                               |
| `part_height`      | mm                     | Total axial height of the connector                                                                                           |
| `entry_depth`      | mm                     | Insertion depth from the top face before the bayonet turn begins; must be < part_height                                       |
| `number_of_pins`   | int ≥ 1                | Number of locking points                                                                                                      |
| `pin_radius`       | mm                     | Radius of the locking pin sphere; explicit `shell_thickness` values must satisfy `pin_radius + allowance/2 ≤ shell_thickness` |
| `sweep_angle`      | degrees                | Arc the pin travels; must be > 0 and < 360/number_of_pins                                                                     |
| `pin_direction`    | `"inner"` \| `"outer"` | Whether the pin protrudes toward the bore or toward the OD                                                                    |
| `turn_direction`   | `"CW"` \| `"CCW"`      | Direction of the locking rotation                                                                                             |

## License & Attribution

Originally developed by [xavierasx](https://www.thingiverse.com/xavierasx), this is a rewritten version of [bayonet Lock Connector library V2.1](https://www.thingiverse.com/thing:6536797) which is originally licensed under **CC BY**.
