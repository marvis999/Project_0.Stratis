//Just a quick file to initialize the modules already made in needed order

#include "OOP_Light\OOP_Light.h"

//Initialize the group for logic objects
if(isNil "groupLogic") then
{
	groupLogic = createGroup sideLogic;
};

//Initialize templates
call compile preprocessFileLineNumbers "Templates\initFunctions.sqf";
call compile preprocessFileLineNumbers "Templates\initVariablesServer.sqf";

//Initialize the NATO template
tNATO = call compile preprocessFileLineNumbers "Templates\NATO.sqf";
tCSAT = call compile preprocessFileLineNumbers "Templates\CSAT.sqf";
//a = [classesNATO, T_VEH, T_VEH_default] call t_fnc_select;
//[classesNATO] call t_fnc_checkNil;

//Initialize misc functions
call compile preprocessFileLineNumbers "Misc\initFunctions.sqf";

/*
//Initialize garrison
call compile preprocessFileLineNumbers "Garrison\initFunctions.sqf";
call compile preprocessFileLineNumbers "Garrison\initVariablesServer.sqf";

//Initialize location
call compile preprocessFileLineNumbers "Location\initFunctions.sqf";
call compile preprocessFileLineNumbers "Location\initVariablesServer.sqf";

//Initialize AI scripts
call compile preprocessFileLineNumbers "AI\initFunctions.sqf";
call compile preprocessFileLineNumbers "AI\initVariablesServer.sqf";

//Initialize UI functions
call compile preprocessFileLineNumbers "UI\initFunctions.sqf";

//Initialize sense module
call compile preprocessFileLineNumbers "Sense\initFunctions.sqf";
call compile preprocessFileLineNumbers "Sense\initVariablesServer.sqf";

//Initialize cluster module
call compile preprocessFileLineNumbers "Cluster\initFunctions.sqf";

//Initialize script objects
call compile preprocessFileLineNumbers "scriptObject\scriptObject.sqf";

//Initialize commander scripts
call compile preprocessFileLineNumbers "Commander\initFunctions.sqf";
*/

// Initialize OOP_Light
call compile preprocessFileLineNumbers "OOP_Light\OOP_Light_init.sqf";

// Initialize MessageReceiver class
call compile preprocessFileLineNumbers "MessageReceiver\MessageReceiver.sqf";

// Initialize MessageReceiverEx class
call compile preprocessFileLineNumbers "MessageReceiverEx\MessageReceiverEx.sqf";

// Initialize MessageLoop class
call compile preprocessFileLineNumbers "MessageLoop\MessageLoop.sqf";

// Initialize Unit class
call compile preprocessFileLineNumbers "Unit\Unit.sqf";

// Initialize Group class
call compile preprocessFileLineNumbers "Group\Group.sqf";

// Initialize Garrison class
call compile preprocessFileLineNumbers "Garrison\Garrison.sqf";

// Initialize Location class
call compile preprocessFileLineNumbers "Location\Location.sqf";

// Initialize Timer class
call compile preprocessFileLineNumbers "Timer\Timer.sqf";

// Initialize TimerService class
call compile preprocessFileLineNumbers "TimerService\TimerService.sqf";

// Initialize DebugPrinter class
call compile preprocessFileLineNumbers "DebugPrinter\DebugPrinter.sqf";

// Initialize LocationUnitArrayprovider class
call compile preprocessFileLineNumbers "LocationUnitArrayProvider\LocationUnitArrayProvider.sqf";

// Initialize Goal class
call compile preprocessFileLineNumbers "Goal\Goal.sqf";

// Initialize GoalComposite class
call compile preprocessFileLineNumbers "GoalComposite\GoalComposite.sqf";

// Initialize GoalCompositeSerial class
call compile preprocessFileLineNumbers "GoalCompositeSerial\GoalCompositeSerial.sqf";

// Initialize Goal inherited classes
call compile preprocessFileLineNumbers "GoalsGarrison\initClasses.sqf";
call compile preprocessFileLineNumbers "GoalsGroup\initClasses.sqf";
call compile preprocessFileLineNumbers "GoalsUnit\initClasses.sqf";

// Initialize AnimObject class
call compile preprocessFileLineNumbers "AnimObject\AnimObject.sqf";

// Initialize AnimObject inherited classes
call compile preprocessFileLineNumbers "AnimObjects\initClasses.sqf";