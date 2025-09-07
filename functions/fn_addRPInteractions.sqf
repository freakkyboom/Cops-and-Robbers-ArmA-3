/*
    Funktion: CR_fnc_addRPInteractions
    Zweck: Fügt clientseitig einfache RP-Interaktionen hinzu. Aktuell
    erhalten alle Spieler eine Aktion "Ausweis zeigen", mit der sie
    anderen in der Nähe ihre Identität präsentieren können. Dies soll
    Rollenspielgespräche zwischen Polizisten und Räubern fördern.
*/

if (!hasInterface) exitWith {};

player addAction [
    "Ausweis zeigen",
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        [_caller] remoteExec ["CR_fnc_showID", 0];
    }
];
