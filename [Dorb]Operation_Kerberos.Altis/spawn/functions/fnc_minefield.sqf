/*
    Author: Dorbedo
    
    Description:
        Spawns ACE-Minefields
    
    Parameter(s):
        0 : ARRAY    - Centerposition of Minefield
        1 : SCALAR    - Radius
        2 : SCALAR    - Type (0=AT&AP 1=AT 2=AP)
        3 : SCALAR    - Count of Mines
    
    Return
    BOOL
*/
#include "script_component.hpp"
SCRIPT(minefield);
params[["_centerpos",[],[[]],[2,3]],["_spawnrad",25,[0]],["_type",0,[0]],["_anzahl",15,[0]]];
CHECKRET((_centerpos isEqualTo []),false);
Private["_anzahl","_ap_mines","_at_mines","_allmines","_magazineClass","_magazineTrigger","_pos","_dir","_triggerConfig","_triggerSpecificVars","_ammo","_explosive"];

If (_type <1) then {
    _anzahl = _anzahl * 2;
};

_ap_mines = ["APERSBoundingMine_Range_Mag","APERSMine_Range_Mag"];
_at_mines = ["ATMine_Range_Mag","SLAMDirectionalMine_Wire_Mag"];
_allmines = _ap_mines + _at_mines;

_magazineClass="";
for "_i" from 0 to _anzahl do {
    _pos = [_centerpos,_spawnrad,0] call EFUNC(common,pos_random);
    
    If (_type <1) then {
        _magazineClass = selectRandom _allmines;
    }else{
        If (_type <2) then {
            _magazineClass = selectRandom _at_mines;
        }else{
            _magazineClass = selectRandom _ap_mines;
        };
    };
    
    _dir = floor(random 360);
    _triggerConfig = "PressurePlate";
    _triggerSpecificVars = [];

    _magazineTrigger = ConfigFile >> "CfgMagazines" >> _magazineClass >> "ACE_Triggers" >> _triggerConfig;
    _triggerConfig = ConfigFile >> "ACE_Triggers" >> _triggerConfig;

    _ammo = getText(ConfigFile >> "CfgMagazines" >> _magazineClass >> "ammo");
    if (isText(_magazineTrigger >> "ammo")) then {
        _ammo = getText (_magazineTrigger >> "ammo");
    };
    _triggerSpecificVars pushBack _triggerConfig;

    _explosive = createVehicle [_ammo, _pos, [], 0, "NONE"];
    _explosive setPosATL _pos;
    GVARMAIN(side) revealMine _explosive;

    [objNull,_explosive,_magazineClass,_triggerSpecificVars] call compile (getText (_triggerConfig >> "onPlace"));
};
true;
