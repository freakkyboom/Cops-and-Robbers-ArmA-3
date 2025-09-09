/*
    Funktion: CR_fnc_endMission
    Zweck: Beendet die Mission und zeigt allen Spielern den Sieger an.
    Die Funktion prüft, ob die Räuber mit der Beute entkommen sind
    oder ob alle Räuber festgenommen/neutralisiert wurden.  Danach
    wird mithilfe von `endMission` ein Missionsendebildschirm
    angezeigt.  Die Mission kann bei Bedarf in der editor‑
    Konfiguration um weitere Endings ergänzt werden.
*/

// Von Server ausgeführt, um Doppelaufrufe zu vermeiden
if (!isServer) exitWith {};

// Prüfen, ob ein Räuber den Geldsack erfolgreich zur Fluchtzone gebracht hat
private _lootDelivered = false;
{
    if (side _x == civilian && isPlayer _x) then
    {
        if (_x getVariable ["CR_lootDelivered", false]) then
        {
            _lootDelivered = true;
        };
    };
} forEach allUnits;

if (_lootDelivered) then
{
    // Räuber haben gewonnen
    ["RobbersWin"] remoteExec ["BIS_fnc_endMission", 0];
} else
{
    // Polizisten haben gewonnen (alle Räuber verhaftet oder ausgeschaltet)
    ["CopsWin"] remoteExec ["BIS_fnc_endMission", 0];
