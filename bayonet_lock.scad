// simple bayonet cylindrical locking mechanism
// Cameron K. Brooks
// MIT License
// version 0.4.1

// Hollow cylindrical tube primitive — outer shell minus thru-bore.
// The bore is triple-height and centered to avoid z-fighting on both faces.
module tube(h, r_outer, r_inner) {
  difference() {
    cylinder(h=h, r=r_outer);
    cylinder(h=h * 3, r=r_inner, center=true);
  }
}

// Adds a hollow cylindrical neck/flange below the bayonet body.
// The bayonet module is passed as a child and positioned at the top of the neck.
module bayonet_neck(neck_height, inner_radius, outer_radius) {
  union() {
    tube(h=neck_height, r_outer=outer_radius, r_inner=inner_radius);
    translate([0, 0, neck_height]) {
      children();
    }
  }
}

module bayonet(
  part_to_render,
  pin_direction,
  number_of_pins,
  path_sweep_angle,
  turn_direction,
  inner_radius,
  outer_radius,
  pin_radius,
  allowance,
  part_height,
  channel_depth
) {
  assert(
    part_to_render == "pin" || part_to_render == "lock",
    str("bayonet: part_to_render must be \"pin\" or \"lock\", got: ", part_to_render)
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
    inner_radius > 0,
    str("bayonet: inner_radius must be > 0, got: ", inner_radius)
  );
  assert(
    outer_radius > inner_radius,
    str("bayonet: outer_radius must be > inner_radius (", inner_radius, "), got: ", outer_radius)
  );
  assert(
    pin_radius > 0,
    str("bayonet: pin_radius must be > 0, got: ", pin_radius)
  );
  assert(
    allowance >= 0,
    str("bayonet: allowance must be >= 0, got: ", allowance)
  );
  assert(
    number_of_pins >= 1,
    str("bayonet: number_of_pins must be >= 1, got: ", number_of_pins)
  );
  assert(
    channel_depth > 0,
    str("bayonet: channel_depth must be > 0, got: ", channel_depth)
  );
  assert(
    channel_depth < part_height,
    str("bayonet: channel_depth (", channel_depth, ") must be < part_height (", part_height, ")")
  );
  assert(
    path_sweep_angle > 0,
    str("bayonet: path_sweep_angle must be > 0, got: ", path_sweep_angle)
  );
  assert(
    path_sweep_angle < 360 / number_of_pins,
    str("bayonet: path_sweep_angle (", path_sweep_angle, ") must be < 360/number_of_pins (", 360 / number_of_pins, ") to avoid channel overlap")
  );

  mid_radius = (inner_radius + outer_radius) / 2;
  mid_in_radius = mid_radius - allowance / 2;
  mid_out_radius = mid_in_radius + allowance;

  // Determine which annular shell carries the pin vs the channel/lock.
  // For pin_direction=="inner": the pin is on the outer shell, channel on the inner shell.
  // For pin_direction=="outer": the pin is on the inner shell, channel on the outer shell.
  pin_ext_r = (pin_direction == "inner") ? outer_radius : mid_in_radius;
  pin_int_r = (pin_direction == "inner") ? mid_out_radius : inner_radius;
  lock_ext_r = (pin_direction == "inner") ? mid_in_radius : outer_radius;
  lock_int_r = (pin_direction == "inner") ? inner_radius : mid_out_radius;

  if (part_to_render == "pin") {
    _bayonet_channel(
      part_to_render,
      pin_direction,
      number_of_pins,
      path_sweep_angle,
      turn_direction,
      mid_radius,
      pin_radius,
      allowance,
      part_height,
      channel_depth
    );
    // pin-bearing shell body
    tube(h=part_height, r_outer=pin_ext_r, r_inner=pin_int_r);
  } else if (part_to_render == "lock") {
    difference() {
      // channel-bearing shell body
      tube(h=part_height, r_outer=lock_ext_r, r_inner=lock_int_r);
      // cut out the locking channel
      _bayonet_channel(
        part_to_render,
        pin_direction,
        number_of_pins,
        path_sweep_angle,
        turn_direction,
        mid_radius,
        pin_radius,
        allowance,
        part_height,
        channel_depth
      );
    }
  }
}

module _bayonet_channel(
  part_to_render,
  pin_direction,
  number_of_pins,
  path_sweep_angle,
  turn_direction,
  mid_radius,
  pin_radius,
  allowance,
  part_height,
  channel_depth
) {
  assert(
    part_to_render == "pin" || part_to_render == "lock",
    str("_bayonet_channel: part_to_render must be \"pin\" or \"lock\", got: ", part_to_render)
  );
  assert(
    pin_direction == "inner" || pin_direction == "outer",
    str("_bayonet_channel: pin_direction must be \"inner\" or \"outer\", got: ", pin_direction)
  );
  assert(
    turn_direction == "CW" || turn_direction == "CCW",
    str("_bayonet_channel: turn_direction must be \"CW\" or \"CCW\", got: ", turn_direction)
  );

  mid_in_radius = mid_radius - allowance / 2;
  mid_out_radius = mid_in_radius + allowance;
  shaft_radius = pin_radius + allowance / 2;

  // Radial position of the mating surface (where pin meets channel wall)
  interface_radius = (pin_direction == "outer") ? mid_in_radius : mid_out_radius;

  for (runs = [0:number_of_pins - 1]) {
    angle = 360 / number_of_pins * runs;
    rotate([0, 0, angle]) {
      if (part_to_render == "lock") {
        difference() {
          union() {
            // vertical entry shaft
            translate([interface_radius, 0, channel_depth]) {
              cylinder(h=part_height - channel_depth + shaft_radius, r=shaft_radius);
            }
            // rounded entry transition
            translate([interface_radius, 0, channel_depth]) {
              difference() {
                sphere(shaft_radius);
                cylinder(h=shaft_radius * 2, r=shaft_radius * 2);
              }
            }
            // curved sweep path
            sweep_entry_angle =
              (pin_direction == "inner") ? atan2(shaft_radius - allowance / 2, mid_radius)
              : atan2(shaft_radius - allowance / 4, mid_radius);
            torus_angle =
              (turn_direction == "CW") ? -(path_sweep_angle + sweep_entry_angle)
              : path_sweep_angle + sweep_entry_angle;
            translate([0, 0, channel_depth]) {
              rotate_extrude(angle=torus_angle, convexity=10) {
                translate([interface_radius, 0, 0]) {
                  circle(r=shaft_radius);
                }
              }
            }
          }

          // locking notch cutout
          lock_pos =
            (pin_direction == "inner") ? interface_radius - pin_radius - allowance / 2
            : interface_radius + pin_radius;
          lock_notch_angle =
            (pin_direction == "inner") ? atan2(shaft_radius - allowance / 2, mid_radius)
            : atan2(shaft_radius - 1.5 * allowance, mid_radius);
          lock_angle =
            (turn_direction == "CW") ? -(path_sweep_angle - lock_notch_angle)
            : path_sweep_angle - lock_notch_angle;
          x = cos(lock_angle) * lock_pos;
          y = sin(lock_angle) * lock_pos;
          z = channel_depth - shaft_radius;
          translate([x, y, z]) {
            cylinder(h=2 * shaft_radius, r=allowance);
          }
        }
      } else if (part_to_render == "pin") {
        // locking pin sphere
        translate([interface_radius, 0, part_height - channel_depth]) {
          sphere(pin_radius);
        }
      }
    }
  }
}
