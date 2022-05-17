// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com

module imprint(x,y,z)
{
	Font = "Liberation Sans:style=Bold";
	FontSize = 3;
	translate([x,y,z])
	rotate([270,0,0])
	{
		linear_extrude(height = 0.4) { text(IMPRINT, font = Font, size = FontSize, halign="center", valign="bottom"); }
	}
}

// cable strain relief (attached to the top shell)
module makeTopCableStrainRelief(height)
{
	translate([ScrewPostDiameter, 0, 0])
		rotate([180,0,0]) screwPost(height, ScrewPostDiameter+1, ScrewDiameter, height, 0);
	translate([-RearWallCableGapWidth, 0, 0])
		rotate([180,0,0]) screwPost(height, ScrewPostDiameter+1, ScrewDiameter, height, 0);
	StrainReliefWidth=3;
	translate([-RearWallCableGapWidth+ScrewPostDiameter/2, -StrainReliefWidth/2, -height])
		cube([RearWallCableGapWidth, StrainReliefWidth, height]);
}

// little mounting point, so the base plate does not drop when glueing to the top shell
module makeGlueHelper(Width)
{
	SupportAngle = 35;
	intersection()
	{
		union()
		{
			translate([-20, 0, 0])
				rotate([0, 0, SupportAngle])
					translate([-20,-25,-Width/2])
						cube([40, 50, Width]);
		}
		translate([0,0,-Width/2]) cube([40,50,Width]);
	}
}

// little mounting points to help when glueing the base to the top shell
module makeGlueMountingPoints()
{
	SupportWidth = 5; // 10mm
	//SupportXOffset = -36.9;
	SupportXOffset1 = -28;//34.9;
	//SupportXOffset2 = SupportXOffset1+32.1;
	SupportXOffset2 = 32.1;
	// support for bottom curved edges
	SupportYOffset = 0;

	FrontZ = FrontPanelZLedge+FrontPanelZOffset+SKIN*5; // front position
	RearZ = BoxZ_Depth-RearWallZLedge-RearWallZOffset-5*SKIN; // rear position
	intersection()
	{
		union()
		{
			// strain relief, attached to the top shell (which is the most rigid structure)
			if (STRAIN_RELIEF == "yes")
				translate([BoxX_Width-RearWallGap-RearWallCableGapXOffset-7, BoxY_Height, BoxZ_Depth-RearWallZLedge-RearWallZOffset])
					rotate([65+180,0,0]) makeTopCableStrainRelief(7);

			for (z=[FrontZ, RearZ, (FrontZ+RearZ)/2])
			{
				// right
				translate([0, SupportYOffset, z]) makeGlueHelper(SupportWidth);

				// left
				translate([BoxX_Width, SupportYOffset, z]) rotate([0, 180, 0]) makeGlueHelper(SupportWidth);
			}
		}
		// cut away anything which is outside the shell
		outerBox(SKIN, BoxX_Width, BoxY_Height, BoxZ_Depth, Box_Corner_Radius);
	}
}

module makeTopStiffeners()
{
	SupportWidth = 15;
	// front right
	translate([0, BoxY_Height-SupportWidth, FrontPanelZOffset+SKIN*2+15]) rotate([0,90,0]) prism(SKIN, SupportWidth, SupportWidth);
	// front left
	translate([BoxX_Width, BoxY_Height-SupportWidth, FrontPanelZOffset+SKIN+15]) rotate([0,270,0]) prism(SKIN, SupportWidth, 10);
	// center right
	translate([0, BoxY_Height-SupportWidth, BoxZ_Depth/2]) rotate([0,90,0]) prism(SKIN, SupportWidth, SupportWidth);
	// center left
	translate([BoxX_Width, BoxY_Height-SupportWidth, BoxZ_Depth/2-SKIN]) rotate([0,270,0]) prism(SKIN, SupportWidth, SupportWidth);
	// rear right
	translate([0, BoxY_Height-SupportWidth, BoxZ_Depth-RearWallZOffset-SKIN-3-2]) rotate([0,90,0]) prism(SKIN, SupportWidth, SupportWidth);
	// rear left
	translate([BoxX_Width, BoxY_Height-SupportWidth, BoxZ_Depth-RearWallZOffset-3-SKIN*2-2]) rotate([0,270,0]) prism(SKIN, SupportWidth, SupportWidth);
}

module roundedEdge()
{
	translate([-SKIN, 0, 30]) rotate([270, 0, 0]) roundedCube(2, 30, SKIN, 1);
}

module roundCorner()
{
	$fn=24;
	Radius = TopGrooveCornerRadius/2;
	translate([0,1,0]) rotate([270, 0, 0])
		translate([-Radius-TopGrooveYDepth, -Radius-TopGrooveYDepth, 0])
			intersection()
			{
				torus(Radius, TopGrooveYDepth);
				cube([Radius*2, Radius*2, TopGrooveYDepth]);
			}
}

