/*
    Funktion: CR_fnc_clearCopMarkers
    Zweck: Entfernt alle aktuell gespeicherten Polizeimarker.
*/

if (!hasInterface || side player != west) exitWith {};

if (isNil "CR_policeMarkers") exitWith {};
{
    deleteMarkerLocal _x;
} forEach CR_policeMarkers;
CR_policeMarkers = [];
