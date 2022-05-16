// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com

// floppy emu PCB
module makePcb()
{
	translate([BoxX_Width/2 - PcbXWidth/2+PcbXOfs, PcbYOfs, PcbZOfs])
	{
		difference()
		{
			// PCB
			cube([PcbXWidth, PcbYHeight, PcbZDepth]);
			// front holes
			translate([PcbScrewDistance,0,PcbScrewDistance]) rotate([270, 0, 0]) hole(PcbScrewDiameter, PcbYHeight);
			translate([PcbXWidth-PcbScrewDistance,0,PcbScrewDistance]) rotate([270, 0, 0]) hole(PcbScrewDiameter, PcbYHeight);
			// rear holes
			translate([PcbScrewDistance,0,PcbZDepth-PcbScrewDistance]) rotate([270, 0, 0]) hole(PcbScrewDiameter, PcbYHeight);
			translate([PcbXWidth-PcbScrewDistance,0,PcbZDepth-PcbScrewDistance]) rotate([270, 0, 0]) hole(PcbScrewDiameter, PcbYHeight);
		}
	}
}

module makeRearPcbFeet(center)
{
	//translate([BoxX_Width/2 - PcbXWidth/2+PcbXOfs, PcbYOfs, PcbZDepth+PcbZOfs])
	rotate([90,0,90])
	{
		difference()
		{
			translate([-PcbScrewDiameter/2, -SKIN, -PcbScrewDistance-PcbScrewDiameter])
				cube([PcbXWidth+PcbScrewDiameter, SKIN, PcbScrewDiameter*2]);
			// holes
			translate([PcbScrewDistance,-SKIN,-PcbScrewDistance]) rotate([270, 0, 0])
				hole(PcbScrewDiameter, PcbYHeight);
			translate([PcbXWidth-PcbScrewDistance,-SKIN,-PcbScrewDistance]) rotate([270, 0, 0])
				hole(PcbScrewDiameter, PcbYHeight);
		}
		FeetYHeight = PcbYOfs-SKIN;
		translate([PcbScrewDistance,-SKIN,-PcbScrewDistance]) rotate([90, 0, 0]) 
			screwPost(FeetYHeight, PcbScrewDiameter*2, PcbScrewDiameter, FeetYHeight, 0);
		translate([PcbXWidth-PcbScrewDistance,-SKIN,-PcbScrewDistance]) rotate([90, 0, 0]) 
			screwPost(FeetYHeight, PcbScrewDiameter*2, PcbScrewDiameter, FeetYHeight, 0);
	}
}
