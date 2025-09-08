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
            };
            case civilian:
            {
                _x setPosATL _robberSpawn;
                _x removeAllWeapons;
                _x removeAllItems;
                _x addWeapon "hgun_PDW2000_F";
                _x addMagazine "30Rnd_9x21_Mag";
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
[_copArsenal, west] remoteExec ["CR_fnc_addArsenalAction", 0, true];

private _robberArsenal = "B_supplyCrate_F" createVehicle (getMarkerPos "robber_arsenal");
[_robberArsenal, civilian] remoteExec ["CR_fnc_addArsenalAction", 0, true];

// Fahrzeug-Spawner
private _copPad = "Land_HelipadEmpty_F" createVehicle (getMarkerPos "cop_vehicle_spawn");
[_copPad, west] remoteExec ["CR_fnc_addGarageActions", 0, true];

private _robberPad = "Land_HelipadEmpty_F" createVehicle (getMarkerPos "robber_vehicle_spawn");
[_robberPad, civilian] remoteExec ["CR_fnc_addGarageActions", 0, true];
