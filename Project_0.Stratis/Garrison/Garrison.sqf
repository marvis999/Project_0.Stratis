/*
Author: Sparker 12.07.2018

Garrison is an object which holds units and groups and handles their lifecycle (spawning, despawning, destruction).
Garrison typically is located in one area and is performing one task.
*/

#include "..\OOP_Light\OOP_Light.h"
#include "..\Message\Message.hpp"
#include "..\MessageTypes.hpp"

CLASS("Garrison", "MessageReceiverEx")

	VARIABLE("units");
	VARIABLE("groups");
	VARIABLE("spawned");
	VARIABLE("side");
	VARIABLE("debugName");
	VARIABLE("location");
	VARIABLE("goal"); // Top level goal of this garrison
	
	// ----------------------------------------------------------------------
	// |                 S E T   D E B U G   N A M E                        |
	// ----------------------------------------------------------------------
	
	METHOD("setDebugName") {
		params [["_thisObject", "", [""]], ["_debugName", "", [""]]];
		SET_VAR(_thisObject, "debugName", _debugName);
	} ENDMETHOD;

	// ----------------------------------------------------------------------
	// |                              N E W                                 |
	// ----------------------------------------------------------------------
	
	METHOD("new") {
		params [["_thisObject", "", [""]], ["_side", WEST, [WEST]]];
		
		// Check existance of neccessary global objects
		if (isNil "gMessageLoopMain") exitWith {"[Garrison] Error: global main message loop doesn't exist!";};
		if (isNil "gMessageLoopGoal") exitWith { diag_log "[Garrison] Error: global garrison goal message loop doesn't exist!"; };
		
		SET_VAR(_thisObject, "units", []);
		SET_VAR(_thisObject, "groups", []);
		SET_VAR(_thisObject, "spawned", false);
		SET_VAR(_thisObject, "side", _side);
		SET_VAR(_thisObject, "debugName", "");
		SET_VAR(_thisObject, "goal", "");
	} ENDMETHOD;
	
	// ----------------------------------------------------------------------
	// |                            D E L E T E                             |
	// ----------------------------------------------------------------------
	
	METHOD("delete") {
		params [["_thisObject", "", [""]]];
		SET_VAR(_thisObject, "units", nil);
		SET_VAR(_thisObject, "groups", nil);	
		SET_VAR(_thisObject, "spawned", nil);
		SET_VAR(_thisObject, "side", nil);
		SET_VAR(_thisObject, "debugName", nil);
		
		// Delete the goal object of this garrison
		private _goal = GET_VAR(_thisObject, "goal");
		if (_goal != "") then {
			// Since garrison's goals are processed in another thread, we must wait until the thread properly terminates this goal.
			private _msg = MESSAGE_NEW();
			_msg set [MESSAGE_ID_DESTINATION, _goal];
			_msg set [MESSAGE_ID_TYPE, GOAL_MESSAGE_DELETE];
			private _msgID = CALLM(_goal, "postMessage", _msg);
			CALLM(_goal, "waitUntilMessageDone", [_msgID]);
		};
	} ENDMETHOD;
	
	// Returns the message loop this object is attached to
	METHOD("getMessageLoop") {
		gMessageLoopMain
	} ENDMETHOD;
	
	// Getting values
	
	// getSide
	METHOD("getSide") {
		params [["_thisObject", "", [""]]];
		GET_VAR(_thisObject, "side")
	} ENDMETHOD;
	
	// Sets the location of this garrison
	METHOD("setLocation") {
		params [["_thisObject", "", [""]], ["_location", "", [""]] ];
		SET_VAR(_thisObject, "location", _location);
	} ENDMETHOD;
	
	// Handles incoming messages. Since it's a MessageReceiverEx, we must overwrite handleMessageEx
	METHOD_FILE("handleMessageEx", "Garrison\handleMessageEx.sqf");
	
	// Spawns the whole garrison
	METHOD_FILE("spawn", "Garrison\spawn.sqf");
	
	// Despawns the whole garrison
	METHOD_FILE("despawn", "Garrison\despawn.sqf");
	
	// Adds an existing group into the garrison
	METHOD_FILE("addGroup", "Garrison\addGroup.sqf");
	
	// Adds an existing unit into the garrison
	METHOD_FILE("addUnit", "Garrison\addUnit.sqf");
	
	//Removes an existing unit from this garrison
	METHOD_FILE("removeUnit", "Garrison\removeUnit.sqf");
	
	// Move unit between garrisons
	METHOD_FILE("moveUnit", "Garrison\moveUnit.sqf");

ENDCLASS;