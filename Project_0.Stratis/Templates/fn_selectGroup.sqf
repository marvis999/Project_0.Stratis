/*
Selects a group from the template and converts units to standard format if the group is specified as a config

Return value array of [catID, subcatID, classID]
*/

params [["_template", [], [[]]], ["_subcatID", 0, [0]], ["_classID", -1, [0]] ];

private _group = [_template, T_GROUP, _subcatID, _classID] call t_fnc_select;

private _return = 0;
if (_group isEqualType configNull) then {
	_return = [_template, _group] call t_fnc_convertConfigGroup;
} else {
	_return = _group;
};

_return