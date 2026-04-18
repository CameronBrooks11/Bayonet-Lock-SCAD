// Example: outer pin direction, 4 pins, CCW turn, larger bore, no neck
// Cameron K. Brooks — MIT License
// Demonstrates: 4 locking points, CCW rotation, wider body

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

inner_radius    = 15;
shell_thickness = 3.5;
pin_radius      = 1.75;
allowance       = 0.2;
number_of_pins  = 4;
sweep_angle     = 25;
turn_direction  = "CCW";
part_height     = 15;
entry_depth     = 7;

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

// Pin — translated right for side-by-side comparison
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
    pin_direction   = "outer",
    turn_direction  = turn_direction
  );

