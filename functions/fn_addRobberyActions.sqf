/*
    Datei: functions/fn_addRobberyActions.sqf
    Funktion: CR_fnc_addRobberyActions
    Zweck: Fügt einem Zielobjekt (Tankstelle/ATM/Tresor/Juwelier/Lagerhalle) passende ACE-Aktionen hinzu.
    Aufruf: [_obj] remoteExec ["CR_fnc_addRobberyActions", 0, true];  // vom Server aus
*/

    params [["_obj", objNull, [objNull]]];
    if (isNull _obj) exitWith {};
    if (!hasInterface) exitWith {};

    // Warten bis ACE Interact bereit ist (mit Timeout)
    private _t0 = time;
    waitUntil {
        !isNil "ace_interact_menu_fnc_createAction"
        || { time > _t0 + 10 }
    };
    if (isNil "ace_interact_menu_fnc_createAction") exitWith {};

    // Doppelte Registrierung pro Client verhindern
    if (_obj getVariable ["CR_actionsAdded", false]) exitWith {};
    _obj setVariable ["CR_actionsAdded", true];

    // Zieltyp ermitteln
    private _type = _obj getVariable ["CR_target", ""];
    if (_type isEqualTo "") then {
        private _lname = toLower (vehicleVarName _obj);
        if (_lname select [0,12] isEqualTo "gas_station_") then { _type = "gas"; };
        if (_lname select [0,4]  isEqualTo "atm_")          then { _type = "atm"; };
        if (_lname select [0,6]  isEqualTo "vault_")        then { _type = "vault"; };
        if (_lname select [0,8]  isEqualTo "jewel_" )       then { _type = "jewelry"; };
        if (_lname select [0,10] isEqualTo "warehouse")    then { _type = "warehouse"; };
    };

    // Hilfsfunktion: Aktion hinzufügen
    private _addActionTo = {
        params ["_holder", "_id", "_displayName", "_onExec", "_cond"];
        private _act = [
            _id,
            _displayName,
            "",
            {
                params ["_target", "_player", "_args"];
                _args params ["_onExec"];
                [_target, _player] call _onExec;
            },
            {
                params ["_target", "_player", "_args"];
                _args params ["_onExec", "_cond"];
                [_target, _player] call _cond
            }
        ] call ace_interact_menu_fnc_createAction;

        [_holder, 0, ["ACE_MainActions"], _act] call ace_interact_menu_fnc_addActionToObject;
    };

    // Gemeinsame Bedingungen
    private _condCivilNear = {
        params ["_tgt","_pl"];
        (side _pl == civilian) && { alive _pl } && { _pl distance _tgt < 3 }
    };

    switch (_type) do {
        case "gas": {
            // Manche Maps nutzen NPC neben der Zapfsäule -> wähle ggf. den Mann als Holder
            private _holder = if (_obj isKindOf "CAManBase") then {_obj} else {
                (nearestObjects [_obj, ["CAManBase"], 5]) param [0, _obj]
            };

            // Ausführung: robGasStation (mit Anti-Double/State)
            private _onExec = {
                params ["_tgt","_pl"];
                if (_tgt getVariable ["CR_robbing", false]) exitWith {
                    ["Bereits im Gange",2] call ace_common_fnc_displayTextStructured;
                };
                [_tgt, _pl] call CR_fnc_robGasStation;
            };

            // Condition: Räuber, in Reichweite, nicht bereits ausgeraubt/aktiv
            private _cond = {
                params ["_tgt","_pl"];
                ([_tgt,_pl] call _condCivilNear)
                && { !(_tgt getVariable ["robbed", false]) }
                && { !(_tgt getVariable ["CR_robbing", false]) }
            };

            [_holder, "CR_robGasStation", "Tankstelle ausrauben", _onExec, _cond] call _addActionTo;
        };

        case "atm": {
            private _onExec = {
                params ["_tgt","_pl"];
                if (_tgt getVariable ["robbed", false]) exitWith { hint "Bereits geknackt"; };
                [_tgt, _pl] call CR_fnc_robATM;
            };
            private _cond = {
                params ["_tgt","_pl"];
                ([_tgt,_pl] call _condCivilNear) && { !(_tgt getVariable ["robbed", false]) }
            };
            [_obj, "CR_robATM", "ATM knacken", _onExec, _cond] call _addActionTo;
        };

        case "vault": {
            private _onExec = {
                params ["_tgt","_pl"];
                if (_tgt getVariable ["robbed", false]) exitWith { hint "Bereits geknackt"; };
                _tgt setVariable ["robbed", true, true];
                [getPos _tgt, "Ein Tresor wird geknackt!"] remoteExec ["CR_fnc_triggerAlarm", 2];
            };
            private _cond = {
                params ["_tgt","_pl"];
                ([_tgt,_pl] call _condCivilNear) && { !(_tgt getVariable ["robbed", false]) }
            };
            [_obj, "CR_robVault", "Tresor knacken", _onExec, _cond] call _addActionTo;
        };

        case "jewelry": {
            private _onExec = {
                params ["_tgt","_pl"];
                if (_tgt getVariable ["robbed", false]) exitWith { ["Bereits geplündert",2] call ace_common_fnc_displayTextStructured; };
                [_tgt, _pl] call CR_fnc_robJewelry;
            };
            private _cond = {
                params ["_tgt","_pl"];
                ([_tgt,_pl] call _condCivilNear) && { !(_tgt getVariable ["robbed", false]) }
            };
            [_obj, "CR_robJewelry", "Juwelier ausrauben", _onExec, _cond] call _addActionTo;
        };

        case "warehouse": {
            private _onExec = {
                params ["_tgt","_pl"];
                if (_tgt getVariable ["robbed", false]) exitWith { ["Bereits geplündert",2] call ace_common_fnc_displayTextStructured; };
                [_tgt, _pl] call CR_fnc_robWarehouse;
            };
            private _cond = {
                params ["_tgt","_pl"];
                ([_tgt,_pl] call _condCivilNear) && { !(_tgt getVariable ["robbed", false]) }
            };
            [_obj, "CR_robWarehouse", "Lagerhalle plündern", _onExec, _cond] call _addActionTo;
        };

        default {
            // unbekannter Typ -> nichts
            _obj setVariable ["CR_actionsAdded", false]; // Freigeben, falls später Typ gesetzt wird
        };
    };
