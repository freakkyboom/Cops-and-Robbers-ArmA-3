if (!isServer) exitWith {};
params ["_obj"]; if (isNull _obj) exitWith {};
private _old = _obj getVariable ["CR_sirenThread", scriptNull]; if (!isNull _old) then {terminate _old;};
private _h = [_obj] spawn { params ["_o"]; while {_o getVariable ["CR_robbing",false]} do { [_o] remoteExecCall ["CR_fnc_saySirenLocal",0]; sleep 5; }; };
_obj setVariable ["CR_sirenThread", _h, true];
