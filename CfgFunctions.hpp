/*
    CfgFunctions.hpp – Funktionsregistrierung für Cops & Robbers (ArmA 3)

    - Tag: "CR"
    - Alle Funktionen liegen im Ordner "functions"
    - Keine preInit/postInit Auto-Initialisierung (Init-Reihenfolge wird über init.sqf gesteuert)
*/

class CfgFunctions
{
    class CR
    {
        tag = "CR";

        // --- Kern / Setup / Interaktionen ---
        class Core
        {
            file = "functions";
            class setupTeams {};            // fn_setupTeams.sqf
            class assignTasks {};           // fn_assignTasks.sqf
            class initRobberyTargets {};    // fn_initRobberyTargets.sqf
            class addRPInteractions {};     // fn_addRPInteractions.sqf
            class addRobberyActions {};     // fn_addRobberyActions.sqf

            // Arsenal & Garage & Laptop & ID
            class addArsenalAction {};      // fn_addArsenalAction.sqf
            class openArsenal {};           // fn_openArsenal.sqf
            class addGarageActions {};      // fn_addGarageActions.sqf
            class addLaptopAction {};       // fn_addLaptopAction.sqf
            class showID {};                // fn_showID.sqf
        };

        // --- Raub / Kriminalität ---
        class Robbery
        {
            file = "functions";
            class robGasStation {};         // fn_robGasStation.sqf
            class robATM {};                // fn_robATM.sqf
            class startRobbery {};          // fn_startRobbery.sqf
            class pickupLoot {};            // fn_pickupLoot.sqf
            class spawnGasLoot {};          // fn_spawnGasLoot.sqf
            class postGasRobbery {};        // fn_postGasRobbery.sqf
            class triggerAlarm {};          // fn_triggerAlarm.sqf
            class notifyCops {};            // fn_notifyCops.sqf
            class robberyPreventedCops {};  // fn_robberyPreventedCops.sqf
        };

        // --- Polizei / Einsatzmittel ---
        class Police
        {
            file = "functions";
            class arrestPlayer {};          // fn_arrestPlayer.sqf
            class clearCopMarkers {};       // fn_clearCopMarkers.sqf
            class assignInterceptTask {};   // fn_assignInterceptTask.sqf

            // Sirene / Audio
            class startSiren {};            // fn_startSiren.sqf
            class stopSiren {};             // fn_stopSiren.sqf
            class saySirenLocal {};         // fn_saySirenLocal.sqf
        };

        // --- Safehouse / Missionsfluss ---
        class Safehouse
        {
            file = "functions";
            class assignSafehouseTask {};   // fn_assignSafehouseTask.sqf
            class safehouseSuccess {};      // fn_safehouseSuccess.sqf
            class finishSafehouseRobber {}; // fn_finishSafehouseRobber.sqf
            class finishSafehouseCops {};   // fn_finishSafehouseCops.sqf
        };

        // --- Fahrzeuge / Sonstiges ---
        class Vehicles
        {
            file = "functions";
            class spawnVehicle {};          // fn_spawnVehicle.sqf
        };

        class Misc
        {
            file = "functions";
            class explodeUnit {};           // fn_explodeUnit.sqf
            class endMission {};            // fn_endMission.sqf
        };
    };
};
