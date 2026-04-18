# bayonet-Lock-SCAD

This OpenSCAD library provides a parametric bayonet lock connector, inspired by designs used in aviation maintenance for their reliability and ease of use. It produces both the pin and lock halves of the mechanism with a fully configurable number of locking points and turn direction.

Key features:

- Configurable number of locking pins (2 or more).
- Customizable inner and outer radii for any bore size.
- `pin_direction` parameter selects whether the pin protrudes inward or outward.
- Adjustable `allowance` (clearance gap) for tuning fit tolerance.
- Optional neck/flange below the bayonet body via `bayonet_neck`; set `neck_height = 0` to omit.
- Preview-aware `$fn` (64 preview / 128 render) for fast iteration.

The design improves upon earlier versions by modularizing the code and addressing issues from the original implementation. Contributions and feedback are welcome.

## Usage

```
use <bayonet_lock.scad>;

bayonet_neck(neck_height, inner_radius, outer_radius)
  bayonet(
    part_to_render = "pin",   // "pin" | "lock"
    pin_direction  = "outer", // "inner" | "outer"
    number_of_pins = 3,
    path_sweep_angle = 30,    // degrees; must be < 360/number_of_pins
    turn_direction = "CW",    // "CW" | "CCW"
    inner_radius   = 10,
    outer_radius   = 15,
    pin_radius     = 1,
    allowance      = 0.2,
    part_height    = 10,
    channel_depth  = 5        // axial Z position where the bayonet turn begins
  );
```

See `example_usage.scad` for a complete working example with `manual_pin_radius` auto-fallback.

## Parameter reference

| Parameter          | Type                   | Description                                                                      |
| ------------------ | ---------------------- | -------------------------------------------------------------------------------- |
| `part_to_render`   | `"pin"` \| `"lock"`    | Which half to generate                                                           |
| `pin_direction`    | `"inner"` \| `"outer"` | Pin protrudes toward bore or OD                                                  |
| `number_of_pins`   | int ≥ 1                | Number of locking points                                                         |
| `path_sweep_angle` | degrees                | Arc the pin travels; must be < 360/number_of_pins                                |
| `turn_direction`   | `"CW"` \| `"CCW"`      | Direction of the locking rotation                                                |
| `inner_radius`     | mm                     | Bore radius                                                                      |
| `outer_radius`     | mm                     | Outer shell radius; must be > inner_radius                                       |
| `pin_radius`       | mm > 0                 | Radius of the locking pin sphere                                                 |
| `allowance`        | mm ≥ 0                 | Radial clearance between mating shells                                           |
| `part_height`      | mm                     | Total axial height of the connector                                              |
| `channel_depth`    | mm                     | Axial Z position where the bayonet turn begins (0 < channel_depth < part_height) |

`bayonet_neck(neck_height, inner_radius, outer_radius)` adds a plain hollow cylinder below the bayonet body. Pass the bayonet module as a child.

## License & Attribution

Originally developed by [xavierasx](https://www.thingiverse.com/xavierasx), this is a rewritten version of [bayonet Lock Connector library V2.1](https://www.thingiverse.com/thing:6536797) which is originally licensed under **CC BY**.
