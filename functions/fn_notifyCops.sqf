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

// Marker erzeugen und Namen speichern, damit er später gelöscht werden kann
if (isNil "CR_policeMarkers") then { CR_policeMarkers = [] };
private _markerName = format ["robbery_%1", diag_tickTime];
private _m = createMarkerLocal [_markerName, _pos];
_m setMarkerType "mil_warning";
_m setMarkerColor "ColorRed";
_m setMarkerText "Raub";
CR_policeMarkers pushBack _markerName;

// Aufgabe zum Verhindern des Überfalls zuweisen
if (isNil "CR_copTaskPrevent") then {
    CR_copTaskPrevent = player createSimpleTask ["CR_PreventRobbery"];
    CR_copTaskPrevent setSimpleTaskDescription [
        "Verhindere den Überfall auf die markierte Position.",
        "Überfall verhindern",
        "Überfall"
    ];
};
CR_copTaskPrevent setSimpleTaskDestination _pos;
CR_copTaskPrevent setTaskState "Assigned";

[_message] call BIS_fnc_showSubtitle;
