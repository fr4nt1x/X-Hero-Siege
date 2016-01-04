--=================================================================-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
GAMEMODE_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')

-- These internal libraries set up gamemode's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core gamemode files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core gamemode files.
require('events')

--event_special the event specific events
require('events_special')
require('libraries/spawncreeps')

--just add the original hero name as key, with the abilityname as value
local AbilitiesHeroes = {npc_dota_hero_antimage = "demonhunter_roar",
                   npc_dota_hero_nyx_assassin = "crypt_lord_anubarak_claw",
                    npc_dota_hero_enchantress = "dryad_poison_weapons",
                    npc_dota_hero_luna = "luna_moon_glaive",
                    npc_dota_hero_mirana = "moon_priest_rejunivation",
                    npc_dota_hero_lich = "lich_frost_frenzy",
                    npc_dota_hero_phantom_assassin = "blink",
                    npc_dota_hero_zuus = "mountain_king_thunderspirit",
                    npc_dota_hero_juggernaut = "blademaster_berserk",
                    npc_dota_hero_windrunner = "windrunner_healing",
                    npc_dota_hero_shadow_shaman = "shadow_hunter_healing_ward",
                    npc_dota_hero_omniknight = "paladin_taunt",
                    npc_dota_hero_keeper_of_the_light = "archmage_spell_shield",
                    npc_dota_hero_night_stalker = "dreadlord_sleep",
                    npc_dota_hero_crystal_maiden = "jaina_mana_shield",
                    npc_dota_hero_invoker = "bloodmage_chains",
                    npc_dota_hero_lina="shandris_spell_resistance"}
--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
  
  GameMode.FrostTowers_killed = 0
  GameMode.wave_event_happened = false
  GameMode.kill_event_happened = false
  GameMode.first_time_teleport = true

  GameMode.specialEventCreeps = {"npc_murloc_mutant_special_event_I","npc_wildekin_special_event_II","npc_golem_special_event_III",
                                "npc_tuskarr_special_event_IV","npc_centaur_special_event_V","npc_bristleback_special_event_VI",
                                "npc_death_ghost_special_event_VII","npc_ursa_special_event_VIII","npc_satyr_special_event_IX"}
  GameMode.level_state ={}
  GameMode.level_state.level = 1
  GameMode.level_state.dragonlevel= 1
  GameMode.level_state.wave = 0

  GameMode.timers = {}
  GameMode.openLanes = {}

  local number_players = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
  wave_kills_for_event = 55
  for i = 1,number_players do
   wave_kills_for_event = wave_kills_for_event +5
  end

  if PlayerResource:GetPlayerCount() >= 8 then
    for i = 1,8 do
      
      --hold the first waypoint, level of the lane, creeps per wave
      GameMode.openLanes["spawn"..i] = {waypoint = "wp_p"..i.."_1" , lane_level=0, creeps_per_spawn = {2,3,3,2,2}}
    end
    
  else
    for i = 1,PlayerResource:GetPlayerCount() do

      --hold the first waypoint, level of the lane, creeps per wave
      GameMode.openLanes["spawn"..i] = {waypoint = "wp_p"..i.."_1" , lane_level=0, creeps_per_spawn = {2,3,3,2,2}}
    end
  end


