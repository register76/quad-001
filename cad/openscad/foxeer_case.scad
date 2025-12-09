//////////////////////////////
// Foxeer Razer Mini simple sleeve
// B Dog + ChatGPT v0.1
//////////////////////////////

// --- User parameters ---
inner_w      = 22.2;  // internal width  (camera is 22mm)
inner_h      = 22.2;  // internal height (camera is 22mm)
inner_d      = 29;    // internal depth  (body length)
wall        = 1.6;  // wall thickness
front_lip    = 2.0;  // small lip around front face
lens_open_r  = 8.5;  // radius opening for lens
clear_above  = 4.0;  // open “window” above lens (for FOV clearance)
connector_cut = [12, 6, 4]; // [width, height, depth] cutout at rear
fillet_r    = 2.0;  // corner rounding
slop        = 0.2;  // extra clearance fudge

// --- Derived ---
outer_w = inner_w + 2*wall;
outer_h = inner_h + 2*wall;
outer_d = inner_d + wall;  // closed just at back, open at front

// Path to your GoPro two-tooth mount STL
gopro_stl = "2_prong.stl";   // <-- rename to match your file

$fn = 64;

module gopro_two_tooth_mount() {
    import(gopro_stl, convexity = 10);
}

module cam_sleeve() {
    difference() {
        // Outer rounded box
        minkowski() {
            cube([outer_w - 2*fillet_r, outer_h - 2*fillet_r, outer_d - 2*fillet_r], center=true);
            sphere(fillet_r);
        }

        // Internal cavity for camera body
        translate([0,0,(-wall /*- outer_d/2*/)])  // push cavity towards front so back is closed
            cube([inner_w + slop, inner_h + slop, inner_d + slop], center=true);

        // Front lens opening (circular)
        translate([0,0, outer_d/2-1 + 0.1])
            cylinder(r=lens_open_r, h=wall+3, center=true);

        // Optional “FOV notch” above lens: rectangular bite at top front
/*
        translate([0,
                  (outer_h/2 - clear_above/2),
                  outer_d/2 - wall])
            cube([outer_w + 0.5, clear_above, wall+1], center=true);
*/
        // Rear connector cutout (simple rectangular slot)
        conn_w = connector_cut[0];
        conn_h = connector_cut[1];
        conn_d = connector_cut[2];

        translate([0, 0, -outer_d/2 - 0.1 + conn_d/2])
            cube([conn_w, conn_h, conn_d+0.5], center=true);
    }
}

// --- Mount tabs / holes (simple generic side tabs) ---
tab_thick = 3;
tab_len  = 10;
hole_r    = 1.1;  // for M2

module side_tab(mirror_y=false) {
    mirror([0, mirror_y ? 1 : 0, 0]) {
        translate([0, outer_h/2 + tab_thick/2 - wall, 0])
            difference() {
                cube([tab_len, tab_thick, 8], center=true);
                // M2 hole
                translate([0,0,0])
                    rotate([90,0,0])
                        cylinder(r=hole_r, h=tab_thick+1, center=true);
            }
    }
}

// --- Assembly ---
module camera_case() {
    cam_sleeve();
    side_tab(false);
    side_tab(true);
}

// --- Combined assembly: camera + GoPro mount ---
module camera_with_gopro() {
    // 1) Camera case at origin
    camera_case();

    // 2) GoPro mount under the camera body
    //
    // Assumptions:
    // - The GoPro stl base is at z=0
    // - We want that base roughly at the bottom of the camera case
    //
    // Step 1: move the GoPro mount so its base is just below the camera
    // Step 2: scoot it forward/back so the tooth center lines up nicely

    // Rough placement: adjust these numbers while previewing
    gopro_offset_x = 8.5;                       // forward/back relative to camera
    gopro_offset_y = -5;                       // left/right
    gopro_offset_z = 12;                      // drop it below the camera (tweak the "+ 2")

    rotate([0,90,0])
        translate([gopro_offset_x, gopro_offset_y, gopro_offset_z])
            // If the STL is rotated differently, you might need rotate([90,0,0]) etc.
            gopro_two_tooth_mount();
}

camera_with_gopro();



