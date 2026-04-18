// Example: outer pin direction, 3 pins, CW turn, neck on pin half
// Cameron K. Brooks — MIT License
// Demonstrates: pin_direction="outer", bayonet_neck flange on pin side, no neck on lock

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

inner_radius     = 10;
outer_radius     = 15;
pin_radius       = 1;
allowance        = 0.2;
number_of_pins   = 3;
path_sweep_angle = 30;
turn_direction   = "CW";
part_height      = 10;
channel_depth    = 5;
neck_height      = 5;

// For "outer" pin direction the pin shell's OD is mid_in_radius, not outer_radius.
neck_outer_r = (inner_radius + outer_radius) / 2 - allowance / 2;

// Lock — rendered at origin
bayonet(
  part_to_render  = "lock",
  pin_direction   = "outer",
  number_of_pins  = number_of_pins,
  path_sweep_angle = path_sweep_angle,
  turn_direction  = turn_direction,
  inner_radius    = inner_radius,
  outer_radius    = outer_radius,
  pin_radius      = pin_radius,
  allowance       = allowance,
  part_height     = part_height,
  channel_depth   = channel_depth
);

// Pin with neck — translated right for side-by-side comparison
translate([outer_radius * 2 + 5, 0, 0])
  bayonet_neck(neck_height, inner_radius, neck_outer_r)
    bayonet(
      part_to_render  = "pin",
      pin_direction   = "outer",
      number_of_pins  = number_of_pins,
      path_sweep_angle = path_sweep_angle,
      turn_direction  = turn_direction,
      inner_radius    = inner_radius,
      outer_radius    = outer_radius,
      pin_radius      = pin_radius,
      allowance       = allowance,
      part_height     = part_height,
      channel_depth   = channel_depth
    );
