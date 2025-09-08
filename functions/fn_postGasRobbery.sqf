/*
    Funktion: CR_fnc_postGasRobbery
    Zweck: Wird vom Server aufgerufen, wenn der Tankstellenraub
    erfolgreich abgeschlossen wurde. Wählt ein zufälliges Safehouse,
    spawnt dort einen Laptop und weist neue Tasks zu.
    Parameter:
        0: ARRAY - Position des Überfalls
*/

if (!isServer) exitWith {};
params ["_robPos"];

// Ein Safehouse mindestens 5 km entfernt suchen
private _houses = nearestObjects [_robPos, ["House"], 20000];
_houses = _houses select { _x distance2D _robPos > 5000 };
_houses = _houses call BIS_fnc_arrayShuffle;
if (_houses isEqualTo []) exitWith {};

private _house = _houses select 0;
private _safePos = getPos _house;

private _laptop = "Land_Laptop_03_black_F" createVehicle _safePos;
// Aktion auf allen Clients hinzufügen
[_laptop] remoteExec ["CR_fnc_addLaptopAction", 0, _laptop];

// Tasks zuweisen
[_safePos] remoteExec ["CR_fnc_assignSafehouseTask", civilian];
[_robPos]  remoteExec ["CR_fnc_assignInterceptTask", west];
