  if (!isServer) exitWith {};
  params ["_anchor"];
  private _pos = getPosATL _anchor vectorAdd [0,0.8,0];
  private _crate = createVehicle ["Box_NATO_Ammo_F", _pos, [], 0, "NONE"];
  clearBackpackCargoGlobal _crate; clearItemCargoGlobal _crate; clearWeaponCargoGlobal _crate; clearMagazineCargoGlobal _crate;
  _crate addMagazineCargoGlobal ["TrainingMine_Mag", 10];
