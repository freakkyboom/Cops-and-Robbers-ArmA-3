/*
    Funktion: CR_fnc_startRobbery
    Zweck: Ermöglicht es Räubern, den Bankraub zu starten.  Diese
    Funktion kann z. B. über ein `addAction` an einem Tresor oder an
    einem Auslöser aufgerufen werden.  Beim Start des Raubes wird ein
    Timer gesetzt und ein Alarm ausgelöst.  Polizisten erhalten eine
    Meldung, dass ein Raub läuft.  Nach Ablauf des Timers wird die
    Beute (ein „Geldsack“) in der Bank erzeugt.

    Hinweis: Dies ist eine einfache Vorlage.  In einer echten
    Implementierung sollte geprüft werden, dass nur Räuber den Raub
    starten können und dass der Tresor nur einmal geöffnet wird.
*/

params ["_target", "_caller", "_actionId", "_arguments"];

// Nur Räuber (CIVILIAN) dürfen starten
if (side _caller != civilian) exitWith
{
    hint "Nur Räuber können den Tresor knacken!";
};

// Alarm auslösen (global)
["Ein Bankraub wurde gestartet!", "PLAIN", 3] remoteExec ["BIS_fnc_showNotification", 0];

// Timer: Nach 60 Sekunden erscheint die Beute
_duration = 60;
[_duration, _caller] spawn
{
    params ["_time", "_robber"];
    sleep _time;
    // Beute erzeugen
    private _moneyBag = "Land_Money_F" createVehicle (getMarkerPos "bank_marker" vectorAdd [0,0,0]);
    _moneyBag setVariable ["CR_loot", true, true];
    ["Der Tresor ist offen! Schnapp dir die Beute!", "PLAIN", 3] remoteExec ["BIS_fnc_showNotification", [civilian, west]];
};

// Task‑Status aktualisieren: Grundaufgabe der Räuber als erledigt markieren
if (!isNil "CR_robTaskRob") then
{
    CR_robTaskRob setTaskState "Succeeded";
