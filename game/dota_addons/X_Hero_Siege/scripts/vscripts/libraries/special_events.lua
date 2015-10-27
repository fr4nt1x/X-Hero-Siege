
function specialEventRoshan()
  --body
  if GameMode.FinalWave then
    return nil
  end
  for _,v in pairs(Timers.timers) do 
    v.endTime = v.endTime + SpecialEventRoshanDuration
  end
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

  for _,unit in pairs(units) do
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

  for _,unit in pairs(units) do
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  Timers:CreateTimer(SpecialEventRoshanDuration+5,endSpecialEventRoshan)
  GameMode.hero_position = {}

  local heroes = HeroList:GetAllHeroes()
  local point = Entities:FindByName(nil,"spawn_roshan_hero"):GetAbsOrigin()
  
  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventRoshanDuration)

  for _,hero in pairs(heroes) do

    if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
      hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
      hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

      hero.in_special_event = true

      if not hero:IsAlive() then
        hero:RespawnHero(false, false, false)
      end
      GameMode.hero_position[hero:GetEntityIndex()] = hero:GetAbsOrigin()
      FindClearSpaceForUnit(hero, point, true)
      PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
      Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
    end

  end
  local point = Entities:FindByName(nil,"spawn_roshan"):GetAbsOrigin()
  GameMode.roshan = CreateUnitByName("npc_dota_hero_roshan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
  GameMode.roshan:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  GameMode.roshan:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

  
end

function endSpecialEventRoshan()
  -- body


  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
  end

  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
  end

  for id, point in pairs(GameMode.hero_position) do
      local hero = EntIndexToHScript(id)
      hero.in_special_event = false
      if hero:IsAlive() then
        FindClearSpaceForUnit(hero, GameMode.hero_position[id], true)
        hero:SetGold(8000+hero:GetGold(),false)
      else
        if hero.ankh_respawn then
          hero:SetGold(8000+hero:GetGold(),false)
        end

        hero:SetRespawnPosition(GameMode.hero_position[id])
        hero:RespawnHero(false, false, false)
        hero.ankh_respawn = false
        hero:SetRespawnsDisabled(false)
        Timers:RemoveTimer(hero.respawn_timer)
        hero.respawn_timer = nil
      end
  end 
  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  GameMode.roshan:RemoveSelf()
  GameMode.roshan = nil
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveSelf()
  end
  GameMode.hero_position = nil
  return nil
end

--------------------------------------------------------------------------------------------------------------------
function specialEventArena()
  --body
  for _,v in pairs(Timers.timers) do 
    v.endTime = v.endTime + SpecialArenaDuration
  end
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

  for _,unit in pairs(units) do
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  Timers:CreateTimer(SpecialArenaDuration+5,endSpecialArena)
  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialArenaDuration)

  GameMode.hero_position = {}
  GameMode.player_spawn_round_kills = {}
  GameMode.player_count_arena = 1
  local heroes = HeroList:GetAllHeroes()
  for _,hero in pairs(heroes) do
    if not hero:IsNull() and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
      hero.in_special_event = true 
      local point = Entities:FindByName(nil,"special_arena_"..GameMode.player_count_arena):GetAbsOrigin()
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()] = {}
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["point"] = hero:GetAbsOrigin()
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["spawn_point"] = point
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["round"] = 1
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["kills"] = 0

      GameMode.hero_position[hero:GetEntityIndex()] = hero:GetAbsOrigin()
      GameMode.player_count_arena = GameMode.player_count_arena +1
      FindClearSpaceForUnit(hero, point, true)
      hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
      hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

      PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
      Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
      for j = 1,10 do
        local unit = CreateUnitByName(specialEventCreeps[1], point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        unit.heroid = hero:GetEntityIndex()
        unit:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
        unit:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
      end
    end

  end

  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    if unit:GetPlayerOwner()~= nil and unit:IsAlive() then
      FindClearSpaceForUnit(unit, unit:GetPlayerOwner():GetAssignedHero():GetAbsOrigin()  , true)
      unit:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
      unit:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
    end
  end  
end

function endSpecialArena()
  -- body
  for k,v in pairs(GameMode.player_spawn_round_kills) do
    --FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
    local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,v["spawn_point"], nil,  500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    for _,unit in pairs(units) do
      if unit:IsAlive() then
        unit:RemoveSelf()
      end
    end

    local hero = EntIndexToHScript(k)
    if not hero:IsNull() then
      if hero:IsAlive() then
        FindClearSpaceForUnit(hero, GameMode.hero_position[k], true)
      else 
        hero:SetRespawnPosition(GameMode.hero_position[k])
        hero:RespawnHero(false, false, false)
        hero.ankh_respawn = false
        hero:SetRespawnsDisabled(false)
        Timers:RemoveTimer(hero.respawn_timer)
        hero.respawn_timer = nil
      end
      hero.in_special_event = false 
    end

  end

  GameMode.player_spawn_round_kills  = nil
  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
  end
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    if unit:GetPlayerOwner() ~=nil and unit:GetPlayerOwner():GetAssignedHero():GetEntityIndex() ~= nil and unit:IsAlive() then
      FindClearSpaceForUnit(unit, GameMode.hero_position[unit:GetPlayerOwner():GetAssignedHero():GetEntityIndex()]  , true)
    else
      unit:RemoveSelf()
    end
  end 
  GameMode.hero_position = nil
  return nil
end



---------------------------------------------------------------------------------------------------------------------------------------------------------
function startKillEvent(hero)
  -- body
  GameMode.killEvent = true
  local point = Entities:FindByName(nil, "spawn_roshan_hero"):GetAbsOrigin()

  GameMode.event_start_time = GameRules:GetGameTime()

  for _,v in pairs(Timers.timers) do 
    v.endTime = v.endTime + SpecialEventKillsDuration + 5
  end

  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  
  for _,unit in pairs(units) do
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  
  for _,unit in pairs(units) do
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
  hero.in_special_event = true
  if not hero:IsAlive() then
    hero:SetRespawnPosition(point)
    GameMode.old_position = Entities:FindByName(nil, "base"):GetAbsOrigin()
    hero:RespawnHero(false, false, false)
  else
    GameMode.old_position = hero:GetAbsOrigin()
    FindClearSpaceForUnit(hero,point, true)

  end
  --hero:RemoveModifierByName("modifier_stunned")
  --hero:RemoveModifierByName("modifier_invulnerable")

  hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
  PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
  Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
end

function endKillEvent(event)
  -- body
  if GameMode.killEvent == nil then
    return nil
  end

  local duration = GameRules:GetGameTime() - GameMode.event_start_time 

  for _,v in pairs(Timers.timers) do 
    v.endTime = v.endTime - (SpecialEventKillsDuration - duration)
  end

  GameMode.event_start_time  = nil

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

  local hero =EntIndexToHScript(event.hero_index)

  hero.in_special_event = false
  
  if not  GameMode.ramero:IsNull() and  GameMode.ramero:IsAlive() then
    GameMode.ramero:RemoveSelf()
    GameMode.kill_event_happened = false
  end

  if hero:IsAlive() then
    FindClearSpaceForUnit(hero,GameMode.old_position, true)
  else
      hero:SetRespawnPosition(GameMode.old_position)
      hero:RespawnHero(false, false, false)
      hero.ankh_respawn = false
      hero:SetRespawnsDisabled(false)
      Timers:RemoveTimer(hero.respawn_timer)
      hero.respawn_timer = nil

  end

  GameMode.ramero = nil
  GameMode.killEvent = nil
end


-------------------------------------------------------------------------------------------------------------------------------------------------------
function startWaveKillEvent(hero)
  -- body
  GameMode.waveKillEvent = true
  hero.in_special_event = true
  local point = Entities:FindByName(nil, "spawn_roshan_hero"):GetAbsOrigin()

  GameMode.event_start_time = GameRules:GetGameTime()
  
  GameMode.eventWaveKills = 0

  for _,v in pairs(Timers.timers) do 
    v.endTime = v.endTime + SpecialEventWaveKillsDuration + 5
  end

  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

  for _,unit in pairs(units) do
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  
  for _,unit in pairs(units) do
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
  
  if not hero:IsAlive() then
    hero:SetRespawnPosition(point)
    GameMode.old_position = Entities:FindByName(nil, "base"):GetAbsOrigin()
    hero:RespawnHero(false, false, false)
  else
    GameMode.old_position = hero:GetAbsOrigin()
    FindClearSpaceForUnit(hero,point, true)
  end
  hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
  PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
  Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
end

function endWaveKillEvent(event)
  -- body
  if GameMode.waveKillEvent == nil then
    return nil
  end

  local duration = GameRules:GetGameTime() - GameMode.event_start_time 

  for _,v in pairs(Timers.timers) do 
    v.endTime = v.endTime - (SpecialEventWaveKillsDuration - duration)
  end

  GameMode.event_start_time  = nil

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

  local hero = EntIndexToHScript(event.hero_index)

  hero.in_special_event = false
  
  if not GameMode.baristal:IsNull() and GameMode.baristal:IsAlive() then
    GameMode.baristal:RemoveSelf()
    GameMode.wave_event_happened = false
  end
  if not GameMode.ramero:IsNull() and GameMode.ramero:IsAlive() then
    GameMode.ramero:RemoveSelf()
    GameMode.wave_event_happened = false
  end

  if hero:IsAlive() then
    FindClearSpaceForUnit(hero,GameMode.old_position, true)
  else
    hero:SetRespawnPosition(GameMode.old_position)
    hero:RespawnHero(false, false, false)
    hero.ankh_respawn = false
    hero:SetRespawnsDisabled(false)
    Timers:RemoveTimer(hero.respawn_timer)
    hero.respawn_timer = nil
  end

  GameMode.old_position = nil
  GameMode.baristal = nil
  GameMode.ramero = nil
  GameMode.waveKillEvent = nil
end

---------------------------------------------------------------------------------------------------------------------------
function teleport_special_event_choice( event)
  -- body
  local hero = event.activator
  local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
  local triggers_events = Entities:FindAllByName("trigger_special_event")
  for _,v in pairs(triggers_choice) do
    v:Disable()
  end
  for _,v in pairs(triggers_events) do
    v:Enable()
  end

  local point = Entities:FindByName(nil,"point_teleport_special_events"):GetAbsOrigin()
  FindClearSpaceForUnit(hero, point, true)
  PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
  Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)