end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  local number_players = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
  local difficulty = GameRules:GetCustomGameDifficulty()
  local AbilitiesHeroes_XX = {npc_dota_hero_mirana= {{"moon_priest_lightning_chaos_XX",4}},
                              npc_dota_hero_enchantress= {{"neutral_spell_immunity",3}},
                              npc_dota_hero_antimage = {{"demonhuner_spell_resistance_XX",3}},
                              npc_dota_hero_luna = {{"luna_neutralisation_XX",5}},
                              npc_dota_hero_nyx_assassin = {{"crypt_lord_burrow_impale_XX",4}},
                              npc_dota_hero_lich ={{"lich_frost_chaos_XX",5}},
                              npc_dota_hero_crystal_maiden = {{"jaina_rain_of_ice_XX",4}},
                              npc_dota_hero_invoker = {{"bloodmage_rain_of_fire_XX",2}},
                              npc_dota_hero_windrunner = {{"windrunner_rockethail_XX",2}},
                              npc_dota_hero_zuus ={{"mountain_king_thunderclap_XX",0},{"mountain_king_stormbolt_XX",1}},
                              npc_dota_hero_omniknight = {{"paladin_light_frenzy_XX",3}},
                              npc_dota_hero_shadow_shaman = {{"shadow_hunter_hex_XX",3}},
                              npc_dota_hero_phantom_assassin = {{"warden_morph_XX",3}},
                              npc_dota_hero_keeper_of_the_light = {{"archmage_frost_shield_XX",2}},
                              npc_dota_hero_night_stalker = {{"deardlord_rain_of_chaos_XX",2}},
                              npc_dota_hero_juggernaut = {{"blademaster_partition_XX",3}},
                              npc_dota_hero_lina = {{"shandris_lightning_attack_XX",2}}
                              }

  if  IsValidEntity(hero) and IsValidEntity(hero:GetPlayerOwner()) and hero:IsRealHero() and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
    if difficulty == 1 then
      hero:SetGold(20000, false)
    elseif difficulty == 2 then
      hero:SetGold(500, false)
    elseif difficulty == 3 then
      hero:SetGold(400, false)
    elseif difficulty == 4 then
      hero:SetGold(300, false)
    end  

  if AbilitiesHeroes_XX[hero:GetUnitName()] ~= nil then 
    for _,ability in pairs(AbilitiesHeroes_XX[hero:GetUnitName()]) do
      PrecacheItemByNameAsync(ability[1], function() end)
    end
  end
    
    --local item = CreateItem("item_tome_big", hero, hero)
    --hero:AddItem(item)
    --local item = CreateItem("item_tome_big", hero, hero)
    --hero:AddItem(item)
    --hero:AddNewModifier(hero, nil,  "modifier_item_ultimate_scepter", {})

    hero.which_special_events = {}
    hero.in_special_event = false
    hero.wave_kills = 0
    hero.creep_kills  =0
    hero.got_kill_bonus = false
    hero.illusion_done = false
    local ability = AbilitiesHeroes[hero:GetUnitName()]
    if ability ~=nil then
      hero:AddAbility(ability)
      hero:UpgradeAbility(hero:FindAbilityByName(ability))
      hero:SetAbilityPoints(1)
    end

    player = hero:GetPlayerOwnerID()
    local point = Entities:FindByName(nil,"dota_goodguys_fort")
    --[[
    unit = CreateUnitByName("npc_dota_hero_spirit_beast",point:GetAbsOrigin(),true,hero,nil,DOTA_TEAM_NEUTRALS)
    -- local ability = unit:FindAbilityByName("ramero_baristal")
    --ability:ApplyDataDrivenModifier(unit, unit, "modifier_baristal", {})
    unit:SetControllableByPlayer(player, true)
    --
    for j = 1,40 do
    illusion = CreateUnitByName("npc_ghul_II",point:GetAbsOrigin()+Vector(1000,0,0),true,hero,nil,DOTA_TEAM_NEUTRALS)
    illusion:SetControllableByPlayer(player, true)
    end
    --[[  
    illusion = CreateUnitByName("npc_dragon_level_III",point:GetAbsOrigin(),true,hero,nil,DOTA_TEAM_GOODGUYS)
    
    illusion = CreateUnitByName("npc_dota_hero_balanar",point:GetAbsOrigin(),true,hero,nil,DOTA_TEAM_NEUTRALS)
    illusion:SetControllableByPlayer(player, true)  
    --]]
    local item = CreateItem("item_healing_pot", hero, hero)
    hero:AddItem(item)
    local item = CreateItem("item_ankh", hero, hero)
    hero:AddItem(item)
    -- These lines will create an item and add it to the player, effectively ensuring they start with the item

    --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
      --with the "example_ability" ability

    local abil = hero:GetAbilityByIndex(1)
    hero:RemoveAbility(abil:GetAbilityName())
    hero:AddAbility("example_ability")]]
  end
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")

  
  --remove invulnerability of the open lanes towers 
  for  k,_  in pairs(GameMode.openLanes) do

    local i,j = string.find(k,"%d")
    local lane = string.sub(k,i,j) 
    local towers = Entities:FindAllByName("tower_p"..lane)
    
    for _,tower in pairs(towers)do
      tower:RemoveModifierByName("modifier_invulnerable")
    end 
  end
  --remove invulnerability of the base towers
  local towers = Entities:FindAllByName("tower_base")
  for _,tower in pairs(towers)do
    tower:RemoveModifierByName("modifier_invulnerable")
  end 
  --enable special event triggers
  local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
  for _,v in pairs(triggers_choice) do
    v:Enable()
  end


  GameMode.timers.timer_creep_spawn = Timers:CreateTimer(0,SpawnCreeps)
  timer_wave_spawn = Timers:CreateTimer(TimeBetweenWaves,SpawnWaves)
  timer_special_arena = Timers:CreateTimer(TimeSpecialArena,specialEventArena)
  timer_wave_message = Timers:CreateTimer(TimeBetweenWaves - 30,SendWaveMessage)
  timer_arena_message = Timers:CreateTimer(TimeSpecialArena - 30,SendSpecialArenaMessage)
  timer_event_roshan = Timers:CreateTimer(SpecialEventRoshan,specialEventRoshan)
  Timers:CreateTimer(30,printEvents)
  GameMode.FrostInfernalDead = false
  GameMode.SpiritBeastDead = false

  local diff = {"Easy","Normal","Hard","Extreme"}
  Notifications:TopToAll({text="DIFFICULTY:"..diff[GameRules:GetCustomGameDifficulty()], duration=10.0})
end




-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  --Convars:RegisterCommand( "openlane1", openlane1, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "openlane2", openlane2, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "openlane3", openlane3, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "openlane4", openlane4, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "openlane5", openlane5, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "closelane1", closelane1, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "closelane2", closelane2, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "closelane3", closelane3, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "closelane4", closelane4, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "closelane5", closelane5, "A console command example", FCVAR_CHEAT )
  --Convars:RegisterCommand( "lasthits", lasthits, "A console command example", FCVAR_CHEAT )

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
        local i,j = string.find(Convars,"%d")
        local lane = string.sub(Convars,i,j)

    end
  end

  print( '*********************************************' )
end
