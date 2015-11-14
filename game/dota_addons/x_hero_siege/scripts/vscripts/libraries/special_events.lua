
function specialEventRoshan()
  --body
  if GameMode.FinalWave then
    return nil
  end
  for _,v in pairs(Timers.timers) do
    if v.endTime ~= nil then 
      v.endTime = v.endTime + SpecialEventRoshanDuration
    end
  end
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

  for _,unit in pairs(units) do
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end

  Timers:CreateTimer(SpecialEventRoshanDuration+5,stopEventRoshan)

  local heroes = HeroList:GetAllHeroes()
  local point = Entities:FindByName(nil,"spawn_roshan_hero"):GetAbsOrigin()

  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventRoshanDuration)

  for _,hero in pairs(heroes) do

    if hero.disconnected ~= true and IsValidEntity(hero) and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
      hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
      hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

      hero.in_special_event = true

      if not hero:IsAlive() then
        hero:RespawnHero(false, false, false)
      end
      hero.position_roshan = hero:GetAbsOrigin()
      FindClearSpaceForUnit(hero, point, true)
      PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
      Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
    end

  end

  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  
  for _,v in pairs(units) do
    if not v:IsNull() and IsValidAlive(v) and v:GetPlayerOwner() ~= nil then
      FindClearSpaceForUnit(v, v:GetPlayerOwner():GetAssignedHero():GetAbsOrigin(), true)
    end
  end

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
    if IsValidEntity(hero) and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
      hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 2,IsHidden = true})
      hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 2,IsHidden = true})
    end
  end
end

function endSpecialEventRoshan()
  -- body

  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
  end

  local heroes = HeroList:GetAllHeroes()

  for _,hero in pairs(heroes) do

    if hero.disconnected ~= true and IsValidEntity(hero) and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
      hero.in_special_event = false
      
      if hero:IsAlive() then
        FindClearSpaceForUnit(hero, hero.position_roshan, true)
        hero:SetGold(8000+hero:GetGold(),false)
      else
        if hero.ankh_respawn then
          hero:SetGold(8000+hero:GetGold(),false)
        end

        hero:SetRespawnPosition(hero.position_roshan)
        hero:RespawnHero(false, false, false)
        hero.ankh_respawn = false
        hero:SetRespawnsDisabled(false)
        Timers:RemoveTimer(hero.respawn_timer)
        hero.respawn_timer = nil
      end
      
      PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
      Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
      hero.position_roshan = nil
    end
  end

  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  GameMode.roshan:RemoveSelf()
  GameMode.roshan = nil
  
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  
  for _,v in pairs(units) do
    if not v:IsNull() and v:IsAlive() and v:GetPlayerOwner() ~= nil then
      FindClearSpaceForUnit(v, v:GetPlayerOwner():GetAssignedHero():GetAbsOrigin(), true)
    end
  end
  
  return nil
end

