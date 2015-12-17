require('internal/util')
require('libraries/notifications')

--[[
  The Variables that have to be saved in the GameMode Entity are declared in OnAllPlayersLoaded
]]

local creepsToSpawn = {{"npc_soldier","npc_sharpshooter","npc_priest","npc_knight","npc_spellbreaker"},
                       {"npc_archer","npc_huntress","npc_druid","npc_chimera","npc_mountain_giant"},  
                       {"npc_ghul","npc_fiend","npc_necromancer","npc_abomination","npc_frost_wyrm"},
                       {"npc_grunt","npc_berserker","npc_shaman","npc_tauren","npc_kodo_beast"}}

--Holds which race to spawn cycles through 0,1,2,3
local creepround = 0



-- names of the spawnpoints, waypoints stand in Gamemode.openLanes
local spawn_waves = {"wave_west", "wave_north" ,"wave_east", "wave_south"}

local creepsWave = {"npc_necro_wave_I","npc_naga_wave_II","npc_guard_wave_III",
              "npc_captain_wave_IV","npc_slardar_wave_V","npc_orc_raider_wave_VI",
              "npc_luna_wave_VII","npc_chaos_orc_wave_VIII","npc_banshee_wave_IX",
              "npc_warlock_wave_X","npc_bloodelf_wave_XI","npc_keeper_wave_XII"}

local dragonNames = {"npc_dragon_level_I","npc_dragon_level_II","npc_dragon_level_III"}

final_wave_creeps ={
                    west = {"npc_abomination_final_wave","npc_banshee_final_wave","npc_necro_final_wave","npc_magnataur_final_wave","npc_dota_hero_balanar_final_wave"},
                    north = {"npc_tauren_final_wave","npc_chaos_orc_final_wave","npc_warlock_final_wave","npc_orc_raider_final_wave","npc_dota_hero_grom_hellscream_final_wave"},
                    east = {"npc_druid_final_wave","npc_guard_final_wave","npc_keeper_final_wave","npc_luna_final_wave","npc_dota_hero_illidan_final_wave"},
                    south = {"npc_captain_final_wave","npc_marine_final_wave","npc_captain_final_wave","npc_knight_final_wave","npc_dota_hero_proudmoore_final_wave"}
                  }

creep_kills_for_gold = 600 
creep_kills_for_event = 1500

TimeBetweenWaves = 4*60
TimeBetweenCreepWavesTop = 7

numberOfTopWaves = 0
SpecialArenaDuration = 2*60
SpecialEventKillsDuration = 2*60
SpecialEventWaveKillsDuration = 2*60
SpecialEventFrostInfernalDuration = 2*60
SpecialEventRoshan = 13*60
SpecialEventRoshanDuration = 1.1*60
TimeBetweenCreepSpawn = 15
TimeSpecialArena = 60*22

waves_between_levels = {10,44,68,93}

waves_between_dragons = {28,56,84,108}

--only in extreme mode needs to be after the normal dragon attack
waves_between_special_dragon_attack = {38,72,100,120}


spawn_dragon = false

