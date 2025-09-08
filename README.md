# Cops-and-Robbers für Arma 3

## Überblick
Cops-and-Robbers ist ein kooperatives Szenario für Arma 3, in dem zwei Teams gegeneinander antreten: Polizisten versuchen die Stadt zu sichern, während Räuber Geld durch Überfälle erbeuten.

## Voraussetzungen
- Arma 3 in aktueller Version
- Empfohlene Mods: [ACE](https://ace3mod.com) und [CBA_A3](https://github.com/CBATeam/CBA_A3)

## Installation
1. Den Missionsordner in den `MPMissions`-Ordner deiner Arma-3-Installation kopieren.
2. Arma 3 starten und die Mission im Editor öffnen.
3. Szenario konfigurieren und im Mehrspielermodus hosten oder veröffentlichen.

## Spielablauf
- **Polizisten** patrouillieren und reagieren auf verdächtige Aktivitäten.
- **Räuber** planen Überfälle auf z. B. Tankstellen und müssen mit der Beute zum Safehouse gelangen.
- Nach einem erfolgreichen Überfall folgt eine Safehouse-Phase, in der die Räuber sich verstecken und die Polizei nach ihnen fahndet.

Die Mission bringt bereits drei benannte Tankstellen-NPCs (`gas_station_1` bis `gas_station_3`) und
fünf Geldautomaten (`atm_1` bis `atm_5`) mit. Ein Tresor wird zur Laufzeit zufällig innerhalb des
Markers `vault_area` erstellt. `CR_fnc_initRobberyTargets` versieht alle diese Ziele mit den
passenden ACE-Interaktionen für Überfälle.

## Funktionsreferenz
| Funktion | Beschreibung |
| --- | --- |
| `CR_fnc_setupTeams` | Erstellt die Gruppen der Polizisten und Räuber zu Missionsbeginn. |
| `CR_fnc_assignTasks` | Verteilt Missionsziele an die jeweiligen Rollen. |
| `CR_fnc_robGasStation` | Führt den Überfall auf eine Tankstelle aus und löst Alarm aus. |
| `CR_fnc_initRobberyTargets` | Sucht in der mission.sqm nach benannten NPCs, ATMs und Tresoren und markiert sie als Überfallziele. |
| `CR_fnc_addRobberyActions` | Fügt den gefundenen Zielen die passende ACE-Interaktion hinzu. |

## Mitwirken & Lizenz
Beiträge sind willkommen! Reiche Pull Requests oder Issues über GitHub ein.  
Dieses Projekt steht unter der MIT-Lizenz.
