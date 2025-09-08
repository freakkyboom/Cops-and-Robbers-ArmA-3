/*
    Funktion: CR_fnc_initRobberyTargets
    Zweck: Initialisiert Tankstellen, Geldautomaten und einen platzierten Tresor.
    Bei Interaktion wird ein Alarm ausgelöst.
*/

if (!isServer) exitWith {};

// Objektvariablen aus mission.sqm ermitteln
private _vars = allVariables missionNamespace;

// Tankstellen (NPCs)
{   
    private _obj = missionNamespace getVariable [_x, objNull];
    if (!isNull _obj) then {
        _obj setVariable ["CR_target", "gas", true];
        [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, _obj];
    };
} forEach (_vars select { _x find "gas_station_" == 0 });

// Geldautomaten (platzierte Objekte)
{   
    private _obj = missionNamespace getVariable [_x, objNull];
    if (!isNull _obj) then {
        _obj setVariable ["CR_target", "atm", true];
        [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, _obj];
    };
} forEach (_vars select { _x find "ATM_" == 0 });

// Tresore (platzierte Safes)
{   
    private _obj = missionNamespace getVariable [_x, objNull];
    if (!isNull _obj) then {
        _obj setVariable ["CR_target", "vault", true];
        [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, _obj];
    };
} forEach (_vars select { _x find "tresor" == 0 });