end
----------------------------------------------------------------------------------------------------------------------------

function startFrostInfernalEvent(event)
  -- body
  local hero = event.activator

  if GameMode.FrostInfernalDead then
    FindClearSpaceForUnit(hero,Entities:FindByName(nil, "base" ):GetAbsOrigin(), true)
      --enable special event triggers
    local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
    local triggers_events = Entities:FindAllByName("trigger_special_event")

    for _,v in pairs(triggers_events) do
      v:Disable()
    end 
    for _,v in pairs(triggers_choice) do
      v:Enable()
    end
    return nil
  end

  local hero = event.activator

  hero.old_position = Entities:FindByName(nil, "base" ):GetAbsOrigin()

  local triggers = Entities:FindAllByName("trigger_frost_infernal_return")
  for _,v in pairs(triggers) do
    v:Enable()
  end

  local point_hero = Entities:FindByName(nil, "point_hero_special_event_beasts"):GetAbsOrigin()
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
  hero.in_special_event = true

  FindClearSpaceForUnit(hero,point_hero, true)

  hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

  PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
  Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)

end

function endFrostInfernalEvent(event)
  -- body
  if GameMode.frost_infernal_event == nil then
    --enable special event triggers
    local triggers_choice = Entities:FindAllByName("trigger_special_event_choice")
    local triggers_events = Entities:FindAllByName("trigger_special_event")

    for _,v in pairs(triggers_events) do
      v:Disable()
    end 
    for _,v in pairs(triggers_choice) do
      v:Enable()
    end
    return nil
  end
  
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
  hero.in_special_event = false
  if not GameMode.frost_infernal:IsNull() and  GameMode.frost_infernal:IsAlive() then
    GameMode.frost_infernal:RemoveSelf()
  end
  
  if hero:IsAlive() then
    FindClearSpaceForUnit(hero,hero.old_position, true)
  else
    hero:SetRespawnPosition(hero.old_position)
    hero:RespawnHero(false, false, false)
    hero.ankh_respawn = false
    hero:SetRespawnsDisabled(false)
    Timers:RemoveTimer(hero.respawn_timer)
    hero.respawn_timer = nil
  end

  GameMode.frost_infernal = nil
  GameMode.frost_infernal_event = nil
