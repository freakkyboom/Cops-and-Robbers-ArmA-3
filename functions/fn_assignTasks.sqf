/*
    Funktion: CR_fnc_assignTasks
    Zweck: Erstellt Aufgaben (Tasks) für Spieler, abhängig von ihrer
    Zugehörigkeit (Polizist vs. Räuber).  Die Task‑Struktur orientiert
    sich an dem in der Bohemia‑Community beschriebenen Aufgabenmodell,
    bei dem Aufgaben Zustände wie „created“, „assigned“ und „succeeded“
    annehmen【176927070815116†L340-L404】.  Spieler erhalten visuelle
    Markierungen und Hinweise in der Aufgabenübersicht.

    Voraussetzungen: Im Editor müssen Marker mit folgenden Namen
    vorhanden sein:
       - bank_marker: Standort der Bank, die ausgeraubt werden soll
       - escape_marker: Fluchtpunkt für die Räuber

    Die Tasks werden beim Client erstellt, damit sie individuell pro
    Spieler verwaltet werden können.
*/

if (!hasInterface) exitWith {};

// Lokale Referenzen für Markerpositionen
private _bankPos   = getMarkerPos "bank_marker";
private _escapePos = getMarkerPos "escape_marker";

// Hilfsfunktionen zum Erstellen einer Task
_createTask = {
    params ["_ownerSide", "_taskID", "_desc", "_title", "_short", "_dest"];
    private _task = player createSimpleTask [_taskID];
    _task setSimpleTaskDescription [_desc, _title, _short];
    _task setSimpleTaskDestination _dest;
    _task setTaskState "Assigned";
    _task
};

// Aufgaben zuweisen je nach Seite
private _playerSide = side player;
switch (side player) do
{
    case west:
    {
        // Polizisten: Bank verteidigen und Räuber festnehmen
        CR_copTask1 = [_playerSide, "CR_DefendBank", 
            "Verhindert, dass die Räuber die Bank ausrauben.", 
            "Bank verteidigen", "Bank", _bankPos] call _createTask;
        CR_copTask2 = [_playerSide, "CR_ArrestRobbers", 
            "Nehmt die Räuber fest oder neutralisiert sie.", 
            "Räuber festnehmen", "Festnahme", _bankPos] call _createTask;
    };
    case east:
    {
        // Räuber: Tresor plündern und Beute wegschaffen
        CR_robberTask1 = [_playerSide, "CR_RobBank", 
            "Knackt den Tresor in der Bank und stehlt das Geld.", 
            "Bank ausrauben", "Raub", _bankPos] call _createTask;
        CR_robberTask2 = [_playerSide, "CR_Escape", 
            "Bringt die Beute zum Fluchtfahrzeug.", 
            "Entkommen", "Flucht", _escapePos] call _createTask;
    };
    default
    {
        // Neutrale Spieler erhalten keine spezifische Aufgabe
    };
};