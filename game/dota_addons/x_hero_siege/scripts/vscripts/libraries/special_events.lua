require('libraries/tools')
require('libraries/notifications')



function specialEventRoshan()
  --body

  for _,v in pairs(Timers.timers) do
    if v.endTime ~= nil then 
      v.endTime = v.endTime + SpecialEventRoshanDuration+4+5
    end
  end
  
  local msg = "Special Event: You can't kill Roshan. Just survive for "..sec2Min(SpecialEventRoshanDuration).." minutes to get bonus gold."
  Notifications:TopToAll({text=msg, duration=5.0})
  
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

  for _,unit in pairs(units) do
    if IsValidAlive(unit) then
      unit:RemoveModifierByName("modifier_stunned")
      unit:RemoveModifierByName("modifier_invulnerable")

      unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
      unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
    end
  end

  FireGameEventLocal("make_base_towers_invulnerable", {})

  Timers:CreateTimer(SpecialEventRoshanDuration+5,stopEventRoshan)

  local heroes = HeroList:GetAllHeroes()
  local point = Entities:FindByName(nil,"spawn_roshan_hero")

  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventRoshanDuration)

  for _,hero in pairs(heroes) do

    if IsValidEntity(hero) and hero:GetTeam() == DOTA_TEAM_GOODGUYS and hero:IsRealHero() then
      --save position before moving hero
      hero.position_roshan = hero:GetAbsOrigin()
      FireGameEventLocal("teleport_hero_to_special_event", {hero_index = hero:GetEntityIndex() , teleport_entity_index = point:GetEntityIndex()})
    end

  end

  FireGameEventLocal("teleport_all_units_to_hero",{stun_duration = 0})
  
  local point = Entities:FindByName(nil,"spawn_roshan"):GetAbsOrigin()

  GameMode.roshan = CreateUnitByName("npc_dota_hero_roshan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
  GameMode.roshan:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  GameMode.roshan:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

  
end


function stopEventRoshan()
  local heroes = HeroList:GetAllHeroes()
  Timers:CreateTimer(2,endSpecialEventRoshan)
  GameMode.roshan:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 2,IsHidden = true})
  GameMode.roshan:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 2,IsHidden = true})
  for _,hero in pairs(heroes) do 
    if IsValidEntity(hero) and hero:GetTeam() == DOTA_TEAM_GOODGUYS and hero:IsRealHero() then
      hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 2,IsHidden = true})
      hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 2,IsHidden = true})
    end
  end
end


function endSpecialEventRoshan()
  -- body

  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    if IsValidAlive(unit) then
      unit:RemoveModifierByName("modifier_stunned")
      unit:RemoveModifierByName("modifier_invulnerable")
    end
  end
  
  FireGameEventLocal("make_base_towers_vulnerable", {})

  local heroes = HeroList:GetAllHeroes()

  for _,hero in pairs(heroes) do

    if IsValidEntity(hero) and hero:GetTeam() == DOTA_TEAM_GOODGUYS and hero:IsRealHero() then

      hero.in_special_event = false
      
      if hero:IsAlive() then

        if IsValidEntity(hero:GetPlayerOwner()) then
          PlayerResource:ModifyGold(hero:GetPlayerOwnerID(),8000, false,  DOTA_ModifyGold_Unspecified)
        end

      else
        if hero.ankh_respawn then
          if IsValidEntity(hero:GetPlayerOwner()) then
            PlayerResource:ModifyGold(hero:GetPlayerOwnerID(),8000, false,  DOTA_ModifyGold_Unspecified)
          end
        end
      end

      FireGameEventLocal("teleport_hero_from_special_event", {hero_index = hero:GetEntityIndex(),stun_duration = 0.5 , teleport_point_x = hero.position_roshan[1], teleport_point_y = hero.position_roshan[2], teleport_point_z = hero.position_roshan[3]})
      hero.position_roshan = nil
    end
  end

  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  GameMode.roshan:RemoveSelf()
  GameMode.roshan = nil
  
  FireGameEventLocal("teleport_all_units_to_hero",{stun_duration = 0.5})
  
  return nil
end

