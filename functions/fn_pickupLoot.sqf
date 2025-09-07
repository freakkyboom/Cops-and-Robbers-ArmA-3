/*
    Funktion: CR_fnc_pickupLoot
    Zweck: Gibt Räubern die Möglichkeit, den Geldsack aufzunehmen.
    Beim Aufnehmen der Beute wird der Gegenstand an den Spieler
    angeheftet (attached) und der Task‑Status wird angepasst.
    Danach kann der Spieler zur Fluchtzone fahren/laufen.  Sobald
    er dort ankommt, endet die Mission.

    Voraussetzungen: Der Geldsack muss die Variable "CR_loot" besitzen.
    Diese wird in startRobbery.sqf gesetzt.  Außerdem muss im Editor
    ein Trigger oder eine Logik in der Fluchtzone existieren, die
    `CR_fnc_endMission` aufruft, wenn ein Räuber mit dem Loot diese
    Zone betritt.
*/

params ["_target", "_caller", "_actionId", "_arguments"];

// Nur Räuber dürfen die Beute aufnehmen
if (side _caller != east) exitWith
{
    hint "Nur Räuber können die Beute aufnehmen!";
};

// Prüfen, ob das Objekt tatsächlich eine Beute ist
if (!(_target getVariable ["CR_loot", false])) exitWith
{
    hint "Das ist kein Geldsack.";
};

// Beute an Spieler anhängen
_target attachTo [_caller, [0, 0.4, -0.1], "Spine3"];
_target setVariable ["CR_lootCarrier", _caller, true];

// Task‑Status aktualisieren
if (!isNil "CR_robberTask2") then
{
    CR_robberTask2 setTaskState "Assigned";
};

hint "Du hast die Beute aufgenommen! Bringe sie zur Fluchtzone.";