/*
    init.sqf — Cops & Robbers (ArmA 3)
    Zweck:
      - MP-sichere Initialisierung für Server & Clients (JIP unterstützt)
      - Server: Team-/Ziel-Setup
      - Client: Aufgaben + RP-Interaktionen
      - Respawn-Handling (Interaktionen/Tasks erneuern)

    Voraussetzungen:
      - description.ext inkludiert CfgFunctions.hpp & CfgRemoteExec
      - Folgende Funktionen existieren:
          CR_fnc_setupTeams           (SERVER)
          CR_fnc_initRobberyTargets   (SERVER)
          CR_fnc_assignTasks          (CLIENT)
          CR_fnc_addRPInteractions    (CLIENT)
*/

scriptName "init.sqf";

// --- Clientseitiger Block (inkl. JIP & ACE-Check)
if (hasInterface) then {
    // Warte auf Engine/Player
    waitUntil { !isNull player && player == player };

    // Warte auf Simulationszeit > 0
    waitUntil { time >= 0 };

    // Warte auf ACE oder Timeout nach 30 Sekunden
    private _startTime = time;
    waitUntil {
        (
            isClass (configFile >> "CfgPatches" >> "ace_main")
            && { !isNil "ace_interact_menu_fnc_createAction" }
        ) || { (time - _startTime) > 30 }
    };

    // Aufgaben zuweisen
    try {
        [] call CR_fnc_assignTasks;
    } catch {
        diag_log format ["[CR][ERROR] assignTasks failed for %1", name player];
    };

    // RP-Interaktionen hinzufügen
    try {
        [] call CR_fnc_addRPInteractions;
    } catch {
        diag_log format ["[CR][ERROR] addRPInteractions failed for %1", name player];
    };

    // Respawn-EventHandler einmalig registrieren
    if (isNil "CR_RespawnHandlerAdded") then {
        player addEventHandler ["Respawn", {
            params ["_unit", "_corpse"];

            // Warte auf ACE erneut oder Timeout
            private _respawnStart = time;
            waitUntil {
                (
                    isClass (configFile >> "CfgPatches" >> "ace_main")
                    && { !isNil "ace_interact_menu_fnc_createAction" }
                ) || { (time - _respawnStart) > 30 }
            };

            // Aufgaben & Interaktionen neu setzen
            try {
                [] call CR_fnc_assignTasks;
            } catch {
                diag_log format ["[CR][ERROR] assignTasks (respawn) failed for %1", name _unit];
            };

            try {
                [] call CR_fnc_addRPInteractions;
            } catch {
                diag_log format ["[CR][ERROR] addRPInteractions (respawn) failed for %1", name _unit];
            };
        }];
        CR_RespawnHandlerAdded = true;
    };
};

// --- Serverseitiges Setup (einmalig)
if (isServer) then {
    try {
        [] call CR_fnc_setupTeams;
    } catch {
        diag_log "[CR][ERROR] setupTeams failed.";
    };

    try {
        [] call CR_fnc_initRobberyTargets;
    } catch {
        diag_log "[CR][ERROR] initRobberyTargets failed.";
    };
};

// --- Headless Client-Setup (optional)
/*
if (!hasInterface && !isServer) then {
    // HC-spezifisches Setup hier
};
*/

// --- Setup abgeschlossen
diag_log "[CR] init.sqf completed.";
