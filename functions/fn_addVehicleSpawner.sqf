/*
    Funktion: CR_fnc_addVehicleSpawner
    Zweck: Fügt einem Objekt eine ACE-Interaktion "Fahrzeug spawnen" hinzu,
    die ein bestimmtes Fahrzeug auf dem Server erzeugt. Die Interaktion ist
    nur für eine bestimmte Seite sichtbar.
    Parameter:
        0: OBJECT - Spawnobjekt
        1: STRING - Fahrzeugklasse
        2: STRING - Seitenname ("west" oder "civilian")
*/

params ["_pad", "_class", "_sideName"];
if (!hasInterface) exitWith {};

private _allowedSide = call compile _sideName;

private _action = [
    format ["CR_spawn_%1", _class],
    "Fahrzeug spawnen",
    "",
    {
        params ["_target", "_player", "_params"];
        _params params ["_class", "_allowedSide"];
        if (side _player != _allowedSide) exitWith {};
        [_class, getPos _target, direction _target] remoteExec ["CR_fnc_spawnVehicle", 2];
    },
    {
        params ["_target", "_player", "_params"];
        _params params ["_class", "_allowedSide"];
        side _player == _allowedSide
    },
    {},
    [_class, _allowedSide]
] call ace_interact_menu_fnc_createAction;

[_pad, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

