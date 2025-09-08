/*
    CR_fnc_initRobberyTargets
    - Sucht relevante Missionsobjekte und versieht sie mit ACE-Raubaktionen.
    - Präfixe: gas_station_*, atm_*
    - Spawnt 1 Tresor zufällig im Marker 'vault_area'
*/
if (!isServer) exitWith {};

// Nur relevante Objekte durchsuchen
private _allObjects =
    (allMissionObjects "Land_FuelStation_Feed_F") +
    (allMissionObjects "Land_FuelStation_Build_F") +
    (allMissionObjects "Land_FuelStation_Shed_F") +
    (allMissionObjects "Land_ATM_01_malden_F");

{
    private _name = vehicleVarName _x;
    switch (true) do {
        case (_name find "gas_station_" == 0): {
            _x setVariable ["CR_target", "gas", true];
            [_x] remoteExec ["CR_fnc_addRobberyActions", 0, _x];
        };
        case (_name find "atm_" == 0): {
            _x setVariable ["CR_target", "atm", true];
            [_x] remoteExec ["CR_fnc_addRobberyActions", 0, _x];
        };
    };
} forEach _allObjects;

private _center = getMarkerPos "vault_area";
if (!(_center isEqualTo [0,0,0])) then {
    private _size = getMarkerSize "vault_area";
    private _pos = [
        (_center # 0) + (random (_size # 0 * 2) - (_size # 0)),
        (_center # 1) + (random (_size # 1 * 2) - (_size # 1)),
        0
    ];
    private _vault = "Land_Safe_F" createVehicle _pos;
    _vault setVariable ["CR_target", "vault", true];
    [_vault] remoteExec ["CR_fnc_addRobberyActions", 0, _vault];
} else {
    diag_log "CR: FEHLER - Marker 'vault_area' nicht gefunden!";
};
