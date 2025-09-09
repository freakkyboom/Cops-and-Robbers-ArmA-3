  if (!isServer) exitWith {};
  params ["_obj"]; private _h = _obj getVariable ["CR_sirenThread", scriptNull]; if (!isNull _h) then {terminate _h;};
  _obj setVariable ["CR_sirenThread", scriptNull, true];
