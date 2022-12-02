/*
 * Power Alert Board Enclosure Lid
 */

include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <common.scad>

lid_height   = 3.0;
lid_overlap  = 2.5;
lid_overlaps = 5.0;

$fn = 90;

// build it

color(box_color)
lid();

//---------------------

// modules

module lid() {
  difference() {
    down(wall_thickness) {
      difference() {
        union() {
          cuboid([base_x-walls, base_y-walls,
                  lid_height+lid_overlap],
                 align=V_TOP, fillet=0.5,
                 edges=EDGES_TOP+EDGES_Z_ALL);
          cuboid([base_x, base_y, lid_height],
                 align=V_TOP, fillet=0.5,
                 edges=EDGES_Z_ALL);
        }
        led_hole(-led_dx, led_dy, -1); // flip on Y-axis
      }
    }

    cuboid([base_x-walls-lid_overlaps,
            base_y-walls-lid_overlaps,
            lid_height+lid_overlap],
           align=V_TOP);
  }
}

module led_hole (dx, dy, dz) {
  translate([dx, dy, dz])
  cyl(d=led_dia, h=wall_thickness+2, align=V_TOP);
}