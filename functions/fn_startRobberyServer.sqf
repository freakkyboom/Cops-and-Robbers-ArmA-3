/*
    Funktion: CR_fnc_startRobberyServer
    Zweck: Serverseitige Logik für den Tankstellenraub
*/
params ["_target", "_mode", ["_robber", objNull]];
if (!isServer) exitWith {};

switch (_mode) do {
    case "start": {
        if (_target getVariable ["CR_isLocked", false]) exitWith {};
        _target setVariable ["CR_isLocked", true, true];
        [_target] spawn {
            params ["_tgt"];
            uiSleep 160;
            if (_tgt getVariable ["CR_isLocked", false]) then {
                _tgt setVariable ["CR_isLocked", false, true];
            };
        };
    };
    case "cancel": {
        _target setVariable ["CR_isLocked", false, true];
    };
    case "success": {
        if (!(_target getVariable ["CR_isLocked", false])) exitWith {};
        private _crate = "Box_NATO_Ammo_F" createVehicle (getMarkerPos "mrk_gasLoot");
        _crate addItemCargoGlobal ["TrainingMine_Mag", 1];
        [_crate] spawn {
            params ["_box"];
            uiSleep 900;
            deleteVehicle _box;
        };
        [_target] spawn {
            params ["_tgt"];
            uiSleep 600;
            _tgt setVariable ["CR_isLocked", false, true];
        };
    };
