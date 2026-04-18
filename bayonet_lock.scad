// simple bayonet cylindrical locking mechanism
// Cameron K. Brooks
// MIT License

module add_neck(neck_height, inner_radius, outer_radius) {
  union() {
    difference() {
      cylinder(d=outer_radius * 2, h=neck_height);
      cylinder(d=inner_radius * 2, h=neck_height);
    }
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
  depth
) {

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
    bayonet_channel(
      part_to_render,
      pin_direction,
      number_of_pins,
      path_sweep_angle,
      turn_direction,
      mid_radius,
      pin_radius,
      allowance,
      part_height,
      depth
    );
    difference() {
      // pin-bearing shell body
      cylinder(part_height, pin_ext_r, pin_ext_r);
      // internal bore (slightly over-cut for clean boolean)
      translate([0, 0, -part_height / 100]) {
        cylinder(part_height * 1.02, pin_int_r, pin_int_r);
      }
    }
  } else if (part_to_render == "lock") {
    difference() {
      // channel-bearing shell body
      cylinder(part_height, lock_ext_r, lock_ext_r);
      // internal bore (slightly over-cut for clean boolean)
      translate([0, 0, -part_height / 100]) {
        cylinder(part_height * 1.02, lock_int_r, lock_int_r);
      }
      // cut out the locking channel
      color("Red")
        bayonet_channel(
          part_to_render,
          pin_direction,
          number_of_pins,
          path_sweep_angle,
          turn_direction,
          mid_radius,
          pin_radius,
          allowance,
          part_height,
          depth
        );
    }
  }
}

module bayonet_channel(
  part_to_render,
  pin_direction,
  number_of_pins,
  path_sweep_angle,
  turn_direction,
  mid_radius,
  pin_radius,
  allowance,
  part_height,
  depth
) {

  // Don't mess with it
  mid_in_radius = mid_radius - allowance / 2;
  mid_out_radius = mid_in_radius + allowance;
  shaft_radius = pin_radius + allowance / 2;

  interface_radius = (pin_direction == "outer") ? mid_in_radius : (pin_direction == "inner") ? mid_out_radius : 0;

  pin_position = (pin_direction == "outer") ? mid_in_radius : (pin_direction == "inner") ? mid_out_radius : 0;

  for (runs = [0:number_of_pins - 1]) {
    angle = 360 / number_of_pins * runs;
    rotate([0, 0, angle]) {
      if (part_to_render == "lock") {
        // render lock part
        difference() {
          union() {
            // vertical shaft cylinder
            translate([interface_radius, 0, depth]) {
              cylinder(part_height - depth + shaft_radius, shaft_radius, shaft_radius);
            }
            // turn sphere
            translate([interface_radius, 0, depth]) {
              difference() {
                sphere(shaft_radius);
                cylinder(shaft_radius * 2, shaft_radius * 2, shaft_radius * 2);
              }
            }
            // curved path
            add_angle1 =
              (pin_direction == "inner") ? atan2(shaft_radius - allowance / 2, mid_radius)
              : atan2(shaft_radius - allowance / 4, mid_radius);
            thorus_angle =
              (turn_direction == "CW") ? -(path_sweep_angle + add_angle1) : path_sweep_angle + add_angle1;
            translate([0, 0, depth]) {
              rotate_extrude(angle=thorus_angle, convexity=10) {
                translate([interface_radius, 0, 0]) {
                  circle(r=shaft_radius);
                }
              }
            }
          }

          // lock
          lock_pos =
            (interface_radius == mid_out_radius) ? interface_radius - pin_radius - allowance / 2
            : (interface_radius == mid_in_radius) ? interface_radius + pin_radius
            : 0;

          add_angle2 =
            (pin_direction == "inner") ? atan2(shaft_radius - allowance / 2, mid_radius)
            : atan2(shaft_radius - 1.5 * allowance, mid_radius);
          lock_angle =
            (turn_direction == "CW") ? -(path_sweep_angle - add_angle2) : path_sweep_angle - add_angle2;
          x = cos(lock_angle) * lock_pos;
          y = sin(lock_angle) * lock_pos;
          z = depth - shaft_radius;
          translate([x, y, z]) {
            cylinder(2 * shaft_radius, allowance, allowance);
          }
        }
      } else if (part_to_render == "pin") // render pin part
      {
        // pin
        translate([pin_position, 0, part_height - depth]) {
          sphere(pin_radius);
        }
      }
    }
  }
}