module makeRoundGapEdges()
{
	// front left
	translate([FrontGapX-FrontGapWidth/2-1, -SKIN, 0]) roundedEdge();
	translate([FrontGapX+FrontGapWidth/2+1, -SKIN, 0]) roundedEdge();

	// front right
	translate([BoxX_Width-FrontGapX-FrontGapWidth/2-1, -SKIN, 0]) roundedEdge();
	translate([BoxX_Width-FrontGapX+FrontGapWidth/2+1, -SKIN, 0]) roundedEdge();

	// rear left
	translate([FrontGapX-FrontGapWidth/2-1, -SKIN, BoxZ_Depth-30]) roundedEdge();

	// rear right
	translate([BoxX_Width-FrontGapX+FrontGapWidth/2+1, -SKIN, BoxZ_Depth-30]) roundedEdge();
}

module makeGaps()
{
	// front gaps
	translate([FrontGapX-FrontGapWidth/2-1, -SKIN, 0]) cube([FrontGapWidth+2, SKIN*2, FrontGapY]);
	translate([BoxX_Width-FrontGapX-FrontGapWidth/2-1, -SKIN, 0]) cube([FrontGapWidth+2, SKIN*2, FrontGapY]);

	// rear gap
	translate([FrontGapX-FrontGapWidth/2-1, -SKIN, BoxZ_Depth-10]) cube([BoxX_Width-2*FrontGapX+FrontGapWidth+2, SKIN*2, 10]);
}

module ventilationCut()
{
	translate([-SKIN, BoxY_Height-VentilationYHeight,BoxZ_Depth-VentilationZOffset]) rotate([0, 90, 0]) 
		roundedCube(VentilationWidth, VentilationYHeight, SKIN, VentilationWidth/2);

	translate([BoxX_Width, BoxY_Height-VentilationYHeight,BoxZ_Depth-VentilationZOffset]) rotate([0, 90, 0])
		roundedCube(VentilationWidth, VentilationYHeight, SKIN, VentilationWidth/2);

	translate([-SKIN-VentilationYHeight+VentilationXLength, BoxY_Height+SKIN,BoxZ_Depth-VentilationZOffset]) rotate([90, 90, 0])
		roundedCube(VentilationWidth, VentilationYHeight, SKIN+5, VentilationWidth/2);

	translate([BoxX_Width-VentilationXLength, BoxY_Height+SKIN,BoxZ_Depth-VentilationZOffset]) rotate([90, 90, 0])
		roundedCube(VentilationWidth, VentilationYHeight, SKIN+5, VentilationWidth/2);
}

module makeVentilation()
{
	for (z = [0 : 1: VentilationCount-1])
	{
		translate([0, 0, -z*VentilationZDistance]) ventilationCut();
	}
}


module makeScrewHoles()
{
	// front hole
	translate([FrontGapX/2, -SKIN, FrontPanelZOffset+FrontPanelZLedge/2]) rotate([270, 0, 0])
		hole(ScrewDiameter, 10);

	// front hole
	translate([BoxX_Width-FrontGapX/2, -SKIN, FrontPanelZOffset+FrontPanelZLedge/2]) rotate([270, 0, 0])
		hole(ScrewDiameter, 10);
	
	// rear hole
	translate([FrontGapX/2, -SKIN , BoxZ_Depth-RearWallZOffset-RearWallZLedge/2]) rotate([270, 0, 0])
		hole(ScrewDiameter, 10);

	// rear hole
	translate([BoxX_Width-FrontGapX/2, -SKIN, BoxZ_Depth-RearWallZOffset-RearWallZLedge/2]) rotate([270, 0, 0])
		hole(ScrewDiameter, 10);

	// rear PCB holes
	translate([BoxX_Width/2-PcbXWidth/2, 0, PcbZOfs])
	{
		translate([PcbScrewDistance, -SKIN,PcbZDepth-PcbScrewDistance]) rotate([270, 0, 0]) hole(PcbScrewDiameter, SKIN);
		translate([PcbXWidth-PcbScrewDistance, -SKIN,PcbZDepth-PcbScrewDistance]) rotate([270, 0, 0]) hole(PcbScrewDiameter, SKIN);
	}
}

GrooveSupportZOffset = (BoxZ_Depth-2*TopGrooveZLength)/3;
GrooveXOfs = BoxX_Width/2-(TopGrooveXWidth+4)/2;

module makeTopGroovesSupport()
{
	translate([GrooveXOfs, BoxY_Height-TopGrooveYDepth, GrooveSupportZOffset+TopGrooveZLength+2]) rotate([270, 0, 0])
		roundedCube(TopGrooveXWidth+4, TopGrooveZLength+4, TopGrooveYDepth, TopGrooveCornerRadius);

	translate([GrooveXOfs, BoxY_Height-TopGrooveYDepth, GrooveSupportZOffset*2+TopGrooveZLength*2+2]) rotate([270, 0, 0])
		roundedCube(TopGrooveXWidth+4, TopGrooveZLength+4, TopGrooveYDepth, TopGrooveCornerRadius);
}

