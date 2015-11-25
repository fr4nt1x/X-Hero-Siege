
-- Telport the hero to the given point reviving him if needed, hero and points are sent through entity indices
function GameMode:OnTeleportHeroToSpecialEvent(keys)

  local teleport_point = EntIndexToHScript(keys.teleport_entity_index) 
  local hero = EntIndexToHScript(keys.hero_index)

  if IsValidEntity(hero) and IsValidEntity(teleport_point) then

  	hero:Stop()
    hero.in_special_event = true

    if not hero:IsAlive() then
      hero:RespawnHero(false, false, false)
      hero.ankh_respawn = false
      hero:SetRespawnsDisabled(false)
    
      if hero.respawn_timer ~= nil then
        Timers:RemoveTimer(hero.respawn_timer)
        hero.respawn_timer = nil
      end
    end

    FindClearSpaceForUnit(hero, teleport_point:GetAbsOrigin(), true)
    hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration = 5,IsHidden = true})
    hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = 5,IsHidden = true})

    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(4,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
  end
end


-- Telport the hero to the given point reviving him if needed, hero is entity index point has three coordinates
function GameMode:OnTeleportHeroFromSpecialEvent(keys)

  local teleport_point = Vector(keys.teleport_point_x , keys.teleport_point_y, keys.teleport_point_z)

  local hero = EntIndexToHScript(keys.hero_index)
  local stun_duration = keys.stun_duration

  if stun_duration == nil then 
  	stun_duration = 1
  end
  if IsValidEntity(hero) then

  	hero:Stop()
    hero.in_special_event = false

    if not hero:IsAlive() then
      hero:RespawnHero(false, false, false)
      hero.ankh_respawn = false
      hero:SetRespawnsDisabled(false)
    
      if hero.respawn_timer ~= nil then
        Timers:RemoveTimer(hero.respawn_timer)
        hero.respawn_timer = nil
      end
    end

    FindClearSpaceForUnit(hero, teleport_point, true)
    hero:AddNewModifier(nil, nil, "modifier_stunned", {Duration =stun_duration,IsHidden = true})
    hero:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = stun_duration,IsHidden = true})
    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
    Timers:CreateTimer(stun_duration,function () PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil) 
                            end)
  end
end


-- Teleports all units which are playerOwned to the hero of the player´and adds a stun_duration second stun and invulnerable modifier
function GameMode:TeleportUnitsToHero(keys)
  
  local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED , FIND_ANY_ORDER, false )
  local stun_duration = keys.stun_duration

  if stun_duration == nil then 
  	stun_duration = 5
  end

  for _,v in pairs(units) do
    
    if not v:IsRealHero() and IsValidAlive(v) then
		local playerOwner = v:GetPlayerOwner()
		if playerOwner == nil then
			playerOwner = PlayerResource:GetPlayer(v:GetPlayerOwnerID())
		end
		if IsValidEntity(playerOwner) then
			FindClearSpaceForUnit(v, playerOwner:GetAssignedHero():GetAbsOrigin(), true)
			v:AddNewModifier(nil, nil, "modifier_stunned", {Duration = stun_duration,IsHidden = true})
			v:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = stun_duration,IsHidden = true})
    	else
    		v:RemoveSelf()
    	end
    end
  end
end


-- Teleports all units which are playerOwned to the hero of the player´and adds a 5 second stun and invulnerable modifier
function GameMode:ReturnUnitsOfHero(keys)

  local hero = EntIndexToHScript(keys.hero_index)
  
  local stun_duration = keys.stun_duration

  if stun_duration == nil then 
  	stun_duration = 5
  end

  local heroOwner = hero:GetPlayerOwner()

  if IsValidEntity(heroOwner) then
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,Vector(0,0,0), nil,  FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED , FIND_ANY_ORDER, false )
	  
	for _,v in pairs(units) do
	    
	    if not v:IsRealHero() and IsValidAlive(v) then
			local playerOwner = v:GetPlayerOwner()
			if playerOwner == nil then
				playerOwner = PlayerResource:GetPlayer(v:GetPlayerOwnerID())
			end

			if playerOwner == heroOwner then
				FindClearSpaceForUnit(v, playerOwner:GetAssignedHero():GetAbsOrigin(), true)
				v:AddNewModifier(nil, nil, "modifier_stunned", {Duration = stun_duration, IsHidden = true})
				v:AddNewModifier(nil, nil, "modifier_invulnerable", {Duration = stun_duration, IsHidden = true})
	    	end
	    end
  	end
  end
end