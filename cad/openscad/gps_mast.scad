// gps_mast.scad  — sturdy parametric mast with reliable base & top
// Tune these to your hardware
puck_is_round      = false;     // false => square top with hole pattern
puck_diameter      = 26;       // mm (round puck OD)
puck_hole_spacing  = 20;       // mm (square pattern, center-to-center)
puck_hole_d        =  0;       // mm (for M2 screws) — set to 0 for no holes

top_plate_d        = 21;       // mm (round top OD) or for square
top_plate_t        = 3;        // mm thickness

mast_height        = 60;      // mm
mast_od            = 10;       // mm
mast_id            = 6;        // mm (cable channel)
mast_wall_min      = 2;        // mm (keeps OD >= ID + 2*wall)
mast_offset_from_center = 0;   // mm (usually 0)

base_plate_w       = 30;       // mm
base_plate_l       = 34;       // mm
base_plate_t       = 2.0;      // mm
base_csk_hole_d    =   0;      // mm (M3 clearance) set 0 to omit
base_csk_head_d    = 6.2;      // mm (counterbore)
base_csk_head_t    = 2.0;      // mm depth
slot_len           = 0;  //18; // mm elongated mount slots
slot_w             = 0;  //3.4;// mm
slot_pitch         = 30;       // mm (distance between slots centers)

mast_to_base_boss_d = 14;      // mm (boss that ties mast to base)
mast_to_base_boss_t = 4;       // mm

cable_exit_slot_w  = 6;        // mm (in base rear)
cable_exit_slot_h  = 3;        // mm
$fn = 64;

// ---- helpers ----
eps = 0.01;
function clamp(v, lo, hi) = max(lo, min(hi, v));

// Round slot (capsule)
module slot_capsule(len, width, t){
  linear_extrude(height=t)
    hull(){
      translate([ len/2 - width/2, 0, 0]) circle(d=width);
      translate([-len/2 + width/2, 0, 0]) circle(d=width);
    }
}

// ---- parts ----
module base_plate(){
  difference(){
    // base block
    translate([-base_plate_w/2, -base_plate_l/2, 0])
      cube([base_plate_w, base_plate_l, base_plate_t], center=false);

    // elongated slots (x-axis)
    if (slot_w > 0 && slot_len > 0){
      translate([  slot_pitch/2, 0, -eps]) slot_capsule(slot_len, slot_w, base_plate_t+2*eps);
      translate([ -slot_pitch/2, 0, -eps]) slot_capsule(slot_len, slot_w, base_plate_t+2*eps);
    }

    // cable exit at rear edge
    translate([0, -base_plate_l/2 + cable_exit_slot_h/2 + eps, -eps])
      cube([cable_exit_slot_w, cable_exit_slot_h, base_plate_t+2*eps], center=true);

    // counterbored vertical mount holes (optional)
    if (base_csk_hole_d > 0){
      for (x=[ slot_pitch/2, -slot_pitch/2 ]){
        // through hole
        translate([x, 0, -eps]) cylinder(d=base_csk_hole_d, h=base_plate_t+2*eps);
        // counterbore from top
        translate([x, 0, base_plate_t - base_csk_head_t + eps])
          cylinder(d=base_csk_head_d, h=base_csk_head_t+eps);
      }
    }
  }

  // mast boss on top of base
  translate([mast_offset_from_center, 0, base_plate_t])
    cylinder(d=mast_to_base_boss_d, h=mast_to_base_boss_t);
}

module mast_tube(){
  mast_od_eff = max(mast_od, mast_id + 2*mast_wall_min);
  difference(){
    cylinder(d=mast_od_eff, h=mast_height);
    translate([0,0,-eps]) cylinder(d=mast_id, h=mast_height+2*eps);
  }
}

module top_plate(){
  translate([0,0,base_plate_t + mast_to_base_boss_t + mast_height]){
    if (puck_is_round){
      // round top
      difference(){
        cylinder(d=top_plate_d, h=top_plate_t);
        // center pilot (optional)
        // translate([0,0,-eps]) cylinder(d=2.0, h=top_plate_t+2*eps);
      }
    } else {
      // square top
      difference(){
        translate([-top_plate_d/2, -top_plate_d/2, 0])
          cube([top_plate_d, top_plate_d, top_plate_t]);
        // mounting holes
        if (puck_hole_d > 0){
          for (sx=[-1,1]) for (sy=[-1,1]){
            translate([sx*puck_hole_spacing/2, sy*puck_hole_spacing/2, -eps])
              cylinder(d=puck_hole_d, h=top_plate_t+2*eps);
          }
        }
      }
    }
  }
}

// ---- assembly ----
module gps_mast(){
  // base
  base_plate();

  // mast (centered on boss)
  translate([mast_offset_from_center, 0, base_plate_t + mast_to_base_boss_t])
    mast_tube();

  // top
  top_plate();
}

// Preview
gps_mast();
