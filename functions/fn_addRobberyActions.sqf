/*
    Funktion: CR_fnc_addRobberyActions
    Zweck: Fügt einem Zielobjekt die passenden Aktionen für Räuber hinzu.
    Wird vom Server für jedes Ziel per remoteExec auf alle Clients aufgerufen.
    Die Zielobjekte stammen aus der mission.sqm und werden in

    Parameter:
        0: OBJECT - Zielobjekt
*/

params ["_obj"];

if (!hasInterface) exitWith {};
waitUntil { !isNil "ace_interact_menu_fnc_createAction" };

private _type = _obj getVariable ["CR_target", ""];

switch (_type) do
{
    case "gas":
    {
        private _action = [
            "robGasStation",
            "Tankstelle ausrauben",
            "",
            {
                params ["_target", "_player", "_args"];
                if (side _player != civilian) exitWith {};
                if (_target getVariable ["robbed", false]) exitWith { hint "Bereits ausgeraubt"; };
                _target setVariable ["robbed", true, true];
                [_target, _player] call CR_fnc_robGasStation;
            },
            { true }
        ] call ace_interact_menu_fnc_createAction;
        [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };
    case "atm":
    {
        private _action = [
            "robATM",
            "ATM knacken",
            "",
            {
                params ["_target", "_player", "_args"];
                if (side _player != civilian) exitWith {};
                if (_target getVariable ["robbed", false]) exitWith { hint "Bereits geknackt"; };
                _target setVariable ["robbed", true, true];
                [getPos _target, "Ein ATM wird geknackt!"] remoteExec ["CR_fnc_triggerAlarm", 2];
            },
            { true }
        ] call ace_interact_menu_fnc_createAction;
        [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };
    case "vault":
    {
        private _action = [
            "robVault",
            "Tresor knacken",
            "",
            {
                params ["_target", "_player", "_args"];
                if (side _player != civilian) exitWith {};
                if (_target getVariable ["robbed", false]) exitWith { hint "Bereits geknackt"; };
                _target setVariable ["robbed", true, true];
                [getPos _target, "Ein Tresor wird geknackt!"] remoteExec ["CR_fnc_triggerAlarm", 2];
            },
            { true }
        ] call ace_interact_menu_fnc_createAction;
        [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };
    default {}; // für unbekannte Typen keine Aktion
};