function SpawnCreeps()
  --Delete the timers if the final wave is imminent
  local spawns = {}

  -- holds the names of the first waypoints for each lane
  --local waypoints = {"wp_p1_1","wp_p2_1","wp_p3_1","wp_p4_1","wp_p5_1","wp_p6_1","wp_p7_1","wp_p8_1"} 
  for spawn,way in  pairs(GameMode.openLanes) do 
  -- get the coordinates where to spawn the creeps and the waypoint where they should walk

    local point = Entities:FindByName(nil, spawn):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil,way["waypoint"])
    local level = math.min(GameMode.level_state.level + way["lane_level"],5)

    --Check if levellup was so that a dragon has to be spawned
    if spawn_dragon then
      Timers:CreateTimer(function()
      local unit = CreateUnitByName(dragonNames[math.min(3,GameMode.level_state.dragonlevel-1)], point+RandomVector(RandomInt(0, 50)), true, nil, nil, DOTA_TEAM_NEUTRALS)
      unit:SetInitialGoalEntity(waypoint)
      end)
    end
    if level <= 2 then
      for i = 1,2 do 
        for j = 1,way["creeps_per_spawn"][level] do
        Timers:CreateTimer(function()
          local unit = CreateUnitByName(creepsToSpawn[(creepround % 4)+1][i], point+RandomVector(RandomInt(0, 50)), true, nil, nil, DOTA_TEAM_NEUTRALS)
          unit:SetMustReachEachGoalEntity(true)
          unit:SetInitialGoalEntity(waypoint)
        end) 
        end
      end
    else
      for i = 1,math.min(level,4) do 
        for j = 1,way["creeps_per_spawn"][level] do
        Timers:CreateTimer(function()
          local unit = CreateUnitByName(creepsToSpawn[(creepround % 4)+1][i], point+RandomVector(RandomInt(0, 50)), true, nil, nil, DOTA_TEAM_NEUTRALS)
          unit:SetInitialGoalEntity(waypoint)
          unit:SetMustReachEachGoalEntity(true)
        end) 
        end
      end
    end
  end

  if spawn_dragon then
    spawn_dragon = false
  end

  --increment the creepround before level check
  creepround = creepround+ 1
 
  --[[
  The level up system depends on specific creeprounds,
  which are defined in waves_between_levels, only level up 5 times
  ]]  
  if GameMode.level_state.level <= 5 and creepround == waves_between_levels[GameMode.level_state.level] then
    --increment the level
    GameMode.level_state.level = GameMode.level_state.level +1

    --print the level up msg only when the creeps actually get stronger
    if GameMode.level_state.level > 2 then 
      local msg = "Level "..(GameMode.level_state.level-1).." time. The creeps got stronger!"
      Notifications:TopToAll({text=msg, duration=5.0})
    end
    
    --[[Precache the next creeps that get spawned
    if GameMode.level_state.level <= 4 then
      for i = 1,4 do
        PrecacheUnitByNameAsync(creepsToSpawn[i][GameMode.level_state.level], function() end) 
      end
    end
    --]]
  end

  -- integer tells you how many rounds of dragons get spawned 4 = 4 rounds
  if  GameMode.level_state.dragonlevel <= 4 and creepround == waves_between_dragons[ GameMode.level_state.dragonlevel] then
    GameMode.level_state.dragonlevel =  GameMode.level_state.dragonlevel +1
    --Precache the next dragon
    if GameMode.level_state.dragonlevel <= 4 then
      PrecacheUnitByNameAsync(dragonNames[GameMode.level_state.dragonlevel-1], function() end)
    end
    --send msg
    Notifications:TopToAll({text="Dragon Attack next Creep wave!", duration=5.0})
    spawn_dragon = true
  end
  
  -- integer tells you how many rounds of special dragons get spawned 4 = 4 rounds
  if  GameRules:GetCustomGameDifficulty() == 4 and creepround == waves_between_special_dragon_attack[GameMode.level_state.dragonlevel-1] then
    local dragonspawns = Entities:FindAllByName("special_dragons")
    for _,point in  pairs(dragonspawns) do
      for i = 1,4 do
        Timers:CreateTimer(function()
        local unit = CreateUnitByName(dragonNames[math.min(3,GameMode.level_state.dragonlevel-1)],point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
        unit:SetInitialGoalEntity(Entities:FindByName(nil,"base"))
          end)
      end
    end
    --send msg
    Notifications:TopToAll({text="Special Dragon attack at your castle!", duration=5.0})
  end

  return TimeBetweenCreepSpawn

end

function SpawnWaves()

  --waypoint for base to set the spawned creeps to
  local waypoint = Entities:FindByName(nil,"base")
  --Find the points were the wave should appear, runs clockwise around the base starting west(left)
  local point = Entities:FindByName(nil, spawn_waves[(GameMode.level_state.wave%4) +1]):GetAbsOrigin()

  DebugPrint("wave",GameMode.level_state.wave)

  --Add 5 creeps to spawn per player currently in game recalculate everytime
  local number_players = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
  local number_of_wave_creeps = 10

  if number_players >= 2 then
    for i = 2,number_players do
      number_of_wave_creeps = number_of_wave_creeps + 5
    end
  end

  --spawn the amount of creeps and set the waypoint
  for j = 1,number_of_wave_creeps do
    Timers:CreateTimer(function()
      local unit = CreateUnitByName(creepsWave[GameMode.level_state.wave], point+RandomVector(RandomInt(0, 50)), true, nil, nil, DOTA_TEAM_NEUTRALS)

      unit:SetInitialGoalEntity(waypoint)
      end) 
  end

  --increment the wave counter
  GameMode.level_state.wave = GameMode.level_state.wave +1
  
  --only spawn 12 waves, first wave spawns when the counter is 0
  if GameMode.level_state.wave >= 12  then
    return nil
  else
    return TimeBetweenWaves
  end
end

function SendWaveMessage()
  -- body
   --Delete the timers if the final wave is imminent
  if GameMode.level_state.wave >= 12 then
    return nil
  end
  local directions = {"west" , "north", "east", "south"}
  -- Send a notification to all players that displays up top for 5 seconds
    Notifications:TopToAll({text="Warning. Huge wave of darkness incoming from the "..directions[GameMode.level_state.wave%4 + 1] .."! Arriving in 30 seconds!", duration=5.0})
    return TimeBetweenWaves
end

function SendSpecialArenaMessage()
  -- body
   --Delete the timers if the final wave is imminent

  if GameMode.FinalWave then
    return nil
  end
  -- Send a notification to all players that displays up top for 5 seconds
    Notifications:TopToAll({text="Special Arena Event in 30 seconds. Spent your gold before it.", duration=5.0})
    return nil
end


function spawn_second_phase_left()
  -- body

  local point = Entities:FindByName(nil, "spawn_phase2_left"):GetAbsOrigin()
  local waypoint = Entities:FindByName(nil,"wp_phase2_left")
    for j = 1,10 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("npc_ghul_II", point+RandomVector(RandomInt(0, 50)), true, nil, nil, DOTA_TEAM_NEUTRALS)
        unit:SetInitialGoalEntity(waypoint)
      end) 
    end 
  return TimeBetweenCreepSpawn 
