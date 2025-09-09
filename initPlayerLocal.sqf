/*
    initPlayerLocal.sqf – clientseitige Initialisierung für den Tankstellenraub
*/
if (!hasInterface) exitWith {};

player enableStamina false;

private _t0 = time;
waitUntil {
    (isClass (configFile >> "CfgPatches" >> "ace_main") && {!isNil "ace_interact_menu_fnc_createAction"})
    || {time > _t0 + 10}
};
if (isNil "ace_interact_menu_fnc_createAction") exitWith {};

CR_fnc_addGasRobberyAction = {
    private _target = missionNamespace getVariable ["CR_gasStationTarget", objNull];
    if (isNull _target) exitWith {};
    if (_target getVariable ["CR_actionAdded", false]) exitWith {};
    _target setVariable ["CR_actionAdded", true];

    private _action = [
        "CR_RobGas",
        "Tankstelle ausrauben",
        "",
        {
            params ["_target", "_player", "_params"];
            [_target, "start"] remoteExecCall ["CR_fnc_startRobberyServer", 2];
            [
                150,
                [_target, _player],
                {
                    params ["_args"]; _args params ["_tgt", "_pl"];
                    [_tgt, "success", _pl] remoteExecCall ["CR_fnc_startRobberyServer", 2];
                },
                {
                    params ["_args"]; _args params ["_tgt", "_pl"];
                    [_tgt, "cancel"] remoteExecCall ["CR_fnc_startRobberyServer", 2];
                },
                "Tankstelle wird ausgeraubt...",
                {
                    params ["_args"]; _args params ["_tgt", "_pl"];
                    alive _pl && { _pl distance _tgt <= 3 }
                },
                [],
                true
            ] call ace_common_fnc_progressBar;
        },
        {
            params ["_target", "_player", "_params"];
            (side _player == civilian)
            && { _player distance _target <= 3 }
            && { !(_target getVariable ["CR_isLocked", false]) }
        }
    ] call ace_interact_menu_fnc_createAction;

    [_target, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

[] call CR_fnc_addGasRobberyAction;

player addEventHandler ["Respawn", {
    params ["_unit"];
    _unit enableStamina false;
    [] call CR_fnc_addGasRobberyAction;
}];
