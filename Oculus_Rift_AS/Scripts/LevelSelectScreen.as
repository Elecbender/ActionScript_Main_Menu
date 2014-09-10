_global.gfxExtensions = true;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx;
import flash.external.ExternalInterface;

//Establishing event listeners for clicking and rolling over buttons 
iceLevelBtn.addEventListener("click",this,"LoadIceLevel");
iceLevelBtn.addEventListener("rollOver",this,"InitSoundRO");
waterLevelBtn.addEventListener("click",this,"LoadWaterLevel");
waterLevelBtn.addEventListener("rollOver",this,"InitSoundRO");
backButtonSvn.addEventListener("click",this,"ReturnToMainMenu");
backButtonSvn.addEventListener("rollOver",this,"InitSoundRO");

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
Next 2 functions call the "OpenIceLevel" and "OpenWaterLevel"
functions in the respective .uc (UnrealScript) file.
*/
function LoadIceLevel(){
	ExternalInterface.call("OpenIceLevel");
}

function LoadWaterLevel(){
	ExternalInterface.call("OpenWaterLevel");
}

/*
Returns to the main menu.
*/
function ReturnToMainMenu(){
	gotoAndPlay("mainMenu");
}

////Must focus on a CLIK element otherwise the menu will not work with a controller.
Selection.setFocus(iceLevelBtn);

//Selection starts at the top of the menu.
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
		fscommand("buttonhit");
		switch(buttonSelected){
			case 0:
				LoadIceLevel();
				break;
			case 1:
				LoadWaterLevel();
				break;
			case 2:
				ReturnToMainMenu();
				break;
			default:
				break;
		}
		}
	else if(details.navEquivalent == NavigationCode.RIGHT)
	{
		buttonSelected = 2;
	}
	else if(details.navEquivalent == NavigationCode.DOWN )
	{
		InitSoundRO();
		buttonSelected++;
		if(buttonSelected > 2){	//Countermeasure to avoid out-of-sync menu selections.
			buttonSelected = 2;
		}
	}
	else if(details.navEquivalent == NavigationCode.GAMEPAD_B)
	{
		ReturnToMainMenu();
	}
	else if(details.navEquivalent == NavigationCode.UP  || details.navEquivalent == NavigationCode.LEFT)
	{
		InitSoundRO();		
		buttonSelected--;		//Special case for this menu as there are only 2 options
		if(buttonSelected < 0){
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

stop();					   
						