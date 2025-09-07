/*
    Funktion: CR_fnc_showID
    Zweck: Zeigt den Namen und die UID eines Spielers an. Wird über
    `remoteExec` auf allen Clients ausgeführt, wenn jemand seinen
    Ausweis zeigt.
    Parameter:
        0: OBJECT - Spieler, der seinen Ausweis zeigt
*/

params ["_unit"];
hint format ["%1 zeigt seinen Ausweis\nUID: %2", name _unit, getPlayerUID _unit];
