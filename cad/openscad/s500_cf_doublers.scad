//
// S500 Top-Plate Carbon Doublers (Rectangular) — OpenSCAD
// Author: ChatGPT
// Version: v0.2 (2025-10-28) — fix: ternary module call -> if/else; use let() scoping
//

export_mode = "3D";    // "3D" or "DXF"
show_stl    = false;
show_patches= true;
print_one   = true;
stl_alpha   = 0.25;

stl_path    = "top_frame_s500.STL";
stl_rotate_z    = 45;            
stl_translate   = [-97.5, 0, 0];    
stl_scale       = 1.0;          

cf_thickness = 2.0;  
corner_r     = 3.0;  
kerf         = 0.10; 

patch_len    = 60;    
patch_wid    = 40;    
r_patch      = 50;    

arm_angles   = [45, 135, 225, 315];

hole_d        = 4;  
slot_d        = 3.2;  
slot_len      = 0;    

pattern_arm0 = [[-17,0],[13,-15],[13,15],[-17,0]];
pattern_arm1 = pattern_arm0;
pattern_arm2 = pattern_arm0;
pattern_arm3 = pattern_arm0;

module rounded_rect_2d(w, h, r) {
    offset(delta=kerf) offset(delta=-kerf)
    hull() {
        translate([ w/2 - r,  h/2 - r]) circle(r=r, $fn=48);
        translate([-w/2 + r,  h/2 - r]) circle(r=r, $fn=48);
        translate([ w/2 - r, -h/2 + r]) circle(r=r, $fn=48);
        translate([-w/2 + r, -h/2 + r]) circle(r=r, $fn=48);
    }
}

module hole_2d(d) { circle(d=d, $fn=36); }

module slot_2d(d, L) {
    hull() {
        translate([+L/2 - d/2, 0]) circle(d=d, $fn=36);
        translate([-L/2 + d/2, 0]) circle(d=d, $fn=36);
    }
}

module patch_2d(w, h, r, hole_pts) {
    difference() {
        rounded_rect_2d(w, h, r);
        for (p = hole_pts) {
            translate(p)
                if (slot_len > 0)
                    slot_2d(slot_d, slot_len);
                else
                    hole_2d(hole_d);
        }
    }
}

module patch_3d(w, h, r, hole_pts) {
    linear_extrude(height=cf_thickness)
        patch_2d(w, h, r, hole_pts);
}

function select_pattern(idx) =
    idx == 0 ? pattern_arm0 :
    idx == 1 ? pattern_arm1 :
    idx == 2 ? pattern_arm2 : pattern_arm3;

module all_patches_2d() {
    for (i = [0:len(arm_angles)-1]) {
        let(angle = arm_angles[i])
        rotate([0,0,angle])
            translate([r_patch, 0])
                patch_2d(patch_len, patch_wid, corner_r, select_pattern(i));
    }
}

module all_patches_3d() {
    if (print_one) {
        i = 0;
        let(angle = arm_angles[i])
        rotate([0,0,angle])
            translate([r_patch, 0])
                patch_3d(patch_len, patch_wid, corner_r, select_pattern(i));
    
    }
    else
    {
        for (i = [0:len(arm_angles)-1]) {
            let(angle = arm_angles[i])
            rotate([0,0,angle])
                translate([r_patch, 0])
                    patch_3d(patch_len, patch_wid, corner_r, select_pattern(i));
        }
    }
}

module ref_stl() {
    color([0.1,0.5,1.0, stl_alpha])
        translate(stl_translate)
            rotate([90,0,stl_rotate_z])
                scale(stl_scale)
                    import(stl_path, convexity=5);
}

if (export_mode == "DXF") {
    projection(cut=true) all_patches_2d();
} else {
    if (show_stl) ref_stl();
    if (show_patches) color("black") all_patches_3d();
}
