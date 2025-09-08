/*
    Funktion: CR_fnc_addArsenalAction
    Zweck: Fügt einem Objekt eine ACE-Aktion zum Öffnen des fraktionsspezifischen Arsenals hinzu.
    Parameter:
        0: OBJECT - Arsenal-Objekt
        1: SIDE   - Fraktion, die Zugriff hat
*/

if (!hasInterface) exitWith {};
waitUntil { !isNil "ace_interact_menu_fnc_createAction" };
params ["_box", "_side"];
if (side player != _side) exitWith {};

private _action = [
    "openArsenal",
    "Arsenal öffnen",
    "",
    { [_target, _player] call CR_fnc_openArsenal },
    { true }
] call ace_interact_menu_fnc_createAction;

[_box, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
