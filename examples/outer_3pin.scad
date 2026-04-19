// Example: outer pin direction, 3 pins, CW turn, default shell thickness
// Cameron K. Brooks - MIT License

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

interface_radius = 10;
pin_radius = 1;
allowance = 0.2;
number_of_pins = 3;
sweep_angle = 30;
turn_direction = "CW";
part_height = 10;
entry_depth = 7; // override default entry depth of part_height * 0.5

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
  pin_direction="outer",
  turn_direction=turn_direction
);

// Pin - translated right for side-by-side comparison
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
      pin_direction="outer",
      turn_direction=turn_direction
    );
