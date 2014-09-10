_global.gfxExtensions = true;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx;

/*
This function
inhibits sound from the Unreal Development Kit when a CLIK element
is activated.
*/
function InitSoundAct(){
	fscommand("buttonhit");
}

/*
Takes the user to the main menu.
*/
function ReturnToMainMenu(){
	gotoAndPlay("mainMenu");
}

/*
Fscommand is similar to ExternalInterface.call().  
The sound for hitting a button is executed in UnrealKismet rather than
UnrealScript code which makes Fscommand more convenient.
This function inhibits sound from the Unreal Development Kit when moving
from CLIK element to CLIK element.
*/
function InitSoundRO(){
	fscommand("initsound");
}

//Establising event listeners for clicking and roll over actions
creditsBackBtn.addEventListener("click",this,"ReturnToMainMenu");
creditsBackBtn.addEventListener("rollOver",this,"InitSoundRO");

/*
Executes the action given a certain input.
*/
this.ProcessKeyDown = function(details:InputDetails, pathToFocus:Array)
{	
	//trace("process key down");
	var bHandled = false;
	if (details.navEquivalent == NavigationCode.GAMEPAD_A)
	{
		InitSoundAct();
		ReturnToMainMenu();
		
	}else if(details.navEquivalent == NavigationCode.GAMEPAD_B){
		InitSoundAct();
		ReturnToMainMenu();
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
Selection.setFocus(creditsBackBtn);

stop();
