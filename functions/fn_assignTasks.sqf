/*
    ===========================================
    functions/fn_assignTasks.sqf
    ===========================================
    Weist pro Client (JIP-sicher) grundlegende Tasks nach Fraktion zu.
    - Vermeidet Duplikate bei erneutem Aufruf (Respawn/JIP).
    - Fällt robust auf alternative Marker zurück.
*/
if (!hasInterface) exitWith {};

    // ----- Hilfsfunktionen
    private _markerPos = {
        params ["_candidates"]; // ["cop_spawn","respawn_west"]
        private _pos = [0,0,0];

        {
            if (markerExists _x) exitWith {
                _pos = getMarkerPos _x;
            };
        } forEach _candidates;

        _pos
    };

    private _createOrUpdateTask = {
        params ["_varName", "_taskId", "_desc", "_title", "_short", "_destPos"];
        private _existing = missionNamespace getVariable [_varName, objNull];

        if (!isNull _existing) then {
            // Task existiert bereits -> nur Ziel/Status updaten
            _existing setSimpleTaskDescription [_desc, _title, _short];
            if !(_destPos isEqualTo [0,0,0]) then { _existing setSimpleTaskDestination _destPos; };
            _existing setTaskState "Assigned";
            _existing
        } else {
            private _t = player createSimpleTask [_taskId];
            _t setSimpleTaskDescription [_desc, _title, _short];
            if !(_destPos isEqualTo [0,0,0]) then { _t setSimpleTaskDestination _destPos; };
            _t setTaskState "Assigned";
            missionNamespace setVariable [_varName, _t];
            _t
        };
    };

    // ----- Marker-Ziele
    private _copHomePos    = ["cop_spawn","respawn_west"] call _markerPos;
    private _robberHomePos = ["robber_spawn","respawn_civilian"] call _markerPos;

    // ----- Pro Fraktion Tasks
    switch (side player) do {
        case west: {
            // Streifen-Task
            ["CR_copTaskPatrol", "CR_Patrol",
                "Führe Streife, reagiere auf Alarme und sichere Tatorte.",
                "Streife fahren",
                "Cops",
                _copHomePos
            ] call _createOrUpdateTask;

            // Intercept-Placeholder für zukünftige Einsätze (bleibt 'Assigned')
            ["CR_copTaskIntercept", "CR_Intercept",
                "Reagiere auf aktive Raubmeldungen und stelle Verdächtige.",
                "Einsatzbereitschaft",
                "Cops",
                _copHomePos
            ] call _createOrUpdateTask;
        };

        case civilian: {
            // Grundaufgabe Räuber
            ["CR_robTaskOverview", "CR_RobTargets",
                "Raube Tankstellen/ATMs aus oder plane einen Tresor-Überfall.",
                "Raubzüge durchführen",
                "Raub",
                _robberHomePos
            ] call _createOrUpdateTask;

            // Safehouse-Hinweis (wird später bei Bedarf auf 'Succeeded' gesetzt)
            ["CR_robTaskSafehouse", "CR_Safehouse",
                "Finde ein Safehouse und nutze dort Interaktionen, um Fahndungslevel zu managen.",
                "Safehouse aufsuchen",
                "Safehouse",
                _robberHomePos
            ] call _createOrUpdateTask;
        };

        default {
            // keine Tasks
        };
    };