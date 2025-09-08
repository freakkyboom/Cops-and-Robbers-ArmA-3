/*
    Funktion: CR_fnc_setupTeams
    Zweck: Erzeugt Polizisten- und Räuber-Teams, weist ihnen Spawnpunkte zu
    und richtet Arsenal sowie Fahrzeug-Spawner ein.
    Benötigte Marker:
        cop_spawn, robber_spawn,
        cop_arsenal, robber_arsenal,
        cop_vehicle_spawn, robber_vehicle_spawn
*/

if (!isServer) exitWith {};

private _copSpawn    = getMarkerPos "cop_spawn";
private _robberSpawn = getMarkerPos "robber_spawn";

{
    if (isPlayer _x) then
    {
        switch (side _x) do
        {
            case west:
            {
                _x setPosATL _copSpawn;
                _x removeAllWeapons;
                _x removeAllItems;
                _x addWeapon "SMG_05_F";
                _x addMagazine "30Rnd_9x21_Mag_SMG_02";
                if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
                    _x addItem "tf_anprc152";
                    _x assignItem "tf_anprc152";
                    _x addBackpack "tf_anprc155";
                };
            };
            case civilian:
            {
                _x setPosATL _robberSpawn;
                _x removeAllWeapons;
                _x removeAllItems;
                _x addWeapon "hgun_PDW2000_F";
                _x addMagazine "30Rnd_9x21_Mag";
                if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
                    _x addItem "tf_fadak";
                    _x assignItem "tf_fadak";
                };
            };
            default
            {
                _x setPosATL _robberSpawn;
            };
        };
    };
} forEach allUnits;

// Arsenal-Kisten
private _copArsenal = "B_supplyCrate_F" createVehicle (getMarkerPos "cop_arsenal");
[_copArsenal, true] remoteExec ["ace_arsenal_fnc_initBox", 0, _copArsenal];

private _robberArsenal = "B_supplyCrate_F" createVehicle (getMarkerPos "robber_arsenal");
[_robberArsenal, true] remoteExec ["ace_arsenal_fnc_initBox", 0, _robberArsenal];

// Fahrzeug-Spawner
private _copPad = "Land_HelipadEmpty_F" createVehicle (getMarkerPos "cop_vehicle_spawn");
[_copPad, "C_Offroad_01_F", "west"] remoteExec ["CR_fnc_addVehicleSpawner", 0, _copPad];

private _robberPad = "Land_HelipadEmpty_F" createVehicle (getMarkerPos "robber_vehicle_spawn");
[_robberPad, "C_SUV_01_F", "civilian"] remoteExec ["CR_fnc_addVehicleSpawner", 0, _robberPad];

