# ArmA 3 Cops & Robbers — Master Plan

This document outlines the overarching plan for developing the Cops & Robbers scenario in ArmA 3. It supplements the detailed design draft in `DESIGN.md` and aligns with current guidance from the ArmA 3, ACE3 and CBA developer communities.

## 1. Guiding References
- **ArmA 3 Developer Guide** – mission structure, SQF conventions and multiplayer best practices.
- **ACE3 Developer Guide** – interaction framework, medical and explosive APIs, and recommended progress bar usage.
- **CBA Developer Guide** – event handlers, settings system and function registration conventions.

Following these resources ensures that scripting patterns, network behaviour and configuration files remain compatible with the broader mod ecosystem.

## 2. Milestones
1. **MVP** – faction spawns, robbery interactions, notifications, loot crates, basic police mechanics and economy.
2. **Trucking & Advanced Economy** – dynamic job board, market pricing and driver skills.
3. **High‑Tier Heists & Siege Zones** – bank/jewelry targets, zone rules and anti‑abuse measures.

Each milestone is delivered in iterative sprints, adhering to the guidelines above for scripting standards and network security.

## 3. Implementation Standards
- Use CBA function and event frameworks for modularity.
- Register ACE interactions client‑side while validating actions server‑side.
- Whitelist remote executions in `description.ext` per ArmA 3 security recommendations.
- Configure gameplay options via `cba_settings.sqf` so servers can override defaults.

## 4. Testing & Validation
- Local and dedicated server tests follow the procedures outlined in the ArmA 3 mission testing guide.
- ACE3 and CBA debug tools assist with verifying interaction conditions, event firing and network synchronisation.
- Automated checks (`make test`) are executed where available to catch scripting errors early.

## 5. Documentation & Maintenance
- Keep function headers and file organisation consistent with CBA and ACE3 templates.
- Reference changes back to this master plan and the detailed design to maintain alignment.

