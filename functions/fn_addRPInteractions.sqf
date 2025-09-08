/*
    Funktion: CR_fnc_addRPInteractions
    Zweck: Fügt clientseitig einfache RP-Interaktionen hinzu. Aktuell
    erhalten alle Spieler eine ACE-Selbstaktion "Ausweis zeigen", mit der
    sie anderen in der Nähe ihre Identität präsentieren können. Dies soll
    Rollenspielgespräche zwischen Polizisten und Räubern fördern.
*/

if (!hasInterface) exitWith {};
waitUntil { !isNil "ace_interact_menu_fnc_createAction" };

private _action = [
    "showID",
    "Ausweis zeigen",
    "",
    {
        params ["_target", "_player", "_args"];
        [_player] remoteExec ["CR_fnc_showID", 0];
    },
    { true }
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
