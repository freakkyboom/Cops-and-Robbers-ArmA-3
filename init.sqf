/*
    Init‑Skript für die Mission.  Dieses Skript wird automatisch
    ausgeführt, sobald die Mission geladen ist.  Es ruft
    serverseitige und klientseitige Initialisierungsfunktionen auf.

    Das Skript teilt die Initialisierung in zwei Teile:
    1) Auf dem Server werden Teams erstellt und Spawnpunkte gesetzt.
    2) Auf jedem Client werden die Aufgaben (Tasks) basierend auf der
       Teamzugehörigkeit zugewiesen.

    In der Bohemia‑Dokumentation wird empfohlen, Missionen in
    überschaubare Aufgaben aufzuteilen【176927070815116†L340-L404】, damit
    Spieler jederzeit wissen, was sie zu tun haben.  Dies wird hier
    umgesetzt, indem sowohl Räuber als auch Polizisten eigene Tasks
    erhalten.
*/

if (isServer) then
{
    // Serverseitige Team‑ und Fahrzeugvorbereitung
    [] call CR_fnc_setupTeams;
};

// Aufgaben für Spieler auf ihren Clients erstellen
if (hasInterface) then
{
    [] call CR_fnc_assignTasks;
};