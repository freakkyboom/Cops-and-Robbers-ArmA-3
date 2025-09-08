/*
    CR_fnc_initRobberyTargets
    - Sucht alle Missionsobjekte nach Präfixen ab und stattet sie mit ACE-Raubaktionen aus.
    - Präfixe: gas_station_*, atm_*
    - Spawnt 1 Tresor zufällig im Marker 'vault_area'
*/
if (!isServer) exitWith {};

// 1) Gas-Station & ATM: per Präfix finden und kennzeichnen
{
    private _name = vehicleVarName _x;

    if (_name find "gas_station_" == 0) then {
        _x setVariable ["CR_target", "gas", true];
        [_x] remoteExec ["CR_fnc_addRobberyActions", 0, true];
    };

    if (_name find "atm_" == 0) then {
        _x setVariable ["CR_target", "atm", true];
        [_x] remoteExec ["CR_fnc_addRobberyActions", 0, true];
    };
} forEach allMissionObjects "All";

// 2) Tresor zufällig im Marker 'vault_area'
private _center = getMarkerPos "vault_area";
private _size   = getMarkerSize "vault_area";
if (_center isEqualTo [0,0,0]) exitWith { diag_log "CR: Marker 'vault_area' fehlt."; };

private _pos = [
    (_center # 0) + (random (_size # 0 * 2) - (_size # 0)),
    (_center # 1) + (random (_size # 1 * 2) - (_size # 1)),
    0
];
private _vault = "Land_Safe_F" createVehicle _pos;
_vault setVariable ["CR_target", "vault", true];
[_vault] remoteExec ["CR_fnc_addRobberyActions", 0, true];
