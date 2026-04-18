// Example: inner pin direction, 2 pins, CCW turn, no neck
// Cameron K. Brooks — MIT License
// Demonstrates: pin_direction="inner", 2 locking points, CCW rotation, no neck

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

inner_radius     = 12;
outer_radius     = 18;
pin_radius       = 1.5;
allowance        = 0.25;
number_of_pins   = 2;
path_sweep_angle = 45;
turn_direction   = "CCW";
part_height      = 12;
channel_depth    = 6;

// Lock — rendered at origin
bayonet(
  part_to_render  = "lock",
  pin_direction   = "inner",
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

// Pin — translated right for side-by-side comparison (no neck)
translate([outer_radius * 2 + 5, 0, 0])
  bayonet(
    part_to_render  = "pin",
    pin_direction   = "inner",
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
