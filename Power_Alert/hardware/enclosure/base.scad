/*
 * Power Alert Board Enclosure Base
 */

include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <common.scad>

SHOW_COMPONENTS = false;

pins_x = mm(1.700);
pins_y = mm(1.700);
pin_dia    = 3.0;
pin_height = 2.0;
pin_hole_dia = 3.2;

post_dia    = 5.0;
post_height = 8.0;

pcb_x = mm(1.900);
pcb_y = mm(1.900);
pcb_cx = mm(1.900/2);  // pcb center
pcb_cy = mm(1.900/2);
topPCB = post_height+pcb_thickness; // top of PCB : floor

piezo_dia    = 17.0;
piezo_height = 7.8;
// piezo_dia    = 14.0;   // piezo element 2
// piezo_height = 12.8;
piezo_x = mm(0.375);
piezo_y = mm(0.400);

cap_dia = 5.0;
cap_height = 7.0;
cap_x = -mm(0.600);
cap_y =  mm(0.600);

hdr_x = 36.06;
hdr_y = 2.54;
hdr_z = 8.5;
topHdr = topPCB + hdr_z;  // top of hdr : floor

legs_x = hdr_x;
legs_y = hdr_y;
legs_z = 1.27;
topHdr2 = topHdr + legs_z;

ib_x  = mm(1.400);  // ItsyBitsy MCU
ib_y  = mm(0.700);
ib_h  = pcb_thickness + mm(0.125);
ib_dx = mm(0.800) - pcb_cx;
ib_dy = -mm(0.350);
topMCU = topHdr + 1.27 + pcb_thickness;

hdz  = topPCB;
hdx1 = ib_dx;  // top row
hdy1 = mm(0.900) - pcb_cy;
hdx2 = ib_dx;  // bottom row
hdy2 = mm(0.300) - pcb_cy;

// when pcb doesn't seat fully
legs_dx1 = hdx1;
legs_dy1 = hdy1;
legs_dx2 = hdx2;
legs_dy2 = hdy2;
legs_dz  = hdz+hdr_z;

usb_x = mm(0.220);
usb_y = mm(0.300);
usb_z = 2.5;
usb_dx = mm(0.195) - pcb_cy;
usb_dy = ib_dy;


$fn = 64;

// build it

if (SHOW_COMPONENTS) {

  // height marker
//  component_rnd(4, 16, "orange", -20, 10);

  // CPU
  component_rect45(8.0, 8.0, 2.0, "darkslategrey",
                   ib_dx+5, ib_dy, topMCU);
  // USB port
  component_rect(usb_x, usb_y, usb_z, "silver",
                 usb_dx, usb_dy, topMCU);
  pcb(ib_x, ib_y, 2, "blue",          // ItsyBitsy MCU
      ib_dx, ib_dy, topHdr2);
  // when pcb doesn't seat fully
  component_rect(legs_x, legs_y, legs_z, "gold",
                 legs_dx1, legs_dy1, legs_dz);
  component_rect(legs_x, legs_y, legs_z, "gold",
                 legs_dx2, legs_dy2, legs_dz);
  // headers
  component_rect(hdr_x, hdr_y, hdr_z, "black",
                 hdx1, hdy1, hdz);
  component_rect(hdr_x, hdr_y, hdr_z, "black",
                 hdx2, hdy2, hdz);
  // LED caps, piezo
  LED_rnd(led_dia, led_height, "red",
                led_dx, led_dy);
  component_rnd(cap_dia, cap_height, "blue",
                cap_x, cap_y);
  component_rnd(piezo_dia, piezo_height, "darkslategrey",
                piezo_x, piezo_y);
  pcboard();
}

difference() {
  union() {
    pposts(pin_dia, "blue", pins_x/2, pins_y/2,
           post_height+pin_height);
    posts(pin_dia, pin_height, "blue", pins_x/2,
          pins_y/2, post_height);
    posts(5, post_height, "blue", pins_x/2, pins_y/2, 0);
    shell();
  }

  window(wall_thickness+3, 8, 6, 1,
         -(base_x-wall_thickness)/2, ib_dy, topMCU-1.75,
         EDGES_X_ALL);
}
//----------------------

// modules

// pointy posts
module pposts(dia, color, dx, dy, dz) {
  color(color) {
    ppost(dia,  dx,  dy, dz);
    ppost(dia,  dx, -dy, dz);
    ppost(dia, -dx,  dy, dz);
    ppost(dia, -dx, -dy, dz);
  }
}

module ppost(dia, dx, dy, dz) {
  translate([dx, dy, dz])
  cyl(d1=dia, d2=dia/2, h=dia*0.85, align=V_TOP);
}

module posts(dia, ht, color, dx, dy, dz) {
  color(color) {
    post(dia, ht,  dx,  dy, dz);
    post(dia, ht,  dx, -dy, dz);
    post(dia, ht, -dx,  dy, dz);
    post(dia, ht, -dx, -dy, dz);
  }
}

module post(dia, ht, dx, dy, dz) {
  translate([dx, dy, dz])
  cyl(d=dia, h=ht, align=V_TOP);
}

module component_rect(x, y, z, color, dx, dy, dz) {
  translate([dx, dy, dz])
  color(color)
  cuboid([x, y, z], align=V_TOP);
}

module component_rect45(x, y, z, color, dx, dy, dz) {
  translate([dx, dy, dz])
  rotate(45)
  color(color)
  cuboid([x, y, z], align=V_TOP);
}

module component_rnd(dia, ht, color, dx, dy) {
  translate([dx, dy, topPCB])
  color(color)
  cyl(d=dia, h=ht, align=V_TOP);
}

module LED_rnd(dia, ht, color, dx, dy) {
  translate([dx, dy, topPCB]) {
    color(color) {
      up(ht-dia/2)
      sphere(d=dia);
      cyl(d=dia, h=ht-dia/2, align=V_TOP);
    }
  }
}

module pcboard() {
  up(post_height)
  difference() {
    color("darkorchid")
    cuboid([pcb_x, pcb_y, pcb_thickness], align=V_TOP,
           fillet=2, edges=EDGES_Z_ALL);

    holes();
  }
}

// generic pcb, no holes
module pcb(x, y, fil, color, dx, dy, dz) {
  translate([dx, dy, dz])
  color(color)
  cuboid([x, y, pcb_thickness], align=V_TOP,
         fillet=fil, edges=EDGES_Z_ALL);
}

/*
module holes (dia, dx, dy) {
  translate([dx, dy, 0])
  cyl(d=dia, h=pcb_thickness*2+1);
}
*/

module holes () {
  translate([pins_x/2, pins_y/2, 0.2])
  cyl(d=pin_hole_dia, h=4, align=V_TOP);

  translate([pins_x/2, -pins_y/2, 0.2])
  cyl(d=pin_hole_dia, h=4, align=V_TOP);

  translate([-pins_x/2, pins_y/2, 0.2])
  cyl(d=pin_hole_dia, h=4, align=V_TOP);

  translate([-pins_x/2, -pins_y/2, 0.2])
  cyl(d=pin_hole_dia, h=4, align=V_TOP);
}

module window (x, y, z, fil, dx, dy, dz, edges) {
  translate([dx, dy, dz])
  cuboid([x, y, z], fillet=fil, align=V_TOP, 
         edges=edges);
}

module shell() {
  down(wall_thickness)
  difference() {
    color(box_color)
    cuboid([base_x, base_y, base_z], align=V_TOP,
           fillet=2, edges=EDGES_Z_ALL);

    up(wall_thickness)
    cuboid([base_x-walls, base_y-walls, base_z],
           align=V_TOP);
  }
}
