/*
	Author: Dorbedo

	Description:
	

	Parameter(s):
		0 : ARRAY - Position
		1 : ARRAY/STRING - type of spawn
	Returns:
	none
*/
#include "script_component.hpp"
SCRIPT(mission);
params[["_centerposition",[],[[]],[2,3]],["_type","",["",[]]]];

CHECK(_centerpos isEqualTo [])

private["_amount_defence","_amount_max","_amount_patrols","_amount_players","_amount_strikeforce",
		"_count_defence","_count_patrols","_count_strikeforce","_mult","_mult_player"];


_amount_patrols = getNumber(missionConfigFile >> "unitlists" >> GVARMAIN(side) >> GVARMAIN(side_type) >> "amount_patrols");
_amount_strikeforce = getNumber(missionConfigFile >> "unitlists" >> GVARMAIN(side) >> GVARMAIN(side_type) >> "amount_strikeforce");
_amount_defence = getNumber(missionConfigFile >> "unitlists" >> GVARMAIN(side) >> GVARMAIN(side_type) >> "amount_defence");

_amount_max = _amount_patrols + _amount_strikeforce + _amount_defence;

_mult = 45/_amount_max;

_amount_players = count([] call EFUNC(common,players));
_mult_player = switch (true) do {
	case (_amount_players>25) : {1};
	case (_amount_players<15) : {0.7};
	case (_amount_players<8) : {0.4} 
	default {0.2};
};

_count_patrols = _amount_patrols * _mult * _mult_player;
_count_strikeforce = _amount_strikeforce * _mult * _mult_player;
_count_defence = _amount_defence * _mult * _mult_player * 0.2;

If (IS_STRING(_type)) then {
	_type = [_type];
};
{
	switch (toLower _x) do {
		case "defence" : {
			[_centerposition,_count_defence] call EFUNC(spawn,defence_create);
		};
		case "patrols" : {
			[_centerposition,_count_patrols] call EFUNC(spawn,patrol_create);
		};
		case "strikeforce" : {
			[_centerposition,_count_strikeforce] call EFUNC(spawn,strikeforce_create);
		};
	};
}forEach _type;
true