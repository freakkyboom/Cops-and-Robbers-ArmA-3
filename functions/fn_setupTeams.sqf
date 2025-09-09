/*
    File: functions/fn_setupTeams.sqf
    Author: CR Framework

    Zweck
    -----
    - Serverseitig: Spawns/Marker nach Namenskonvention einsammeln, global publizieren,
      Arsenal- & Garagen-Interaktionen an bereits platzierte Objekte binden.
    - Clientseitig: Seitenabhängige Respawn-Positionen (BIS_fnc_addRespawnPosition) registrieren
      und JIP-sicher halten.

    Marker-Namenskonvention (beliebig viele, lückenlos oder mit Lücken):
      - Cops (BLUFOR/west):  cop_spawn_1, cop_spawn_2, cop_spawn_3, ...
        Fallbacks: respawn_west, cop_spawn
      - Robbers (CIV/civilian): robber_spawn_1, robber_spawn_2, robber_spawn_3, ...
        Fallbacks: respawn_civilian, robber_spawn

    Erforderliche RemoteExec-Whitelist (in description.ext -> CfgRemoteExec):
      - CR_fnc_setupTeams (ANYONE / jip=1)
      - CR_fnc_addArsenalAction (CLIENT)
      - CR_fnc_addGarageActions (CLIENT)
*/

CR_fnc_setupTeams = {
    params [
        // _mode: "serverInit" (intern), "clientInit" (intern) oder "" (Default -> orchestriert beides)
        ["_mode", ""],
        // optionale, vom Server übergebene Spawn-Arrays (JIP-sicher via remoteExec mit JIP-Flag)
        ["_westSpawns", [], [[]]],
        ["_civSpawns",  [], [[]]]
    ];

    // ----------------------------
    // Hilfsfunktionen (lokal)
    // ----------------------------
    private _collectMarkers = {
        params ["_prefixes", "_fallbacks"];
        private _out = [];

        // Sammle sequentielle Marker _prefix_i (i: 1..99; Lücken werden toleriert)
        {
            private _prefix = _x;
            for "_i" from 1 to 99 do {
                private _name = format ["%1_%2", _prefix, _i];
                if (markerExists _name) then {
                    private _pos = getMarkerPos _name;
                    if (!(_pos isEqualTo [0,0,0])) then {
                        _out pushBack [_name, _pos, format ["%1 #%2", _prefix, _i]];
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

        // Duplikate anhand des Markernamens entfernen (sicherheits-halber)
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
        // Arsenal-/Garage-Objekte anhand globaler Variablen binden (falls im Editor als VarName gesetzt)
        private _copArsenalObj = missionNamespace getVariable ["cop_arsenal", objNull];
        if (!isNull _copArsenalObj) then {
            [_copArsenalObj, west] remoteExec ["CR_fnc_addArsenalAction", 0, true];
        };

        private _robArsenalObj = missionNamespace getVariable ["robber_arsenal", objNull];
        if (!isNull _robArsenalObj) then {
            [_robArsenalObj, civilian] remoteExec ["CR_fnc_addArsenalAction", 0, true];
        };

        private _copVehPad = missionNamespace getVariable ["cop_vehicle_spawn", objNull];
        if (!isNull _copVehPad) then {
            [_copVehPad, west] remoteExec ["CR_fnc_addGarageActions", 0, true];
        };

        private _robVehPad = missionNamespace getVariable ["robber_vehicle_spawn", objNull];
        if (!isNull _robVehPad) then {
            [_robVehPad, civilian] remoteExec ["CR_fnc_addGarageActions", 0, true];
        };
    };

    private _applyRespawnsClient = {
        params ["_westSpawns","_civSpawns"];

        if (!hasInterface) exitWith {};

        // Entferne ggf. alte CR-Respawns dieses Clients
        private _old = player getVariable ["CR_respawnIDs", []];
        {
            // BIS_fnc_removeRespawnPosition erwartet [side, id]
            [side player, _x] call BIS_fnc_removeRespawnPosition;
        } forEach _old;
        player setVariable ["CR_respawnIDs", []];

        // Wähle spawn-Liste für Seite
        private _spawns = switch (side player) do {
            case west: { _westSpawns };
            case civilian: { _civSpawns };
            default { [] };
        };

        // Falls nichts gefunden, nicht fehlschlagen – Menü funktioniert mit Standard-Respawnmarkern weiter
        if (_spawns isEqualTo []) exitWith {};

        // Registriere Respawn-Positionen (clientseitig)
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

            // Rückgabe: Respawn-ID (numeric)
            private _id = [side player, _pos, _label] call BIS_fnc_addRespawnPosition;
            if (!isNil "_id") then { _ids pushBack _id; };
        } forEach _spawns;

        player setVariable ["CR_respawnIDs", _ids];
    };

    // --------------------------------
    // Orchestrierung
    // --------------------------------
    if (_mode isEqualTo "") exitWith {
        // Server orchestriert beides und macht JIP-sichere RemoteExecs
        if (isServer) then {
            // 1) Serverseitig sammeln
            private _west = [_collectMarkers, [["cop_spawn"], ["respawn_west","cop_spawn"]]] call BIS_fnc_call;   // Prefixes, Fallbacks
            private _civ  = [_collectMarkers, [["robber_spawn"], ["respawn_civilian","robber_spawn"]]] call BIS_fnc_call;

            // Falls gar nichts gefunden: bewusst NICHT abbrechen -> Standard-Respawnmarker greifen
            missionNamespace setVariable ["CR_SpawnMarkersWest", _west];
            missionNamespace setVariable ["CR_SpawnMarkersCiv",  _civ];
            publicVariable "CR_SpawnMarkersWest";
            publicVariable "CR_SpawnMarkersCiv";

            // 2) Arsenal/Garage-Actions binden
            call _bindInteractionsServer;

            // 3) Clients initialisieren (JIP-sicher)
            ["clientInit", _west, _civ] remoteExec ["CR_fnc_setupTeams", 0, true];
        } else {
            // Falls ein Client dies direkt aufruft (z. B. Test), nur lokale Respawns anwenden, sofern Daten vorhanden
            private _west = missionNamespace getVariable ["CR_SpawnMarkersWest", []];
            private _civ  = missionNamespace getVariable ["CR_SpawnMarkersCiv",  []];
            [_west, _civ] call _applyRespawnsClient;
        };
    };

    // --------------------------------
    // Server-spezifisch
    // --------------------------------
    if (_mode isEqualTo "serverInit") exitWith {
        if (!isServer) exitWith {};
        // (Wird aktuell nicht separat genutzt – Orchestrierung oben.)
        true
    };

    // --------------------------------
    // Client-spezifisch
    // --------------------------------
    if (_mode isEqualTo "clientInit") exitWith {
        // _westSpawns/_civSpawns kommen als Parameter vom Server (JIP-sicher via remoteExec mit JIP-Flag)
        [_westSpawns, _civSpawns] call _applyRespawnsClient;

        // Zusätzlich: Falls später vom Server neue Marker publiziert werden, registriere dich auf Änderungen.
        // (Leichtgewichtig, stört nicht falls nie geändert wird.)
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
};

// Auto-Start beim Laden, falls direkt ausgeführt wird (z. B. via [] call CR_fnc_setupTeams; in init.sqf)
if (isNil {missionNamespace getVariable "CR_SetupTeams_AutoRun"}) then {
    missionNamespace setVariable ["CR_SetupTeams_AutoRun", true];
    // Nur einmal orchestrieren
    [""] call CR_fnc_setupTeams;
};
