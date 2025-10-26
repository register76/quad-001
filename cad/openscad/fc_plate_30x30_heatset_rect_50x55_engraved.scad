//
// Flat FC plate with M2.5 heat-set insert pockets (30×30 pattern)
// + Auxiliary rectangular through-hole pattern (50 x 55 mm)
// + Centered engraved label
// Author: ChatGPT
// Units: millimeters
//

//////////// Parameters ////////////
plate_len = 55;          // overall X length of the plate
plate_wid = 55;          // overall Y width of the plate
plate_thk = 3.0;         // plate thickness

corner_rad = 4;          // rounded corner radius

// Flight controller heat-set pattern (centered on origin)
mount_spacing = 30.5;    // 30x30 pattern (hole centers)
insert_pocket_d = 3.5;   // blind pocket diameter for M2.5 insert (common OD ≈3.5–3.8)
insert_pocket_h = 2.2;   // blind pocket depth (should be <= plate_thk)
pilot_through_d = 2.2;   // small pilot through-hole (keeps insert centered, not for screw)

// Optional: screw clearance from opposite side (disabled by default)
add_clearance_from_bottom = false;
clearance_d = 2.7;       // typical M2.5 screw clearance ~2.6–2.8

// Small chamfer ring at pocket mouth (visual aid / tiny lead-in)
add_micro_lead = true;
lead_height = 0.2;       // tiny height
lead_extra = 0.4;        // +diameter for lead-in ring

// Auxiliary rectangular through-hole pattern
aux_dx = 45;             // spacing in X (mm)
aux_dy = 47;             // spacing in Y (mm)
aux_hole_d = 4.5;        // through-hole diameter (M3 clearance by default)

// Engraved label
engrave_text   = "FC/ESC"; // text to engrave
engrave_size   = 4;        // font size (mm)
engrave_depth  = 0.6;      // recess depth into the top surface (mm)
////////////////////////////////////

$fn = 64; // smooth circles
eps = 0.01;

// Robust rounded rectangle (avoids offset() negative-radius parsing issues)
module rounded_rect_2d(x, y, r) {
    if (r <= 0) {
        square([x, y], center=true);
    } else {
        minkowski() {
            square([x - 2*r, y - 2*r], center=true);
            circle(r=r);
        }
    }
}

// Returns 4 points at the corners of a square hole pattern
function mount_points(sp) = [
    [ sp/2,  sp/2],
    [-sp/2,  sp/2],
    [-sp/2, -sp/2],
    [ sp/2, -sp/2]
];

// Returns 4 points at the corners of a rectangular hole pattern
function rect_points(dx, dy) = [
    [ dx/2,  dy/2],
    [-dx/2,  dy/2],
    [-dx/2, -dy/2],
    [ dx/2, -dy/2]
];

// Engraved text cutter (centered)
module engrave_cutter(txt, size_mm, depth_mm) {
    translate([0, 0, plate_thk - depth_mm])  // sink into top face
        linear_extrude(height = depth_mm + eps)
            text(txt, size = size_mm, halign = "center", valign = "center");
}

module fc_plate() {
    difference() {
        // Base plate
        linear_extrude(height = plate_thk)
            rounded_rect_2d(plate_len, plate_wid, corner_rad);

        // Engrave label (subtract)
        engrave_cutter(engrave_text, engrave_size, engrave_depth);

        // Heat-set pockets and through features (30x30 pattern)
        for (pt = mount_points(mount_spacing)) {
            // Blind pocket from TOP face
            translate([pt[0], pt[1], plate_thk - insert_pocket_h])
                cylinder(d = insert_pocket_d, h = insert_pocket_h + eps);

            // Optional micro lead-in at pocket mouth
            if (add_micro_lead) {
                translate([pt[0], pt[1], plate_thk - lead_height])
                    cylinder(d = insert_pocket_d + lead_extra, h = lead_height + eps);
            }

            // Pilot through-hole (all the way)
            translate([pt[0], pt[1], -eps])
                cylinder(d = pilot_through_d, h = plate_thk + 2*eps);

            // Optional: screw clearance from bottom up to the bottom of the pocket
            if (add_clearance_from_bottom) {
                translate([pt[0], pt[1], -eps])
                    cylinder(d = clearance_d, h = plate_thk - insert_pocket_h + 2*eps);
            }
        }

        // Auxiliary rectangular through-holes (50 x 55 mm)
        for (pt = rect_points(aux_dx, aux_dy)) {
            translate([pt[0], pt[1], -eps])
                cylinder(d = aux_hole_d, h = plate_thk + 2*eps);
        }
    }
}

// Render the model
fc_plate();
