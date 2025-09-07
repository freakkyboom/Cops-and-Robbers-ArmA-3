/*
    Funktion: CR_fnc_setupTeams
    Zweck: Erzeugt Polizisten‑ und Räuber‑Teams, weist ihnen
    spawnpunkte zu und stattet sie mit Basisausrüstung aus.

    Für dieses Framework gehen wir davon aus, dass im Editor zwei
    Marker namens "police_spawn" und "robber_spawn" existieren.  Alle
    spielbaren Einheiten auf der Seite BLUFOR (west) gelten als
    Polizisten, während OPFOR (east) die Räuber darstellen.  Die
    Einheiten werden an ihre entsprechenden Spawnpunkte versetzt und
    erhalten einfache Waffen.
*/

if (!isServer) exitWith {};

private _policeSpawn = getMarkerPos "police_spawn";
private _robberSpawn = getMarkerPos "robber_spawn";

{
    // Spieler nur einmal initialisieren
    if (isPlayer _x) then
    {
        switch (side _x) do
        {
            case west:
            {
                _x setPosATL _policeSpawn;
                // Beispielhafte Ausrüstung: Waffe, Magazin, Handschellen
                _x removeAllWeapons;
                _x removeAllItems;
                _x addWeapon "SMG_05_F";
                _x addMagazine "30Rnd_9x21_Mag_SMG_02";
                _x addItemToUniform "ACE_EarPlugs";
            };
            case east:
            {
                _x setPosATL _robberSpawn;
                _x removeAllWeapons;
                _x removeAllItems;
                _x addWeapon "hgun_PDW2000_F";
                _x addMagazine "30Rnd_9x21_Mag";
                _x addItemToUniform "ACE_EarPlugs";
            };
            default
            {
                // neutrale/fraktionslose Spieler erscheinen bei den Räubern
                _x setPosATL _robberSpawn;
            };
        };
    };
} forEach allUnits;

// Fahrzeuge spawnen (optional): Polizeiauto und Fluchtfahrzeug
private _policeCar = "C_Offroad_01_F" createVehicle (_policeSpawn vectorAdd [5,5,0]);
_policeCar setDir 90;

private _getawayCar = "C_SUV_01_F" createVehicle (_robberSpawn vectorAdd [5,-5,0]);
_getawayCar setDir 270;

// Marker für Bank und Fluchtzone sind in initServer.sqf im Editor angelegt
// Weitere Logik (z.B. Alarmanlage) wird in startRobbery.sqf implementiert