--------------------------------------------------------------------------------------------------------------------
function specialEventArena()
  --body
  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
      v.endTime = v.endTime + SpecialArenaDuration+5+2
    end
  end
  local msg = "Special Event Arena: Kill as many units as you can. You have "..sec2Min(SpecialArenaDuration).." minutes."
  Notifications:TopToAll({text=msg, duration=5.0})
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

  for _,unit in pairs(units) do
    
    if IsValidAlive(unit) then
      unit:RemoveModifierByName("modifier_stunned")
      unit:RemoveModifierByName("modifier_invulnerable")
      unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
      unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
    end
  end

  FireGameEventLocal("make_base_towers_invulnerable", {})

  Timers:CreateTimer(SpecialArenaDuration+5,endSpecialArena)

  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialArenaDuration+5)

  GameMode.player_spawn_round_kills = {}
  local player_count_arena = 1
  
  local heroes = HeroList:GetAllHeroes()
  for _,hero in pairs(heroes) do
    if IsValidEntity(hero) and hero:GetTeam() == DOTA_TEAM_GOODGUYS and hero:IsRealHero()  then

      local point = Entities:FindByName(nil,"special_arena_"..player_count_arena)
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()] = {}
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["point"] = hero:GetAbsOrigin()
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["spawn_point"] = point:GetAbsOrigin()
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["round"] = 1
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["kills"] = 0


      hero.old_position_arena = hero:GetAbsOrigin()
      player_count_arena = player_count_arena +1

      --Fire the game event to teleport hero to the event
      FireGameEventLocal("teleport_hero_to_special_event", {hero_index = hero:GetEntityIndex() , teleport_entity_index = point:GetEntityIndex()})

      for j = 1,10 do
        local unit = CreateUnitByName(GameMode.specialEventCreeps[1], point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
        unit.heroid = hero:GetEntityIndex()
        unit:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
        unit:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
      end
    end

  end

  FireGameEventLocal("teleport_all_units_to_hero",{stun_duration = 2})

end

function endSpecialArena()
  -- body
  
  local heroes = HeroList:GetAllHeroes()
  
  for _,hero in pairs(heroes) do


    if IsValidEntity(hero) and  hero:GetTeam() == DOTA_TEAM_GOODGUYS and hero:IsRealHero() then
     
      FireGameEventLocal("teleport_hero_from_special_event", {hero_index = hero:GetEntityIndex(),stun_duration = 0.5 , teleport_point_x = hero.old_position_arena[1], teleport_point_y = hero.old_position_arena[2], teleport_point_z = hero.old_position_arena[3]})
      hero.old_position_arena = nil

    end

  end

  GameMode.player_spawn_round_kills  = nil
  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    if IsValidAlive(unit) then
      unit:RemoveModifierByName("modifier_stunned")
      unit:RemoveModifierByName("modifier_invulnerable")
    end
  end

  FireGameEventLocal("make_base_towers_vulnerable", {})

  FireGameEventLocal("teleport_all_units_to_hero",{stun_duration = 0.5})

  --FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
  for i = 1,8 do
    units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Entities:FindByName(nil,"special_arena_"..i):GetAbsOrigin(), nil,  500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false )
    
    for _,unit in pairs(units) do
      if IsValidEntity(unit) then
        unit:RemoveSelf()
      end
    end
  end
  return nil
end



