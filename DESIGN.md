# CnR:NG → ArmA 3 (ACE³/CBA) — Design & Implementation Plan



---

## 1) Inspirationsbasis (aus CnR:NG)

* **Robberies & Heists**: Tankstellen, ATMs, Tresor/Bank, Juwelier, Lagerhalle, etc.
* **Trucking 2.0-Ideen**: Routenwahl, Gütertypen, Dringlichkeitsaufträge, Marktpreise, Achievements.
* **Skill-/Role-Gates**: Orte/Interaktionen sind skill-/rollenbasiert (z. B. PO öffnet Poller automatisch).
* **Police/Medic QoL**: Schnelle Alarme, Siegezonen, UI-Feedback, kleine Regeln (Jailtime, Manhunt).

*(Wir adaptieren die Ideen systemisch — konkrete UI/Kommandos werden ACE-Interaktionen und Marker/Notifications.)*

---

## 2) MVP-Umfang (Phase 1)

1. **Fraktionen & Spawns**: BLUFOR=Cops, CIV=Robbers, je 3 feste Spawnpunkte.
2. **ACE-Interaktionen**:

   * Tankstellenraub per NPC/Objekt („Ausrauben“, 150 s Progress).
   * ATM-Hack (Tool benötigt), Tresor-Interaktion (Schneidbrenner/Sprengsatz Gate).

3. **Alarm-/Benachrichtigungssystem**: Startet Robbery → setzt Marker + Broadcast an Cops, Throttle & Cooldowns.
4. **Beutecontainer**: Kiste spawnt beim Erfolg; Transport zum **Fence/Safehouse** gegen Geld.
5. **Polizei-Mechaniken**: Festnehmen/Abführen, Ticketieren, Jail (45–180 s), Beute beschlagnahmen.
6. **Ökonomie (basic)**: Cash, Item-Preise, Heist-Belohnungen, simple Marktparameter.


---

## 3) Mods & Tech-Stack

* **Hard**: CBA_A3, ACE³ (Interaction, Medical light, Explosives, Logistics, ProgressBar APIs).


---

## 4) Missionsstruktur & Dateien

```
missionRoot/
  description.ext
  init.sqf
  initServer.sqf
  initPlayerLocal.sqf
  cba_settings.sqf
  CfgFunctions.hpp
  functions/
    fn_setupTeams.sqf
    fn_initRobberyTargets.sqf
    fn_addRobberyActions.sqf
    fn_startRobbery.sqf
    fn_finishRobbery.sqf
    fn_failRobbery.sqf
    fn_notifyCops.sqf
    fn_spawnLootCrate.sqf
    fn_registerArrest.sqf
    fn_confiscateLoot.sqf
    fn_economy_getPrice.sqf
    fn_economy_payout.sqf
    fn_skill_check.sqf
    fn_trucking_offerJobs.sqf (Phase 2)
    ...
  sounds/
  mission.sqm (benannte Objekte/NPCs/Marker)
```

---

## 5) Cfg & Engine-Hooks

**description.ext**

* CfgFunctions inkl. `tag = "CR"`.
* RemoteExec für erlaubte Funktionen.
* Respawn-Einstellungen, ACE RscTitles (falls Progress/Notifications custom), CfgSounds (Alarme).

**CfgFunctions.hpp (Beispiel)**

```cpp
class CfgFunctions {
  class CR {
    tag = "CR";
    class Core {
      file = "functions";
      class setupTeams {};
      class initRobberyTargets {};
      class addRobberyActions {};
      class startRobbery {};
      class finishRobbery {};
      class failRobbery {};
      class notifyCops {};
      class spawnLootCrate {};
      class registerArrest {};
      class confiscateLoot {};
      class economy_getPrice {};
      class economy_payout {};
      class skill_check {};
      class trucking_offerJobs {}; // Phase 2
    };
  };
};
```

**remoteExec (description.ext)**

```cpp
class CfgRemoteExec {
  class Functions {
    mode = 1; jip = 1;
    class CR_fnc_notifyCops { allowedTargets = 2; } // Server → Clients
    class CR_fnc_startRobbery { allowedTargets = 2; } // Server bestätigt Start → Alle
    class CR_fnc_finishRobbery { allowedTargets = 2; }
    class CR_fnc_failRobbery   { allowedTargets = 2; }
    class CR_fnc_spawnLootCrate{ allowedTargets = 2; }
  };
};
```

**initServer.sqf (Ausschnitt)**

