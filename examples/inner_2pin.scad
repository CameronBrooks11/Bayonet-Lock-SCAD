// Example: inner pin direction, 2 pins, CCW turn, no neck
// Cameron K. Brooks - MIT License

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

interface_radius = 12;
pin_radius = 1.5;
allowance = 0.25;
number_of_pins = 2;
sweep_angle = 45;
turn_direction = "CCW";
part_height = 12;
entry_depth = 6;

// Lock - rendered at origin
bayonet(
  half="lock",
  interface_radius=interface_radius,
  allowance=allowance,
  part_height=part_height,
  entry_depth=entry_depth,
  number_of_pins=number_of_pins,
  pin_radius=pin_radius,
  sweep_angle=sweep_angle,
  pin_direction="inner",
  turn_direction=turn_direction
);

// Pin - translated right for side-by-side comparison (no neck)
translate([interface_radius * 3, 0, 0])
  bayonet(
    half="pin",
    interface_radius=interface_radius,
    allowance=allowance,
    part_height=part_height,
    entry_depth=entry_depth,
    number_of_pins=number_of_pins,
    pin_radius=pin_radius,
    sweep_angle=sweep_angle,
    pin_direction="inner",
    turn_direction=turn_direction
  );
