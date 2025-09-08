/*
    Funktion: CR_fnc_addGarageActions
    Zweck: Fügt einem Spawn-Pad ACE-Aktionen zum Spawnen fraktionsabhängiger Fahrzeuge mit Skinauswahl hinzu.
    Parameter:
        0: OBJECT - Spawn-Pad
        1: SIDE   - Fraktion, die Zugriff hat
*/

if (!hasInterface) exitWith {};
params ["_pad", "_side"];
if (side player != _side) exitWith {};

private _vehicles = switch (_side) do
{
    case west:
    {
        [
            ["B_MRAP_01_F", [["","Standard"]]],
            ["C_Offroad_01_F", [["","Standard"]]]
        ]
    };
    case civilian:
    {
        [
            ["C_SUV_01_F", [["","Standard"], ["#(argb,8,8,3)color(1,0,0,1)","Rot"]]],
            ["C_Offroad_02_unarmed_F", [["","Standard"]]]
        ]
    };
    default
    {
        []
    };
};

private _root = ["garageRoot", "Fahrzeuge", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_pad, 0, ["ACE_MainActions"], _root] call ace_interact_menu_fnc_addActionToObject;

{
    _x params ["_class", "_textures"];
    private _vehAction = [format ["veh_%1", _class], getText (configFile >> "CfgVehicles" >> _class >> "displayName"), "", {}, {true}] call ace_interact_menu_fnc_createAction;
    [_pad, 0, ["ACE_MainActions", "garageRoot"], _vehAction] call ace_interact_menu_fnc_addActionToObject;

    {
        _x params ["_tex", "_name"];
        private _texAction = [format ["tex_%1_%2", _class, _forEachIndex], _name, "", {
            params ["_target", "_player", "_args"];
            _args params ["_class", "_tex"];
            [ _class, getPos _target, direction _target, _tex ] remoteExec ["CR_fnc_spawnVehicle", 2];
        }, {true}, [_class, _tex]] call ace_interact_menu_fnc_createAction;
        [_pad, 0, ["ACE_MainActions", "garageRoot", format ["veh_%1", _class]], _texAction] call ace_interact_menu_fnc_addActionToObject;
    } forEach _textures;
} forEach _vehicles;
