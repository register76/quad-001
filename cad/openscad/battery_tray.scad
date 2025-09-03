//
// Parametric battery tray with SIDE-WALL strap slots
// B Dog — Pi/quad build
//
// Coordinate frame:
//   X = width  (left↔right)
//   Y = length (front↔back)
//   Z = up (floor → lips)
//

//-------------------
// USER PARAMETERS 
//-------------------
battery           = [47, 160, 32];   // [W, L, H]  (width, length, height) in mm
clearance         = 0.30;            // per-side clearance inside pocket (ABS ≈ 0.3–0.4)
wallThickness     = 3.00;            // wall thickness
floorThickness    = 3.20;            // floor thickness

// Side-wall strap slots (two bands)
strapWidth       = 20.0;                // strap width (typical 20 mm)
slotLengthY      = strapWidth + 2.0;    // along Y (give ~1 mm per side)
slotThicknessZ   = 3.0;                 // vertical opening (Z) for the strap thickness
slot1OffsetFront = 10.0;                // first slot center from inner FRONT (Y)
slotSpacingY     = 120.0;               // distance between the two slots along Y

// Cable exit notch (front lip)
cableNotchWidth = 12.0;
cableNotchDepth = 6.0;

//-----------------------
// DERIVED GEOMETRY
//-----------------------
innerWidth  = battery[0] + 2*clearance;  // inner width
innerLength = battery[1] + 2*clearance;  // inner length 
innerHeight = battery[2] + 2*clearance;  // inner height

outerBlock = [ innerWidth  + 2*wallThickness,
               innerLength + 2*wallThickness, 
               innerHeight + floorThickness ];
              
//----------------
// MAIN SHAPES
//----------------
module tray_shell() 
{
  difference() 
  {
    // Outer block
    cube(outerBlock, center=false);

    // Inner pocket (removes volume, leaves floor + walls)
    translate([wallThickness, wallThickness, floorThickness])
    {
      cube([innerWidth, innerLength, innerHeight], center=false);
    }

    // FRONT cable notch (cut through front lip)
    translate([0.5*(outerBlock[0] - cableNotchWidth), 0.0, floorThickness])
    {
      cube([cableNotchWidth, cableNotchDepth, innerHeight], center=false);
    }
    
    // first slot from front
    translate([0.0, wallThickness + slot1OffsetFront, floorThickness])
    {
      cube([wallThickness, slotLengthY, slotThicknessZ], center=false);
      translate([wallThickness + innerWidth, 0.0, 0.0])
      {
        cube([wallThickness, slotLengthY, slotThicknessZ], center=false);
      }
      translate([0.0, slotSpacingY, 0.0])
      {
        cube([wallThickness, slotLengthY, slotThicknessZ], center=false);
        translate([wallThickness + innerWidth, 0.0, 0.0])
        {
          cube([wallThickness, slotLengthY, slotThicknessZ], center=false);
        }
      }
    }
  }
}

//---------------------
// ASSEMBLY
//---------------------
tray_shell();