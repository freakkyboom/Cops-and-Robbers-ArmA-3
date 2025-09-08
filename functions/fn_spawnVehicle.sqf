/*
    Funktion: CR_fnc_spawnVehicle
    Zweck: Spawnt ein Fahrzeug auf dem Server. Wird vom Vehicle-Spawner
    via remoteExec aufgerufen.
    Parameter:
        0: STRING - Klassenname des Fahrzeugs
        1: ARRAY  - Position (ATL)
        2: NUMBER - Richtung in Grad
*/

if (!isServer) exitWith {};

params ["_class", "_spawnPos", ["_dir", 0], ["_texture", ""]];

// Sicheren Spawnplatz finden
private _safePos = [_spawnPos, 3, 10, 3, 0, 0.3, 0] call BIS_fnc_findSafePos;
if (_safePos isEqualTo []) then { _safePos = _spawnPos; };

// Fahrzeuge in der Nähe aufräumen
{
    if (_x distance _safePos < 15 && !isPlayer _x) then {
        deleteVehicle _x;
    };
} forEach vehicles;

private _veh = createVehicle [_class, _safePos, [], 0, "NONE"];
_veh setDir _dir;
_veh setPosATL [_safePos select 0, _safePos select 1, 0];

if (_texture != "") then {
    _veh setObjectTextureGlobal [0, _texture];
};

_veh addEventHandler ["HandleDamage", { false }];
_veh setVariable ["CR_spawnedVehicle", true, true];

_veh
