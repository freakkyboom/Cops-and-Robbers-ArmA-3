/*
    Funktion: CR_fnc_finishSafehouseRobber
    Zweck: Schließt den Safehouse-Task für Räuber ab.
*/

if (!hasInterface || side player != civilian) exitWith {};

if (!isNil "CR_robTaskSafehouse") then {
    CR_robTaskSafehouse setTaskState "Succeeded";
};
