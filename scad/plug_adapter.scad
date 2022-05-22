// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com

// Enclosure for the Floppy Emu DB-19 Plug Adapter

// Which part do you want to see/generate?
PART = "topBottom"; // [topBottom: Both elements, bottom:Bottom element, top:Top element, test:--Test--, full:Full, mask:Show top mask, pcb:Show PCB, carving:Carved space]

/* [Hidden] */

// Adapter PCB
PcbWidthX = 46;
PcbHeightY = 2;
PcbDepthZ = 18;

// Box Header
BoxHeaderWidthX = 33.5;
BoxHeaderHeightY = 14;
BoxHeaderDepthZ = 11.5;

BoxHeaderPositonZ = PcbDepthZ-BoxHeaderDepthZ; // position from the front of the PCB

BoxHeaderPinHeightY = 2; // height of the pins on the PCB bottom side

// Cable
CableWidthX = 26;
CableHeightY = 1.0; // 1.5

CablePositionY = -CableHeightY/2;

// SUB-D Connector
SubDWidthX = 33;
SubDHeightY = 11.5;
SubDDepthZ = 13;

SubDPlateWidthX = 45;
SubDPlateHeightY = 13;
SubDPlateDepthZ = 1;

SubDPlatePositonZ = 5; // position from the front of the PCB

// rear
RearDepthZ = 6;

SKIN = 1.5;

SnapNotchX = 0.5;
SnapNotchY = 0.6;

// quality setting
QUALITY = "high";

include <components/baseLib.scad>

module imprint(x,y,z, txt, Font = "Liberation Sans:style=Bold")
{
	FontSize = 3;
	translate([x,y,z])
	rotate([270,0,0])
	{
		linear_extrude(height = 0.4) { text(txt, font = Font, size = FontSize, halign="center", valign="center"); }
	}
}

module makeFilamentSaver()
{
	translate([-BoxHeaderWidthX/2,0,0]) cube([BoxHeaderWidthX, PcbHeightY+BoxHeaderHeightY, BoxHeaderPositonZ]);
	translate([-PcbWidthX/2, PcbHeightY, SKIN*2]) cube([PcbWidthX-2*SKIN, BoxHeaderHeightY, PcbDepthZ-SKIN*2]);

	// cable
	translate([-(CableWidthX-2*SKIN)/2, -SubDHeightY/2, 0])
		cube([CableWidthX-2*SKIN, PcbHeightY+BoxHeaderHeightY+SubDHeightY/2, BoxHeaderPositonZ+BoxHeaderDepthZ+RearDepthZ+SKIN]);

	// Box header pins (below PCB)
	translate([-(PcbWidthX-2*SKIN)/2, -SubDHeightY/2, SKIN]) cube([PcbWidthX-2*SKIN, SubDHeightY/2, BoxHeaderDepthZ+BoxHeaderPositonZ-SKIN]);
}

module makePcb()
{
	// PCB
	translate([-PcbWidthX/2,0,0]) cube([PcbWidthX, PcbHeightY, PcbDepthZ]);

	// Box Header
	translate([-BoxHeaderWidthX/2, PcbHeightY, BoxHeaderPositonZ]) cube([BoxHeaderWidthX, BoxHeaderHeightY, BoxHeaderDepthZ]);

	// Box header pins (below PCB)
	translate([-BoxHeaderWidthX/2, -BoxHeaderPinHeightY, BoxHeaderPositonZ]) cube([BoxHeaderWidthX, BoxHeaderPinHeightY, BoxHeaderDepthZ]);

	// SUB-D connecor
	translate([-SubDWidthX/2, -SubDHeightY/2, -SubDDepthZ]) cube([SubDWidthX, SubDHeightY, SubDDepthZ+SKIN]);
	// SUB-D connector plate
	translate([-SubDPlateWidthX/2, -SubDPlateHeightY/2, -SubDPlatePositonZ-SubDPlateDepthZ]) cube([SubDPlateWidthX, SubDPlateHeightY, SubDPlateDepthZ]);

	// cable
	translate([-CableWidthX/2, CablePositionY, BoxHeaderPositonZ+BoxHeaderDepthZ]) cube([CableWidthX, CableHeightY, 20]);
}

