/*
    Funktion: CR_fnc_addLaptopAction
    Zweck: Fügt dem Safehouse-Laptop eine Aktion hinzu, die nur von
    Räubern genutzt werden kann.
    Parameter:
        0: OBJECT - Laptop
*/

params ["_laptop"];
if (!hasInterface) exitWith {};

_laptop addAction [
    "Daten löschen",
    {
        params ["_target", "_caller", "_actionId", "_args"];
        if (side _caller != civilian) exitWith {};
        [_caller] remoteExec ["CR_fnc_safehouseSuccess", 2];
    }
];
