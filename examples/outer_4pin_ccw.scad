// Example: outer pin direction, 4 pins, CCW turn, larger bore, no neck
// Cameron K. Brooks — MIT License
// Demonstrates: 4 locking points, CCW rotation, wider body

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

inner_radius     = 15;
outer_radius     = 22;
pin_radius       = 1.75;
allowance        = 0.2;
number_of_pins   = 4;
path_sweep_angle = 25;
turn_direction   = "CCW";
part_height      = 15;
channel_depth    = 7;

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

// Pin — translated right for side-by-side comparison
translate([outer_radius * 2 + 5, 0, 0])
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
