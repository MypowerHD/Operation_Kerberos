/*
    Author: Dorbedo
    
    Description:
        adds KnockKnockSound
        
    Parameter(s):
        none
        
    Return
        none
*/
#include "script_component.hpp"
[
    "KnockKnock",
    {
        _this params ["_tank","_knocker"];
        [_tank,_knocker] say3D QGVARMAIN(sound_knockknock);
    }
] call EFUNC(events,addEventHandler);

private _targets = ["Tank"];
private _cfgLog = missionconfigFile >> "logistics" >> "vehicles";

private _Action = [QGVAR(action_knockknock), localize LSTRING(ACTION_KNOCKKNOCK), "", {["KnockKnock",[_target,player]] call EFUNC(events,clientEvent);}, {alive _target}] call ace_interact_menu_fnc_createAction;

for "_i" from 0 to ((count _cfgLog)-1) do {
    private _vehicle = configname(_cfgLog select _i);
    If (isClass(configFile >> "cfgvehicles" >> _vehicle)) then {
        If (({_vehicle isKindOf _x} count _targets)>0) for {
            [_vehicle, 0, ["ACE_MainActions"], _Action] call ace_interact_menu_fnc_addActionToClass;
        };
    };
};