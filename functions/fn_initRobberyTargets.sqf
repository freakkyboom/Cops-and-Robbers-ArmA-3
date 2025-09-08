/*
    Funktion: CR_fnc_initRobberyTargets
    Zweck:    Sucht in der mission.sqm nach benannten Zielen und
              statte sie mit ACE-Raubaktionen aus.
              Unterstützte Präfixe:
                - gas_station_* für Tankstellen-NPCs
                - atm_*         für Geldautomaten

    Diese Funktion wird nur auf dem Server ausgeführt.
*/

if (!isServer) exitWith {};


{
    private _name = vehicleVarName _x;
    if (_name find "gas_station_" == 0) then {
        _x setVariable ["CR_target", "gas", true];
        [_x] remoteExec ["CR_fnc_addRobberyActions", 0, true];
    };

    if (_name find "atm_" == 0) then {
        _x setVariable ["CR_target", "atm", true];
        [_x] remoteExec ["CR_fnc_addRobberyActions", 0, true];
    };
} forEach _allObjects;
=======
} forEach (_vars select { _x find "gas_station_" == 0 });

// Geldautomaten (platzierte Objekte)
{
    private _obj = missionNamespace getVariable [_x, objNull];
    if (!isNull _obj) then {
        _obj setVariable ["CR_target", "atm", true];
        [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, _obj];
    };
} forEach (_vars select { _x find "atm_" == 0 });


// Tresor zufällig innerhalb des Bereichs platzieren
private _areaCenter = getMarkerPos "vault_area";
private _areaSize   = getMarkerSize "vault_area";
private _vaultPos = [
    (_areaCenter select 0) + (random ((_areaSize select 0) * 2) - (_areaSize select 0)),
    (_areaCenter select 1) + (random ((_areaSize select 1) * 2) - (_areaSize select 1)),
    0
];
private _vault = "Land_Safe_F" createVehicle _vaultPos;
_vault setVariable ["CR_target", "vault", true];
[_vault] remoteExec ["CR_fnc_addRobberyActions", 0, true];

