/*
    Funktion: CR_fnc_addRPInteractions
    Zweck: Fügt clientseitig RP-Interaktionen hinzu. Spieler können
    ihren Ausweis zeigen und Polizisten erhalten eine Verhaftungsaktion
    für zivile Spieler.
*/

if (!hasInterface) exitWith {};

// Ausweis zeigen (Self-Action)
private _idAction = [
    "CR_showID",
    "Ausweis zeigen",
    "",
    {
        params ["_target", "_player", "_params"];
        private _near = (getPos _player) nearEntities ["CAManBase", 5];
        {
            [_player] remoteExec ["CR_fnc_showID", _x];
        } forEach _near;
    },
    {true}
] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _idAction] call ace_interact_menu_fnc_addActionToObject;

// Verhaftung (Action auf Zielspieler)
private _arrestAction = [
    "CR_arrest",
    "Verhaften",
    "",
    {
        params ["_target", "_player", "_params"];
        [_target, _player] remoteExec ["CR_fnc_arrestPlayer", 2];
    },
    {
        params ["_target", "_player", "_params"];
        (side _player == west) && (side _target == civilian) && { _player distance _target < 3 }
    }
] call ace_interact_menu_fnc_createAction;
[player, 0, ["ACE_MainActions"], _arrestAction] call ace_interact_menu_fnc_addActionToObject;

