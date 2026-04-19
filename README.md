# bayonet-Lock-SCAD

This OpenSCAD library provides a parametric bayonet lock connector, inspired by designs used in aviation maintenance for their reliability and ease of use. It produces both the pin and lock halves of the mechanism with a fully configurable number of locking points and turn direction.

Key features:

- Configurable number of locking pins (2 or more).
- Configurable bore radius (`inner_radius`) and shell wall thickness (`shell_thickness`) for any coupling diameter.
- `pin_direction` parameter selects whether the pin protrudes inward or outward.
- Adjustable `allowance` (clearance gap) for tuning fit tolerance.
- Preview-aware `$fn` (64 preview / 128 render) for fast iteration.

The design improves upon earlier versions by modularizing the code and addressing issues from the original implementation. Contributions and feedback are welcome.

## Usage

```
use <bayonet_lock.scad>;

bayonet(
  half            = "pin",    // "pin" | "lock"
  inner_radius    = 10,
  shell_thickness = 2.5,      // each shell wall; outer_r = inner_radius + 2 * shell_thickness
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

| File                                                  | What it shows                          |
| ----------------------------------------------------- | -------------------------------------- |
| [`outer_3pin.scad`](examples/outer_3pin.scad)         | Default: outer pin, 3 pins, CW         |
| [`inner_2pin.scad`](examples/inner_2pin.scad)         | Inner pin, 2 pins, CCW                 |
| [`outer_4pin_ccw.scad`](examples/outer_4pin_ccw.scad) | Outer pin, 4 pins, CCW, larger bore    |
| [`minimal.scad`](examples/minimal.scad)               | Bare minimum call no derived variables |

Each file renders both the lock and pin side-by-side for visual inspection.

## Parameter reference

| Parameter         | Type                   | Description                                                                               |
| ----------------- | ---------------------- | ----------------------------------------------------------------------------------------- |
| `half`            | `"pin"` \| `"lock"`    | Which half to generate                                                                    |
| `inner_radius`    | mm > 0                 | Bore inner radius                                                                         |
| `shell_thickness` | mm > 0                 | Radial thickness of each shell wall; outer radius = `inner_radius + 2 * shell_thickness`  |
| `allowance`       | mm ≥ 0                 | Radial clearance applied ±allowance/2 around the mating surface                           |
| `part_height`     | mm                     | Total axial height of the connector                                                       |
| `entry_depth`     | mm                     | Insertion depth from the top face before the bayonet turn begins; must be < part_height   |
| `number_of_pins`  | int ≥ 1                | Number of locking points                                                                  |
| `pin_radius`      | mm                     | Radius of the locking pin sphere; must satisfy pin_radius + allowance/2 ≤ shell_thickness |
| `sweep_angle`     | degrees                | Arc the pin travels; must be > 0 and < 360/number_of_pins                                 |
| `pin_direction`   | `"inner"` \| `"outer"` | Whether the pin protrudes toward the bore or toward the OD                                |
| `turn_direction`  | `"CW"` \| `"CCW"`      | Direction of the locking rotation                                                         |

## License & Attribution

Originally developed by [xavierasx](https://www.thingiverse.com/xavierasx), this is a rewritten version of [bayonet Lock Connector library V2.1](https://www.thingiverse.com/thing:6536797) which is originally licensed under **CC BY**.
