/*
    Author: Dorbedo
    
    Description:
        displays info global
        (is localized on client, if String is given)
    
    Parameter(s):
        0 :    STRING - Title 
        1 :    STRING or Array - Beschreibung
        3 : STRING - Iconpath
        4 : BOOL    - Body for Icon is shown
    
    
    
*/
#include "script_component.hpp"
_this params[["_title","",[""]],["_content","",["",[]]],["_icon","",[""]],["_body",true,[true]]];

If (IS_STRING(_content)) then {_content = [_content];};

[{_this spawn FUNC(disp_info)},[_title,_content,_icon,_body],-1] call EFUNC(events,globalExec);