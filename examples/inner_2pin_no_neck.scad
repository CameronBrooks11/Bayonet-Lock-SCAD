// Example: inner pin direction, 2 pins, CCW turn, no neck
// Cameron K. Brooks — MIT License
// Demonstrates: pin_direction="inner", 2 locking points, CCW rotation, no neck

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

inner_radius    = 12;
shell_thickness = 3;
pin_radius      = 1.5;
allowance       = 0.25;
number_of_pins  = 2;
sweep_angle     = 45;
turn_direction  = "CCW";
part_height     = 12;
entry_depth     = 6;

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
  pin_direction   = "inner",
  turn_direction  = turn_direction
);

// Pin — translated right for side-by-side comparison (no neck)
translate([(inner_radius + 2 * shell_thickness) * 2 + 5, 0, 0])
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
    pin_direction   = "inner",
    turn_direction  = turn_direction
  );

