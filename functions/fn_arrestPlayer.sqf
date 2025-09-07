/*
    Funktion: CR_fnc_arrestPlayer
    Zweck: Ermöglicht Polizisten, einen Räuber festzunehmen, wenn sie
    sich in unmittelbarer Nähe befinden.  Die Festnahme wird mittels
    `disableAI` und `playAction` simuliert.  Der festgenommene Spieler
    wird für eine bestimmte Zeit bewegungsunfähig gemacht und sein
    Task‑Status schlägt fehl.  Polizisten erhalten Punkte und die
    Mission kann je nach Konfiguration enden.

    Hinweis: In Altis Life und ähnlichen Mods gibt es komplexe
    Systeme mit Taser‑Munition und Handschellen【581149796512259†L26-L60】.
    Dieses Beispiel verwendet eine einfachere Variante, die ohne
    zusätzliche Addons auskommt.
*/

params ["_target", "_caller", "_actionId", "_arguments"];

// Nur Polizisten dürfen verhaften
if (side _caller != west) exitWith
{
    hint "Nur Polizisten können Räuber verhaften!";
};
// Nur Räuber (INDEPENDENT) können verhaftet werden
if (side _target != resistance) exitWith
{
    hint "Ziel ist kein Räuber.";
};

// Prüfen, ob Distanz klein genug ist
if ((player distance _target) > 3) exitWith
{
    hint "Du bist zu weit entfernt, um zu verhaften.";
};

// Festnahme: Spieler bewegungsunfähig machen
_target disableAI "MOVE";
_target playActionNow "Surrender";
_target setCaptive true;
// Task des Räubers als fehlgeschlagen markieren
if (!isNil "CR_robberTask1") then { CR_robberTask1 setTaskState "Failed"; };
if (!isNil "CR_robberTask2") then { CR_robberTask2 setTaskState "Failed"; };

// Polizist erhält eine Erfolgsmeldung
hint "Räuber wurde verhaftet!";

// Optional: Mission beenden, wenn alle Räuber verhaftet sind
[] spawn
{
    sleep 5;
    private _remaining = {side _x == resistance && isPlayer _x && !(_x getVariable ["CR_arrested", false])} count allUnits;
    if (_remaining == 0) then
    {
        [] call CR_fnc_endMission;
    };
};