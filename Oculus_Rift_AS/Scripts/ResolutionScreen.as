import gfx;
_global.gfxExtensions = true;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import flash.external.ExternalInterface;

/*
Returns to the Options Screen.
*/
function ReturnToOptionsScreen(){
	InitSoundAct();
	gotoAndPlay("optionsScreen");
}

//Click events for when the user clicks on a button with the mouse
bckButtonThree.addEventListener("click",this,"ReturnToOptionsScreen");
resOneBtn.addEventListener("click",this,"setResOne");
resTwoBtn.addEventListener("click",this,"setResTwo");
resThreeBtn.addEventListener("click",this,"setResThree");
resFourBtn.addEventListener("click",this,"setResFour");
resFiveBtn.addEventListener("click",this,"setResFive");
resSixBtn.addEventListener("click",this,"setResSix");
fullscreenBtn.addEventListener("click",this,"setFullScreen");

//Rollover events for when the cursor moves over a button
bckButtonThree.addEventListener("rollOver",this,"InitSoundRO");
resOneBtn.addEventListener("rollOver",this,"InitSoundRO");
resTwoBtn.addEventListener("rollOver",this,"InitSoundRO");
resThreeBtn.addEventListener("rollOver",this,"InitSoundRO");
resFourBtn.addEventListener("rollOver",this,"InitSoundRO");
resFiveBtn.addEventListener("rollOver",this,"InitSoundRO");
resSixBtn.addEventListener("rollOver",this,"InitSoundRO");
fullscreenBtn.addEventListener("rollOver",this,"InitSoundRO");

/*
All the following resolution functions call their respective
function from the corresponding .uc (UnrealScript) file using
the ExternalInterface.call() function.
*/
function setResOne(){
	ExternalInterface.call("resolutionOne");
	InitSoundAct();
}

function setResTwo(){
	ExternalInterface.call("resolutionTwo");
	InitSoundAct();
}

function setResThree(){
	ExternalInterface.call("resolutionThree");
	InitSoundAct();
}

function setResFour(){
	ExternalInterface.call("resolutionFour");
	InitSoundAct();
}

function setResFive(){
	ExternalInterface.call("resolutionFive");
	InitSoundAct();
}

function setResSix(){
	ExternalInterface.call("resolutionSix");
	InitSoundAct();
}

function setFullScreen(){
	ExternalInterface.call("funcFullScreen");
	InitSoundAct();
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
				setResOne();
				break;
			case 1:
				setResTwo();
				break;
			case 2:
				setResThree();
				break;
			case 3:
				setResFour();
				break;
			case 4:
				setResFive();
				break;
			case 5:
				setResSix();
				break;
			case 6:
				setFullScreen();
				break;
			case 7:
				ReturnToOptionsScreen();
				break;
			default:
				break;
		}
	}
	else if(details.navEquivalent == NavigationCode.RIGHT || details.navEquivalent == NavigationCode.LEFT)
	{
		InitSoundRO();
		buttonSelected = 0;	//Right and left inhibit UP and DOWN as well so care is taken for these.
	}
	else if (details.navEquivalent == NavigationCode.GAMEPAD_B)
	{
		InitSoundRO();
		ReturnToOptionsScreen();
	}
	else if(details.navEquivalent == NavigationCode.DOWN)
	{
		InitSoundRO();
		buttonSelected++;
		if(buttonSelected > 7){	//Countermeasure to avoid out-of-sync menu selections.
			buttonSelected = 7;
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
Selection.setFocus(resOneBtn);

stop();