module makeTopGroovesEdges()
{
        for (z=[GrooveSupportZOffset,2*GrooveSupportZOffset+TopGrooveZLength])
	translate([GrooveXOfs+2, BoxY_Height-TopGrooveYDepth+SKIN, z])
	{
		// right edge
		translate([0, 0, 4+TopGrooveZLength/2-5])
			cylinderLedge(TopGrooveYDepth, TopGrooveZLength);

		// left edge
		translate([TopGrooveXWidth, 0, 4+TopGrooveZLength/2-5])
			rotate([0, 180, 0]) cylinderLedge(TopGrooveYDepth, TopGrooveZLength);

		// front edge
		translate([TopGrooveXWidth/2, 0, 0])
			rotate([0, 270, 0]) cylinderLedge(TopGrooveYDepth, TopGrooveXWidth);

		// rear edge
		translate([TopGrooveXWidth/2, 0, TopGrooveZLength])
			rotate([0, 90, 0]) cylinderLedge(TopGrooveYDepth, TopGrooveXWidth);

		// rear right corner
		translate([TopGrooveXWidth, -1, 0]) roundCorner();

		// rear left corner
		translate([0, -1, 0]) rotate([0, 90, 0]) roundCorner();

		// front right corner
		translate([TopGrooveXWidth, -1, TopGrooveZLength]) rotate([0, 270, 0]) roundCorner();

		// front left corner
		translate([0, -1, TopGrooveZLength]) rotate([0, 180, 0]) roundCorner();

	}
}

module makeTopGrooves()
{
	GrooveZOffset = (BoxZ_Depth-2*TopGrooveZLength)/3;
	translate([BoxX_Width/2-TopGrooveXWidth/2, BoxY_Height-TopGrooveYDepth+SKIN, GrooveZOffset+TopGrooveZLength]) rotate([270, 0, 0])
		roundedCube(TopGrooveXWidth, TopGrooveZLength, TopGrooveYDepth, TopGrooveCornerRadius);

	translate([BoxX_Width/2-TopGrooveXWidth/2, BoxY_Height-TopGrooveYDepth+SKIN, GrooveZOffset*2+TopGrooveZLength*2]) rotate([270, 0, 0])
		roundedCube(TopGrooveXWidth, TopGrooveZLength, TopGrooveYDepth, TopGrooveCornerRadius);
}

// little supports to prevent the front and rear panels from bending into the case
module makeTopPanelSupports()
{
	Distance = 10; // distance of the supports from the left/right edge of the box
	SupportWidth = 3;  // x,z size of the supports
	SupportYHeight = 4; // y size of the supports (cube)
	// front left
	translate([BoxX_Width-5, BoxY_Height-SupportYHeight, FrontPanelZOffset+SKIN])
		cube([SupportWidth, SupportYHeight, SupportWidth]);
	// front right
	translate([18, BoxY_Height-SupportYHeight, FrontPanelZOffset+SKIN])
		cube([SupportWidth, SupportYHeight, SupportWidth]);
	// front center
	translate([BoxX_Width/2-4, BoxY_Height-SupportYHeight, FrontPanelZOffset+SKIN])
		cube([SupportWidth, SupportYHeight, SupportWidth]);

	// rear
	translate([BoxX_Width-RearWallCableGapXOffset/2-SupportWidth, 
	           BoxY_Height-SupportYHeight, BoxZ_Depth-RearWallZOffset-SKIN-SupportWidth])
		cube([SupportWidth, SupportYHeight, SupportWidth]);
	translate([Distance, BoxY_Height-SupportYHeight, BoxZ_Depth-RearWallZOffset-SKIN-SupportWidth])
		cube([SupportWidth, SupportYHeight, SupportWidth]);
}


module makeThing()
{
	union()
	{
		difference()
		{
			union()
			{
				box(SKIN, BoxX_Width, BoxY_Height, BoxZ_Depth, Box_Corner_Radius);
				makeTopGroovesSupport();
				makeGlueMountingPoints();
			}
			makeGaps();
			makeVentilation();
			makeTopGrooves();
			makeScrewHoles();

			if (prototype == "yes")
			{
				removePrototypeAreas();
			}
		}
		makeRoundGapEdges();
		makeTopGroovesEdges();
		makeTopPanelSupports();
		makeTopStiffeners();
	}
}

module makeMask()
{
	XOffs = 3.5*ScalingFactor;
	translate([XOffs/2, -BoxY_Height, 0]) cube([BoxX_Width-XOffs, BoxY_Height+SKIN, BoxZ_Depth]);
}

module makeTop()
{
	difference()
	{
		makeThing();
		makeMask();
	}
}

module makeBottom()
{
	intersection()
	{
		makeThing();
		makeMask();
	}
	imprint(BoxX_Width/2,0,BoxZ_Depth-RearWallZLedge-RearWallZOffset);
}

