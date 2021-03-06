/*
    Author: iJesuz

    Description:
        Nebenmission gemäß der Hauptmission spawnen

    Parameter(s):
        0 : Array - Hauptmission Position
        1 : String - Aufgabenname

*/
#include "script_component.hpp"
CHECK(true)
SCRIPT(chooseMission);

private ["_aufgabe", "_aufgaben", "_zeit", "_wichtung", "_position", "_positionen", "_locationName", "_location", "_task", "_side_task", "_task_array", "_basisPosition"];

params ["_locationName", "_location", "_task"];
_side_task = FORMAT_1("%1_side", _task);

// Missionsstart zwischen 20min (1200 Sekunden) und 60min (3600 Sekunden) festlegen
_zeit = 1200 + (random 2401);
// _zeit = 60;
uiSleep _zeit;
private "_state";
_state = [_task] call BIS_fnc_taskState;
If (_state in ["CANCELED","SUCCEEDED","FAILED"]) exitWith {};
_basisPosition = getMarkerPos "respawn_west";

_aufgaben = [ "ueberlaeufer", "sdv", "aircraft", "supplies" ];
_wichtung = [ 1, 1, 1, 1 ];
_aufgabe = [_aufgaben, _wichtung] call BIS_fnc_selectRandomWeighted;

switch (_aufgabe) do
{
    case "sdv": {
        _positionen = GETMVAR(GVAR(wasser),[]);    // ["Name",[x,y]]
    };
    case "supplies": {
        _positionen = GETMVAR(GVAR(stadt),[]);    // ["Name",[x,y]]
    };
    default {
        _positionen = (GETMVAR(GVAR(sonstiges),[])) + (GETMVAR(GVAR(industrie),[]));    // ["Name",[x,y]]
    };
};

_position = (selectRandom _positionen);

_counter = 0;
while { (((_position select 1) distance _location) < 6000) AND (((_position select 1) distance _basisPosition) < 6000)  } do {
    _position = selectRandom _positionen;
    _counter = _counter + 1;
    if (_counter > 100) exitWith {};
};

_task_array = [_side_task,_task];

switch (_aufgabe) do
{
    case "ueberlaeufer":
    {
        [(_position select 1) + [0], _task_array] call FUNC(DOUBLES(,sideby,ueberlaeufer));
    };
    case "sdv":
    {
        [(_position select 1) + [0], _task_array] call FUNC(DOUBLES(,sideby,sdv));
    };
    case "aircraft":
    {
        [[(_position select 1) + [0], _task_array]] call FUNC(DOUBLES(,sideby,aircraft));
    };
    case "supplies":
    {
        [(_position select 1) + [0], _task_array, _position select 0] call FUNC(DOUBLES(,sideby,supplies));
    };
};
