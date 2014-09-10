_global.gfxExtensions = true;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx;
import flash.external.ExternalInterface;

/*
Following three conditional statements govern the current value of the 
Volume sliders.
1) If the user has first entered the Volume screen, each slider is set to Off.
2) After adjusting the value, the value is saved when the Volume screen is left.
*/
if(options.sfxVolume == null){
	continue;
}else{
	sfxSlider.value = options.sfxVolume;
}

if(options.musicVolume == null){
	continue;
}else{
	musicSlider.value = options.musicVolume;
}

if(options.ambienceVolume == null){
	continue;
}else{
	ambienceSlider.value = options.ambienceVolume;
}

/*
These 3 conditional statements govern the text in relation to the value of the
slider.
*/
if(options.sfxText == null){
	sfxSetting.text = " ";
}else{
	sfxSetting.text = options.sfxText;
}

if(options.musicText == null){
	musicSetting.text = " ";
}else{
	musicSetting.text = options.musicText;
}

if(options.ambienceText == null){
	ambienceSetting.text = " ";
}else{
	ambienceSetting.text = options.ambienceText;
}

function InitSoundRO(){
	fscommand("initsound");
}

/*
Saves the options upon returning to the Options screen.
*/
function OpenOptionsScreen(){
	options.sfxVolume = sfxSlider.value;
	options.musicVolume = musicSlider.value;
	options.ambienceVolume = ambienceSlider.value;
	options.sfxText = sfxSetting.text;
	options.musicText = musicSetting.text;
	options.ambienceText = ambienceSetting.text;
	fscommand("buttonhit");
	gotoAndPlay("optionsScreen");
}

/*
The current value of the slider is sent to a function in an .uc file
called sfxAlter(value) using the ExternalInterface.call() function
and is adjusted as needed.
*/
function sfxChange(event:Object){
	 InitSoundRO();
	 trace("SFX Slider: " + event.target.value); 
	if (event.target.value == 0){
	 ExternalInterface.call("sfxAlter",0.0);
	 sfxSetting.text = "Off";
 }else if(event.target.value == 3.33){
	 ExternalInterface.call("sfxAlter",3.33);
	 sfxSetting.text = "Low";
 }else if(event.target.value == 6.66){
	 ExternalInterface.call("sfxAlter",6.66);
	 sfxSetting.text = "Medium";
 }else if(event.target.value == 9.99){
	 ExternalInterface.call("sfxAlter",9.99);
	 sfxSetting.text = "High";
 }
}

/*
The current value of the slider is sent to a function in an .uc file
called musicAlter(value) using the ExternalInterface.call() function
and is adjusted as needed.
*/
function musicChange(event:Object){
	 InitSoundRO();
	 trace("Music Slider: " + event.target.value); 
	if (event.target.value == 0){
	 ExternalInterface.call("musicAlter",0.0);
	 musicSetting.text = "Off";
 }else if(event.target.value == 3.33){
	 ExternalInterface.call("musicAlter",3.33);
	 musicSetting.text = "Low";
 }else if(event.target.value == 6.66){
	 ExternalInterface.call("musicAlter",6.66);
	 musicSetting.text = "Medium";
 }else if(event.target.value == 9.99){
	 ExternalInterface.call("musicAlter",9.99);
	 musicSetting.text = "High";
 }
}


/*
The current value of the slider is sent to a function in an .uc file
called ambienceAlter(value) using the ExternalInterface.call() function
and is adjusted as needed.
*/
function ambienceChange(event:Object){
	 InitSoundRO();
	 trace("Ambience Slider: " + event.target.value); 
	if (event.target.value == 0){
	 ExternalInterface.call("ambienceAlter",0.0);
	 ambienceSetting.text = "Off";
 }else if(event.target.value == 3.33){
	 ExternalInterface.call("ambienceAlter",3.33);
	 ambienceSetting.text = "Low";
 }else if(event.target.value == 6.66){
	 ExternalInterface.call("ambienceAlter",6.66);
	 ambienceSetting.text = "Medium";
 }else if(event.target.value == 9.99){
	 ExternalInterface.call("ambienceAlter",9.99);
	 ambienceSetting.text = "High";
 }
}

/*
Plays a unique sound for sliders.
*/
function PlaySoundMX(){
	InitSoundRO();
}

//Event Listeners for executing actions upon a change in sliders.
sfxSlider.addEventListener("change",this,"sfxChange");
musicSlider.addEventListener("change",this,"musicChange");
ambienceSlider.addEventListener("change",this,"ambienceChange");

//Click events for when the user clicks on a button with the mouse.
bckButtonFive.addEventListener("click",this,"OpenOptionsScreen");
var buttonSelected = 0;

/*
Executes the action given a certain input.
*/
this.ProcessKeyDown = function(details:InputDetails, pathToFocus:Array)
{	
	//trace("process key down");
	var bHandled = false;
	if (details.navEquivalent == NavigationCode.GAMEPAD_A && buttonSelected == 3)
	{
		fscommand("buttonhit");
		OpenOptionsScreen();
	}
	else if (details.navEquivalent == NavigationCode.GAMEPAD_B){
		OpenOptionsScreen();
	}
	else if(details.navEquivalent == NavigationCode.DOWN)
	{
		buttonSelected++;
		if(buttonSelected > 3){	//Countermeasure to avoid out-of-sync menu selections.
			buttonSelected = 3;
		}
	}
	else if(details.navEquivalent == NavigationCode.UP)
	{
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
	var nextItem:Object = pathToFocus.shift(); 
 	var handled:Boolean = nextItem.handleInput(details, pathToFocus); 
 	if (handled) { 
		return true; 
	} 
 	else if ((details.value == "keyDown") && (ProcessKeyDown))
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
Selection.setFocus(sfxSlider);

stop();