module makeBlock()
{
	translate([-SKIN-PcbWidthX/2, -SKIN-SubDHeightY/2, -SubDPlatePositonZ])
		rcube(size=[2*SKIN + PcbWidthX, 2*SKIN + SubDHeightY/2+PcbHeightY+BoxHeaderHeightY, SKIN*2 + PcbDepthZ+SubDPlatePositonZ],
	              radius=[2,2,2], center=false);

	translate([-SKIN-CableWidthX/2, -SKIN-SubDHeightY/2, PcbDepthZ-1])
		rcube(size=[2*SKIN + CableWidthX, 2*SKIN + SubDHeightY/2+PcbHeightY+BoxHeaderHeightY, SKIN*2 +RearDepthZ+1],
	              radius=[2,2,2], center=false);
}

module makeThing()
{
	difference()
	{
		makeBlock();
		union()
		{
			makePcb();
			makeFilamentSaver();
		}
	}
	imprint(0, -SubDHeightY/2, PcbDepthZ/2, "Floppy Emu DB-19");
	imprint(0, -SubDHeightY/2, PcbDepthZ+RearDepthZ/2+SKIN, "TB 5/22");
}

module makeTopMask()
{
	// cable
	translate([-CableWidthX/2, CablePositionY+CableHeightY, BoxHeaderPositonZ+BoxHeaderDepthZ])
		cube([CableWidthX, SKIN+BoxHeaderHeightY-CablePositionY+PcbHeightY-CableHeightY, 20]);

	// PCB area
	translate([-PcbWidthX/2, PcbHeightY, 0])
		cube([PcbWidthX, SKIN+BoxHeaderHeightY, PcbDepthZ]);

	// subd
	translate([-(SubDWidthX+2*SKIN)/2, SubDHeightY/2, -SubDDepthZ])
		cube([SubDWidthX+2*SKIN, SKIN+PcbHeightY+BoxHeaderHeightY-SubDHeightY/2, SubDDepthZ]);

	// click notch (cable)
	translate([-CableWidthX/2-SnapNotchX, BoxHeaderHeightY+SKIN+0.5, PcbDepthZ])
		cube([CableWidthX+SnapNotchX*2, SnapNotchY, RearDepthZ+SKIN]);
	translate([-CableWidthX/2-SnapNotchX, CablePositionY+CableHeightY, PcbDepthZ+RearDepthZ+SKIN/2+0.15])
		cube([CableWidthX+SnapNotchX*2, BoxHeaderHeightY-CablePositionY+PcbHeightY-SKIN+0.5, SnapNotchY]);

	// click notch (PCB)
	translate([-PcbWidthX/2-SnapNotchX, BoxHeaderHeightY+SKIN+0.5, 0])
		cube([PcbWidthX+SnapNotchX*2, SnapNotchY, PcbDepthZ]);

	// click notch (subd)
	translate([-(SubDWidthX+2*SKIN+SnapNotchX*2)/2, SubDHeightY/2, -SubDPlatePositonZ+SKIN])
		cube([SubDWidthX+2*SKIN+SnapNotchX*2, PcbHeightY+BoxHeaderHeightY-SubDHeightY/2, SnapNotchY]);

}

module makeTop()
{
	intersection()
	{
		makeThing();
		makeTopMask();
	}
}

module makeBottom()
{
	difference()
	{
		makeThing();
		makeTopMask();
	}
}

module main()
{
	if (PART == "test")
	{
	}
	else
	if (PART == "top")
	{
		makeTop();
	}
	else
	if (PART == "bottom")
	{
		makeBottom();
	}
	else
	if (PART == "full") {
                 makeThing();
	}
	else
	if (PART == "mask")
	{
		makeTopMask();
	}
	else
	if (PART == "topBottom")
	{
		translate([0, PcbHeightY+BoxHeaderHeightY+SKIN, 40]) rotate([180,180,0]) makeTop();
		translate([0, SKIN+SubDHeightY/2, 0]) makeBottom();
	}
	else
	if (PART == "carving")
	{
		makePcb();
		makeFilamentSaver();
	}
	else
	if (PART == "pcb") {
		makePcb();
	}
	else
	{
		// nothing!
	}
}

main();
