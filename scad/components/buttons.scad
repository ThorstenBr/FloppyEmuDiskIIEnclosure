// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com

// single button
module button()
{
	// front part of the button
	translate([-ButtonXWidth/2, -ButtonYHeight/2, 0])
		roundedCube(ButtonXWidth, ButtonYHeight, ButonZDepth, ButtonCorners);

	// slightly larger frame around the buttons rear, to keep the button from falling through the panel
	translate([-(ButtonXWidth+ButtonLedgeWidth)/2, -(ButtonYHeight+ButtonLedgeWidth)/2, 0])
		roundedCube(ButtonXWidth+ButtonLedgeWidth, ButtonYHeight+ButtonLedgeWidth, SKIN, ButtonCorners);

	// connector for the button's peg
	rotate([0,180,0]) screwPost(ButtonPegDepth, ButtonPegDiameter+2, ButtonPegDiameter, ButtonPegDepth, 1);
}

// single round/reset button
module resetButton()
{
	$fn = 30;

	// front part of the button
	translate([0, 0, 0])
		cylinder(r=(ButtonXWidth-3)/2, ButonZDepth);

	// slightly larger frame around the buttons rear, to keep the button from falling through the panel
	cylinder(r=(ButtonXWidth-3+ButtonLedgeWidth)/2, SKIN);

	// connector for the button's peg
	rotate([0,180,0]) screwPost(ButtonPegDepth, ButtonPegDiameter+2, ButtonPegDiameter, ButtonPegDepth, 1);
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