end

------------------------------------------------------------------------------------------------------------------
function startSpiritBeastEvent(event)
  -- body

  local hero = event.activator

  if GameMode.SpiritBeastDead then
    FindClearSpaceForUnit(hero,Entities:FindByName(nil, "base" ):GetAbsOrigin(), true)
    return nil
  end
  
  hero.old_position = Entities:FindByName(nil, "base" ):GetAbsOrigin()
  local triggers = Entities:FindAllByName("trigger_frost_infernal_return")
  
  for _,v in pairs(triggers) do
    v:Enable()
  end


  local point_hero = Entities:FindByName(nil, "point_hero_special_event_beasts"):GetAbsOrigin()
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
  hero.in_special_event = true

  FindClearSpaceForUnit(hero,point_hero, true)

  hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

  PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
  Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
  
end

function endSpiritBeastEvent(event)
  -- body
  if GameMode.spirit_beast_event == nil then
    return nil
  end

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
  hero.in_special_event = false
  if not GameMode.spirit_beast:IsNull() and  GameMode.spirit_beast:IsAlive() then
    GameMode.spirit_beast:RemoveSelf()
  end
  if hero:IsAlive() then
    FindClearSpaceForUnit(hero,hero.old_position, true)
  else
    hero:SetRespawnPosition(hero.old_position)
    hero:RespawnHero(false, false, false)
    hero.ankh_respawn = false
    hero:SetRespawnsDisabled(false)
    Timers:RemoveTimer(hero.respawn_timer)
    hero.respawn_timer = nil
  end

  GameMode.spirit_beast = nil
  GameMode.spirit_beast_event = nil
  
end
