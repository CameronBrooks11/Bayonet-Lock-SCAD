// example usage of the bayonet cylindrical locking mechanism
// Cameron K. Brooks
// MIT License
// version 0.4.1

use <bayonet_lock.scad>;

// ---- global settings ----
$fn = $preview ? 64 : 128;

// ---- user settings ----

// What style of lock to produce, with the pin pointed inward ou outward?
pin_direction = "outer"; // ["inner", "outer"]

// What to render
part_to_render = "lock"; // ["pin", "lock"]

// Render the mechanism with 2 to 6 locks / pins
number_of_pins = 3;

// The angle of the path that the pin will follow
path_sweep_angle = 30;

// Direction of the lock
turn_direction = "CW"; // ["CW", "CCW"]

// inner radius of the lock
inner_radius = 10;

// outer radius of the lock
outer_radius = 15;

// the allowance or "gap" between the pin and the lock
allowance = 0.2;

// manual pin radius, if not set, it will be calculated based on the inner and outer radius
manual_pin_radius = 1;

// Height of the connector part
part_height = 10;

// Axial height at which the bayonet turn begins
channel_depth = 5;

// height of the added neck to create a flange
neck_height = 5;

// ---- derived values ----

// radius of the locking pin
pin_radius = (manual_pin_radius == 0) ? (outer_radius - inner_radius) / 4 : manual_pin_radius;

// Outer radius of the neck must match the pin shell's outer wall.
// When pin_direction=="outer" the pin shell ends at mid_in_radius, not outer_radius.
neck_outer_radius = (pin_direction == "outer")
  ? (inner_radius + outer_radius) / 2 - allowance / 2
  : outer_radius;

neck_h = (part_to_render == "lock") ? 0 : neck_height;

bayonet_neck(neck_h, inner_radius, neck_outer_radius)
  bayonet(
    part_to_render=part_to_render,
    pin_direction=pin_direction,
    number_of_pins=number_of_pins,
    path_sweep_angle=path_sweep_angle,
    turn_direction=turn_direction,
    inner_radius=inner_radius,
    outer_radius=outer_radius,
    pin_radius=pin_radius,
    allowance=allowance,
    part_height=part_height,
    channel_depth=channel_depth
  );
