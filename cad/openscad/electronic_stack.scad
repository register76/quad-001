// OpenSCAD — Parametric FC/ESC Stack Frame (30.5×30.5 + 35×35)
// Author: ChatGPT × B Dog
// License: CC0/Public Domain — tweak freely
//
// Includes additional 35×35 mm M3 hole pattern.
// All holes are plain through-holes (no heat-set pockets, no grommets).
// Plates are clean and flat (no integrated standoffs).

// ================ USER PARAMETERS =================
plate_thickness        = 3.0;    // mm
standoff_height_esc    = 7.0;    // base→ESC clearance
standoff_height_fc     = 10.0;   // ESC→FC clearance
edge_radius            = 2.0;    // outer corner rounding (2D)

// Stack & hardware
stack_spacing          = 30.5;   // Ardu/Betaflight standard
alt_stack_spacing      = 35.0;   // new hole pattern
mount_hole_d           = 3.2;    // for M3 screws

// Plate footprint
base_w                 = 45;
base_l                 = 45;
lip_overhang           = 2;

// Zip-tie slots
slot_w                 = 6.0;
slot_l                 = 22.0;
slot_margin            = 8.0;
slot_count_per_side    = 2;
use_zip_tie_slots      = false;

// Venting
vent_count             = 2;
vent_w                 = 6.0;
vent_gap               = 6.0;

// Aux shelf
use_aux_shelf          = false;
aux_spacing            = 20.0;
aux_w                  = 28.0;
aux_l                  = 36.0;
aux_offset             = [0, 32];
aux_thickness          = 2.5;

// Side guards
use_side_guards        = false;
side_guard_h           = 10.0;
side_guard_t           = 2.0;

$fn=64;

// ================ HELPERS =================
module rounded_plate(w,l,r,th){
  linear_extrude(th)
    minkowski(){
      square([w-2*r,l-2*r], center=true);
      circle(r);
    }
}

module rect_cut(c, sx, sy, h){ translate([c[0]-sx/2, c[1]-sy/2, 0]) cube([sx,sy,h+0.2], center=false); }
function stack_xy(i,spacing)=
  let(s=spacing/2)
  [ [ s,  s],
    [-s,  s],
    [-s, -s],
    [ s, -s] ][i];

// ================ FEATURES =================
module stack_holes(th){
  // main 30.5 mm pattern
  for(i=[0:3])
    translate([stack_xy(i,stack_spacing)[0], stack_xy(i,stack_spacing)[1], 0])
      cylinder(d=mount_hole_d, h=th+0.4);

  // additional 35 mm pattern
  for(i=[0:3])
    translate([stack_xy(i,alt_stack_spacing)[0], stack_xy(i,alt_stack_spacing)[1], 0])
      cylinder(d=mount_hole_d, h=th+0.4);
}


module vents(th){
  // vents centered along Y
  total = vent_count*vent_w + (vent_count-1)*vent_gap;
  y0 = -total/2 + vent_w/2;
  for(i=[0:vent_count-1]){
    y = y0 + i*(vent_w+vent_gap);
    rect_cut([0,y,0], base_w-2*slot_margin-6, vent_w, th);
  }
}

// ================ PLATES =================
module base_plate(){
  difference(){
    rounded_plate(base_w, base_l, edge_radius, plate_thickness);
    stack_holes(plate_thickness);
    if(use_zip_tie_slots) zip_tie_slots(slot_w, slot_l, plate_thickness);
    vents(plate_thickness);
  }
}

module esc_plate(){
  translate([0,0,plate_thickness + standoff_height_esc])
    difference(){
      rounded_plate(base_w - 2*lip_overhang, base_l - 2*lip_overhang, edge_radius, plate_thickness);
      stack_holes(plate_thickness);
      vents(plate_thickness);
    }
}

module fc_plate(){
  translate([0,0,plate_thickness + standoff_height_esc + plate_thickness + standoff_height_fc])
    difference(){
      rounded_plate(base_w - 2*lip_overhang, base_l - 2*lip_overhang, edge_radius, plate_thickness);
      stack_holes(plate_thickness);
      vents(plate_thickness);
    }
}

// ================ ASSEMBLY =================
module assembly(){
  color("lightgray") base_plate();
  color("gainsboro") esc_plate();
  color("whitesmoke") fc_plate();
}

// ================ PREVIEWS =================
assembly();

// ================ HOW TO EXPORT =================
// 1) Set 'assembly();' to show only the part you want (e.g., base_plate();)
// 2) Design → Render (F6)
// 3) File → Export → STL
// 
// Tuning Tips
// - For rubber isolation, print a second copy of base_plate() in TPU, trim to only the grommet_bosses() (or set a modifier),
//   then sandwich between frame and arms.
// - If using metal standoffs, set standoff heights to 0 and rely on hardware. 
// - The heat‑set pockets fit typical M3 inserts; tweak heatset_d/depth for your brand.
