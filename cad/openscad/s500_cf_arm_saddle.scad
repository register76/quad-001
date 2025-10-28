//
// S500 Arm Saddle (Bolt-On) — OpenSCAD
// Author: ChatGPT
// Version: v0.1 (2025-10-28)
// Purpose:
//   Two flat CF plates (top & bottom) that clamp the arm root using the existing 4-hole pattern.
//   Cut from 2.0 mm carbon fiber. No epoxy needed. Improves torsional stiffness.
//   Export each plate as DXF for CNC or print PLA first as a fit template.
//
// -------------------- User Parameters --------------------

export_mode       = "3D";   // "3D" or "DXF" (DXF outputs 2D outlines+holes only)
show_all_arms     = true;   // true: preview all four; false: preview one (arm_index)
arm_index         = 0;      // which arm to show when show_all_arms=false (0..3)

// Plate geometry
cf_thickness      = 2.0;    // mm
plate_len         = 60;     // mm (along arm axis)
plate_wid         = 40;     // mm (across arm axis)
corner_r          = 3.0;    // mm fillet for corners
kerf              = 0.10;   // mm (+ grows outline) for CNC compensation

// Holes (M3 recommended)
hole_d            = 4.0;    // mm (loose fit). If you want tighter, set to 3.2
slot_enable       = false;  // true -> slots in long direction
slot_d            = 3.2;    // slot width
slot_len          = 5.0;    // slot extra length (overall ~ hole_d + slot_len)

// Arm relief pocket (shallow recess on the inner face to hug the arm crown slightly)
relief_enable     = true;
relief_len        = 36;     // mm along arm
relief_wid        = 18;     // mm across arm
relief_depth      = 0.5;    // mm depth (keeps plate nearly full strength)
relief_round_r    = 2.0;    // corner fillet of relief

// Placement (reused from your good fit)
r_patch           = 50;                 // distance from board origin to plate center
arm_angles        = [45, 135, 225, 315];

// Hole pattern (XY offsets relative to plate center BEFORE rotation)
pattern_arm0      = [[-14,0],[13,-15],[13,15],[-13,0]];
pattern_arm1      = pattern_arm0;
pattern_arm2      = pattern_arm0;
pattern_arm3      = pattern_arm0;

// Optional: reference STL (for visual alignment only)
show_stl          = false;              // set true if you want to overlay your frame STL
stl_path          = "top_frame_s500.STL";
stl_alpha         = 0.25;
stl_rotate_deg    = [90,0,45];          // your earlier good orientation
stl_translate     = [-97.5, 0, 0];
stl_scale         = 1.0;

// -------------------- Helpers --------------------

function sel_pattern(i) =
    i==0 ? pattern_arm0 :
    i==1 ? pattern_arm1 :
    i==2 ? pattern_arm2 :
           pattern_arm3 ;

module rounded_rect_2d(w, h, r) {
    // Kerf in/out to keep fillets clean
    offset(delta=kerf) offset(delta=-kerf)
    hull() {
        translate([ w/2 - r,  h/2 - r]) circle(r=r, $fn=48);
        translate([-w/2 + r,  h/2 - r]) circle(r=r, $fn=48);
        translate([ w/2 - r, -h/2 + r]) circle(r=r, $fn=48);
        translate([-w/2 + r, -h/2 + r]) circle(r=r, $fn=48);
    }
}

module relief_2d(L, W, r) {
    // filleted inner pocket
    hull() {
        translate([ L/2 - r,  W/2 - r]) circle(r=r, $fn=36);
        translate([-L/2 + r,  W/2 - r]) circle(r=r, $fn=36);
        translate([ L/2 - r, -W/2 + r]) circle(r=r, $fn=36);
        translate([-L/2 + r, -W/2 + r]) circle(r=r, $fn=36);
    }
}

module hole_2d(d)    { circle(d=d, $fn=36); }
module slot_2d(d, L) {
    // Capsule slot along X
    hull() {
        translate([+L/2 - d/2, 0]) circle(d=d, $fn=36);
        translate([-L/2 + d/2, 0]) circle(d=d, $fn=36);
    }
}

module holes_2d(points) {
    for (p = points) translate(p)
        if (slot_enable) slot_2d(slot_d, hole_d + slot_len);
        else             hole_2d(hole_d);
}

// One plate outline with holes; if relief is enabled, subtract shallow recess on the "inner" face.
// We'll build TOP and BOTTOM from the same 2D and just extrude; relief direction is documented in notes.
module saddle_plate_2d(hole_pts) {
    difference() {
        rounded_rect_2d(plate_len, plate_wid, corner_r);
        holes_2d(hole_pts);
        if (relief_enable) // carve an internal pocket area
            relief_2d(relief_len, relief_wid, relief_round_r);
    }
}

module saddle_plate_3d(hole_pts) {
    linear_extrude(height=cf_thickness)
        saddle_plate_2d(hole_pts);
}

// Render one arm's top+bottom at its frame position
module arm_saddle_set(i) {
    angle = arm_angles[i];
    pts   = sel_pattern(i);
    // Position at arm root
    rotate([0,0,angle]) translate([r_patch,0,0]) {
        // TOP plate (put relief DOWN toward arm)
        color("black") translate([0,0, cf_thickness]) mirror([0,0,1]) saddle_plate_3d(pts);

        // BOTTOM plate (put relief UP toward arm)
        color("black") saddle_plate_3d(pts);

        // Optional visual markers:
        // translate([0,0,cf_thickness*1.8]) color([0,1,0]) cylinder(h=0.1,d=2,$fn=24); // plate center dot
    }
}

module all_saddles() {
    for (i=[0:len(arm_angles)-1]) arm_saddle_set(i);
}

module ref_stl() {
    color([0.1,0.6,1.0, stl_alpha])
        translate(stl_translate) rotate(stl_rotate_deg) scale(stl_scale)
            import(stl_path, convexity=5);
}

// -------------------- Scene --------------------

if (export_mode == "DXF") {
    // DXF export: choose TOP or BOTTOM—same outline; relief pocket shows so CAM can engrave 0.5 mm depth if desired.
    // Comment/uncomment the one you want to export at a time:
    projection(cut=true) saddle_plate_2d(pattern_arm0);
} else {
    if (show_stl) ref_stl();
    if (show_all_arms) {
        all_saddles();
    } else {
        arm_saddle_set(arm_index);
    }
}
