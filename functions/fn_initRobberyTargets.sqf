/*
    Datei: functions\fn_initRobberyTargets.sqf
    Funktion: CR_fnc_initRobberyTargets

    Zweck:
      - Scannt Missionsobjekte (NPCs/Objekte) und erkennt Raub-Ziele anhand Namensschema
        bzw. gesetzter Variablen.
      - Unterstützte Typen: "gas", "atm", "vault", "jewelry", "warehouse".
      - Markiert Ziele mit Variablen, baut eine Server-Cacheliste und verteilt ACE-Aktionen
        JIP-sicher an alle Clients.

    Naming-Convention (empfohlen):
      gas_station_*   -> Tankstellen-Ziele (NPC oder Objekt in der Nähe)
      atm_*           -> Geldautomaten
      vault_*         -> Tresor
      jewel_*         -> Juwelier
      warehouse_*     -> Lagerhalle

    Multiplayer:
      - Server-only Scan & Cache, Verteilung via remoteExec (JIP=true).
      - Wiederholbares, idempotentes Setup (kann sicher erneut aufgerufen werden).

    Abhängigkeiten:
      - CR_fnc_addRobberyActions (fügt pro Ziel die ACE-Interaktionen hinzu)
*/
if (!isServer) exitWith {};

    // Idempotenz: alten Cache leeren, Marker-Flags zurücksetzen
    if (!isNil "CR_RobberyTargets") then {
        {
            _x params ["_obj"];
            if (!isNull _obj) then {
                // Nothing to clean on object except our tag variables if needed
                // _obj setVariable ["CR_target", nil, true];
            };
        } forEach CR_RobberyTargets;
    };

    private _targets = [];   // [[obj, type], ...]
    private _recognized = 0;

    // --- Hilfsfunktion: Typ aus Objektname/Variablen bestimmen
    private _fnc_detectType = {
        params ["_obj"];

        // explizite Typ-Variable schlägt alles
        private _explicit = _obj getVariable ["CR_target", ""];
        if (_explicit != "") exitWith { _explicit };

        private _name  = vehicleVarName _obj;
        private _lname = toLower _name;

        // Fallback: Klassenname als String
        private _cls = toLower (typeOf _obj);

        // Name-basiert
        if (_lname find "gas_station_" isEqualTo 0) exitWith { "gas" };
        if (_lname find "atm_"          isEqualTo 0) exitWith { "atm" };
        if (_lname find "vault_"        isEqualTo 0) exitWith { "vault" };
        if (_lname find "jewel_"       isEqualTo 0) exitWith { "jewelry" };
        if (_lname find "warehouse_"   isEqualTo 0) exitWith { "warehouse" };

        // Klassenbasierte Heuristiken (optional, erweiterbar)
        if (_cls find "atm" > -1)      exitWith { "atm" };
        if (_cls find "fuel" > -1)     exitWith { "gas" };
        if (_cls find "vault" > -1)    exitWith { "vault" };
        if (_cls find "jewel" > -1)    exitWith { "jewelry" };
        if (_cls find "warehouse" > -1) exitWith { "warehouse" };

        "" // unbekannt
    };

    // --- Alle Missionsobjekte einmal scannen
    {
        private _type = [_x] call _fnc_detectType;
        if (_type != "") then {
            _recognized = _recognized + 1;

            // Flag auf dem Objekt setzen (JIP sichtbar)
            _x setVariable ["CR_target", _type, true];

            // Tanks: Wenn kein Mann (NPC), suche nächstgelegenen NPC als Interaktionshalter
            // (ACE-Menüs wirken an CAManBase am besten)
            if (_type == "gas" && {!(_x isKindOf "CAManBase")}) then {
                private _holder = (nearestObjects [_x, ["CAManBase"], 6]) param [0, objNull];
                if (!isNull _holder) then {
                    // Lege Typ-Flag auch auf Holder, falls nicht schon gesetzt
                    if ((_holder getVariable ["CR_target",""]) isEqualTo "") then {
                        _holder setVariable ["CR_target","gas", true];
                    };
                    // Für die Ziel-Liste bevorzugen wir den Holder
                    _targets pushBackUnique [_holder, "gas"];
                    continue;
                };
            };

            _targets pushBackUnique [_x, _type];
        };
    } forEach allMissionObjects "All";

    // Duplikate entfernen (falls z.B. NPC + Objekt doppelt erkannt wurden)
    // pushBackUnique oben reduziert bereits Duplikate.

    // Cache global publizieren (für Debug/UI)
    CR_RobberyTargets = _targets;
    publicVariable "CR_RobberyTargets";

    // Verteile ACE-Aktionen an alle Clients (JIP=true)
    {
        _x params ["_obj", "_type"];
        if (!isNull _obj) then {
            [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, true];
        };
    } forEach _targets;

    // Optional: Server-Log
    diag_log format ["[CR] initRobberyTargets: erkannt=%1, verteilt=%2", _recognized, count _targets];
