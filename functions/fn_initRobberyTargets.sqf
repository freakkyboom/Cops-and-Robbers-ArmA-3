/*
    Funktion: CR_fnc_initRobberyTargets
    Zweck: Initialisiert Tankstellen, Geldautomaten und einen zufälligen Tresor.
    Bei Interaktion wird ein Alarm ausgelöst.
*/

if (!isServer) exitWith {};

// Tankstellen
private _gasMarkers = ["gas_station_1", "gas_station_2", "gas_station_3"];
{
    private _pos = getMarkerPos _x;
    private _obj = "Land_FuelStation_Feed_F" createVehicle _pos;
    _obj setVariable ["CR_target", "gas", true];
    [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, _obj];
} forEach _gasMarkers;

// Geldautomaten
private _atmMarkers = ["atm_1", "atm_2", "atm_3", "atm_4", "atm_5"];
{
    private _pos = getMarkerPos _x;
    private _obj = "Land_ATM_01_F" createVehicle _pos;
    _obj setVariable ["CR_target", "atm", true];
    [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, _obj];
} forEach _atmMarkers;

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

