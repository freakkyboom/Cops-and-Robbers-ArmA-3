/*
    Funktion: CR_fnc_robGasStation
    Zweck: Führt den Tankstellenraub mit einer Fortschrittsanzeige durch
    und löst einen Alarm aus. Nach Ablauf von 150 Sekunden wird auf dem
    Server eine Kiste mit einer Übungsmine gespawnt.
    Parameter:
        0: OBJECT - Tankstellenobjekt
        1: OBJECT - auslösender Spieler
*/

params ["_target", "_caller"];

if (!hasInterface) exitWith {};

// Alarm für Polizisten auslösen
[getPos _target, "Überfall auf eine Tankstelle!"] remoteExec ["CR_fnc_triggerAlarm", 2];

[
    150,
    _target,
    {
        // fertig
        params ["_target", "_caller"];
        [_target] remoteExec ["CR_fnc_spawnGasLoot", 2];
        [getPos _target] remoteExec ["CR_fnc_postGasRobbery", 2];
    },
    {
        // abgebrochen
        params ["_target", "_caller"];
        _target setVariable ["robbed", false, true];
        [] remoteExec ["CR_fnc_robberyPreventedCops", west];
    },
    "Tankstelle wird ausgeraubt...",
    _target,
    _caller
] call ace_common_fnc_progressBar;

