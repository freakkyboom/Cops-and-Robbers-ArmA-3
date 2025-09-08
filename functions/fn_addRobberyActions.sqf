/*
    Funktion: CR_fnc_addRobberyActions
    Zweck: Fügt einem Zielobjekt die passenden Aktionen für Räuber hinzu.
    Wird vom Server für jedes Ziel per remoteExec auf alle Clients aufgerufen.
    Parameter:
        0: OBJECT - Zielobjekt
*/

params ["_obj"];

if (!hasInterface) exitWith {};

private _type = _obj getVariable ["CR_target", ""];

switch (_type) do {
    case "gas": {
        private _action = [
            "CR_gasRob",
            "Tankstelle ausrauben",
            "",
            {
                params ["_target", "_player", "_params"];
                if (_target getVariable ["robbed", false]) exitWith { hint "Bereits ausgeraubt"; };
                _target setVariable ["robbed", true, true];
                [getPos _target, "Überfall auf eine Tankstelle!"] remoteExec ["CR_fnc_triggerAlarm", 2];
            },
            {
                params ["_target", "_player", "_params"];
                (side _player == civilian) && !(_target getVariable ["robbed", false])
            }
        ] call ace_interact_menu_fnc_createAction;
        [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };
    case "atm": {
        private _action = [
            "CR_atmRob",
            "ATM aufbrechen",
            "",
            {
                params ["_target", "_player", "_params"];
                if (_target getVariable ["robbed", false]) exitWith { hint "Bereits geknackt"; };
                _target setVariable ["robbed", true, true];
                [getPos _target, "Ein ATM wird geknackt!"] remoteExec ["CR_fnc_triggerAlarm", 2];
                [_target, _player] spawn {
                    params ["_atm", "_robber"];
                    [120,
                        {
                            params ["_atm", "_robber"];
                            hint "ATM erfolgreich geknackt!";
                        },
                        {
                            params ["_atm", "_robber"];
                            _atm setVariable ["robbed", false, true];
                            hint "ATM knacken abgebrochen.";
                        },
                        "ATM wird aufgebrochen...",
                        { params ["_atm", "_robber"]; alive _robber && _robber distance _atm < 2 },
                        [_atm, _robber]
                    ] call ace_common_fnc_progressBar;
                };
            },
            {
                params ["_target", "_player", "_params"];
                (side _player == civilian) && !(_target getVariable ["robbed", false])
            }
        ] call ace_interact_menu_fnc_createAction;
        [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };
    default {};
};

