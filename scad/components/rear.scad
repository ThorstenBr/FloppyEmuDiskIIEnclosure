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

	// cable strain relief
	translate([BoxX_Width-RearWallGap-RearWallCableGapXOffset+ScrewPostDiameter, BoxY_Height-CableStrainReliefYOffset, BoxZ_Depth-RearWallZOffset-SKIN])
		rotate([180,0,0]) screwPost(ScrewPostHeight, ScrewPostDiameter, ScrewDiameter, ScrewPostHeight, ScrewPostFillet);
	translate([BoxX_Width-RearWallGap-RearWallCableGapXOffset-RearWallCableGapWidth, BoxY_Height-CableStrainReliefYOffset, BoxZ_Depth-RearWallZOffset-SKIN])
		rotate([180,0,0]) screwPost(ScrewPostHeight, ScrewPostDiameter, ScrewDiameter, ScrewPostHeight, ScrewPostFillet);
	StrainReliefHeight=2;
	CableThickness = 0;
	translate([BoxX_Width-RearWallGap-RearWallCableGapXOffset-RearWallCableGapWidth+ScrewPostDiameter/2, BoxY_Height-CableStrainReliefYOffset-StrainReliefHeight/2, BoxZ_Depth-RearWallZOffset-SKIN-ScrewPostHeight+CableThickness])
		cube([RearWallCableGapWidth, StrainReliefHeight, ScrewPostHeight-CableThickness]); // 0.5mm to allow a bit space for the cable

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

module makeCableStrainRelief()
{
	StrainReliefHeight=4+SKIN;

	difference()
	{
		union()
		{
			// cable strain relief
			translate([ScrewPostDiameter, 0, 0])
				rotate([180,0,0]) screwPost(StrainReliefHeight, ScrewPostDiameter, ScrewDiameter, StrainReliefHeight, 0);
			translate([-RearWallCableGapWidth, 0, 0])
				rotate([180,0,0]) screwPost(StrainReliefHeight, ScrewPostDiameter, ScrewDiameter, StrainReliefHeight, 0);

			translate([-RearWallCableGapWidth+ScrewPostDiameter/3, -(StrainReliefHeight-SKIN)/2, -(StrainReliefHeight-SKIN)])
				cube([RearWallCableGapWidth+1, (StrainReliefHeight-SKIN), StrainReliefHeight-SKIN]); // 0.5mm to allow a bit space for the cable
			translate([-RearWallCableGapWidth,-ScrewPostDiameter/2,-SKIN])
				cube([RearWallCableGapWidth+ScrewPostDiameter, ScrewPostDiameter, SKIN]);
		}
		translate([ScrewPostDiameter,0,-SKIN]) hole(ScrewDiameter, SKIN);
		translate([-RearWallCableGapWidth,0,-SKIN]) hole(ScrewDiameter, SKIN);
	}
}
