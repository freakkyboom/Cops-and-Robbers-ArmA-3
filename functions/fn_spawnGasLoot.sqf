/*
    Funktion: CR_fnc_spawnGasLoot
    Zweck: Spawnt eine Kiste mit einer Übungsmine an der Tankstelle
    nach erfolgreichem Raub.
    Parameter:
        0: OBJECT - Tankstellenobjekt
*/

if (!isServer) exitWith {};

params ["_target"];

private _crate = "Box_NATO_Ammo_F" createVehicle (getPos _target);
_crate addItemCargoGlobal ["TrainingMine_Mag", 1];

