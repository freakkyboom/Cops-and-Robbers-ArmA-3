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
    switch (side _x) do
    {
        case west:
        {
            _x setPosATL _copSpawn;
            removeAllWeapons _x;
            removeAllItems _x;
            removeAllAssignedItems _x;
            _x addWeapon "SMG_05_F";
            _x addMagazine "30Rnd_9x21_Mag_SMG_02";
        };
        case civilian:
        {
            _x setPosATL _robberSpawn;
            removeAllWeapons _x;
            removeAllItems _x;
            removeAllAssignedItems _x;
            _x addWeapon "hgun_PDW2000_F";
            _x addMagazine "30Rnd_9x21_Mag";
        };
        default
        {
            _x setPosATL _robberSpawn;
        };
    };
} forEach allPlayers;

// Arsenal-Kisten (bereits platzierte Objekte)
private _copArsenal = missionNamespace getVariable ["cop_arsenal", objNull];
if (!isNull _copArsenal) then {
    [_copArsenal, west] remoteExec ["CR_fnc_addArsenalAction", 0, true];
};

private _robberArsenal = missionNamespace getVariable ["robber_arsenal", objNull];
if (!isNull _robberArsenal) then {
    [_robberArsenal, civilian] remoteExec ["CR_fnc_addArsenalAction", 0, true];
};

// Fahrzeug-Spawner (Cargo-Netze)
private _copPad = missionNamespace getVariable ["cop_vehicle_spawn", objNull];
if (!isNull _copPad) then {
    [_copPad, west] remoteExec ["CR_fnc_addGarageActions", 0, true];
};

private _robberPad = missionNamespace getVariable ["robber_vehicle_spawn", objNull];
if (!isNull _robberPad) then {
    [_robberPad, civilian] remoteExec ["CR_fnc_addGarageActions", 0, true];
};

