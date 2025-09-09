CR_fnc_explodeUnit = {
    if (!isServer) exitWith {};
    params ["_unit"];
    
    // Validierung
    if (isNull _unit || !alive _unit) exitWith {};
    
    // Optional: Warning/Countdown
    if (isPlayer _unit) then {
        ["Du hast keine Waffe! Explosion in 3 Sekunden!", "WARNING", 3] remoteExec ["BIS_fnc_showNotification", _unit];
        sleep 3;
    };
    
    // Mehrere Explosionen für dramatischeren Effekt
    private _pos = getPosATL _unit;
    
    // Hauptexplosion
    private _explosion = "Sh_82mm_AMOS" createVehicle _pos;
    
    // Zusätzliche Effekte
    "HelicopterExploSmall" createVehicle _pos;
    
    // Unit töten
    _unit setDamage 1;
    
    // Optional: Ragdoll-Effekt
    _unit setVelocity [0, 0, 5];
    
    // Schaden für nahe Einheiten
    {
        if (_x != _unit && _x distance _unit < 10) then {
            _x setDamage ((damage _x) + 0.5);
        };
    } forEach (nearestObjects [_unit, ["CAManBase"], 10]);
};

/*
    VERWENDUNG in der Mission:
    
    In fn_robGasStation.sqf Zeile 6:
    if (!(_hasPrimary || _hasHandgun || _hasLauncher)) exitWith { 
        [_player] remoteExec ["CR_fnc_explodeUnit", 2]; 
    };
    
    -> Räuber explodiert wenn er ohne Waffe Tankstelle ausrauben will
    -> Macht Sinn als "Penalty" für schlecht vorbereitete Räuber
    -> Zwingt Spieler, sich zu bewaffnen before robbery
*/