```sqf
[] call CR_fnc_setupTeams;
[] call CR_fnc_initRobberyTargets;
publicVariable "CR_RobberySites"; // [{obj, type, name, cooldown}, ...]


**initPlayerLocal.sqf (Ausschnitt)**

```sqf
[] call CR_fnc_addRobberyActions; // Client-side ACE actions on discovered targets
```

---

## 6) ACE-Interaktionen (Pattern)

**Ziel**: Scripted Actions pro Zieltyp (Tankstelle/ATM/Tresor), mit `condition` (Cooldown, Tool/Skill) & `statement`.

```sqf
// fn_addRobberyActions.sqf (Client)
{
  private _obj  = _x select 0;
  private _type = _x select 1; // "GAS", "ATM", "SAFE"
  private _name = _x select 2;

  private _action = [
    format ["CR_%1Rob", _type],
    format ["%1 ausrauben", _name],
    "",
    {
      // onSelect
      [(_this select 0), (_this select 1), _type] remoteExecCall ["CR_fnc_startRobbery", 2];
    },
    {
      // condition
      params ["_target","_player","_params"];
      (alive _player) &&
      !(_target getVariable ["CR_busy", false]) &&
      [("robbery"), _player] call CR_fnc_skill_check &&
      (serverTime > (_target getVariable ["CR_cdUntil", 0]))
    }
  ] call ace_interact_menu_fnc_createAction;

  [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach (missionNamespace getVariable ["CR_RobberySites", []]);
```

**Progress & QTE**: ACE Progressbar (`ace_common_fnc_progressBar`) oder QuickTime-Event-Mod (optional) einbinden.

---

## 7) Robbery-Flow (Server)

**Start** (`CR_fnc_startRobbery`)

```sqf
params ["_obj","_player","_type"];
if (!isServer) exitWith {};
if (_obj getVariable ["CR_busy", false]) exitWith {};

_obj setVariable ["CR_busy", true, true];
_obj setVariable ["CR_cdUntil", serverTime + 600, true]; // 10 min cooldown

// Broadcast Marker + Alarm
[[_obj, _type, _player], "CR_fnc_notifyCops"] remoteExec ["call", 0, true];

// Start a server-side timer
[_obj, _player, _type] spawn {
  params ["_o","_p","_t"];
  private _dur = switch (_t) do {case "GAS":150; case "ATM":180; case "SAFE":210; default {150};};
  private _ok = true;
  for "_i" from 1 to _dur do {
    sleep 1;
    if (!alive _p || (_p distance _o) > 5) exitWith {_ok = false};
  };
  if (_ok) then {
    [_o, _p, _t] call CR_fnc_finishRobbery;
  } else {
    [_o, _p, _t] call CR_fnc_failRobbery;
  };
};
```

**Erfolg** (`CR_fnc_finishRobbery`)

```sqf
params ["_obj","_player","_type"];
if (!isServer) exitWith {};
[_obj, _type] call CR_fnc_spawnLootCrate; // crate with class "CR_Loot_%1"
[_player, _type] call CR_fnc_economy_payout; // optional sofortiger Teilbetrag
_obj setVariable ["CR_busy", false, true];
```

**Fehlschlag** (`CR_fnc_failRobbery`)

```sqf
params ["_obj","_player","_type"];
_obj setVariable ["CR_busy", false, true];
// Optional: Cop-Bonus für Verhinderung
```

**Notifys** (`CR_fnc_notifyCops`)

```sqf
params ["_payload"]; // [_obj,_type,_player]
_payload params ["_obj","_type","_plr"];

// Marker für Cops erstellen (client-side on each Cop)
if (side player isEqualTo west) then {
  private _m = createMarkerLocal [format ["CR_m_%1", diag_tickTime], position _obj];
  _m setMarkerTypeLocal "mil_warning";
  _m setMarkerTextLocal format ["%1 - %2", _type, name _plr];
  _m setMarkerColorLocal "ColorRed";
  // RscTitle / hintC / cutText für Audio/Visuelles Feedback
};
```

---

## 8) Polizei-Loop

* **Festnahme**: `addAction`/ACE-Interaktion „Festnehmen“ (nur on-foot).
* **Ticket/Jail**: Menüs via ACE-Untermenü oder Dialog; Jailzeit 45–180 s.
* **Beschlagnahme**: Interaktion am Beutecontainer/Spieler-Inventar; Cash & Items an Staat.

**Arrest (Server-Stub)**

```sqf
// CR_fnc_registerArrest.sqf
params ["_cop","_sus"];
if (!isServer) exitWith {};
// remove weapons, set captive, moveInCargo policeCar, set variable jail, timer, etc.
```

---

## 9) Economy & Skills (Basismodell)

* **Ökonomie**: Preisfunktionen per Tabelle + Multiplikatoren (Heat/Market). Beispiel: `CR_Economy select "GAS_BASE"` × `robberyTierMult`.
* **Skills**: `CR_fnc_skill_check` liest per Profile/DB: `robbery>=X` → erlaube High-Tier Ziele; Cops-Grade → Poller öffnen.

```sqf
// CR_fnc_skill_check.sqf
params ["_action","_unit"];
private _lvl = _unit getVariable [format ["CR_skill_%1", _action], 0];
_lvl >= 1;
```

---


* **Jobboard**: Terminalobjekte mit ACE-„Trucking-Jobs ansehen“ → Liste generierter Routen (Start-Hub → Ziel, Gütertyp, Zeitlimit, Bonus).
* **Dynamischer Markt**: Güterpreise ±%/Zeit, seltene „Urgent Cargo“. Skills gates (Driver-Level) für Spezialaufträge.
* **Datenpunkte**: `trucking_jobs`, `delivered_goods`, `player_driver_stats`.

---



* Bank/Heist-Orte in „Siege“-Triggern: Inside → bestimmte Regeln (z. B. Waffen erlaubt, Timer, Respawn-Block).
* Visual: Dome/Marker, Audio-Cues.

---