---------------------------------------------------------------------------------------------------------------------------------------------------------
function startKillEvent(hero)
  -- body
  GameMode.killEvent = true
  local point = Entities:FindByName(nil, "spawn_roshan_hero")

  GameMode.event_start_time = GameRules:GetGameTime()

  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
      v.endTime = v.endTime + SpecialEventKillsDuration + 5
    end
  end

  local msg = "Special Event Arena: Kill Ramero for a powerful item. You have "..sec2Min(SpecialEventKillsDuration).." minutes."
  Notifications:TopToAll({text=msg, duration=5.0})
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  FireGameEventLocal("make_base_towers_invulnerable", {})

  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventKillsDuration)
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  GameMode.ramero = CreateUnitByName("npc_dota_hero_ramero", Entities:FindByName(nil, "spawn_roshan"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
  GameMode.ramero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  GameMode.ramero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
  
  local ability = GameMode.ramero:FindAbilityByName("ramero_baristal")
  ability:ApplyDataDrivenModifier(GameMode.ramero, GameMode.ramero, "modifier_ramero", {})

  Timers:CreateTimer( SpecialEventKillsDuration+5,function () FireGameEventLocal("end_special_event_kills", {hero_index = hero:GetEntityIndex()}) 
                                                end)

  if IsValidEntity(hero) then
    hero.old_position_kills = hero:GetAbsOrigin()
    --Fire the game event to teleport hero to the event
    FireGameEventLocal("teleport_hero_to_special_event", {hero_index = hero:GetEntityIndex() , teleport_entity_index = point:GetEntityIndex()})
    FireGameEventLocal("return_units_of_hero",{hero_index = hero:GetEntityIndex(),stun_duration = 5})
  end
end

function endKillEvent(event)
  -- body
  if GameMode.killEvent == nil then
    return nil
  end

  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
  end

  local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
  end

  FireGameEventLocal("make_base_towers_vulnerable", {})

  local hero = EntIndexToHScript(event.hero_index)
  
  if IsValidAlive(GameMode.ramero) then
    GameMode.ramero:RemoveSelf()
    GameMode.kill_event_happened = false
  end

  if IsValidEntity(hero) then
    FireGameEventLocal("teleport_hero_from_special_event", {hero_index = hero:GetEntityIndex(),stun_duration = 0.5 , teleport_point_x = hero.old_position_kills[1], teleport_point_y = hero.old_position_kills[2], teleport_point_z = hero.old_position_kills[3]})
    FireGameEventLocal("return_units_of_hero",{hero_index = hero:GetEntityIndex(), stun_duration = 0.5})
    hero.old_position_kills = nil
  end
  
  local duration = GameRules:GetGameTime() - GameMode.event_start_time 

  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
      v.endTime = v.endTime + duration - SpecialEventKillsDuration 
    end
  end
  GameMode.event_start_time  = nil
  GameMode.ramero = nil
  GameMode.killEvent = nil
end


-------------------------------------------------------------------------------------------------------------------------------------------------------
function startWaveKillEvent(hero)
  -- body
  GameMode.waveKillEvent = true

  local point = Entities:FindByName(nil, "spawn_roshan_hero")

  GameMode.event_start_time = GameRules:GetGameTime()
  -- Counts how many of the bosses were killed (maximum 2)

  GameMode.eventWaveKills = 0

  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
      v.endTime = v.endTime + SpecialEventWaveKillsDuration + 5
    end
  end

  local msg = "Special Event Arena: Kill Ramero and Baristal for a powerful item. You have "..sec2Min(SpecialEventWaveKillsDuration).." minutes."
  Notifications:TopToAll({text=msg, duration=5.0})
  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventWaveKillsDuration)
  
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  FireGameEventLocal("make_base_towers_invulnerable", {})

  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  GameMode.ramero = CreateUnitByName("npc_dota_hero_ramero", Entities:FindByName(nil, "spawn_roshan"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
  GameMode.baristal = CreateUnitByName("npc_dota_hero_baristal", Entities:FindByName(nil, "spawn_roshan"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
  GameMode.ramero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  GameMode.ramero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
  GameMode.baristal:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  GameMode.baristal:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

  local ability = GameMode.ramero:FindAbilityByName("ramero_baristal")
  ability:ApplyDataDrivenModifier(GameMode.ramero, GameMode.ramero, "modifier_baristal", {})
  ability:ApplyDataDrivenModifier(GameMode.baristal, GameMode.baristal, "modifier_baristal", {})

  Timers:CreateTimer( SpecialEventWaveKillsDuration+5,function () FireGameEventLocal("end_special_event_wave_kills", {hero_index = hero:GetEntityIndex()}) 
                                                end)

  if IsValidEntity(hero) then
    hero.old_position_wavekills = hero:GetAbsOrigin()
    --Fire the game event to teleport hero to the event
    FireGameEventLocal("teleport_hero_to_special_event", {hero_index = hero:GetEntityIndex() , teleport_entity_index = point:GetEntityIndex()})
    FireGameEventLocal("return_units_of_hero",{hero_index = hero:GetEntityIndex(),stun_duration = 5})

  end

end

function endWaveKillEvent(event)
  -- body
  if GameMode.waveKillEvent == nil then
    return nil
  end


  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)


  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
  end

  local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
  end

  FireGameEventLocal("make_base_towers_vulnerable", {})
  
  local hero = EntIndexToHScript(event.hero_index)
  
  if IsValidAlive(GameMode.baristal) then
    GameMode.baristal:RemoveSelf()
    GameMode.wave_event_happened = false
  end
  if IsValidAlive(GameMode.ramero) then
    GameMode.ramero:RemoveSelf()
    GameMode.wave_event_happened = false
  end
  
  if IsValidEntity(hero) then
    FireGameEventLocal("teleport_hero_from_special_event", {hero_index = hero:GetEntityIndex(),stun_duration = 0.5 , teleport_point_x = hero.old_position_wavekills[1], teleport_point_y = hero.old_position_wavekills[2], teleport_point_z = hero.old_position_wavekills[3]})
    FireGameEventLocal("return_units_of_hero",{hero_index = hero:GetEntityIndex(), stun_duration = 0.5})
    hero.old_position_wavekills = nil
  end


  local duration = GameRules:GetGameTime() - GameMode.event_start_time 

  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
    v.endTime = v.endTime + duration - SpecialEventWaveKillsDuration 
    end
  end
  GameMode.event_start_time  = nil
  GameMode.baristal = nil
  GameMode.ramero = nil
  GameMode.waveKillEvent = nil
end

---------------------------------------------------------------------------------------------------------------------------
function teleport_special_event_choice( event)
  -- body
  if not GameMode.event_choice_occupied then
    local hero = event.activator

    local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
    local triggers_events = Entities:FindAllByName("trigger_special_event")

    GameMode.event_choice_occupied = true

    for _,v in pairs(triggers_choice) do
      v:Disable()
    end

    for _,v in pairs(triggers_events) do
      v:Enable()
    end

    local point = Entities:FindByName(nil,"point_teleport_special_events"):GetAbsOrigin()
    FindClearSpaceForUnit(hero, point, true)
    hero:Stop()
    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                          end)
  end
end
----------------------------------------------------------------------------------------------------------------------------

function startFrostInfernalEvent(event)
  -- body
  local hero = event.activator

  if GameMode.FrostInfernalDead then
    GameMode.event_choice_occupied = false
    FindClearSpaceForUnit(hero,Entities:FindByName(nil, "base" ):GetAbsOrigin(), true)
    hero:Stop()
      --enable special event triggers
    local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
    local triggers_events = Entities:FindAllByName("trigger_special_event")

    for _,v in pairs(triggers_events) do
      v:Disable()
    end 
    for _,v in pairs(triggers_choice) do
      v:Enable()
    end

    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
    return nil
  
  end

  local hero = event.activator

  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventFrostInfernalDuration)


  local triggers = Entities:FindAllByName("trigger_frost_infernal_return")
  for _,v in pairs(triggers) do
    v:Enable()
  end

  local point_hero = Entities:FindByName(nil, "point_hero_special_event_beasts")
  local point_beast = Entities:FindByName(nil, "spawn_beasts"):GetAbsOrigin()

  GameMode.frost_infernal = CreateUnitByName("npc_dota_hero_frost_infernal", point_beast, true, nil, nil, DOTA_TEAM_NEUTRALS)
  GameMode.frost_infernal:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  GameMode.frost_infernal:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

  local ability = GameMode.frost_infernal:FindAbilityByName("beasts_special_event")
  ability:ApplyDataDrivenModifier(GameMode.frost_infernal, GameMode.frost_infernal, "modifier_frost_infernal", {})

  GameMode.frost_infernal_event = true
  
  --local ability = ramero:FindAbilityByName("ramero_baristal")
  --ability:ApplyDataDrivenModifier(ramero, ramero, "modifier_ramero", {})

  Timers:CreateTimer( SpecialEventFrostInfernalDuration+5,function () FireGameEventLocal("end_special_event_frost_infernal", {hero_index = hero:GetEntityIndex()}) 
                                                end)
  if IsValidEntity(hero) then
    --Fire the game event to teleport hero to the event
    FireGameEventLocal("teleport_hero_to_special_event", {hero_index = hero:GetEntityIndex() , teleport_entity_index = point_hero:GetEntityIndex()})
    local msg = "Special Event: Kill Frost Infernal for a powerful item. You have "..sec2Min(SpecialEventFrostInfernalDuration).." minutes."
    Notifications:Top(hero:GetPlayerOwnerID(),{text=msg, duration=5.0})
  end


end

function endFrostInfernalEvent(event)
  -- body
  if GameMode.frost_infernal_event == nil then
    return nil
  end
  GameMode.event_choice_occupied = false
  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  
  --enable special event triggers
  local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
  local triggers_events = Entities:FindAllByName("trigger_special_event")

  for _,v in pairs(triggers_events) do
    v:Disable()
  end 
  for _,v in pairs(triggers_choice) do
    v:Enable()
  end

  local triggers = Entities:FindAllByName("trigger_frost_infernal_return")
  for _,v in pairs(triggers) do
    v:Disable()
  end

  local hero = EntIndexToHScript(event.hero_index)

  if IsValidAlive(GameMode.frost_infernal) then
    GameMode.frost_infernal:RemoveSelf()
  end
  
  local point = Entities:FindByName(nil, "base" ):GetAbsOrigin()
  
  if IsValidEntity(hero) then
    FireGameEventLocal("teleport_hero_from_special_event", {hero_index = hero:GetEntityIndex(),stun_duration = 0.5 , teleport_point_x =point[1], teleport_point_y = point[2], teleport_point_z = point[3]})
    FireGameEventLocal("return_units_of_hero",{hero_index = hero:GetEntityIndex(), stun_duration = 0.5})
  end

  GameMode.frost_infernal = nil
  GameMode.frost_infernal_event = nil
end

------------------------------------------------------------------------------------------------------------------
function startSpiritBeastEvent(event)
  -- body

  local hero = event.activator

  if GameMode.SpiritBeastDead then
    GameMode.event_choice_occupied = false
    --enable special event triggers
    local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
    local triggers_events = Entities:FindAllByName("trigger_special_event")

    for _,v in pairs(triggers_events) do
      v:Disable()
    end 
    for _,v in pairs(triggers_choice) do
      v:Enable()
    end
    FindClearSpaceForUnit(hero,Entities:FindByName(nil, "base" ):GetAbsOrigin(), true)
    hero:Stop()
    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
    return nil
  end

  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventFrostInfernalDuration)

  local triggers = Entities:FindAllByName("trigger_frost_infernal_return")
  
  for _,v in pairs(triggers) do
    v:Enable()
  end


  local point_hero = Entities:FindByName(nil, "point_hero_special_event_beasts")
  local point_beast = Entities:FindByName(nil, "spawn_beasts"):GetAbsOrigin()

  GameMode.spirit_beast = CreateUnitByName("npc_dota_hero_spirit_beast", point_beast, true, nil, nil, DOTA_TEAM_NEUTRALS)
  GameMode.spirit_beast:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  GameMode.spirit_beast:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
  
  local ability = GameMode.spirit_beast:FindAbilityByName("beasts_special_event")
  ability:ApplyDataDrivenModifier(GameMode.spirit_beast, GameMode.spirit_beast, "modifier_spirit_beast", {})  

  GameMode.spirit_beast_event = true
  
  --local ability = ramero:FindAbilityByName("ramero_baristal")
  --ability:ApplyDataDrivenModifier(ramero, ramero, "modifier_ramero", {})

  Timers:CreateTimer( SpecialEventFrostInfernalDuration+5,function () FireGameEventLocal("end_special_event_spirit_beast", {hero_index = hero:GetEntityIndex()}) 
                                                end)
  if IsValidEntity(hero) then
    --Fire the game event to teleport hero to the event
    FireGameEventLocal("teleport_hero_to_special_event", {hero_index = hero:GetEntityIndex() , teleport_entity_index = point_hero:GetEntityIndex()})
    local msg = "Special Event: Kill Spirit Beast for a powerful item. You have "..sec2Min(SpecialEventFrostInfernalDuration).." minutes."
    Notifications:Top(hero:GetPlayerOwnerID(),{text=msg, duration=5.0})
  end
  
end

function endSpiritBeastEvent(event)
  -- body
  if GameMode.spirit_beast_event == nil then
    return nil
  end
  GameMode.event_choice_occupied = false
  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  --enable special event triggers
  local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
  local triggers_events = Entities:FindAllByName("trigger_special_event")

  for _,v in pairs(triggers_events) do
    v:Disable()
  end 
 
  for _,v in pairs(triggers_choice) do
  
    v:Enable()
  end

  local triggers = Entities:FindAllByName("trigger_frost_infernal_return")
  for _,v in pairs(triggers) do
    v:Disable()
  end

  local hero = EntIndexToHScript(event.hero_index)
  
  if not GameMode.spirit_beast:IsNull() and  GameMode.spirit_beast:IsAlive() then
    GameMode.spirit_beast:RemoveSelf()
  end

  local point = Entities:FindByName(nil, "base" ):GetAbsOrigin()
  
  if IsValidEntity(hero) then
    FireGameEventLocal("teleport_hero_from_special_event", {hero_index = hero:GetEntityIndex(),stun_duration = 0.5 , teleport_point_x =point[1], teleport_point_y = point[2], teleport_point_z = point[3]})
    FireGameEventLocal("return_units_of_hero",{hero_index = hero:GetEntityIndex(), stun_duration = 0.5})
  end

  GameMode.spirit_beast = nil
  GameMode.spirit_beast_event = nil
  
end


------------------------------------------------------------------------------------------------------------------
function startIllusionEvent(event)
  -- body

  local hero = event.activator

  if hero.illusion_done then
    GameMode.event_choice_occupied = false
    --enable special event triggers
    local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
    local triggers_events = Entities:FindAllByName("trigger_special_event")

    for _,v in pairs(triggers_events) do
      v:Disable()
    end 

    for _,v in pairs(triggers_choice) do
      v:Enable()
    end

    FindClearSpaceForUnit(hero,Entities:FindByName(nil, "base" ):GetAbsOrigin(), true)
    hero:Stop()
    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
    return nil
  end

  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventFrostInfernalDuration)

  local triggers = Entities:FindAllByName("trigger_illusion_return")
  
  for _,v in pairs(triggers) do
    v:Enable()
  end

  GameMode.illusion_event = hero:GetEntityIndex() 

  GameMode.heroid_doing_illusions = hero:GetEntityIndex() 
  local point_hero = Entities:FindByName(nil, "point_hero_special_event_illusions")
  local point_beast = Entities:FindByName(nil, "spawn_illusions"):GetAbsOrigin()

  GameMode.illusion = CreateUnitByName(hero:GetUnitName(), point_beast, true, nil, nil, DOTA_TEAM_NEUTRALS)
  GameMode.illusion:AddAbility("event_illusion")
  
  local ability = GameMode.illusion:FindAbilityByName("event_illusion")
  

  GameMode.illusion:SetBaseStrength(hero:GetBaseStrength()*5)
  GameMode.illusion:SetBaseIntellect(hero:GetBaseIntellect()*5)
  GameMode.illusion:SetBaseAgility(hero:GetBaseAgility()*5)
  

  GameMode.illusion:AddNewModifier(GameMode.illusion, nil, "modifier_illusion", { outgoing_damage = 100, incoming_damage = 100})
  
  GameMode.illusion:MakeIllusion()

  ability:ApplyDataDrivenModifier(GameMode.illusion, GameMode.illusion, "modifier_single_illusion", {}) 
  


  GameMode.illusion:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  GameMode.illusion:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

  Timers:CreateTimer( SpecialEventFrostInfernalDuration+5,function () FireGameEventLocal("end_special_event_illusion", {hero_index = hero:GetEntityIndex()}) 
                                                end)
  if IsValidEntity(hero) then
    --Fire the game event to teleport hero to the event
    FireGameEventLocal("teleport_hero_to_special_event", {hero_index = hero:GetEntityIndex() , teleport_entity_index = point_hero:GetEntityIndex()})
    local msg = "Special Event: Kill your illusion for 100 bonus stats. You have "..sec2Min(SpecialEventFrostInfernalDuration).." minutes."
    Notifications:Top(hero:GetPlayerOwnerID(),{text=msg, duration=5.0})
  end

  hero.illusion_done = true

