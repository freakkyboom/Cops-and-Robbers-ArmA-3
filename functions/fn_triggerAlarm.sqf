/*
    Funktion: CR_fnc_triggerAlarm
    Zweck: Löst einen Alarm aus und benachrichtigt alle Polizisten.
    Parameter:
        0: ARRAY  - Position des Ereignisses
        1: STRING - Nachricht für die Polizisten
*/

if (!isServer) exitWith {};

params ["_pos", "_message"];

[_pos, _message] remoteExec ["CR_fnc_notifyCops", west];
