/*
    Funktion: CR_fnc_openArsenal
    Zweck: Öffnet ein ACE-Arsenal mit fraktionsabhängigen Whitelist-Items.
    Parameter:
        0: OBJECT - Arsenal-Container
        1: OBJECT - Spieler, der das Arsenal nutzt
*/

params ["_box", "_caller"];

private _items = switch (side _caller) do
{
    case west:
    {
        [
            "SMG_05_F",
            "30Rnd_9x21_Mag_SMG_02",
            "U_B_CombatUniform_mcam",
            "V_TacVest_blk_POLICE"
        ]
    };
    case civilian:
    {
        [
            "hgun_PDW2000_F",
            "30Rnd_9x21_Mag",
            "U_C_Poor_1",
            "V_Rangemaster_belt"
        ]
    };
    default
    {
        []
    };
};

[_box, _items] call ace_arsenal_fnc_clearBox;
[_box, _items] call ace_arsenal_fnc_addVirtualItems;
[_box, _caller, true] call ace_arsenal_fnc_openBox;
