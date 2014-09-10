import gfx
_global.gfxExtensions = true;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import flash.external.ExternalInterface;

/*
These alias functions use a function called ExternalInterface.call()
to use a function located in a .uc file when this file is linked 
with the Unreal Development Kit.
*/
function setAliasNone(){
	ExternalInterface.call("AntiAliasNone");
	InitSoundAct();
}

function setAliasTwo(){
	ExternalInterface.call("AntiAliasTwo");
	InitSoundAct();
}

function setAliasFour(){
	ExternalInterface.call("AntiAliasFour");
	InitSoundAct();
}

function setAliasEight(){
	ExternalInterface.call("AntiAliasEight");
	InitSoundAct();
}

function setAliasSixteen(){
	ExternalInterface.call("AntiAliasSixteen");
	InitSoundAct();
}

/*
Takes user back one screen to Options Screen
*/
function ReturnToOptionsScreen(){
	InitSoundAct();
	gotoAndPlay("optionsScreen");
}

/*
Fscommand is similar to ExternalInterface.call().  
The sound for hitting a button is executed in UnrealKismet rather than
UnrealScript code which makes Fscommand more convenient for simple tasks as these.
This function inhibits sound from the Unreal Development Kit when moving
from CLIK element to CLIK element.
*/
function InitSoundRO(){
	fscommand("initsound");
}

/*
This function
inhibits sound from the Unreal Development Kit when a CLIK element
is activated.
*/
function InitSoundAct(){
	fscommand("buttonhit");
}

//Click events for when the user clicks on a button with the mouse
bckButtonFour.addEventListener("click",this,"ReturnToOptionsScreen");
aliasnoneBtn.addEventListener("click",this,"setAliasNone");
aliastwoBtn.addEventListener("click",this,"setAliasTwo");
aliasfourBtn.addEventListener("click",this,"setAliasFour");
aliaseightBtn.addEventListener("click",this,"setAliasEight");
aliassixteenBtn.addEventListener("click",this,"setAliasSixteen");

//Rollover events for when the cursor moves over a button
bckButtonFour.addEventListener("rollOver",this,"InitSoundRO");
aliasnoneBtn.addEventListener("rollOver",this,"InitSoundRO");
aliastwoBtn.addEventListener("rollOver",this,"InitSoundRO");
aliasfourBtn.addEventListener("rollOver",this,"InitSoundRO");
aliaseightBtn.addEventListener("rollOver",this,"InitSoundRO");
aliassixteenBtn.addEventListener("rollOver",this,"InitSoundRO");

var buttonSelected = 0;

/*
Executes the action given a certain input.
*/
this.ProcessKeyDown = function(details:InputDetails, pathToFocus:Array)
{	
	//trace("process key down");
	var bHandled = false;
	if (details.navEquivalent == NavigationCode.GAMEPAD_A)
	{
		switch(buttonSelected){
			case 0:
				setAliasNone();
				break;
			case 1:
				setAliasTwo();
				break;
			case 2:
				setAliasFour();
				break;
			case 3:
				setAliasEight();
				break;
			case 4:
				setAliasSixteen();
				break;
			case 5:
				ReturnToOptionsScreen();
				break;
			default:
				break;
		}
	}
	else if (details.navEquivalent == NavigationCode.GAMEPAD_B)
	{
		ReturnToOptionsScreen();
	}
	else if(details.navEquivalent == NavigationCode.RIGHT || details.navEquivalent == NavigationCode.LEFT)
	{
		InitSoundRO();		
		buttonSelected = 0;	//Right and left inhibit UP and DOWN as well so care is taken for these.
	}
	else if(details.navEquivalent == NavigationCode.DOWN)
	{
		InitSoundRO();
		buttonSelected++;	
		if(buttonSelected > 5){	//Countermeasure to avoid out-of-sync menu selections.
			buttonSelected = 5;
		}
	}
	else if(details.navEquivalent == NavigationCode.UP)
	{
		InitSoundRO();
		buttonSelected--;		
		if(buttonSelected < 0){	//Countermeasure to avoid out-of-sync menu selections.
			buttonSelected = 0;
		}
	}
	return bHandled;
}

/*
Processes the buttons being pressed.
*/
function handleInput(details:InputDetails, pathToFocus:Array):Boolean 
{

	if ((details.value == "keyDown") && (ProcessKeyDown))
	{
		return ProcessKeyDown(details, pathToFocus);
	}
	else if ((details.value == "keyUp") && (ProcessKeyUp))
	{
		return ProcessKeyUp(details, pathToFocus);
	}
	else if ((details.value == "keyHold") && (ProcessKeyHold))
	{
		return ProcessKeyHold(details, pathToFocus);
	}
	//Since this is the top level, the return value isn't relevant.  Just say we didn't handle it.
	return false;
}

//Must focus on a CLIK element otherwise the menu will not work with a controller.
Selection.setFocus(aliasnoneBtn);

stop();