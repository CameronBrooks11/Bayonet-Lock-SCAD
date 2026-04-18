// Example: minimal usage — bare module call, no neck, no derived variables
// Cameron K. Brooks — MIT License
// Demonstrates: simplest possible invocation of the bayonet module

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

// Lock — rendered at origin
bayonet(
  half            = "lock",
  inner_radius    = 8,
  shell_thickness = 2,
  allowance       = 0.2,
  part_height     = 8,
  entry_depth     = 4,
  number_of_pins  = 2,
  pin_radius      = 1,
  sweep_angle     = 40,
  pin_direction   = "inner",
  turn_direction  = "CW"
);

// Pin — translated right for side-by-side comparison
translate([(inner_radius + 2 * shell_thickness) * 2 + 5, 0, 0])
  bayonet(
    half            = "pin",
    inner_radius    = 8,
    shell_thickness = 2,
    allowance       = 0.2,
    part_height     = 8,
    entry_depth     = 4,
    number_of_pins  = 2,
    pin_radius      = 1,
    sweep_angle     = 40,
    pin_direction   = "inner",
    turn_direction  = "CW"
  );

