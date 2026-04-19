// Example: outer pin direction, 4 pins, CCW turn, larger bore, no neck
// Cameron K. Brooks - MIT License

use <../bayonet_lock.scad>;

$fn = $preview ? 64 : 128;

interface_radius = 15;
pin_radius = 1.75;
allowance = 0.2;
number_of_pins = 4;
sweep_angle = 25;
turn_direction = "CCW";
part_height = 15;

// Lock - rendered at origin
bayonet(
  half="lock",
  interface_radius=interface_radius,
  allowance=allowance,
  part_height=part_height,
  number_of_pins=number_of_pins,
  pin_radius=pin_radius,
  sweep_angle=sweep_angle,
  pin_direction="outer",
  turn_direction=turn_direction
);

// Pin - translated right for side-by-side comparison
translate([(interface_radius) * 2 + 5, 0, 0])
  bayonet(
    half="pin",
    interface_radius=interface_radius,
    allowance=allowance,
    part_height=part_height,
    number_of_pins=number_of_pins,
    pin_radius=pin_radius,
    sweep_angle=sweep_angle,
    pin_direction="outer",
    turn_direction=turn_direction
  );
