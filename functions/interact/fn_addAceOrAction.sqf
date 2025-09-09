/*
    CR_fnc_addAceOrAction
    Einheitliches Hinzufügen einer Interaktion:
    - Mit ACE: ace_interact_menu
    - Ohne ACE: addAction

    Params:
      0: Object (_obj)
      1: Titel (_title)
      2: Code (Script handle to execute on use)
      3: Show condition (code returning boolean, optional)
      4: Arguments array passed to code (optional)
*/
// Parameters for addAceOrAction:
// 0: object to attach the action to
// 1: title (string)
// 2: code to execute when the action is used
// 3: show condition (optional, defaults to {true})
// 4: arguments array passed to the code (optional)
params [
    "_obj",
    "_title",
    "_code",
    ["_cond_show", {true}],
    ["_args", []]
];

private _hasACE = isClass (configFile >> "CfgPatches" >> "ace_interact_menu");
if (!isNull _obj) then {
    if (_hasACE) then {
        private _act = [
            format ["CR_%1", _title],
            _title,
            "",
            _code,
            _cond_show,
            {},
            _args
        ] call ace_interact_menu_fnc_createAction;
        [_obj, 0, ["ACE_MainActions"], _act] call ace_interact_menu_fnc_addActionToObject;
    } else {
        // Fallback: addAction ohne Conditions
        _obj addAction [
            _title,
            _code,
            _args,
            1.5,
            true,
            true,
            "",
            "",
            ""
        ];
    };
};