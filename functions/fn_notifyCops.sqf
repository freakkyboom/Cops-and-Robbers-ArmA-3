/*
    Funktion: CR_fnc_notifyCops
    Zweck: Erstellt clientseitig einen Marker und eine Meldung für Polizisten,
    sobald ein Raub gemeldet wird. Wird über remoteExec vom Server
    auf die Seite BLUFOR ausgeführt.
    Parameter:
        0: ARRAY - Position des Ereignisses (ASL)
        1: STRING - Nachricht, die angezeigt werden soll
*/

params ["_pos", "_message"];

if (side player != west) exitWith {};

private _markerName = format ["robbery_%1", diag_tickTime];
private _m = createMarkerLocal [_markerName, _pos];
_m setMarkerType "mil_warning";
_m setMarkerColor "ColorRed";
_m setMarkerText "Raub";

[_message] call BIS_fnc_showSubtitle;
