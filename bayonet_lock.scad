// Copyright by Alexandre da Silva Xavier
// simple bayonet cylindrical locking mechanism
// ver 2.0 - 17/03/2024 (dd/mm/yyyy)
// ===========================================

// What style of lock to produce, with the pin pointed inward ou outward?
pin_direction = "inner"; // ["inner", "outer"]

// What to render
part_render = "pin"; // ["pin", "lock"]
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

// radius of the locking pin
pin_radius = (manual_pin_radius == 0) ? (outer_radius - inner_radius) / 4 : manual_pin_radius;

// Height of the connector part
part_height = 10;

// Height of the connector part
conn_height = 5;

// fragment count for arcs, 48 works best with FreeCAD
_fn = 32;

// height of the added neck to create a flange
neck_height = 5;

$fn = _fn;
zFite = $preview ? 0.1 : 0;

if (pin_direction == "inner")
{
    neck_h = (part_render == "lock") ? 0 : neck_height;
    add_neck(neck_h, inner_radius, outer_radius)
        inner_bayonet(part_render, pin_direction, number_of_pins, path_sweep_angle, turn_direction, inner_radius,
                      outer_radius, pin_radius, allowance, part_height, conn_height);
}
else
{
    neck_h = (part_render == "lock") ? 0 : neck_height;
    add_neck(neck_h, inner_radius, outer_radius)
        outer_bayonet(part_render, pin_direction, number_of_pins, path_sweep_angle, turn_direction, inner_radius,
                      outer_radius, pin_radius, allowance, part_height, conn_height);
}

module add_neck(neck_height, inner_radius, outer_radius)
{
    union()
    {
        difference()
        {
            cylinder(d = outer_radius * 2, h = neck_height);
            translate([ 0, 0, -zFite / 2 ]) cylinder(d = inner_radius * 2, h = neck_height + zFite);
        }
        translate([ 0, 0, neck_height ])
        {
            children();
        }
    }
}

module inner_bayonet(part_to_render, pin_direction, number_of_pins, path_sweep_angle, turn_direction, inner_radius,
                     outer_radius, pin_radius, allowance, part_height, depth)
{

    mid_radius = (inner_radius + outer_radius) / 2;

    mid_in_radius = mid_radius - allowance / 2;
    mid_out_radius = mid_in_radius + allowance;

    if (part_to_render == "pin")
    {
        bayonet_channel(part_to_render, pin_direction, number_of_pins, path_sweep_angle, turn_direction, mid_radius,
                        pin_radius, allowance, conn_height);
        difference()
        {
            // external cylinder
            cylinder(part_height, outer_radius, outer_radius);

            // internal cylinder
            translate([ 0, 0, -part_height / 100 ])
            {
                cylinder(part_height + (part_height / 50), mid_out_radius, mid_out_radius);
            }
        }
    }
    else if (part_to_render == "lock")
    {
        difference()
        {
            // external cylinder
            cylinder(part_height, mid_in_radius, mid_in_radius);
            // internal cylinder
            translate([ 0, 0, -part_height / 100 ])
            {
                cylinder(part_height * 1.02, inner_radius, inner_radius);
            }

            // cut out the locking channel
            color("Red") bayonet_channel(part_to_render, pin_direction, number_of_pins, path_sweep_angle,
                                         turn_direction, mid_radius, pin_radius, allowance, conn_height);
        }
    }
}

