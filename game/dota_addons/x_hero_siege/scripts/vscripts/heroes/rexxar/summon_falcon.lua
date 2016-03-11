
function spawn_servant( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)
	local servant_units = ability:GetLevelSpecialValueFor("units", ability:GetLevel()-1)

	local unitsToSpawn = {"npc_falcon_I","npc_falcon_II","npc_falcon_III","npc_falcon_III"}
	if hero:IsRealHero() then
		if hero.falcons == nil then
			hero.falcons = {}
		end
		for i = 1,servant_units do
			local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()], hero:GetAbsOrigin()+150*hero:GetForwardVector()+RandomVector(RandomInt(0, 50)), true, nil, hero, hero:GetTeam())
			unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
			ability:ApplyDataDrivenModifier(hero, unit, "modifier_falcon", {})
			unit:AddNewModifier(hero,nil, "modifier_kill", {Duration = duration})
			table.insert(hero.falcons,1,unit)
		end
	end 
end

function despawn_servant(event)
	-- body
	local hero = event.caster
	local unit = event.target
	for k,v in pairs(hero.falcons) do
		if v == unit then
			table.remove(hero.falcons,k)
			if IsValidEntity(unit) then
				unit:RemoveSelf()
			end
			break
		end
	end
end