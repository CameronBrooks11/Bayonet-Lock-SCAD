// simple bayonet cylindrical locking mechanism
// Cameron K. Brooks
// MIT License
// version 0.7.0

module bayonet(
  half,
  interface_radius,
  shell_thickness = undef,
  allowance,
  part_height,
  entry_depth,
  number_of_pins,
  pin_radius,
  sweep_angle,
  pin_direction,
  turn_direction
) {

  assert(
    half == "pin" || half == "lock",
    str("bayonet: half must be \"pin\" or \"lock\", got: ", half)
  );
  assert(
    pin_direction == "inner" || pin_direction == "outer",
    str("bayonet: pin_direction must be \"inner\" or \"outer\", got: ", pin_direction)
  );
  assert(
    turn_direction == "CW" || turn_direction == "CCW",
    str("bayonet: turn_direction must be \"CW\" or \"CCW\", got: ", turn_direction)
  );
  assert(
    interface_radius > 0,
    str("bayonet: interface_radius must be > 0, got: ", interface_radius)
  );
  assert(
    allowance >= 0,
    str("bayonet: allowance must be >= 0, got: ", allowance)
  );
  assert(
    pin_radius > 0,
    str("bayonet: pin_radius must be > 0, got: ", pin_radius)
  );
  assert(
    (is_undef(shell_thickness) ? true : (pin_radius + allowance / 2 <= shell_thickness)),
    str(
      "bayonet: shell_thickness must be >= pin_radius + allowance/2 (",
      pin_radius + allowance / 2,
      "), got: ",
      shell_thickness
    )
  );
  assert(
    number_of_pins >= 1,
    str("bayonet: number_of_pins must be >= 1, got: ", number_of_pins)
  );
  assert(
    entry_depth > 0,
    str("bayonet: entry_depth must be > 0, got: ", entry_depth)
  );
  assert(
    entry_depth < part_height,
    str("bayonet: entry_depth (", entry_depth, ") must be < part_height (", part_height, ")")
  );
  assert(
    sweep_angle > 0,
    str("bayonet: sweep_angle must be > 0, got: ", sweep_angle)
  );
  assert(
    sweep_angle < 360 / number_of_pins,
    str("bayonet: sweep_angle (", sweep_angle, ") must be < 360/number_of_pins (", 360 / number_of_pins, ") to avoid channel overlap")
  );

  // Canonical mating surface and derived geometry.
  _shell_thickness = is_undef(shell_thickness) ? pin_radius * 2 : shell_thickness;
  _outer_radius = interface_radius + _shell_thickness;
  _internal_radius = interface_radius - _shell_thickness;
  _channel_z = part_height - entry_depth;

  // Determine which annular shell carries the pin vs the channel/lock.
  // For pin_direction=="inner": pin on outer shell, channel on inner shell.
  // For pin_direction=="outer": pin on inner shell, channel on outer shell.
  pin_direction_inner = (pin_direction == "inner");
  pin_ext_r = pin_direction_inner ? _outer_radius : interface_radius - (allowance / 2);
  pin_int_r = pin_direction_inner ? interface_radius + (allowance / 2) : _internal_radius;

  lock_ext_r = pin_direction_inner ? interface_radius - (allowance / 2) : _outer_radius;
  lock_int_r = pin_direction_inner ? _internal_radius : interface_radius + (allowance / 2);

  if (half == "pin") {
    _bayonet_channel(
      half,
      pin_direction,
      number_of_pins,
      sweep_angle,
      turn_direction,
      interface_radius,
      pin_radius,
      allowance,
      part_height,
      _channel_z
    );
    // pin-bearing shell body
    _tube(
      h=part_height,
      r_outer=pin_ext_r,
      r_inner=pin_int_r
    );
  } else if (half == "lock") {
    difference() {
      // channel-bearing shell body
      _tube(
        h=part_height,
        r_outer=lock_ext_r,
        r_inner=lock_int_r
      );
      // cut out the locking channel
      _bayonet_channel(
        half,
        pin_direction,
        number_of_pins,
        sweep_angle,
        turn_direction,
        interface_radius,
        pin_radius,
        allowance,
        part_height,
        _channel_z
      );
    }
  }
}

