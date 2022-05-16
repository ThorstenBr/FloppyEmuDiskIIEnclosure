// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com

// Radius of the corners
Box_Corner_Radius = 3.0*ScalingFactor; // [0: 10]

// Box skin width
SKIN = 1.0; // [1: 0.1: 5]

/* [Hidden] */

// Width (X) of the box
BoxX_Width = 155*ScalingFactor; // [60: 145]

// Height (Y) of the box
BoxY_Height = 90*ScalingFactor; // [10: 100]

// Depth (Z) of the box
BoxZ_Depth = 210*ScalingFactor; // [10: 200]

// Width of the ventilation cut
VentilationWidth   =  4*ScalingFactor;
VentilationYHeight = 30*ScalingFactor;
VentilationXLength = 15*ScalingFactor;

// Distance of the first ventilation cut from the rear
VentilationZOffset = 17*ScalingFactor;

// Distance between the ventilation cuts
VentilationZDistance = 9.2*ScalingFactor;

// Number of ventilation cuts
VentilationCount = 9;

// Top grooves
TopGrooveXWidth = 110*ScalingFactor;
TopGrooveZLength = 80*ScalingFactor;
TopGrooveYDepth = 2;//*ScalingFactor;
TopGrooveCornerRadius = 6*ScalingFactor;

// Rear wall
RearWallGap = 1.5;
RearWallCableGapHeight = 3;
RearWallCableGapWidth = 27+3; //26mm cable width
RearWallCableGapXOffset = 10+2*ScalingFactor;
RearWallZLedge = 17;
RearWallZOffset = 2.5;

// Strain Relief
CableStrainReliefYOffset = BoxY_Height-20; // distance from the top of the box

// Front panel
FrontPanelGap = 0.5;
FrontPanelZLedge = 10;
FrontPanelZOffset = 2;

// Distance of the gap at the front (from the left/right edge)
FrontGapX = 21;
FrontGapWidth = 0.8;
FrontGapY = FrontPanelZOffset+5;

// Screws
ScrewDiameter = 3;
ScrewPostDiameter = ScrewDiameter+2;
ScrewPostHeight = 5;
ScrewPostFillet = 2;

// Display
DisplayWidth = 30+1+1;  // active area: 29.42
DisplayHeight = 15+1+2; // active area: 14.7
DisplayXDistance = 15*ScalingFactor; // distance from the left of the panel
DisplayYDistance = 3.5+9*ScalingFactor; // distance from the top of the panel
DisplayCornerRadius = 2;
DisplayPegXDistance = 31-0.2;
DisplayPegYDistance = 28.5;
DisplayPegYOffset = 2.25;//-4.5; // 7.35-2=5.35 from the top, 3.25 The display mounting ports are not centered, but have an offset (shifted towards the bottom).

// frame around the display opening
DisplayFrameZHeight = 0.5;

// Pegs to hold the display
DisplayPegHeight   = 4+1;
DisplayPegDiameter = 3; // 3.5

// SDSlot
SDSlotWidth = 12.5; // 12
SDSlotHeight = 3;
SDSlotCorners = 1;
SDSlotXDistance = BoxX_Width/2-SDSlotWidth/2; // distance from the left of the panel
SDSlotYDistance = 10; // distance from the bottom of the panel to the bottom of the SD slot

// Square Buttons
ButtonYHeight = (ScalingFactor<1) ? 8.5 : 10;
ButtonXWidth  = (ScalingFactor<1) ? 8.5 : 10;
ButonZDepth   = SKIN*2+1.5;
ButtonCorners = 1;
ButtonLedgeWidth = 2-0.5;
ButtonPegDiameter = 3.5+0.2-0.1;
ButtonPegDepth = 2.5;

ButtonXOfs = 15*ScalingFactor; // distance from the right edge
ButtonYOfs = 9*ScalingFactor;//9*ScalingFactor; // distance from the top
ButtonRaster = 2.54; // 0.01"
ButtonXSpacing = ButtonRaster*5; // multiple of 2.54mm => allow micro switches to be soldered on prototype raster PCBs
ButtonYSpacing = ButtonRaster*5; // multiple of 2.54mm => allow micro switches to be soldered on prototype raster PCBs

ButtonScrewPostHeight = 9-0.5;

// LEDs
LedDiameter = (ScalingFactor<1) ? 3.4-0.1 : 5; // 3.4
LedSocketHeight = 1.5;
LedYDistance = (ScalingFactor<1) ? LedDiameter+3 : LedDiameter+3.5; // distance between the two LEDs
LedXOfs = (ScalingFactor<1) ? 22 : 20+LedDiameter/2; // distance from the left edge
LedYOfs = (ScalingFactor<1) ? 16 : 20;

// FloppyEmu PCB
PcbXWidth  = 45-1;
PcbYHeight = 2;
PcbZDepth  = 100.0;
PcbXOfs = -0.75+0.5; // from the center. SD Slot on FloppyEmu is not quite centered
PcbYOfs = SDSlotYDistance-PcbYHeight+1;
PcbZOfs = FrontPanelZOffset+SKIN+0.5;
PcbScrewDiameter = 3;
PcbScrewPostDiameter = PcbScrewDiameter+3;
PcbScrewDistance = 2.5; // distance from the PCB edges

include <baseLib.scad>;
include <top_and_bottom.scad>;
include <pcb.scad>;
include <buttons.scad>;
include <rear.scad>;
include <front.scad>;

module main()
{
	if (part == "test")
	{
		intersection()
		{
			makeTop();
			translate([-10,BoxY_Height-22,BoxZ_Depth-32]) cube([40, 40, 32]);
		}
	}
	else
	if (part == "button")
	{
		for (x = [0,1])
		for (y = [0,1])
			translate([x*ButtonXSpacing, y*ButtonYSpacing, -ButonZDepth]) button();
		translate([-15, 20, 0]) rotate([0,0,90]) makeCableStrainRelief();
		translate([30, -15, 0]) makeRearPcbFeet();
	}
	else
	if (part == "rear")
	{
		makeRear();
	}
	else
	if (part == "front")
	{
		makeFront();
	}
	else
	if (part == "top") {
		makeTop();
	}
	else
	if (part == "topBottom") {
		makeTop();
		translate([0, -ComponentSeparation, 0 ]) makeBottom();
	}
	else
	if (part == "bottom") {
		makeBottom();
	}
	else
	if (part == "all") {
		                                         makeTop();
		translate([0, -ComponentSeparation, 0 ]) makeBottom();
		translate([0, 0, ComponentSeparation  ]) makeRear();
		translate([0, 0, -ComponentSeparation ]) makeFront();
	}
	else
	if ((part == "noFront")||(part == "noRear")||(part=="noBottom")||(part=="frontBottom"))
	{
		if (part != "frontBottom") makeTop();
		if (part != "noBottom")    makeBottom();
		if ((part != "noRear")&&(part != "frontBottom")) makeRear();
		if (part != "noFront") makeFront();
	}
	else
	if (part == "prototype") {
		boxScrewPosts();
	} else {
		// nothing!
	}
	if ((showPcb == "yes")&&(part != "button")) makePcb();
}

main();
