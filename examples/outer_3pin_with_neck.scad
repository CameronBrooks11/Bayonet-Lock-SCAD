// Example: outer pin direction, 3 pins, CW turn, neck on pin half
// Cameron K. Brooks — MIT License
// Demonstrates: pin_direction="outer", bayonet_neck flange on pin side, no neck on lock

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

inner_radius    = 10;
shell_thickness = 2.5;
pin_radius      = 1;
allowance       = 0.2;
number_of_pins  = 3;
sweep_angle     = 30;
turn_direction  = "CW";
part_height     = 10;
entry_depth     = 5;
neck_height     = 5;

// Neck OD = interface_r - allowance/2 = inner_radius + shell_thickness - allowance/2.
neck_outer_r = inner_radius + shell_thickness - allowance / 2;

// Lock — rendered at origin
bayonet(
  half            = "lock",
  inner_radius    = inner_radius,
  shell_thickness = shell_thickness,
  allowance       = allowance,
  part_height     = part_height,
  entry_depth     = entry_depth,
  number_of_pins  = number_of_pins,
  pin_radius      = pin_radius,
  sweep_angle     = sweep_angle,
  pin_direction   = "outer",
  turn_direction  = turn_direction
);

// Pin with neck — translated right for side-by-side comparison
translate([(inner_radius + 2 * shell_thickness) * 2 + 5, 0, 0])
  bayonet_neck(neck_height, inner_radius, neck_outer_r)
    bayonet(
      half            = "pin",
      inner_radius    = inner_radius,
      shell_thickness = shell_thickness,
      allowance       = allowance,
      part_height     = part_height,
      entry_depth     = entry_depth,
      number_of_pins  = number_of_pins,
      pin_radius      = pin_radius,
      sweep_angle     = sweep_angle,
      pin_direction   = "outer",
      turn_direction  = turn_direction
    );

