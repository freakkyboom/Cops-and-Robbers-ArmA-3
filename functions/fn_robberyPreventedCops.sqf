/*
    Funktion: CR_fnc_robberyPreventedCops
    Zweck: Aktualisiert Polizeiaufgaben, wenn ein Überfall vereitelt wurde.
*/

if (!hasInterface || side player != west) exitWith {};

if (!isNil "CR_copTaskPrevent") then {
    CR_copTaskPrevent setTaskState "Succeeded";
};

// Marker entfernen und Streifenaufgabe aktiv lassen
[] call CR_fnc_clearCopMarkers;
if (!isNil "CR_copTaskPatrol") then {
    CR_copTaskPatrol setTaskState "Assigned";
};
