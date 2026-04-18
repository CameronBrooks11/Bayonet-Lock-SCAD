// Example: minimal usage — bare module call, no neck, no derived variables
// Cameron K. Brooks — MIT License
// Demonstrates: simplest possible invocation of the bayonet module

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

// Lock — rendered at origin
bayonet(
  part_to_render  = "lock",
  pin_direction   = "inner",
  number_of_pins  = 2,
  path_sweep_angle = 40,
  turn_direction  = "CW",
  inner_radius    = 8,
  outer_radius    = 12,
  pin_radius      = 1,
  allowance       = 0.2,
  part_height     = 8,
  channel_depth   = 4
);

// Pin — translated right for side-by-side comparison
translate([29, 0, 0])
  bayonet(
    part_to_render  = "pin",
    pin_direction   = "inner",
    number_of_pins  = 2,
    path_sweep_angle = 40,
    turn_direction  = "CW",
    inner_radius    = 8,
    outer_radius    = 12,
    pin_radius      = 1,
    allowance       = 0.2,
    part_height     = 8,
    channel_depth   = 4
  );
