/*
Gets a spawn position for a unit of specified category and subcategory.

Return value:
[[x, y, z], direction]

Author: Sparker 29.07.2018
*/

#include "..\OOP_Light\OOP_Light.h"
#include "..\Group\Group.hpp"
#include "Location.hpp"

params [["_thisObject", "", [""]], ["_catID", 0, [0]], ["_subcatID", 0, [0]], ["_className", "", [""]], ["_groupType", GROUP_TYPE_IDLE, [GROUP_TYPE_IDLE]] ];

//First try to find it in building spawn positions
private _stAll = GET_VAR(_thisObject, "spawnPosTypes");

//Local variables
private _stCurrent = [];
private _stFound = []; //The return value
private _types = [];

//Find spawn position which has specified unit type
private _count = count _stAll;
private _count1 = 0;
private _i = 0;
private _j = 0;
private _found = false;
private _ignoreGT = (_catID == T_VEH); //Ignore the group type check for this unit
private _posReturn = [];
private _dirReturn = 0;


if(_catID == T_INF) then //For infantry we use the counter to check for free position, because inf can be spawned everywhere without blowing up
{
	while {_i < _count && !_found} do {
		_stCurrent = _stAll select _i;
		_types = _stCurrent select LOCATION_SPT_ID_UNIT_TYPES;
		_count1 = count _types;
		_j = 0;
		if([_catID, _subcatID] in _types &&
		   ( _groupType in (_stCurrent select LOCATION_SPT_ID_GROUP_TYPES)) &&
		   ((count (_stCurrent select LOCATION_SPT_ID_SPAWN_POS)) != (_stCurrent select LOCATION_SPT_ID_COUNTER))) then { //If maximum amount hasn't been reached
			private _spawnPositions = _stCurrent select LOCATION_SPT_ID_SPAWN_POS;
			private _nextFreePosID = _stCurrent select LOCATION_SPT_ID_COUNTER;
			private _posArray = (_spawnPositions select _nextFreePosID);
			_posReturn = _posArray select LOCATION_SP_ID_POS;
			_dirReturn = _posArray select LOCATION_SP_ID_DIR;			
			_stCurrent set [LOCATION_SPT_ID_COUNTER, _nextFreePosID + 1]; //Increment the counter
			_found = true;
		};
		_i = _i + 1;
	};
} else { //For vehicles we use a special loc_fnc_isPosSafe function that checks if this place is occupied by something else
	while {_i < _count && !_found} do {
		_stCurrent = _stAll select _i;
		_types = _stCurrent select LOCATION_SPT_ID_UNIT_TYPES;
		_j = 0;
		if([_catID, _subcatID] in _types &&
			( _groupType in (_stCurrent select LOCATION_SPT_ID_GROUP_TYPES))) then {
			//Find the first free spawn position
			{
				private _posArray = _x;
				
				if ([_catID, _subcatID] in [[T_VEH, T_VEH_stat_GMG_high], [T_VEH, T_VEH_stat_HMG_high]]) then {
					diag_log format ["Checking position for HMG/GMG: %1 ...", _posArray];
				};
				
				private _pos = _posArray select LOCATION_SP_ID_POS;
				private _dir = _posArray select LOCATION_SP_ID_DIR;
				// Check if given position is safe to spawn the unit here
				private _args = [_pos, _dir, _className];
				private _posFree = CALL_STATIC_METHOD("Location", "isPosSafe", _args);
				if(_posFree) exitWith {
					if ([_catID, _subcatID] in [[T_VEH, T_VEH_stat_GMG_high], [T_VEH, T_VEH_stat_HMG_high]]) then {
						diag_log "Position is free!";
					};
				
					_posReturn = _pos;
					_dirReturn = _dir;
					_found = true;
					private _nextFreePosID = _stCurrent select LOCATION_SPT_ID_COUNTER;
					_stCurrent set [LOCATION_SPT_ID_COUNTER, _nextFreePosID + 1]; //Increment the counter, although it doesn't matter here
				};
				
				if ([_catID, _subcatID] in [[T_VEH, T_VEH_stat_GMG_high], [T_VEH, T_VEH_stat_HMG_high]]) then {
					diag_log "Position is occupied!";
				};
			} forEach (_stCurrent select LOCATION_SPT_ID_SPAWN_POS);
		};
		_i = _i + 1;
	};
};

//diag_log format ["123: %1", _stCurrent];
/*
Old code that finds spawn positions based on counter.
//todo delete it
if(_found) then //If the category has been found
{
	private _spawnPositions = _stCurrent select 1;
	private _nextFreePosID = _stCurrent select 2;
	_return = (_spawnPositions select _nextFreePosID) select [0, 4]; //Because the last element is _isInBuilding, which we don't need to return
	_stCurrent set [2, _nextFreePosID + 1]; //Increment the counter
}
else
{
	//Provide default spawn position
	private _r = 15; //0.5 * (_o getVariable ["l_radius", 0]);
	_return = ((getPos _o) vectorAdd [-_r + (random (2*_r)), -_r + (random (2*_r)), 0]) + [0];
	diag_log format ["fn_getSpawnPosition.sqf: warning: spawn position not defined for this type or maximum amount was reached: %1. Returning default position.", [_catID, _subcatID, _groupType]];
};

*/

private _return = 0;
if(_found) then {//If the spawn position has been found
		_return = [_posReturn, _dirReturn];
} else {
	//Provide default spawn position
	private _r = (0.5 * (GET_VAR(_thisObject, "boundingRadius"))) min 60;
	private _locPos = GET_VAR(_thisObject, "pos");
	_return = [ ( _locPos vectorAdd [-_r + (random (2*_r)), -_r + (random (2*_r)), 0] ), 0];
	diag_log format ["[Location::getSpawnPos] Warning: spawn position not for unit: %1. Returning default position.", [_catID, _subcatID, _groupType]];
};

_return