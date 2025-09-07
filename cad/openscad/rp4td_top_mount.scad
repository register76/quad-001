//
// RP4TD Zip-Tie Plate (minimal)
// Flat plate with angled slot pairs for two antennas
// Loop-free, explicit placement
// B Dog — quad-001
//

//--------------------
// USER PARAMETERS
//--------------------
plate_size            = [140, 140];  // [X,Y] mm overall platform
plate_thickness       = 3.0;        // mm

// Frame mounting holes (enable/disable)
enable_frame_rect     = true;
frame_rect_spacing    = [35, 35];   // [X,Y] mm center-to-center spacing
hole_diameter         = 3.3;        // mm (M3 clearance)

// Receiver tie-downs (centered front/back)
add_rx_tie_slots      = true;
rx_slot_w             = 4.0;        // mm
rx_slot_l             = 22.0;       // mm
rx_slot_spacing_y     = 26.0;       // mm between the two slots (front/back)

// Antenna slot geometry (per antenna: 2 slots in parallel)
ant_slot_w            = 4.0;        // mm (zip tie width + clearance)
ant_slot_l            = 20.0;       // mm
ant_slot_gap          = 7.0;        // mm between the two parallel slots

// Antenna slot positions/angles
// X offsets from center so the two antennas are left/right
ant_offset_x          = 0.0;  //12.0;       // mm from center to each antenna slot pair
// Y offset forward/aft of FC center (+Y forward, -Y aft)
ant_offset_y          = 55.0;       // mm along the long axis

// Angles are standard OpenSCAD Z-rotations (0° = along +X, 90° = along +Y)
// Pick any pair that gives you good diversity (e.g., 45° & 90°)
left_slot_angle_deg   = 90;         // left antenna (CCW from +X)
right_slot_angle_deg  = 0;          // right antenna (0° points outboard to +X)

// Visual smoothness for rounded ends (if you add fillets later)
$fn = 48;

infinity = 500;
cornerDistance = 70;

makeItAnLShapeDistance = 25;

//--------------------
// MAIN
//--------------------
module zip_plate() {
  difference() {
    // Plate
    translate([0,0,0])
      cube([plate_size[0], plate_size[1], plate_thickness/2], center=true);

    // Frame holes
    if (enable_frame_rect)
      mount_holes_rect_explicit(frame_rect_spacing, hole_diameter);

    // Receiver tie slots (front/back, centered in X)
    if (add_rx_tie_slots)
      rx_tie_slots_explicit();

    // Antenna slots (LEFT & RIGHT), each is a pair of parallel slots

    // LEFT (negative X)
    antenna_slot_pair(
      pos = [ ant_offset_x, ant_offset_y, 0.0],
      slot_l = ant_slot_l,
      slot_w = ant_slot_w,
      gap    = ant_slot_gap,
      angle_deg = left_slot_angle_deg
    );

    // RIGHT (positive X)
    antenna_slot_pair(
      pos = [  ant_offset_x, ant_offset_y, 0.0 ],
      slot_l = ant_slot_l,
      slot_w = ant_slot_w,
      gap    = ant_slot_gap,
      angle_deg = right_slot_angle_deg
    );

    // cut corners of cube to make an octagon    
    //cut_corners(cornerDistance);
    
    // honeycomb with circular pattern
    //honeycomb_holes(plate_size, 6, 10, plate_thickness);

    makeItAnLShape(makeItAnLShapeDistance);
  }
}

zip_plate();

//--------------------
// CUT FEATURES
//--------------------
module mount_holes_rect_explicit(spacing, d) {
  translate([ +spacing[0]/2, +spacing[1]/2, -plate_thickness / 2]) hole(d);
  translate([ -spacing[0]/2, +spacing[1]/2, -plate_thickness / 2]) hole(d);
  translate([ +spacing[0]/2, -spacing[1]/2, -plate_thickness / 2]) hole(d);
  translate([ -spacing[0]/2, -spacing[1]/2, -plate_thickness / 2]) hole(d);
}

module hole(d) {
  cylinder(h = plate_thickness, r = d/2, center=false);
}

module rx_tie_slots_explicit() {
  // Back slot
  translate([0, -rx_slot_spacing_y/2, 0.0])
    cube([rx_slot_l, rx_slot_w, plate_thickness + 0.6], center=true);
  // Front slot
  translate([0,  rx_slot_spacing_y/2, 0.0])
    cube([rx_slot_l, rx_slot_w, plate_thickness + 0.6], center=true);
}

// A pair of parallel slots used to zip-tie an antenna in place at an angle
// pos = center of the slot pair on the plate surface
// angle_deg = rotation about Z (0°=+X, 90°=+Y)
module antenna_slot_pair(pos=[0,0,0], slot_l=20, slot_w=4, gap=7, angle_deg=45) {
  
  // We cut two long rectangles separated by 'gap', both rotated by angle_deg.
  // The pair center sits at 'pos'. Slots are aligned along 'slot_l'.
  // Direction vector perpendicular to slot length for spacing the two slots:
  // We rotate a unit vector by angle+90 to offset each slot half-gap.
  rotate([0,0,angle_deg]) {
    // After rotation, slots are along +X; gap is applied along +Y
    translate([pos[0], pos[1], pos[2]]) {
      // Upper slot
      translate([0, +gap/2, 0])
        cube([slot_l, slot_w, plate_thickness + 0.6], center=true);

      // Lower slot
      translate([0, -gap/2, 0])
        cube([slot_l, slot_w, plate_thickness + 0.6], center=true);
    }
  }
}

module cut_corners(distance) {
   rotate([0, 0, 45]){
       translate([distance, -infinity/2, -plate_thickness/2]) {
           cube([infinity, infinity, infinity], false);
       }
   }
   rotate([0, 0, 135]){
       translate([distance, -infinity/2, -plate_thickness/2]) {
           cube([infinity, infinity, infinity], false);
       }
   }
   rotate([0, 0, 225]){
       translate([distance, -infinity/2, -plate_thickness/2]) {
           cube([infinity, infinity, infinity], false);
       }
   }
   rotate([0, 0, 315]){
       translate([distance, -infinity/2, -plate_thickness/2]) {
           cube([infinity, infinity, infinity], false);
       }
   }   
}

// Generate honeycomb holes
module honeycomb_holes(size=[100,60], d=6, spacing=10, h=3) {
  cols = ceil(size[0]/spacing) + 2;
  rows = ceil(size[1]/(spacing*0.866)) + 2; // 0.866 = sqrt(3)/2
  for (r = [0:rows-1]) {
    y = (r - rows/2) * spacing * 0.866;
    x_shift = (r % 2 == 0) ? 0 : spacing/2;
    for (c = [0:cols-1]) {
      x = (c - cols/2) * spacing + x_shift;
      translate([x, y, -h/2])
        cylinder(h=h, d=d, center=false);
    }
  }
}

module makeItAnLShape(d) {
    // make it an l shape
    translate([d, -infinity/2, -plate_thickness/2]){
      cube([infinity, infinity, plate_thickness], false);
    }

    translate([-infinity /2, -infinity-d, -plate_thickness/2]){
      cube([infinity, infinity, plate_thickness], false);
    }
    
    translate([-d-infinity, d, -plate_thickness/2]) {
      cube([infinity, infinity, plate_thickness], false);
    }
}
