// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com


// front panel hole for a rectangular button
module buttonCutout()
{
	// add 1mm spacing, so the button moves freely (results in 0.5mm clearance on each side)
	buttonXWidth = ButtonXWidth+0.5;
	buttonYHeight = ButtonYHeight+0.5;

	translate([-buttonXWidth/2, -buttonYHeight/2, 0])
		roundedCube(buttonXWidth, buttonYHeight, SKIN, ButtonCorners);
}

// front panel hole for a round button
module resetButtonCutout()
{
	// add 1mm spacing, so the button moves freely (results in 0.5mm clearance on each side)
	buttonWidth = ButtonXWidth-3+0.5;

	$fn = 20;
	cylinder(r=buttonWidth/2, SKIN);
}

// test / unused
module buttonFrame()
{
	XWidth = ButtonXWidth+6;
	YHeight = ButtonYHeight+6;

	difference()
	{
		translate([-XWidth/2, -YHeight/2, 0])
			roundedCube(XWidth, YHeight, SKIN, ButtonCorners);
		buttonCutout();
	}
}

// various holes for the front panel
module panelCutouts()
{
	// LCD display
	translate([BoxX_Width-DisplayXDistance, BoxY_Height-DisplayYDistance, 0]) 
	{
		translate([-DisplayWidth, -DisplayHeight, 0])
			roundedCube(DisplayWidth, DisplayHeight, SKIN*2, DisplayCornerRadius);
	}

	// SD Slot
	translate([BoxX_Width-SDSlotXDistance, SDSlotYDistance, 0]) 
	{
		translate([-SDSlotWidth, 0, 0])
			roundedCube(SDSlotWidth, SDSlotHeight, SKIN, SDSlotCorners);
	}

	// LEDs
	translate([BoxX_Width-LedXOfs, LedYOfs, 0]) hole(LedDiameter, SKIN);
	if (LedCount>1)
		translate([BoxX_Width-LedXOfs, LedYOfs-LedYDistance, 0]) hole(LedDiameter, SKIN);

	// buttons
	for (x = [0 : 1: 0])
	{
		for (y = [0 : 1: 0])
		{
			translate([ButtonXOfs+ButtonXWidth/2+(ButtonXSpacing)*x, 
				   BoxY_Height-ButtonYHeight/2-ButtonYOfs-(ButtonYSpacing)*y, 0])
				resetButtonCutout();
		}
	}

	for (x = [1 : 1: 1])
	{
		for (y = [0 : 1: 2])
		{
			translate([ButtonXOfs+ButtonXWidth/2+(ButtonXSpacing)*x, 
				   BoxY_Height-ButtonYHeight/2-ButtonYOfs-(ButtonYSpacing)*y, 0])
				buttonCutout();
		}
	}
}

// pegs to hold the display
module displayPegs()
{
	translate([BoxX_Width-DisplayXDistance, BoxY_Height-DisplayYDistance-DisplayHeight/2+DisplayPegYDistance/2-DisplayPegYOffset, SKIN]) 
	{
		translate([-DisplayWidth/2+DisplayPegXDistance/2, 0, 0])
			screwPost(DisplayPegHeight, DisplayPegDiameter, 0, 0, 0);
		translate([-DisplayWidth/2+DisplayPegXDistance/2, -DisplayPegYDistance,0])
			screwPost(DisplayPegHeight, DisplayPegDiameter, 0, 0, 0);
		translate([-DisplayWidth/2-DisplayPegXDistance/2, 0,0])
			screwPost(DisplayPegHeight, DisplayPegDiameter, 0, 0, 0);
		translate([-DisplayWidth/2-DisplayPegXDistance/2, -DisplayPegYDistance,0])
			screwPost(DisplayPegHeight, DisplayPegDiameter, 0, 0, 0);
	}
}

// screw posts and supports of the button panel
module buttonPanelSupports()
{
	XOfs = ButtonXOfs+ButtonXWidth/2+ButtonRaster*3/2;
	YOfs = BoxY_Height-ButtonYHeight/2-ButtonYOfs;
	for (x = [-1 : 1: -1])
	for (y = [0 : 2: 2])
	{
		echo("Button Panel mount (x/y):",ButtonXSpacing*x, ButtonYSpacing*y);
		translate([XOfs+ButtonXSpacing*x, YOfs-ButtonYSpacing*y, SKIN])
			screwPost(ButtonScrewPostHeight, ScrewPostDiameter, ScrewDiameter, ButtonScrewPostHeight, 0.5);
	}
	for (x = [2 : 1: 2])
	for (y = [0 : 2: 2])
	{
		echo("Button Panel mount (x/y):",ButtonXSpacing*x-ButtonRaster*3, ButtonYSpacing*y);
		translate([XOfs+ButtonXSpacing*x-ButtonRaster*3, YOfs-ButtonYSpacing*y, SKIN])
			screwPost(ButtonScrewPostHeight, ScrewPostDiameter, ScrewDiameter, ButtonScrewPostHeight, 0.5);
	}
}

