/*
 * Power Alert Board Enclosure
 */

base_x = 60;
base_y = 60;
base_z = 31.5;
wall_thickness = 2.0;
walls = wall_thickness * 2;

pcb_thickness = 1.6;

// box_color = "royalblue";
box_color = "cornflowerblue";

led_dia    = 5.0;
led_height = 9.0;
led_dx = -mm(0.150);
led_dy =  mm(0.200);


// functions

function mm(in) = in * 25.4;