--------------------------------------------------------------------------------------------------------------------
function specialEventArena()
  --body
  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
      v.endTime = v.endTime + SpecialArenaDuration+5
    end
  end
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

  for _,unit in pairs(units) do
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end
  
  Timers:CreateTimer(SpecialArenaDuration+5,endSpecialArena)

  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialArenaDuration+5)

  GameMode.player_spawn_round_kills = {}
  local player_count_arena = 1
  
  local heroes = HeroList:GetAllHeroes()
  for _,hero in pairs(heroes) do
    if IsValidEntity(hero) and hero.disconnected ~= true and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
      hero.in_special_event = true 
      local point = Entities:FindByName(nil,"special_arena_"..player_count_arena):GetAbsOrigin()
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()] = {}
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["point"] = hero:GetAbsOrigin()
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["spawn_point"] = point
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["round"] = 1
      GameMode.player_spawn_round_kills[hero:GetEntityIndex()]["kills"] = 0

      hero.old_position_arena = hero:GetAbsOrigin()
      player_count_arena = player_count_arena +1
      FindClearSpaceForUnit(hero, point, true)
      hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
      hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

      PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
      Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
      for j = 1,10 do
        local unit = CreateUnitByName(GameMode.specialEventCreeps[1], point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        unit.heroid = hero:GetEntityIndex()
        unit:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
        unit:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
      end
    end

  end

  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    if unit:GetPlayerOwner()~= nil and IsValidAlive(unit) then
      FindClearSpaceForUnit(unit, unit:GetPlayerOwner():GetAssignedHero():GetAbsOrigin()  , true)
      unit:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
      unit:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
    end
  end  
end

function endSpecialArena()
  -- body
  


  local heroes = HeroList:GetAllHeroes()
  
  for _,hero in pairs(heroes) do


    if IsValidEntity(hero) and hero.disconnected ~= true and  hero:GetTeam() == DOTA_TEAM_GOODGUYS then
      if hero:IsAlive() then
        FindClearSpaceForUnit(hero, hero.old_position_arena, true)
      else 
        hero:SetRespawnPosition(hero.old_position_arena)
        hero:RespawnHero(false, false, false)
        hero.ankh_respawn = false
        hero:SetRespawnsDisabled(false)
        
        if hero.respawn_timer ~= nil then
          Timers:RemoveTimer(hero.respawn_timer)
          hero.respawn_timer = nil
        end
      end
      hero.in_special_event = false 
      hero.old_position_arena = nil
      PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
      Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)    
    end

  end

  GameMode.player_spawn_round_kills  = nil
  GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)
  
  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  for _,unit in pairs(units) do
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_invulnerable")
  end
  
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  
  for _,v in pairs(units) do
    if IsValidAlive(v) and v:GetPlayerOwner() ~= nil then
      FindClearSpaceForUnit(v, v:GetPlayerOwner():GetAssignedHero():GetAbsOrigin(), true)
    end
  end
  --FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
  for i = 1,8 do
    units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Entities:FindByName(nil,"special_arena_"..i):GetAbsOrigin(), nil,  500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false )
    
    for _,unit in pairs(units) do
      if unit:IsAlive() then
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
  local point = Entities:FindByName(nil, "spawn_roshan_hero"):GetAbsOrigin()

  GameMode.event_start_time = GameRules:GetGameTime()

  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
      v.endTime = v.endTime + SpecialEventKillsDuration + 5
    end
  end

  local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
  
  for _,unit in pairs(units) do
    unit:AddNewModifier(nil, nil, "modifier_stunned", {IsHidden = true})
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {IsHidden = true})
  end
  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventKillsDuration)
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
    hero.old_position_killevent = Entities:FindByName(nil, "base"):GetAbsOrigin()
    hero:RespawnHero(false, false, false)
  else
    hero.old_position_killevent = hero:GetAbsOrigin()
    FindClearSpaceForUnit(hero,point, true)

  end
  --hero:RemoveModifierByName("modifier_stunned")
  --hero:RemoveModifierByName("modifier_invulnerable")

  hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
    
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  
  for _,v in pairs(units) do
    if IsValidAlive(v) and v:GetPlayerOwner() ~= nil then
      FindClearSpaceForUnit(v, v:GetPlayerOwner():GetAssignedHero():GetAbsOrigin(), true)
      v:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
      v:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
    end
  end
  PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
  Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)



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

  local hero =EntIndexToHScript(event.hero_index)

  hero.in_special_event = false
  
  if IsValidAlive(GameMode.ramero) then
    GameMode.ramero:RemoveSelf()
    GameMode.kill_event_happened = false
  end

  if hero:IsAlive() then
    FindClearSpaceForUnit(hero,hero.old_position_killevent, true)
  else
      hero:SetRespawnPosition(hero.old_position_killevent)
      hero:RespawnHero(false, false, false)
      hero.ankh_respawn = false
      hero:SetRespawnsDisabled(false)
      Timers:RemoveTimer(hero.respawn_timer)
      hero.respawn_timer = nil
  end
  
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  
  for _,v in pairs(units) do
    if IsValidAlive(v) and v:GetPlayerOwner() ~= nil then
      FindClearSpaceForUnit(v, v:GetPlayerOwner():GetAssignedHero():GetAbsOrigin(), true)
    end
  end
  PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
  
  Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)

  local duration = GameRules:GetGameTime() - GameMode.event_start_time 

  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
      v.endTime = v.endTime - (SpecialEventKillsDuration - duration)
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
  hero.in_special_event = true
  local point = Entities:FindByName(nil, "spawn_roshan_hero"):GetAbsOrigin()

  GameMode.event_start_time = GameRules:GetGameTime()
  
  GameMode.eventWaveKills = 0

  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
      v.endTime = v.endTime + SpecialEventWaveKillsDuration + 5
    end
  end

  GameRules:GetGameModeEntity():SetFixedRespawnTime(SpecialEventWaveKillsDuration)
  
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
    hero.old_position_wavekills = Entities:FindByName(nil, "base"):GetAbsOrigin()
    hero:RespawnHero(false, false, false)
  else
    hero.old_position_wavekills = hero:GetAbsOrigin()
    FindClearSpaceForUnit(hero,point, true)
  end
  hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
    
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  
  for _,v in pairs(units) do
    if IsValidAlive(v) and v:GetPlayerOwner() ~= nil then
      FindClearSpaceForUnit(v, v:GetPlayerOwner():GetAssignedHero():GetAbsOrigin(), true)
      v:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
      v:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})
   
    end
  end
  
  PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
  Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
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

  local hero = EntIndexToHScript(event.hero_index)

  hero.in_special_event = false
  
  if IsValidAlive(GameMode.baristal) then
    GameMode.baristal:RemoveSelf()
    GameMode.wave_event_happened = false
  end
  if IsValidAlive(GameMode.ramero) then
    GameMode.ramero:RemoveSelf()
    GameMode.wave_event_happened = false
  end
  
  if IsValidAlive(hero) then

    if hero:IsAlive() then
      FindClearSpaceForUnit(hero,hero.old_position_wavekills, true)
    else
      hero:SetRespawnPosition(hero.old_position_wavekills)
      hero:RespawnHero(false, false, false)
      hero.ankh_respawn = false
      hero:SetRespawnsDisabled(false)
      Timers:RemoveTimer(hero.respawn_timer)
      hero.respawn_timer = nil
    end
    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
  end
    
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
  
  for _,v in pairs(units) do
    if IsValidAlive(v) and v:GetPlayerOwner() ~= nil then
      FindClearSpaceForUnit(v, v:GetPlayerOwner():GetAssignedHero():GetAbsOrigin(), true)
    end
  end

  local duration = GameRules:GetGameTime() - GameMode.event_start_time 

  for _,v in pairs(Timers.timers) do 
    if v.endTime ~= nil then
    v.endTime = v.endTime - (SpecialEventWaveKillsDuration - duration)
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
    return nil
  end
  
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
  
  if IsValidEntity(hero) then
    hero.in_special_event = false
  end

  if IsValidAlive(GameMode.frost_infernal) then
    GameMode.frost_infernal:RemoveSelf()
  end

  if IsValidEntity(hero) then
    if hero:IsAlive() then
      FindClearSpaceForUnit(hero,Entities:FindByName(nil, "base" ):GetAbsOrigin(), true)
    else
      hero:SetRespawnPosition(Entities:FindByName(nil, "base" ):GetAbsOrigin())
      hero:RespawnHero(false, false, false)
      hero.ankh_respawn = false
      hero:SetRespawnsDisabled(false)
      Timers:RemoveTimer(hero.respawn_timer)
      hero.respawn_timer = nil
    end
    
    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
  end
  GameMode.frost_infernal = nil
  GameMode.frost_infernal_event = nil
