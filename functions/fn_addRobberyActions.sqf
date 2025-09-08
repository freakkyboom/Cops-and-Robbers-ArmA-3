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

switch (_type) do
{
    case "gas":
    {
        _obj addAction ["Tankstelle ausrauben", {
            params ["_target", "_caller"];
            if (side _caller != civilian) exitWith {};
            if (_target getVariable ["robbed", false]) exitWith { hint "Bereits ausgeraubt"; };
            _target setVariable ["robbed", true, true];
            [getPos _target, "Überfall auf eine Tankstelle!"] remoteExec ["CR_fnc_triggerAlarm", 2];
        }];
    };
    case "atm":
    {
        _obj addAction ["ATM knacken", {
            params ["_target", "_caller"];
            if (side _caller != civilian) exitWith {};
            if (_target getVariable ["robbed", false]) exitWith { hint "Bereits geknackt"; };
            _target setVariable ["robbed", true, true];
            [getPos _target, "Ein ATM wird geknackt!"] remoteExec ["CR_fnc_triggerAlarm", 2];
        }];
    };
    default {}; // für unbekannte Typen keine Aktion
};
