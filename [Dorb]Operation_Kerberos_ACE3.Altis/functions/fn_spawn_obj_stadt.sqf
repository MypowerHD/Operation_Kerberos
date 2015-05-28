/*
	Author: Dorbedo
	
	Description:
	
	Requirements:
	
	Parameter(s):
		0 : ARRAY	- Example
		1 : ARRAY	- Example
		2 : STRIN	- Example
	
	Return
	BOOL
*/
#include "makros.hpp"

private["_position","_gebaeudepos_arr","_difficulty"];

_position = _this select 0;
_gebaeudepos_arr = _this select 1;

d_log(FORMAT_2("Spawn Stadt / Pos=%1 / Gebauedearr=%2",_position,_gebaeudepos_arr))

_difficulty = [] call dorb_fnc_difficulty;

[_position,800,5,1] spawn FM(spawn_patrol_inf);	sleep 10;
[_position,1000,2,0] spawn FM(spawn_patrol_veh);	sleep 10;

If (_difficulty > 1) then {
	[_position,800,3,2] spawn FM(spawn_patrol_inf);	sleep 10;
	[_position,1000,1,1] spawn FM(spawn_patrol_veh);	sleep 10;
};
If (_difficulty > 2) then {
	[_position,800,2,2] spawn FM(spawn_patrol_inf);	sleep 10;
	[_position,1000,0,3] spawn FM(spawn_patrol_veh);	sleep 10;
};

/*
[_position,1000,4,2] spawn FM(spawn_patrol_veh);
sleep 10;
[_position,800,10,4] spawn FM(spawn_patrol_inf);
sleep 10;
*/
[_position] spawn FM(spawn_commandveh);



_gebaeudepos_arr = [_gebaeudepos_arr,5,(8+_difficulty)] call FM(spawn_rooftop);

_gebaeudepos_arr = [_gebaeudepos_arr,15,(40 + (_difficulty*2))] call FM(spawn_in_building);

