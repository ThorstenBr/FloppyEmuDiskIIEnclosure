// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com

// Which part do you want to see/generate?
PART = "bottom"; // [all:All, noRear:No Rear, noFront:No Front, noBottom: No Bottom, frontBottom: Front and Bottom, topBottom: Top and Bottom, bottom:Bottom only,top:Top only,rear:Rear only,front:Front only, button:Buttons and Fittings,prototype:Prototype,test:Test]

// Size of the LCD display?
LCD = "yes"; // [small:Original 1.7inch display, large:Custom large 2.42inch display]

// show FloppyEmu PCB?
PCB = "yes"; // [no:No,yes:Yes]

// Size of the box: 1.0=original Disk II drive size, 0.6='baby box', just matching floppy EMU size
SCALING = 0.6; // [0.1 : 0.01 : 1]

// Which/how many LEDs?
LEDs = "one"; // [one:One / Activity LED,two:Both / Activity and Power LEDs]

/* [Internals] */
// Base board imprint
IMPRINT = "MADE IN GERMANY";  // 20

// Distance of the components (when showing 'exploded' elements)
SEPARATION = 30; // [0: 1: 100]

/* [Hidden] */
// Use prototype cutouts to save filament?
prototype = "no"; // [no:No,yes:Yes]

// Add 3D print supports
supports = "yes"; // [no:No,yes:Yes]

showPcb = PCB;
part = PART;
ComponentSeparation = SEPARATION;
ScalingFactor = SCALING;
LedCount = (LEDs == "two") ? 2 : 1;

include <components/main.scad>

