-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models




  -- Sounds can precached here like anything else


  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("item_ankh", context)
  PrecacheItemByNameSync("item_boots_of_speed", context)
  PrecacheItemByNameSync("demonhunter_roar", context)
  PrecacheItemByNameSync("dryad_poison_weapons", context)
  PrecacheItemByNameSync("luna_moon_glaive", context)
  PrecacheItemByNameSync("moon_priest_rejunivation", context)
  PrecacheItemByNameSync("lich_frost_frenzy", context)
  PrecacheItemByNameSync("blademaster_berserk", context)
  PrecacheItemByNameSync("windrunner_healing", context)
  PrecacheItemByNameSync("shadow_hunter_healing_ward", context)
  PrecacheItemByNameSync("paladin_taunt", context)
  PrecacheItemByNameSync("archmage_spell_shield", context)
  PrecacheItemByNameSync("dreadlord_sleep", context)
  PrecacheItemByNameSync("jaina_mana_shield", context)
  PrecacheItemByNameSync("bloodmage_chains", context)
  PrecacheItemByNameSync("shandris_spell_resistance", context)
  
  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_demonhunter", context)
  PrecacheUnitByNameSync("npc_dota_hero_crypt_lord", context)
  
  PrecacheUnitByNameSync("npc_dota_hero_magtheridon", context)
  PrecacheUnitByNameSync("npc_dota_hero_grom_hellscream", context)
  PrecacheUnitByNameSync("npc_dota_hero_illidan", context)
  PrecacheUnitByNameSync("npc_dota_hero_proudmoore", context)
  PrecacheUnitByNameSync("npc_dota_hero_balanar", context)
  PrecacheUnitByNameSync("npc_dota_hero_arthas", context)
  PrecacheUnitByNameSync("npc_dota_hero_banehallow", context)
  PrecacheUnitByNameSync("npc_banehallow_tomb", context)
  PrecacheUnitByNameSync("npc_dota_hero_baristal", context)
  PrecacheUnitByNameSync("npc_dota_hero_ramero", context)
  PrecacheUnitByNameSync("npc_dota_hero_spirit_beast", context)
  PrecacheUnitByNameSync("npc_dota_hero_frost_infernal", context)

  PrecacheUnitByNameSync("npc_phoenix_I", context)
  PrecacheUnitByNameSync("npc_phoenix_egg", context)

  PrecacheUnitByNameSync("npc_lich_frost_infernal", context)
  PrecacheUnitByNameSync("npc_spirit_of_vengeance", context)

  PrecacheUnitByNameSync("npc_water_servant_I", context)
  PrecacheUnitByNameSync("npc_water_servant_II", context)
  PrecacheUnitByNameSync("npc_water_servant_III", context)

  PrecacheUnitByNameSync("npc_water_elemental_I", context)
  PrecacheUnitByNameSync("npc_water_elemental_II", context)
  PrecacheUnitByNameSync("npc_water_elemental_III", context)

  PrecacheUnitByNameSync("npc_carrion_beetle_I", context)
  PrecacheUnitByNameSync("npc_carrion_beetle_II", context)
  PrecacheUnitByNameSync("npc_carrion_beetle_III", context)
  PrecacheUnitByNameSync("npc_carrion_beetle_IV", context)
  
  PrecacheUnitByNameSync("npc_serpentine_ward_I", context)
  PrecacheUnitByNameSync("npc_serpentine_ward_II", context)
  PrecacheUnitByNameSync("npc_serpentine_ward_III", context)
  PrecacheUnitByNameSync("npc_serpentine_ward_IV", context)

  PrecacheUnitByNameSync("npc_ursa", context)
  PrecacheUnitByNameSync("npc_death_ghost_tower", context)
  PrecacheUnitByNameSync("npc_magnataur_destroyer_crypt", context)
  
  PrecacheUnitByNameSync("npc_dota_hero_roshan", context)

  PrecacheUnitByNameSync("npc_ghul", context)
  PrecacheUnitByNameSync("npc_fiend", context)
  PrecacheUnitByNameSync("npc_necromancer", context)
  PrecacheUnitByNameSync("npc_skeleton_mage", context)
  PrecacheUnitByNameSync("npc_abomination", context)
  PrecacheUnitByNameSync("npc_frost_wyrm", context)
--]]
  PrecacheUnitByNameSync("npc_archer", context)
  PrecacheUnitByNameSync("npc_huntress", context)
  PrecacheUnitByNameSync("npc_druid", context)
  PrecacheUnitByNameSync("npc_chimera", context)
  PrecacheUnitByNameSync("npc_mountain_giant", context)
  --]]

  PrecacheUnitByNameSync("npc_soldier", context)
  PrecacheUnitByNameSync("npc_sharpshooter", context)
  PrecacheUnitByNameSync("npc_priest", context)
  PrecacheUnitByNameSync("npc_knight", context)
  PrecacheUnitByNameSync("npc_spellbreaker", context)
  --]]
  PrecacheUnitByNameSync("npc_berserker", context)
  PrecacheUnitByNameSync("npc_grunt", context)
  PrecacheUnitByNameSync("npc_shaman", context)
  PrecacheUnitByNameSync("npc_tauren", context)
  PrecacheUnitByNameSync("npc_kodo_beast", context)  
--]]
PrecacheUnitByNameSync("npc_necro_wave_I", context)
PrecacheUnitByNameSync("npc_naga_wave_II", context)
PrecacheUnitByNameSync("npc_guard_wave_III", context)
PrecacheUnitByNameSync("npc_captain_wave_IV", context)
PrecacheUnitByNameSync("npc_slardar_wave_V", context)
PrecacheUnitByNameSync("npc_orc_raider_wave_VI", context)
PrecacheUnitByNameSync("npc_luna_wave_VII", context)
PrecacheUnitByNameSync("npc_chaos_orc_wave_VIII", context)
PrecacheUnitByNameSync("npc_banshee_wave_IX", context)
PrecacheUnitByNameSync("npc_warlock_wave_X", context)
PrecacheUnitByNameSync("npc_bloodelf_wave_XI", context)
PrecacheUnitByNameSync("npc_keeper_wave_XII", context)

PrecacheUnitByNameSync("npc_murloc_mutant_special_event_I", context)
PrecacheUnitByNameSync("npc_wildekin_special_event_II", context)
PrecacheUnitByNameSync("npc_golem_special_event_III", context)
PrecacheUnitByNameSync("npc_tuskarr_special_event_IV", context)
PrecacheUnitByNameSync("npc_centaur_special_event_V", context)
PrecacheUnitByNameSync("npc_bristleback_special_event_VI", context)
PrecacheUnitByNameSync("npc_death_ghost_special_event_VII", context)
PrecacheUnitByNameSync("npc_ursa_special_event_VIII", context)
PrecacheUnitByNameSync("npc_satyr_special_event_IX", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:InitGameMode()
end