end

------------------------------------------------------------------------------------------------------------------
function startSpiritBeastEvent(event)
  -- body

  local hero = event.activator

  if GameMode.SpiritBeastDead then
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
  
  if IsValidEntity(hero) then
    hero.in_special_event = false
  end

  if not GameMode.spirit_beast:IsNull() and  GameMode.spirit_beast:IsAlive() then
    GameMode.spirit_beast:RemoveSelf()
  end
  if IsValidEntity(hero) then
    if hero:IsAlive() then
      FindClearSpaceForUnit(hero,Entities:FindByName(nil, "base" ):GetAbsOrigin(), true)
    else
      hero:SetRespawnPosition(Entities:FindByName(nil, "base" ):GetAbsOrigin())
      hero:RespawnHero(false, false, false)
      hero.ankh_respawn = false
      hero:SetRespawnsDisabled(false)
      Timers:RemoveTimer(hero.respawn_timer)
      hero.respawn_timer = nil
    end
    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
  end

  GameMode.spirit_beast = nil
  GameMode.spirit_beast_event = nil
  
end


------------------------------------------------------------------------------------------------------------------
function startIllusionEvent(event)
  -- body

  local hero = event.activator

  if hero.illusion_done then
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

  GameMode.illusion_event = true
  local point_hero = Entities:FindByName(nil, "point_hero_special_event_illusions"):GetAbsOrigin()
  local point_beast = Entities:FindByName(nil, "spawn_illusions"):GetAbsOrigin()

  GameMode.illusion = CreateUnitByName(hero:GetUnitName(), point_beast, true, nil, nil, DOTA_TEAM_NEUTRALS)
  GameMode.illusion:AddAbility("event_illusion")
  
  local ability = GameMode.illusion:FindAbilityByName("event_illusion")
  

  GameMode.illusion:SetBaseStrength(hero:GetBaseStrength()*4)
  GameMode.illusion:SetBaseIntellect(hero:GetBaseIntellect()*4)
  GameMode.illusion:SetBaseAgility(hero:GetBaseAgility()*4)
  

  GameMode.illusion:AddNewModifier(GameMode.illusion, nil, "modifier_illusion", { outgoing_damage = 100, incoming_damage = 100})
  
  GameMode.illusion:MakeIllusion()

  ability:ApplyDataDrivenModifier(GameMode.illusion, GameMode.illusion, "modifier_single_illusion", {}) 
  


  GameMode.illusion:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  GameMode.illusion:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

  Timers:CreateTimer( SpecialEventFrostInfernalDuration+5,function () FireGameEventLocal("end_special_event_illusion", {hero_index = hero:GetEntityIndex()}) 
                                                end)
  hero.in_special_event = true

  FindClearSpaceForUnit(hero,point_hero, true)

  hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
  hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

  PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
  Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
  hero.illusion_done = true
end

function endIllusionEvent(event)
  -- body
  if GameMode.illusion_event == nil then
    return nil
  end

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
  hero.in_special_event = false

  if not GameMode.illusion:IsNull() and  GameMode.illusion:IsAlive() then
    GameMode.illusion:RemoveSelf()
  end
  if hero ~= nil and not hero:IsNull() then
    if hero:IsAlive() then
      FindClearSpaceForUnit(hero,Entities:FindByName(nil, "base" ):GetAbsOrigin(), true)
    else
      hero:SetRespawnPosition(Entities:FindByName(nil, "base" ):GetAbsOrigin())
      hero:RespawnHero(false, false, false)
      hero.ankh_respawn = false
      hero:SetRespawnsDisabled(false)
      Timers:RemoveTimer(hero.respawn_timer)
      hero.respawn_timer = nil
    end
    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
  end

  GameMode.illusion = nil
  GameMode.illusion_event = nil
  
end