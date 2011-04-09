///////////////////////////////////////
//      ADVANCED PLATFORM ENGINE     //
// by Noel Berry (www.noelberry.ca)  //
//-----------------------------------//
// Flash Punk Library by Chevy Ray   //
// read the FlashPunk Licence.txt for//
// more info                         //
///////////////////////////////////////

TITLE:   ANDVANCED PLATFORM ENGINE
VERSION: 0.90

///////////////////////////////////////
//------------DESCRIPTION------------//
///////////////////////////////////////

This example/engine shows how to create
a functional platformer with many
features including pushable blocks,
moving platforms, multiple levels,
wall jumping, and much more, in the
Flash Punk library.

(note this readme does not apply to
the actual Flash Punk library located
in src/net. For information on that,
check out the license.txt within said
folder)


///////////////////////////////////////
//------CHANGES (V0.85 - V0.90)------//
///////////////////////////////////////
 - Updated to FP 1.5 (latest release)
 - Moved the classes Game, Menu, 
   Transition, and View to a new 
   subfolder Control
 - Added a new class called Assets, 
   which contains all the embedded assets. 
   No other classes embed assets anymore.
 - Moved the Main.as into the source 
   folder
 - Renamed a few variables here and 
   there
 - Changed the wall jumping so that you 
   can go back to the wall you jumped 
   from (felt weird if you couldn't do 
   that)
 - Made it so floors (solids) are not 
   active, and thus are never rendered or 
   updated, so the game will run faster 
   even if you have LOTS of walls/floors


///////////////////////////////////////
//---------------LINKS---------------//
///////////////////////////////////////

NOELBERRY: http://www.noelberry.ca
FLASHPUNK: http://www.flashpunk.net