end

function spawn_second_phase_right()
  -- body

  local point = Entities:FindByName(nil, "spawn_phase2_right"):GetAbsOrigin()
  local waypoint = Entities:FindByName(nil,"wp_phase2_right")
    
  for j = 1,10 do
      Timers:CreateTimer(function()
      local unit = CreateUnitByName("npc_orc_II", point+RandomVector(RandomInt(0, 50)), true, nil, nil, DOTA_TEAM_NEUTRALS)
        unit:SetInitialGoalEntity(waypoint)
      end) 
  end
  return TimeBetweenCreepSpawn  
end

function FinalWave()
  -- body
  local final_spawn = nil
  local waypoint = Entities:FindByName(nil,"base")
  local directions = {"west","north","east","south"}
  DebugPrint("Final Wave spawn")
  for _,direction in pairs(directions) do
    for i = 1,5 do
      final_spawn = Entities:FindAllByName("spawn_final_"..direction.."_"..i)
      for _,point in pairs(final_spawn) do
        DebugPrint("spawn unit")
        Timers:CreateTimer(function()
        local unit = CreateUnitByName(final_wave_creeps[direction][i], point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
        unit:AddNewModifier(nil, nil, "modifier_stunned", {duration= 8,IsHidden = true})
        unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration= 8,IsHidden = true})
        unit:SetInitialGoalEntity(waypoint)
        end)  
      end
    end
  end

  local heroes = HeroList:GetAllHeroes()
  local point = Entities:FindByName(nil,"base"):GetAbsOrigin()

  for _,hero in pairs(heroes) do

    if IsValidEntity(hero) and hero:IsRealHero() and hero:GetTeam() == DOTA_TEAM_GOODGUYS then

      hero:Stop()

      if not hero:IsAlive() then
        hero:RespawnHero(false, false, false)
        hero.ankh_respawn = false
        hero:SetRespawnsDisabled(false)
      
        if hero.respawn_timer ~= nil then
          Timers:RemoveTimer(hero.respawn_timer)
          hero.respawn_timer = nil
        end
      end

      FindClearSpaceForUnit(hero, point, true)
      hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 2,IsHidden = true})
      hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 2,IsHidden = true})

      PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
      Timers:CreateTimer(1,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                              end)
    end
  end

  local teleporters = Entities:FindAllByName("teleport")
  
  for _,v in pairs(teleporters) do
    DebugPrint("enable teleport trigger")
    v:Enable()
  end

  return nil
