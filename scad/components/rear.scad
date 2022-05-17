// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com

// rear panel
module makeRear()
{
	Width = BoxX_Width-2*RearWallGap;
	difference()
	{
		translate([RearWallGap, 0, BoxZ_Depth-RearWallZOffset-RearWallZLedge])
		rotate([90, 0, 90])
		{
			difference()
			{
				roundedCube(BoxY_Height, RearWallZLedge, Width, Box_Corner_Radius);
				translate([SKIN, -SKIN, 0]) roundedCube(BoxY_Height, RearWallZLedge, Width, Box_Corner_Radius);
				translate([BoxY_Height-RearWallGap-RearWallCableGapHeight,RearWallZLedge-SKIN*2,0])
					cube([RearWallCableGapHeight+10, SKIN*2, Width]);
			}
		}

		// hole
		translate([FrontGapX/2, -SKIN , BoxZ_Depth-RearWallZOffset-RearWallZLedge/2]) rotate([270, 0, 0])
			hole(ScrewDiameter, 10);

		// hole
		translate([BoxX_Width-FrontGapX/2, -SKIN , BoxZ_Depth-RearWallZOffset-RearWallZLedge/2]) rotate([270, 0, 0])
			hole(ScrewDiameter, 10);
	}

	// long edge, top of rear wall
	translate([RearWallGap, BoxY_Height-RearWallGap-RearWallCableGapHeight-5, BoxZ_Depth-RearWallZOffset-SKIN])
		roundedCube(BoxX_Width-RearWallCableGapWidth-RearWallCableGapXOffset, RearWallCableGapHeight+5, SKIN, Box_Corner_Radius);

	// short edge, top of rear wall
	translate([BoxX_Width-RearWallGap-RearWallCableGapXOffset, BoxY_Height-RearWallGap-RearWallCableGapHeight-5, BoxZ_Depth-RearWallZOffset-SKIN])
		roundedCube(RearWallCableGapXOffset, RearWallCableGapHeight+5, SKIN, Box_Corner_Radius);

	// screw posts
	translate([FrontGapX/2, SKIN , BoxZ_Depth-RearWallZOffset-RearWallZLedge/2]) rotate([270, 0, 0])
		screwPost(ScrewPostHeight, ScrewPostDiameter, ScrewDiameter, ScrewPostHeight, ScrewPostFillet);

	translate([BoxX_Width-FrontGapX/2, SKIN , BoxZ_Depth-RearWallZOffset-RearWallZLedge/2]) rotate([270, 0, 0])
		screwPost(ScrewPostHeight, ScrewPostDiameter, ScrewDiameter, ScrewPostHeight, ScrewPostFillet);

	// support triangles for stability
	SupportWidth = RearWallZLedge-SKIN*2;
	// left
	translate([RearWallGap+Box_Corner_Radius, SKIN, BoxZ_Depth-RearWallZOffset-SupportWidth-SKIN])
		rotate([270, 180, 0]) prism(SKIN, SupportWidth, SupportWidth);
	// right
	translate([BoxX_Width-Box_Corner_Radius-SKIN, SKIN, BoxZ_Depth-RearWallZOffset-SupportWidth-SKIN])
		rotate([270, 180, 0]) prism(SKIN, SupportWidth, SupportWidth);
	// center
	translate([(BoxX_Width-Box_Corner_Radius-SKIN)/2, SKIN, BoxZ_Depth-RearWallZOffset-SupportWidth-SKIN])
		rotate([270, 180, 0]) prism(SKIN, SupportWidth, SupportWidth);
}

