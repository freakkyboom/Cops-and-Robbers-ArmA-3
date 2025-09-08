/*
    Funktion: CR_fnc_safehouseSuccess
    Zweck: Wird vom Server aufgerufen, wenn ein Räuber im Safehouse den
    Laptop benutzt hat. Aktualisiert die Tasks und entfernt Marker.
    Parameter:
        0: OBJECT - Räuber, der die Aktion ausgeführt hat (nicht genutzt)
*/

if (!isServer) exitWith {};

// Aufgaben aktualisieren
[] remoteExec ["CR_fnc_finishSafehouseRobber", civilian];
[] remoteExec ["CR_fnc_finishSafehouseCops", west];
