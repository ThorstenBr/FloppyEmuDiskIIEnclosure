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