module outer_bayonet(part_to_render, pin_direction, number_of_pins, path_sweep_angle, turn_direction, inner_radius,
                     outer_radius, pin_radius, allowance, part_height, depth)
{

    mid_radius = (inner_radius + outer_radius) / 2;

    mid_in_radius = mid_radius - allowance / 2;
    mid_out_radius = mid_in_radius + allowance;

    if (part_to_render == "pin")
    {
        bayonet_channel(part_to_render, pin_direction, number_of_pins, path_sweep_angle, turn_direction, mid_radius,
                        pin_radius, allowance, conn_height);
        difference()
        {
            // external cylinder
            cylinder(part_height, mid_in_radius, mid_in_radius);
            // internal cylinder
            translate([ 0, 0, -part_height / 100 ])
            {
                cylinder(part_height * 1.02, inner_radius, inner_radius);
            }
        }
    }
    else if (part_to_render == "lock")
    {
        difference()
        {
            // external cylinder
            cylinder(part_height, outer_radius, outer_radius);
            // internal cylinder
            translate([ 0, 0, -part_height / 100 ])
            {
                cylinder(part_height + (part_height / 50), mid_out_radius, mid_out_radius);
            }
            color("Red") bayonet_channel(part_to_render, pin_direction, number_of_pins, path_sweep_angle,
                                         turn_direction, mid_radius, pin_radius, allowance, conn_height);
        }
    }
}

module bayonet_channel(part_to_render, pin_direction, number_of_pins, path_sweep_angle, turn_direction, mid_radius,
                       pin_radius, allowance, depth)
{

    // Don't mess with it
    mid_in_radius = mid_radius - allowance / 2;
    mid_out_radius = mid_in_radius + allowance;
    shaft_radius = pin_radius + allowance / 2;

    interface_radius = (pin_direction == "outer") ? mid_in_radius : (pin_direction == "inner") ? mid_out_radius : 0;

    pin_position = (pin_direction == "outer") ? mid_in_radius : (pin_direction == "inner") ? mid_out_radius : 0;

    for (runs = [0:number_of_pins - 1])
    {
        angle = 360 / number_of_pins * runs;
        rotate([ 0, 0, angle ])
        {
            if (part_to_render == "lock")
            { // render lock part
                difference()
                {
                    union()
                    {
                        // vertical shaft cylinder
                        translate([ interface_radius, 0, depth ])
                        {
                            cylinder(part_height - depth + shaft_radius, shaft_radius, shaft_radius);
                        }
                        // turn sphere
                        translate([ interface_radius, 0, depth ])
                        {
                            difference()
                            {
                                sphere(shaft_radius);
                                cylinder(shaft_radius * 2, shaft_radius * 2, shaft_radius * 2);
                            }
                        }
                        // curved path
                        add_angle1 = (pin_direction == "inner") ? atan2(shaft_radius - allowance / 2, mid_radius)
                                                                : atan2(shaft_radius - allowance / 4, mid_radius);
                        thorus_angle =
                            (turn_direction == "CW") ? -(path_sweep_angle + add_angle1) : path_sweep_angle + add_angle1;
                        translate([ 0, 0, depth ])
                        {
                            rotate_extrude(angle = thorus_angle, convexity = 10)
                            {
                                translate([ interface_radius, 0, 0 ])
                                {
                                    circle(r = shaft_radius);
                                }
                            }
                        }
                    }

                    // lock
                    lock_pos = (interface_radius == mid_out_radius)  ? interface_radius - pin_radius - allowance / 2
                               : (interface_radius == mid_in_radius) ? interface_radius + pin_radius
                                                                     : 0;

                    add_angle2 = (pin_direction == "inner") ? atan2(shaft_radius - allowance / 2, mid_radius)
                                                            : atan2(shaft_radius - 1.5 * allowance, mid_radius);
                    lock_angle =
                        (turn_direction == "CW") ? -(path_sweep_angle - add_angle2) : path_sweep_angle - add_angle2;
                    x = cos(lock_angle) * lock_pos;
                    y = sin(lock_angle) * lock_pos;
                    z = depth - shaft_radius;
                    translate([ x, y, z ])
                    {
                        cylinder(2 * shaft_radius, allowance, allowance);
                    }
                }
            }
            else if (part_to_render == "pin") // render pin part
            {
                // pin
                translate([ pin_position, 0, part_height - depth ])
                {
                    sphere(pin_radius);
                }
            }
        }
    }
}