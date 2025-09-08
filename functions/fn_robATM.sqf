/*
    Funktion: CR_fnc_robATM
    Zweck: Führt einen ATM-Raub mit ACE-Fortschrittsanzeige durch.
    Parameter:
        0: OBJECT - ATM-Objekt
        1: OBJECT - raubender Spieler
*/

params ["_target", "_caller"];

if (!hasInterface) exitWith {};
if (side _caller != civilian) exitWith {};
if (_target getVariable ["robbed", false]) exitWith { hint "Bereits geknackt"; };

_target setVariable ["robbed", true, true];

[
    45,
    [_target, _caller],
    {
        params ["_args"];
        _args params ["_target", "_caller"];
        [getPos _target, "Ein ATM wird geknackt!"] remoteExec ["CR_fnc_triggerAlarm", 2];
        private _money = "Land_Money_F" createVehicle (getPos _target);
        _money setVariable ["CR_atmLoot", true, true];
    },
    {
        params ["_args"];
        _args params ["_target", "_caller"];
        _target setVariable ["robbed", false, true];
        hint "ATM-Hack fehlgeschlagen!";
    },
    "ATM wird gehackt...",
    {
        params ["_args"];
        _args params ["_target", "_caller"];
        alive _caller && _caller distance _target < 3
    }
] call ace_common_fnc_progressBar;
