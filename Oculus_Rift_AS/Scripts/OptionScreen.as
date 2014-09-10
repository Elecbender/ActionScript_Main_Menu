import gfx
_global.gfxExtensions = true;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import flash.external.ExternalInterface;

//Variable flags for displaying text with DynamicShadows and VSync.
var cVariable:Number;
var tVariable:Number;

/*
The next 4 conditional statements govern the text behind displaying
the status of Dynamic Shadows and VSync.
1) If the user enters the options menu for the first time, the text is blank.
2) When the user chooses an option, it is stored in an external variable (Located at the first frame)
   that allows the state to be stored.
*/
if(options.dynToggle == null){
	dynText.text = " ";
}else{
	dynText.text = options.dynToggle;
}

if(options.vsyncToggle == null){
	vsyncText.text = " ";
}else{
	vsyncText.text = options.vsyncToggle;
}

if(options.dTG == null){
	cVariable = 0;
}else{
	cVariable = options.dTG;
}

if(options.vSTG == null){
	tVariable = 0;
}else{
	tVariable = options.vSTG;
}

/*
Displays text for Dynamic Shadows depending on the status of the cVariable.
*/
function DSSettings(){
	if(cVariable == 0){
	ExternalInterface.call("EnableDynamicShadows");
	dynText.text = "Dynamic Shadows: Enabled";
	InitSoundAct();
	cVariable = 1;
	break;
	}else if(cVariable == 1){
	ExternalInterface.call("DisableDynamicShadows");
	dynText.text = "Dynamic Shadows: Disabled";
	InitSoundAct();
	cVariable = 0;
	break;
	}
}

/*
Displays text for VSync depending on the status of the tVariable.
*/
function VSyncSettings(){
	if(tVariable == 0){
	ExternalInterface.call("EnableVSync");
	vsyncText.text = "V-Sync : Enabled";
	InitSoundAct();
	tVariable = 1;
	break;
	}else if(tVariable == 1){
	ExternalInterface.call("DisableVSync");
	vsyncText.text = "V-Sync : Disabled";
	InitSoundAct();
	tVariable = 0;
	break;
	}
}

//Click events for when the user clicks on a button with the mouse.
resolutionButton.addEventListener("click",this,"GoToResScreen");
antialiasingButton.addEventListener("click",this,"GoToAliasScreen");
bckButtonTwo.addEventListener("click",this,"ReturnToMainMenu");
volumeButton.addEventListener("click",this,"GoToVolumeScreen");
dynBtn.addEventListener("click",this,"DSSettings");
vsyncButton.addEventListener("click",this,"VSyncSettings");

//Rollover events for when the cursor moves over a button.
resolutionButton.addEventListener("rollOver",this,"InitSoundRO");
antialiasingButton.addEventListener("rollOver",this,"InitSoundRO");
bckButtonTwo.addEventListener("rollOver",this,"InitSoundRO");
volumeButton.addEventListener("rollOver",this,"InitSoundRO");
dynBtn.addEventListener("rollOver",this,"InitSoundRO");
vsyncButton.addEventListener("rollOver",this,"InitSoundRO");

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

/*
Text from Dynamic Shadows and VSync need to be saved and flagged when entering/exiting a screen.
*/
function GoToResScreen(){
	options.dynToggle = dynText.text;
	options.vsyncToggle = vsyncText.text;
	options.dTG = cVariable;
	options.vSTG = tVariable;
	InitSoundAct();
	gotoAndPlay("resScreen");
}
/*
Text from Dynamic Shadows and VSync need to be saved and flagged when entering/exiting a screen.
*/
function GoToAliasScreen(){
	options.dynToggle = dynText.text;
	options.vsyncToggle = vsyncText.text;
	options.dTG = cVariable;
	options.vSTG = tVariable;
	InitSoundAct();
	gotoAndPlay("aliasingScreen");
}
/*
Text from Dynamic Shadows and VSync need to be saved and flagged when entering/exiting a screen.
*/
function ReturnToMainMenu(){
	options.dynToggle = dynText.text;
	options.vsyncToggle = vsyncText.text;
	options.dTG = cVariable;
	options.vSTG = tVariable;
	InitSoundAct();
	gotoAndPlay("mainMenu");
}
/*
Text from Dynamic Shadows and VSync need to be saved and flagged when entering/exiting a screen.
*/
function GoToVolumeScreen(){
	options.dynToggle = dynText.text;
	options.vsyncToggle = vsyncText.text;
	options.dTG = cVariable;
	options.vSTG = tVariable;
	InitSoundAct();
	gotoAndPlay("volumeScreen");
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
				GoToAliasScreen();
				break;
			case 1:
				GoToResScreen();
				break;
			case 2:
				VSyncSettings();
				break;
			case 3:
				DSSettings();
				break;
			case 4:
				GoToVolumeScreen();
				break;
			case 5:
				ReturnToMainMenu();
				break;
			default:
				break;				
		}
	}
	else if (details.navEquivalent == NavigationCode.GAMEPAD_B){
		fscommand("buttonhit");
		ReturnToMainMenu();
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
		if(buttonSelected <= 0){ //Countermeasure to avoid out-of-sync menu selections.
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
	else if ((details.value == "keyHold") && (ProcessKeyHold))
	{
		return ProcessKeyHold(details, pathToFocus);
	}
	return false;
}

//Must focus on a CLIK element otherwise the menu will not work with a controller.
Selection.setFocus(antialiasingButton);


stop();