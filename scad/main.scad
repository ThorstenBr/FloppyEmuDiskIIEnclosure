// Copyright 2022 Thorsten Brehm
// brehmt (at) gmail dot com

// Which part do you want to see/generate?
PART = "bottom"; // [button:Buttons and Brackets, bottom:Base board element, top:Top shell, rear:Rear panel, front:Front panel, test:--Test--, all:All elements, noRear:All except the rear panel, noFront:All except front panel, noBottom: All except base board, frontBottom: Front and base board only, topBottom: Top shell and base board only]

// Size of the LCD display?
LCD = "yes"; // [small:Original 1.7inch display, large:Custom large 2.42inch display]

// show FloppyEmu PCB?
PCB = "no"; // [no:No,yes:Yes]

// Size of the box: 1.0=original Disk II drive size, 0.6='baby box', just matching floppy EMU size
SCALING = 0.6; // [0.1 : 0.01 : 1]

// Which/how many LEDs?
LEDs = "one"; // [one:One / Activity LED,two:Both / Activity and Power LEDs]

/* [Internals] */
// Base board imprint
IMPRINT = "MADE IN GERMANY";  // 30

// Distance of the components (when showing 'exploded' elements)
SEPARATION = 30; // [0: 1: 100]

// Add cable strain-relief to top shell
STRAIN_RELIEF = "yes"; // [no:No,yes:Yes]

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

