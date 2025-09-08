/*
    Funktionskonfiguration für das Cops‑and‑Robbers‑Framework.
    Hier werden Funktionsklassen registriert, damit sie von
    Arma 3 über den Befehl `call` oder `spawn` gefunden werden.  Die
    Struktur folgt dem Muster CfgFunctions -> Klasse -> Unterklasse
    -> Methoden.  Das „tag“ sorgt dafür, dass Funktionen mit
    Präfix aufgerufen werden können, z. B. `CR_fnc_setupTeams`.
*/

class CfgFunctions
{
    class CR
    {
        tag = "CR";
        class Init
        {
            file = "functions";
            class setupTeams      {};
            class assignTasks     {};
            class startRobbery    {};
            class pickupLoot      {};
            class arrestPlayer    {};
            class endMission      {};
            class addRPInteractions {};

            class initRobberyTargets {};
            class addRobberyActions {};
            class robGasStation   {};
            class spawnGasLoot    {};
            class triggerAlarm   {};
            class notifyCops     {};
            class spawnVehicle   {};
            class showID         {};
            class addArsenalAction {};
            class openArsenal   {};
            class addGarageActions {};

            // Neue Funktionen für Safehouse- und Task-Logik
            class clearCopMarkers {};
            class assignInterceptTask {};
            class assignSafehouseTask {};
            class addLaptopAction {};
            class postGasRobbery {};
            class safehouseSuccess {};
            class finishSafehouseRobber {};
            class finishSafehouseCops {};
            class robberyPreventedCops {};
          };
      };
  };
