// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com

module torus(r1, r2)
{
    rotate_extrude(convexity = 10)
		translate([r2 + r1, 0, 0])
			circle(r=r2);
}

module round_cylinder(fillet, r, h)
{
	for(z=[fillet, h-fillet])
		torus(r-2*fillet, fillet, center=[0,0,z]);
	cylinder(r=r-fillet, h);
	translate([0,0,fillet]) cylinder(r=r, h=h-2*fillet);
}

// Make a rectangle with rounded corners of given radius.
// The maximum outer dimensions exactly match the given width/height.
module roundedCube(Width, Height, Depth, CornerRadius)
{
	$fn=36;
	union()
	{
		for (x=[0,Width-CornerRadius*2])
		for (y=[0,Height-CornerRadius*2])
			translate([x+CornerRadius, y+CornerRadius, 0]) cylinder(r=CornerRadius, h=Depth);
		translate([CornerRadius,0,0]) cube([Width - 2*CornerRadius, Height, Depth]);
		translate([0,CornerRadius,0]) cube([Width, Height - 2*CornerRadius, Depth]);
	}
}

module cylinderLedge(r, length)
{
	$fn=36;
	translate([0, 0, -length/2])
	intersection()
	{
		cylinder(r=r, length);
		cube([r, r, length]);
	}
}

module rcube(size=[30, 20, 10], radius=[3, 2, 1], center=true)
{
	hull() {
        translate( center ? [0,0,0] : size/2 ) {
            cube(size-2*radius+[2*radius[0],0,0],center=true);
            cube(size-2*radius+[0,2*radius[1],0],center=true);
            cube(size-2*radius+[0,0,2*radius[2]],center=true);
 
            for(x = [-0.5,0.5], y = [-0.5,0.5], z = [-0.5,0.5])
                translate([x * ( size[0] - 2*radius[0]),
                           y * ( size[1] - 2*radius[1]),
                           z * ( size[2] - 2*radius[2])])
                    scale([radius[0], radius[1], radius[2]])
                        if (quality == "high") sphere(1.0,$fn=4*4*2); else sphere(1.0,$fn=4);
        }
    }
}

module hole(diameter, depth)
{
	$fn = 36;
	cylinder(r=diameter/2, h=depth);
}

module wall(width, height, WallThickness)
{
        translate([-width/2,-WallThickness/2,-height]) cube([width, WallThickness, height]);
}

module prism(l, w, h)
{
	polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
}
	   
module post(height, diameter, post_fillet_r, screw_hole_diameter, screw_hole_depth)
{
	$fn = 36;
    difference() {
      union() {
        cylinder(r=diameter/2, h=height);
        difference() {
                cylinder(r=diameter/2 + post_fillet_r, h=post_fillet_r);
                translate([0,0,post_fillet_r]) torus(diameter/2, post_fillet_r*1.1);
        }
      }
      if (screw_hole_diameter>0)
      {
          translate([0,0,height-screw_hole_depth])
          hole(screw_hole_diameter, screw_hole_depth);
      }
    }
}

module screwPost(ZDepth, PostDiameter, ScrewDiameter, ScrewHoleDepth, FilletR)
{
    if (PostDiameter>0.0)
	post(ZDepth, PostDiameter, FilletR, ScrewDiameter, ScrewHoleDepth);
}


module outerBox(SkinWidth, XWidth, YHeight, ZDepth, CornerRadius)
{
	translate([-SkinWidth, -SkinWidth, 0]) roundedCube(XWidth+SkinWidth*2, YHeight+SkinWidth*2, ZDepth, CornerRadius);
}

module box(SkinWidth, XWidth, YHeight, ZDepth, CornerRadius)
{
	// main shell
	difference() {
		outerBox(SkinWidth, XWidth, YHeight, ZDepth, CornerRadius);
			//rcube(size=[XWidth+SkinWidth*2, YHeight+SkinWidth*2, ZDepth+SkinWidth*2], radius=[2, 2, 2], center=false);
		if (SkinWidth>0)
			roundedCube(XWidth, YHeight, ZDepth, CornerRadius);
			//rcube(size=[XWidth, YHeight, ZDepth], radius=[2, 2, 2], center=false);
	}
}