module _bayonet_channel(
  half,
  pin_direction,
  number_of_pins,
  sweep_angle,
  turn_direction,
  interface_r,
  pin_radius,
  allowance,
  part_height,
  channel_depth
) {

  _channel_radius = pin_radius + allowance / 2;

  // Radial position of pin centre: +/- allowance/2 from the canonical mating surface.
  pin_interface_r =
    (pin_direction == "outer") ? interface_r - allowance / 2
    : interface_r + allowance / 2;

  for (runs = [0:number_of_pins - 1]) {
    angle = 360 / number_of_pins * runs;
    rotate([0, 0, angle]) {
      if (half == "lock") {
        difference() {
          union() {
            // vertical entry shaft
            translate([pin_interface_r, 0, channel_depth]) {
              cylinder(h=part_height - channel_depth + _channel_radius, r=_channel_radius);
            }
            // rounded entry transition
            translate([pin_interface_r, 0, channel_depth]) {
              difference() {
                sphere(_channel_radius);
                cylinder(h=_channel_radius * 2, r=_channel_radius * 2);
              }
            }
            // curved sweep path
            // Angular correction so the torus cross-section meets the entry shaft tangentially.
            // Inner: numerator = _channel_radius - allowance/2, derived from the pin/torus tangent geometry.
            // Outer: coefficient allowance/4 is empirically tuned; the outer-direction interface offset
            // shifts the tangent point differently and a closed-form derivation has not been done.
            // Validated for allowance ∈ [0.1, 0.4] and pin_radius ∈ [0.5, 3.0].
            sweep_entry_angle =
              (pin_direction == "inner") ? atan2(_channel_radius - allowance / 2, interface_r)
              : atan2(_channel_radius - allowance / 4, interface_r);

            torus_angle = sweep_angle + sweep_entry_angle;
            torus_angle_signed =
              (turn_direction == "CW") ?
                -torus_angle
              : torus_angle;

            // Pre-rotate only for CW: torus_angle_signed is negative, so rotating by it places
            // the profile start at torus_angle_signed°; sweeping abs(torus_angle_signed) CCW returns to 0°
            // (the entry shaft). For CCW no pre-rotation needed - sweep runs 0° to torus_angle_signed°.
            translate([0, 0, channel_depth]) {
              rotate([0, 0, (turn_direction == "CW") ? torus_angle_signed : 0])
                rotate_extrude(angle=abs(torus_angle_signed), convexity=10) {
                  translate([pin_interface_r, 0, 0]) {
                    circle(r=_channel_radius);
                  }
                }
            }
          }

          // locking notch cutout
          // Inner: notch at interface_r - pin_radius (symmetric about interface_r).
          // Outer: notch at interface_r - allowance/2 + pin_radius (pin centre sits allowance/2 inside interface_r).
          lock_pos =
            (pin_direction == "inner") ?
              interface_r - pin_radius
            : interface_r + pin_radius - allowance / 2;

          // Same atan2 geometry as sweep_entry_angle; places the notch under the pin at end-of-travel.
          // Inner: same derivation as sweep_entry_angle.
          // Outer: coefficient 1.5*allowance is empirically tuned; same caveat and validated range
          // as sweep_entry_angle outer (allowance ∈ [0.1, 0.4], pin_radius ∈ [0.5, 3.0]).
          lock_notch_angle =
            (pin_direction == "inner") ?
              atan2(_channel_radius - allowance / 2, interface_r)
            : atan2(_channel_radius - 1.5 * allowance, interface_r);

          lock_angle = sweep_angle - lock_notch_angle;
          lock_angle_signed =
            (turn_direction == "CW") ?
              -lock_angle
            : lock_angle;

          x = cos(lock_angle_signed) * lock_pos;
          y = sin(lock_angle_signed) * lock_pos;
          z = channel_depth - _channel_radius;

          translate([x, y, z]) {
            cylinder(h=2 * _channel_radius, r=allowance);
          }
        }
      } else if (half == "pin") {
        // locking pin sphere
        translate([pin_interface_r, 0, part_height - channel_depth]) {
          sphere(pin_radius);
        }
      }
    }
  }
}

// Hollow cylindrical tube primitive consisting of an outer shell minus thru-bore.
// The bore is triple-height and centered to avoid z-fighting on both faces.
module _tube(h, r_outer, r_inner) {
  difference() {

    cylinder(h=h, r=r_outer);

    if (r_inner > 0)
      cylinder(h=h * 3, r=r_inner, center=true);
  }
}
