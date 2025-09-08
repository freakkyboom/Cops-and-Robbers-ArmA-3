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

params ["_class", "_pos", ["_dir", 0]];

private _veh = createVehicle [_class, _pos, [], 0, "NONE"];
_veh setDir _dir;
_veh
