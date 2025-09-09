/*
    File: functions/fn_setupTeams.sqf
    Author: CR Framework
    
    KRITISCHER FIX: Suche nach Objekten über Attribut-Namen UND vehicleVarName
*/
params [
    ["_mode", ""],
    ["_westSpawns", [], [[]]],
    ["_civSpawns",  [], [[]]]
];

    // Hilfsfunktionen (lokal)
    private _collectMarkers = {
        params ["_prefixes", "_fallbacks"];
        private _out = [];

        // Sammle sequentielle Marker _prefix_i (i: 1..99; Lücken werden toleriert)
        {
            private _prefix = _x;
            for "_i" from 1 to 99 do {
                private _name = _prefix + "_" + str _i;
                if (markerExists _name) then {
                    private _pos = getMarkerPos _name;
                    if (!(_pos isEqualTo [0,0,0])) then {
                        private _label = _prefix + " #" + str _i;
                        _out pushBack [_name, _pos, _label];
                    };
                };
            };
        } forEach _prefixes;

        // Fallback-Marker (falls keine oder zusätzlich)
        {
            private _name = _x;
            if (markerExists _name) then {
                private _pos = getMarkerPos _name;
                if (!(_pos isEqualTo [0,0,0])) then {
                    _out pushBackUnique [_name, _pos, _name];
                };
            };
        } forEach _fallbacks;

        // Duplikate anhand des Markernamens entfernen
        private _unique = [];
        private _seen = [];
        {
            private _n = _x # 0;
            if !(_n in _seen) then {
                _unique pushBack _x;
                _seen pushBack _n;
            };
        } forEach _out;

        _unique
    };

    private _bindInteractionsServer = {
        // KRITISCHER FIX: Verbesserte Objektsuche
        private _allObjects = allMissionObjects "All";
        
        diag_log "[CR] Starting interaction binding...";
        diag_log format ["[CR] Total objects found: %1", count _allObjects];
        
        // Finde Arsenal-Objekte - ERWEITERTE SUCHE
        private _copArsenalObj = objNull;
        private _robArsenalObj = objNull;
        private _copVehPad = objNull;
        private _robVehPad = objNull;
        
        {
            private _varName = vehicleVarName _x;
            
            // Logge alle benannten Objekte für Debug
            if (_varName != "") then {
                diag_log format ["[CR] Found named object: varName=%1, type=%2, pos=%3", _varName, typeOf _x, getPosATL _x];
            };
            
            // Prüfe vehicleVarName
            if (_varName == "cop_arsenal") then { 
                _copArsenalObj = _x;
                diag_log format ["[CR] Found cop_arsenal via vehicleVarName: %1", _x];
            };
            if (_varName == "robber_arsenal") then { 
                _robArsenalObj = _x;
                diag_log format ["[CR] Found robber_arsenal via vehicleVarName: %1", _x];
            };
            if (_varName == "cop_vehicle_spawn") then { 
                _copVehPad = _x;
                diag_log format ["[CR] Found cop_vehicle_spawn via vehicleVarName: %1", _x];
            };
            if (_varName == "robber_vehicle_spawn") then { 
                _robVehPad = _x;
                diag_log format ["[CR] Found robber_vehicle_spawn via vehicleVarName: %1", _x];
            };
            
        } forEach _allObjects;
        
        // FALLBACK: Suche über Marker-Positionen wenn vehicleVarName nicht funktioniert
        if (isNull _copArsenalObj && markerExists "cop_arsenal") then {
            private _markerPos = getMarkerPos "cop_arsenal";
            private _nearObjs = nearestObjects [_markerPos, ["I_E_CargoNet_01_ammo_F", "I_CargoNet_01_ammo_F", "Box_NATO_Ammo_F"], 10];
            if (count _nearObjs > 0) then {
                _copArsenalObj = _nearObjs select 0;
                // WICHTIG: vehicleVarName setzen für zukünftige Referenzen
                _copArsenalObj setVehicleVarName "cop_arsenal";
                diag_log format ["[CR] Found cop_arsenal via marker position fallback: %1", _copArsenalObj];
            };
        };
        
        if (isNull _robArsenalObj && markerExists "robber_arsenal") then {
            private _markerPos = getMarkerPos "robber_arsenal";
            private _nearObjs = nearestObjects [_markerPos, ["I_CargoNet_01_ammo_F", "I_E_CargoNet_01_ammo_F", "Box_NATO_Ammo_F"], 10];
            if (count _nearObjs > 0) then {
                _robArsenalObj = _nearObjs select 0;
                _robArsenalObj setVehicleVarName "robber_arsenal";
                diag_log format ["[CR] Found robber_arsenal via marker position fallback: %1", _robArsenalObj];
            };
        };
        
        if (isNull _copVehPad && markerExists "cop_vehicle_spawn") then {
            private _markerPos = getMarkerPos "cop_vehicle_spawn";
            private _nearObjs = nearestObjects [_markerPos, ["I_E_CargoNet_01_ammo_F", "I_CargoNet_01_ammo_F", "Box_NATO_Ammo_F"], 10];
            if (count _nearObjs > 0) then {
                _copVehPad = _nearObjs select 0;
                _copVehPad setVehicleVarName "cop_vehicle_spawn";
                diag_log format ["[CR] Found cop_vehicle_spawn via marker position fallback: %1", _copVehPad];
            };
        };
        
        if (isNull _robVehPad && markerExists "robber_vehicle_spawn") then {
            private _markerPos = getMarkerPos "robber_vehicle_spawn";
            private _nearObjs = nearestObjects [_markerPos, ["I_CargoNet_01_ammo_F", "I_E_CargoNet_01_ammo_F", "Box_NATO_Ammo_F"], 10];
            if (count _nearObjs > 0) then {
                _robVehPad = _nearObjs select 0;
                _robVehPad setVehicleVarName "robber_vehicle_spawn";
                diag_log format ["[CR] Found robber_vehicle_spawn via marker position fallback: %1", _robVehPad];
            };
        };

        // Jetzt die Aktionen hinzufügen
        if (!isNull _copArsenalObj) then {
            diag_log format ["[CR] Adding arsenal action to cop_arsenal: %1", _copArsenalObj];
            [_copArsenalObj, west] remoteExec ["CR_fnc_addArsenalAction", 0, true];
        } else {
            diag_log "[CR][WARNING] cop_arsenal object not found!";
        };

        if (!isNull _robArsenalObj) then {
            diag_log format ["[CR] Adding arsenal action to robber_arsenal: %1", _robArsenalObj];
            [_robArsenalObj, civilian] remoteExec ["CR_fnc_addArsenalAction", 0, true];
        } else {
            diag_log "[CR][WARNING] robber_arsenal object not found!";
        };

        if (!isNull _copVehPad) then {
            diag_log format ["[CR] Adding garage actions to cop_vehicle_spawn: %1", _copVehPad];
            [_copVehPad, west] remoteExec ["CR_fnc_addGarageActions", 0, true];
        } else {
            diag_log "[CR][WARNING] cop_vehicle_spawn object not found!";
        };

        if (!isNull _robVehPad) then {
            diag_log format ["[CR] Adding garage actions to robber_vehicle_spawn: %1", _robVehPad];
            [_robVehPad, civilian] remoteExec ["CR_fnc_addGarageActions", 0, true];
        } else {
            diag_log "[CR][WARNING] robber_vehicle_spawn object not found!";
        };
    };

    private _applyRespawnsClient = {
        params ["_westSpawns","_civSpawns"];

        if (!hasInterface) exitWith {};

        // Entferne ggf. alte CR-Respawns dieses Clients
        private _old = player getVariable ["CR_respawnIDs", []];
        {
            [side player, _x] call BIS_fnc_removeRespawnPosition;
        } forEach _old;
        player setVariable ["CR_respawnIDs", []];

        // Wähle spawn-Liste für Seite
        private _spawns = switch (side player) do {
            case west: { _westSpawns };
            case civilian: { _civSpawns };
            default { [] };
        };

        if (_spawns isEqualTo []) exitWith {};

        // Registriere Respawn-Positionen
        private _ids = [];
        private _idx = 0;
        {
            _idx = _idx + 1;
            private _name = _x # 0;
            private _pos  = _x # 1;
            private _label = switch (side player) do {
                case west: { format ["Cop Spawn #%1", _idx] };
                case civilian: { format ["Robber Spawn #%1", _idx] };
                default { _name };
            };

            private _id = [side player, _pos, _label] call BIS_fnc_addRespawnPosition;
            if (!isNil "_id") then { _ids pushBack _id; };
        } forEach _spawns;

        player setVariable ["CR_respawnIDs", _ids];
    };

    // Orchestrierung
    if (_mode isEqualTo "") exitWith {
        if (isServer) then {
            // 1) Serverseitig sammeln
            private _west = [["cop_spawn"], ["respawn_west","cop_spawn"]] call _collectMarkers;
            private _civ  = [["robber_spawn"], ["respawn_civilian","robber_spawn"]] call _collectMarkers;

            missionNamespace setVariable ["CR_SpawnMarkersWest", _west];
            missionNamespace setVariable ["CR_SpawnMarkersCiv",  _civ];
            publicVariable "CR_SpawnMarkersWest";
            publicVariable "CR_SpawnMarkersCiv";

            // 2) Arsenal/Garage-Actions binden
            call _bindInteractionsServer;

            // 3) Clients initialisieren (JIP-sicher)
            ["clientInit", _west, _civ] remoteExec ["CR_fnc_setupTeams", 0, true];
        } else {
            private _west = missionNamespace getVariable ["CR_SpawnMarkersWest", []];
            private _civ  = missionNamespace getVariable ["CR_SpawnMarkersCiv",  []];
            [_west, _civ] call _applyRespawnsClient;
        };
    };

    // Server-spezifisch
    if (_mode isEqualTo "serverInit") exitWith {
        if (!isServer) exitWith {};
        true
    };

    // Client-spezifisch
    if (_mode isEqualTo "clientInit") exitWith {
        [_westSpawns, _civSpawns] call _applyRespawnsClient;

        if (isNil {missionNamespace getVariable "CR_RespawnPVEH_Registered"}) then {
            missionNamespace setVariable ["CR_RespawnPVEH_Registered", true];
            "CR_SpawnMarkersWest" addPublicVariableEventHandler {
                params ["_var","_val"];
                private _civ = missionNamespace getVariable ["CR_SpawnMarkersCiv", []];
                [_val, _civ] call _applyRespawnsClient;
            };
            "CR_SpawnMarkersCiv" addPublicVariableEventHandler {
                params ["_var","_val"];
                private _west = missionNamespace getVariable ["CR_SpawnMarkersWest", []];
                [_west, _val] call _applyRespawnsClient;
            };
        };
        true
    };

    true