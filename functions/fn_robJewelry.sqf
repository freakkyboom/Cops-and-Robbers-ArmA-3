/*
    Funktion: CR_fnc_robJewelry
    Zweck: Führt einen Juwelier-Überfall mit ACE-Fortschrittsanzeige durch.
    Parameter:
        0: OBJECT - Juwelier-Objekt
        1: OBJECT - raubender Spieler
*/

    params ["_target", "_player"];
    if (!hasInterface || {_player != ACE_player}) exitWith {};
    if (_target getVariable ["CR_robbing", false]) exitWith {
        ["Bereits im Gange",2] call ace_common_fnc_displayTextStructured;
    };
    _target setVariable ["CR_robbing", true, true];
    [_target] remoteExec ["CR_fnc_startSiren", 2];
    private _dur = 180;
    private _cond = {
        params ["_args", "_elapsed", "_target", "_err"];
        _args params ["_tgt", "_pl"];
        alive _pl && { _pl distance _tgt < 5 }
    };
    private _onFinish = {
        params ["_args"];
        _args params ["_tgt", "_pl"];
        [_tgt] remoteExec ["CR_fnc_stopSiren", 2];
        if (isServer) then { [_tgt] call CR_fnc_spawnJewelryLoot; } else { [_tgt] remoteExec ["CR_fnc_spawnJewelryLoot", 2]; };
        [getPos _tgt, "Juwelier wird ausgeraubt!"] remoteExec ["CR_fnc_triggerAlarm", 2];
        _tgt setVariable ["robbed", true, true];
        _tgt setVariable ["CR_robbing", false, true];
        ["Überfall erfolgreich!",3] call ace_common_fnc_displayTextStructured;
    };
    private _onFail = {
        params ["_args"];
        _args params ["_tgt", "_pl"];
        [_tgt] remoteExec ["CR_fnc_stopSiren", 2];
        _tgt setVariable ["CR_robbing", false, true];
        ["Überfall abgebrochen",2] call ace_common_fnc_displayTextStructured;
    };
    [_dur, [_target, _player], _onFinish, _onFail, "Juwelier wird ausgeraubt…", _cond, [], true] call ace_common_fnc_progressBar;
