/*
    Funktion: CR_fnc_arrestPlayer
    Zweck: Ermöglicht Polizisten, einen Räuber festzunehmen, wenn sie
    sich in unmittelbarer Nähe befinden.  Die Festnahme wird mittels
    `disableAI` und `playAction` simuliert.  Der festgenommene Spieler
    wird für eine bestimmte Zeit bewegungsunfähig gemacht und sein
    Task‑Status schlägt fehl.  Polizisten erhalten Punkte; die Mission
    läuft ohne finales End‑Event weiter.

    Hinweis: In Altis Life und ähnlichen Mods gibt es komplexe
    Systeme mit Taser‑Munition und Handschellen【581149796512259†L26-L60】.
    Dieses Beispiel verwendet eine einfachere Variante, die ohne
    zusätzliche Addons auskommt.
*/

params ["_target", "_cop"];

// Nur Polizisten dürfen verhaften
if (side _cop != west) exitWith { ["Nur Polizisten können Räuber verhaften!"] remoteExec ["hint", _cop]; };
// Nur Räuber (civilian) können verhaftet werden
if (side _target != civilian) exitWith { ["Ziel ist kein Räuber."] remoteExec ["hint", _cop]; };

// Prüfen, ob Distanz klein genug ist
if ((_cop distance _target) > 3) exitWith { ["Du bist zu weit entfernt, um zu verhaften."] remoteExec ["hint", _cop]; };

// Festnahme: Spieler bewegungsunfähig machen
_target disableAI "MOVE";
_target playActionNow "Surrender";
_target setCaptive true;
if (!isNil "CR_robberTask1") then { CR_robberTask1 setTaskState "Failed"; };
if (!isNil "CR_robberTask2") then { CR_robberTask2 setTaskState "Failed"; };

["Räuber wurde verhaftet!"] remoteExec ["hint", _cop];
["Du wurdest verhaftet!"] remoteExec ["hint", _target];

