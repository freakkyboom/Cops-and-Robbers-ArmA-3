/*
    Funktion: CR_fnc_assignTasks
    Zweck: Erstellt einfache Aufgaben für Polizisten und Räuber.
*/

if (!hasInterface) exitWith {};

_createTask = {
    params ["_taskID", "_desc", "_title", "_short", "_dest"];
    private _task = player createSimpleTask [_taskID];
    _task setSimpleTaskDescription [_desc, _title, _short];
    _task setSimpleTaskDestination _dest;
    _task setTaskState "Assigned";
    _task
};

switch (side player) do
{
    case west:
    {
        CR_copTask1 = ["CR_Respond", "Reagiere auf Alarme und verhindere Raubüberfälle.",
            "Raubüberfälle verhindern", "Cops", getMarkerPos "cop_spawn"] call _createTask;
    };
    case civilian:
    {
        CR_robTask1 = ["CR_RobTargets", "Raube Tankstellen, ATMs oder den Tresor aus.",
            "Raubzüge durchführen", "Raub", getMarkerPos "robber_spawn"] call _createTask;
    };
    default {};
};
