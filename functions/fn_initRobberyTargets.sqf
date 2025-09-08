/*
    Funktion: CR_fnc_initRobberyTargets
    Zweck: Initialisiert Tankstellen, Geldautomaten und einen zufälligen Tresor.
    Bei Interaktion wird ein Alarm ausgelöst.
*/

if (!isServer) exitWith {};

// Tankstellen (NPCs)
private _gasTargets = ["gas_station_1", "gas_station_2", "gas_station_3"];
{
    private _obj = missionNamespace getVariable [_x, objNull];
    if (!isNull _obj) then {
        _obj setVariable ["CR_target", "gas", true];
        [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, _obj];
    };
} forEach _gasTargets;

// Geldautomaten (platzierte Objekte)
private _atmTargets = ["ATM_1", "ATM_2", "ATM_3", "ATM_4", "ATM_5"];
{
    private _obj = missionNamespace getVariable [_x, objNull];
    if (!isNull _obj) then {
        _obj setVariable ["CR_target", "atm", true];
        [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, _obj];
    };
} forEach _atmTargets;

// Tresor zufällig platzieren
private _areaCenter = getMarkerPos "vault_area";
private _areaSize = getMarkerSize "vault_area";
private _vaultPos = [
    (_areaCenter select 0) + (random ((_areaSize select 0) * 2) - (_areaSize select 0)),
    (_areaCenter select 1) + (random ((_areaSize select 1) * 2) - (_areaSize select 1)),
    0
];
private _vault = "Land_Safe_F" createVehicle _vaultPos;
_vault setVariable ["CR_target", "vault", true];
[_vault] remoteExec ["CR_fnc_addRobberyActions", 0, _vault];

