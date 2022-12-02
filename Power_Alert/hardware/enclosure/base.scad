/*
 * Power Alert Board Enclosure Base
 */

include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <mylibs/components.scad>
include <mylibs/mcus.scad>

include <common.scad>

SHOW_COMPONENTS = true;

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

pcbHdr_x = hdr_x;
pcbHdr_y = hdr_y;
pcbHdr_z = 2.5;
topHdr2 = topHdr + pcbHdr_z;

ib_x  = mm(1.400);  // ItsyBitsy MCU
ib_y  = mm(0.700);
ib_h  = pcb_thickness + mm(0.125);
ib_dx = mm(0.800) - pcb_cx;
ib_dy = -mm(0.350);
topMCU = topHdr + pcbHdr_z + pcb_thickness;

hdz  = topPCB;
hdr_dx = ib_dx;
hdr_dy = ib_dy;

// PCB headers
pcbHdr_dx = ib_dx;
pcbHdr_dy = mm(0.600)-pcb_cy;
pcbHdr_dz  = hdz+hdr_z;


$fn = 64;

// build it

if (SHOW_COMPONENTS) {

  // height marker
//  component_rnd(4, 16, "orange", -20, 10);

  ItsyBitsy(ib_dx, ib_dy, topHdr2);

  // pcb pin headers
  dip_header(pcbHdr_x, pcbHdr_y, pcbHdr_z, mm(0.6),
             pcbHdr_dx, pcbHdr_dy, pcbHdr_dz, "white");
  // DIP sockets
  dip_header(hdr_x, hdr_y, hdr_z, mm(0.6),
             hdr_dx, hdr_dy, topPCB);
  
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
    points(pin_dia, "blue", pins_x, pins_y,
           post_height+pin_height);
    posts(pin_dia, pin_height, "blue", pins_x,
          pins_y, post_height);
    posts(5, post_height, "blue", pins_x/2, pins_y/2, 0);
    shell();
  }

  // window exterior height to center = 23.3mm.
  // Compare with echo in method.
  window(wall_thickness+3, 8, 6, 1,
         -(base_x-wall_thickness)/2, ib_dy, topMCU-3.9,
         EDGES_X_ALL);
}
//----------------------

// modules

//  post points
module points(dia, color, dx, dy, dz) {
  up(dz) 
  color(color) 
  grid2d(rows=2,cols=2,spacing=[dx,dy])
  cyl(d1=dia, d2=dia/2, h=dia*0.85, align=V_TOP);
}

module posts(dia, ht, color, dx, dy, dz) {
  up(dz)
  color(color)
  grid2d(rows=2,cols=2,spacing=[dx,dy])
  cyl(d=dia, h=ht, align=V_TOP);
}

module window (x, y, z, fil, dx, dy, dz, edges) {
  // exterior height to window center
  echo(win_ht=wall_thickness + dz + z/2);
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
