/*
    init.sqf — Cops & Robbers (ArmA 3)
    Zweck:
      - MP-sichere Initialisierung für Server & Clients (JIP unterstützt)
      - Server: Team-/Ziel-Setup
      - Client: Aufgaben + RP-Interaktionen
      - Respawn-Handling (Interaktionen/Tasks erneuern)

    Voraussetzungen (aus der Mission / Repo):
      - description.ext inkludiert CfgFunctions.hpp und CfgRemoteExec ist korrekt gesetzt
      - Folgende Funktionen existieren:
          CR_fnc_setupTeams           (SERVER)
          CR_fnc_initRobberyTargets   (SERVER)
          CR_fnc_assignTasks          (CLIENT)
          CR_fnc_addRPInteractions    (CLIENT)
*/

scriptName "init.sqf";

// --- Grundwartezeiten: Engine/Player bereit
// dedizierter Server hat kein player-Objekt; Clients warten auf player
if (hasInterface) then {
    waitUntil { !isNull player && player == player };
};

// Warte bis Simulationszeit > 0 (verhindert sehr frühe Aufrufe bei JIP)
waitUntil { time >= 0 };

// --- Serverseitiges Setup (einmalig)
if (isServer) then {
    // Teams/Spawns/Grundausrüstung etc.
    try {
        [] call CR_fnc_setupTeams;
    } catch {
        diag_log format ["[CR][ERROR] setupTeams failed: %1", _exception];
    };

    // Robbery-Ziele (NPC/ATM/Tresor) aus mission.sqm erfassen und ACE-Aktionen global verteilen (JIP-fähig)
    try {
        [] call CR_fnc_initRobberyTargets;
    } catch {
        diag_log format ["[CR][ERROR] initRobberyTargets failed: %1", _exception];
    };
};

// --- Clientseitiges Setup (pro Spieler, inkl. JIP)
if (hasInterface) then {
    // (Optional) auf ACE warten, sofern Interaktionen immediate ACE benötigen
    // Falls eure Funktionen bereits intern warten, kann dieser Block entfallen.
    private _aceReady = {
        // ACE vorhanden & Interact-API verfügbar?
        isClass (configFile >> "CfgPatches" >> "ace_main")
        && { !isNil "ace_interact_menu_fnc_createAction" }
    };
    waitUntil { _aceReady() };

    // Tasks (police/robbers) hinzufügen
    try {
        [] call CR_fnc_assignTasks;
    } catch {
        diag_log format ["[CR][ERROR] assignTasks failed for %1: %2", name player, _exception];
    };

    // RP-Interaktionen (ID zeigen, Laptops, Arsenal/Garage-Menüs, etc.)
    try {
        [] call CR_fnc_addRPInteractions;
    } catch {
        diag_log format ["[CR][ERROR] addRPInteractions failed for %1: %2", name player, _exception];
    };

    // --- Respawn-Handling: Interaktionen/Tasks neu aufsetzen
    //   Hinweis: createSimpleTask-Objekte sind spielergebunden; bei Respawn ggf. neu zuweisen.
    //   Wenn ihr persistente Tasks nutzt, passt das je nach Logik an.
    player addEventHandler ["Respawn", {
        params ["_unit", "_corpse"];

        // ACE Verfügbarkeit erneut prüfen (bei schnellem Respawn)
        private _reWait = {
            isClass (configFile >> "CfgPatches" >> "ace_main")
            && { !isNil "ace_interact_menu_fnc_createAction" }
        };
        waitUntil { _reWait() };

        // Tasks/Interaktionen nach Respawn wiederherstellen
        try {
            [] call CR_fnc_assignTasks;
        } catch {
            diag_log format ["[CR][ERROR] assignTasks (respawn) failed for %1: %2", name _unit, _exception];
        };

        try {
            [] call CR_fnc_addRPInteractions;
        } catch {
            diag_log format ["[CR][ERROR] addRPInteractions (respawn) failed for %1: %2", name _unit, _exception];
        };
    }];
};

// --- Headless Client: hier keine Logik nötig, außer ihr nutzt HC für AI/Serverlast.
// if (!hasInterface && !isServer) then { /* HC-spezifisches Setup hier (optional) */ };

// --- Fertig
diag_log "[CR] init.sqf completed.";
