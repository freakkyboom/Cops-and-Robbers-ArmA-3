/*
    Funktion: CR_fnc_assignSafehouseTask
    Zweck: Weist den Räubern einen Task zu, das Safehouse zu erreichen
    und dort den Laptop zu benutzen.
    Parameter:
        0: ARRAY - Position des Safehouses
*/

params ["_pos"];
if (!hasInterface || side player != civilian) exitWith {};

if (!isNil "CR_robTaskRob") then {
    CR_robTaskRob setTaskState "Succeeded";
};

CR_robTaskSafehouse = player createSimpleTask ["CR_Safehouse"];
CR_robTaskSafehouse setSimpleTaskDescription [
    "Fahre zum Safehouse und interagiere mit dem Laptop, um die Fahndung zu beenden.",
    "Zum Safehouse",
    "Safehouse"
];
CR_robTaskSafehouse setSimpleTaskDestination _pos;
CR_robTaskSafehouse setTaskState "Assigned";
