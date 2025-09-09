/*
    Funktion: CR_fnc_finishSafehouseCops
    Zweck: Setzt den Abfang-Task der Polizei auf "Failed" und entfernt
    alle Marker. Anschließend wird die Streifenaufgabe wieder aktiviert.
*/

if (!hasInterface || side player != west) exitWith {};

if (!isNil "CR_copTaskIntercept") then {
    CR_copTaskIntercept setTaskState "Failed";
};

// Alle Fahndungsmarker entfernen
[] call CR_fnc_clearCopMarkers;

// Streifenaufgabe erneut zuweisen
if (!isNil "CR_copTaskPatrol") then {
    CR_copTaskPatrol setTaskState "Assigned";