end


function spawn_creeps_top_first()
  -- body
  numberOfTopWaves = numberOfTopWaves + 1
  DebugPrint("top waves")
  
  if numberOfTopWaves == 1 then
    local heroes = HeroList:GetAllHeroes()

    for _,hero in pairs(heroes) do
        if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
          hero:RemoveModifierByName("modifier_stunned")
          hero:RemoveModifierByName("modifier_invulnerable")
          PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil)
        end
    end
  end
  
  local creep = "npc_ghul_II"

  if  numberOfTopWaves >= 12 then
    FireGameEventLocal("destroy_door", {door_name = "door_top_1", obstruction_name = "obstruction_top_1"})
    numberOfTopWaves = 0
    TimeBetweenCreepWavesTop = 7
    return nil
  end
  
  if numberOfTopWaves >= 6 then
    creep = "npc_death_ghost_tower"
    --one more as in top, because one gets substracted before finish
    TimeBetweenCreepWavesTop = 8
  end

  for i = 1,4 do 
    local point = Entities:FindByName(nil, "top_spawn_"..i):GetAbsOrigin()

      for j = 1,3 do
        CreateUnitByName(creep, point, true, nil, nil, DOTA_TEAM_NEUTRALS) 
      end 
  end
  TimeBetweenCreepWavesTop = TimeBetweenCreepWavesTop-1
  return TimeBetweenCreepWavesTop 
end

function spawn_creeps_top_second()
  -- body
  numberOfTopWaves = numberOfTopWaves + 1
  DebugPrint("top waves")
  
  if numberOfTopWaves == 1 then
    local heroes = HeroList:GetAllHeroes()

    for _,hero in pairs(heroes) do
        if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
          hero:RemoveModifierByName("modifier_stunned")
          hero:RemoveModifierByName("modifier_invulnerable")
          PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil)
        end
    end
  end
  
  local creep = "npc_orc_II"
  local number_of_creeps = 3
  if  numberOfTopWaves >= 12 then
    FireGameEventLocal("destroy_door", {door_name = "door_arthas", obstruction_name = "obstruction_arthas"})
    numberOfTopWaves = nil
    TimeBetweenCreepWavesTop = 7
    local arthas = CreateUnitByName("npc_dota_hero_arthas",Entities:FindByName(nil,"spawn_arthas"):GetAbsOrigin(),true,nil,nil,DOTA_TEAM_NEUTRALS)
    arthas:SetAngles(0, 180, 0)
    
    return nil
  end
  
  if numberOfTopWaves >= 6 then
    creep = "npc_magnataur_final_wave"
    --one more as in top, because one gets substracted before finish
    TimeBetweenCreepWavesTop = 8
    number_of_creeps = 3
  end

  for i = 1,4 do 
    local point = Entities:FindByName(nil, "top_spawn_"..i):GetAbsOrigin()

      for j = 1,number_of_creeps do
        CreateUnitByName(creep, point, true, nil, nil, DOTA_TEAM_NEUTRALS) 
      end 
  end
  TimeBetweenCreepWavesTop = TimeBetweenCreepWavesTop-1
  return TimeBetweenCreepWavesTop 
end


