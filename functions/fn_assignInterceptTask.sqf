/*
    Funktion: CR_fnc_assignInterceptTask
    Zweck: Weist den Polizisten nach einem erfolgreichen Überfall einen
    neuen Task zum Abfangen der Räuber zu.
    Parameter:
        0: ARRAY - Position des Überfalls (für letzte bekannte Position)
*/

params ["_pos"];
if (!hasInterface || side player != west) exitWith {};

if (!isNil "CR_copTaskPrevent") then {
    CR_copTaskPrevent setTaskState "Failed";
};

CR_copTaskIntercept = player createSimpleTask ["CR_InterceptRobbers"];
CR_copTaskIntercept setSimpleTaskDescription [
    "Finde und stoppe die Räuber, bevor sie entkommen.",
    "Räuber abfangen",
    "Abfangen"
];
CR_copTaskIntercept setSimpleTaskDestination _pos;
CR_copTaskIntercept setTaskState "Assigned";
