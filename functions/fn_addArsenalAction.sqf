/*
    Funktion: CR_fnc_addArsenalAction (Debug-Version)
    Zweck: Fügt einem Objekt eine ACE-Aktion zum Öffnen des fraktionsspezifischen Arsenals hinzu.
    Parameter:
        0: OBJECT - Arsenal-Objekt
        1: SIDE   - Fraktion, die Zugriff hat
*/
params ["_box", "_side"];
diag_log format ["[CR] addArsenalAction called: box=%1, side=%2, playerSide=%3", _box, _side, side player];

// Prüfe ACE
if (isNil "ace_interact_menu_fnc_createAction") then {
    diag_log "[CR][ERROR] ACE interact menu not available!";
    exitWith {};
};

if (!hasInterface) then {
    diag_log "[CR] No interface, exiting addArsenalAction";
    exitWith {};
};

// Prüfe Seite
if (side player != _side) then {
    diag_log format ["[CR] Player side %1 != required side %2, exiting", side player, _side];
    exitWith {};
};

// Warte auf ACE (zusätzliche Sicherheit)
waitUntil { !isNil "ace_interact_menu_fnc_createAction" };

try {
    private _action = [
        "openArsenal",
        "Arsenal öffnen",
        "",
        { 
            params ["_target", "_player"];
            diag_log format ["[CR] Arsenal action triggered by %1 on %2", name _player, _target];
            [_target, _player] call CR_fnc_openArsenal;
        },
        { true }
    ] call ace_interact_menu_fnc_createAction;
    
    [_box, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    
    diag_log format ["[CR] Arsenal action successfully added to %1 for %2", _box, name player];
} catch {
    diag_log format ["[CR][ERROR] Failed to add arsenal action: %1", _exception];
};