end



function endIllusionEvent(event)
  -- body
  if GameMode.illusion_event ~= event.hero_index then
    return nil
  end
  
  GameMode.event_choice_occupied = false
  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  --enable special event triggers
  local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
  local triggers_events = Entities:FindAllByName("trigger_special_event")

  for _,v in pairs(triggers_events) do
    v:Disable()
  end 
 
  for _,v in pairs(triggers_choice) do
  
    v:Enable()
  end

  local triggers = Entities:FindAllByName("trigger_illusion_return")
  for _,v in pairs(triggers) do
    v:Disable()
  end

  local hero = EntIndexToHScript(event.hero_index)
  if not GameMode.illusion:IsNull() and  GameMode.illusion:IsAlive() then
    GameMode.illusion:RemoveSelf()
  end

  local point = Entities:FindByName(nil, "base" ):GetAbsOrigin()
  
  if IsValidEntity(hero) then
    FireGameEventLocal("teleport_hero_from_special_event", {hero_index = hero:GetEntityIndex(),stun_duration = 0.5 , teleport_point_x =point[1], teleport_point_y = point[2], teleport_point_z = point[3]})
    FireGameEventLocal("return_units_of_hero",{hero_index = hero:GetEntityIndex(), stun_duration = 0.5})
  end

  GameMode.heroid_doing_illusions = nil 
  GameMode.illusion = nil
  GameMode.illusion_event = nil
end