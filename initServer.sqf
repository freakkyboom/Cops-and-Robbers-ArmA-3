/*
    initServer.sqf – serverseitige Initialisierung für den Tankstellenraub
*/
if (!isServer) exitWith {};

if (!isNil "CR_gasStationTarget") then {
    CR_gasStationTarget setVariable ["CR_isLocked", false, true];
};
