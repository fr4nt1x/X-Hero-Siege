
function spawn_servant( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)
	local servant_units = ability:GetLevelSpecialValueFor("units", ability:GetLevel()-1)

	local unitsToSpawn = {"npc_polar_bear_I","npc_polar_bear_II","npc_polar_bear_III","npc_polar_bear_III"}
	if hero:IsRealHero() then
		if hero.bears == nil then
			hero.bears = {}
		end
		for i = 1,servant_units do
			local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()], hero:GetAbsOrigin()+150*hero:GetForwardVector(), true, nil, hero, hero:GetTeam())
			unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
			ability:ApplyDataDrivenModifier(hero, unit, "modifier_bear", {})
			unit:AddNewModifier(hero,nil, "modifier_kill", {Duration = duration})
			table.insert(hero.bears,1,unit)
		end
	end 
end

function despawn_servant(event)
	-- body
	local hero = event.caster
	local unit = event.target
	for k,v in pairs(hero.bears) do
		if v == unit then
			table.remove(hero.bears,k)
			if IsValidEntity(unit) then
				unit:RemoveSelf()
			end
			break
		end
	end
end