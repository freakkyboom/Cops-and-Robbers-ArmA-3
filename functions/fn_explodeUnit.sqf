CR_fnc_explodeUnit = {
  if (!isServer) exitWith {};
  params ["_unit"]; if (isNull _unit) exitWith {};
  "Bo_Grenade" createVehicle (getPosATL _unit);
  _unit setDamage 1;
};
