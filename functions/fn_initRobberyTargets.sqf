CR_fnc_initRobberyTargets = {
    if (!isServer) exitWith {};
    {
        private _name  = vehicleVarName _x;
        private _lname = toLower _name;
        if (_lname find "gas_station_" == 0) then {
            _x setVariable ["CR_target", "gas", true];
            [_x] remoteExec ["CR_fnc_addRobberyActions", 0, true];
        };
        if (_lname find "atm_" == 0) then {
            _x setVariable ["CR_target", "atm", true];
            [_x] remoteExec ["CR_fnc_addRobberyActions", 0, true];
        };
    } forEach allMissionObjects "All";
};