module baseFrontPanel()
{
	roundedCube(BoxX_Width-2*FrontPanelGap, BoxY_Height-FrontPanelGap, SKIN, Box_Corner_Radius);
}

module displayFrame()
{
	// LCD display
	translate([BoxX_Width-DisplayXDistance, BoxY_Height-DisplayYDistance, 0]) 
	{
		translate([-DisplayWidth-1, -DisplayHeight-1, SKIN])
			roundedCube(DisplayWidth+2, DisplayHeight+2, DisplayFrameZHeight, DisplayCornerRadius);
	}
}

// front panel
module makeFront()
{
	translate([FrontPanelGap, 0, FrontPanelZOffset])
	{
		displayPegs();
		difference()
		{
			union()
			{
				baseFrontPanel();
				displayFrame();
			}
			panelCutouts();
		}

		// screw posts for the button panel
		buttonPanelSupports();

		difference()
		{
			translate([Box_Corner_Radius, 0, SKIN]) cube([BoxX_Width-Box_Corner_Radius*2, SKIN, FrontPanelZLedge]);
			
			// hole
			translate([FrontGapX/2, -SKIN , FrontPanelZLedge/2]) rotate([270, 0, 0])
				hole(ScrewDiameter, 10);

			// hole
			translate([BoxX_Width-FrontGapX/2, -SKIN, FrontPanelZLedge/2]) rotate([270, 0, 0])
				hole(ScrewDiameter, 10);
		}
		
		// LED sockets
		translate([BoxX_Width-LedXOfs, LedYOfs, SKIN])
			screwPost(LedSocketHeight, LedDiameter+2, LedDiameter, LedSocketHeight, 0);
		if (LedCount>1)
			translate([BoxX_Width-LedXOfs, LedYOfs-LedYDistance, SKIN])
				screwPost(LedSocketHeight, LedDiameter+2, LedDiameter, LedSocketHeight, 0);

		// support triangles
		SupportWidth = FrontPanelZLedge;
		// left
		translate([Box_Corner_Radius, SKIN, SupportWidth+SKIN]) rotate([270, 0, 0]) prism(SKIN, SupportWidth, SupportWidth);
		// right
		translate([BoxX_Width-Box_Corner_Radius-SKIN, SKIN, SupportWidth+SKIN]) rotate([270, 0, 0]) prism(SKIN, SupportWidth, SupportWidth);
		
		// screw posts
		translate([FrontGapX/2, SKIN , FrontPanelZLedge/2])
		{
			rotate([270, 0, 0]) screwPost(ScrewPostHeight, ScrewPostDiameter, ScrewDiameter, ScrewPostHeight, 0);
			translate([-ScrewPostDiameter/2, 0, -FrontPanelZLedge/2+SKIN]) cube([ScrewPostHeight, ScrewPostDiameter, FrontPanelZLedge/3-SKIN]);
		}

		translate([BoxX_Width-FrontGapX/2, SKIN, FrontPanelZLedge/2])
		{
			rotate([270, 0, 0]) screwPost(ScrewPostHeight, ScrewPostDiameter, ScrewDiameter, ScrewPostHeight, 0);
			translate([-ScrewPostDiameter/2, 0, -FrontPanelZLedge/2+SKIN]) cube([ScrewPostHeight, ScrewPostDiameter, FrontPanelZLedge/3-SKIN]);
		}
	}

	// front screw posts for FloppyEmu PCB
	PcbFrontMountHeight = PcbYOfs-SKIN;
	translate([BoxX_Width/2-PcbXWidth/2+PcbScrewDistance+PcbXOfs, SKIN , PcbZOfs+PcbScrewDistance])
	{
		rotate([270, 0, 0]) screwPost(PcbFrontMountHeight, PcbScrewPostDiameter, PcbScrewDiameter, PcbFrontMountHeight, 0);
		translate([-PcbScrewPostDiameter/2,0,-PcbScrewPostDiameter/2]) cube([PcbScrewPostDiameter, PcbFrontMountHeight, PcbScrewPostDiameter/4]);
	}

	translate([BoxX_Width/2+PcbXWidth/2-PcbScrewDistance+PcbXOfs, SKIN, PcbZOfs+PcbScrewDistance])
	{
		rotate([270, 0, 0]) screwPost(PcbFrontMountHeight, PcbScrewPostDiameter, PcbScrewDiameter, PcbFrontMountHeight, 0);
		translate([-PcbScrewPostDiameter/2,0,-PcbScrewPostDiameter/2]) cube([PcbScrewPostDiameter, PcbFrontMountHeight, PcbScrewPostDiameter/4]);
	}
}

