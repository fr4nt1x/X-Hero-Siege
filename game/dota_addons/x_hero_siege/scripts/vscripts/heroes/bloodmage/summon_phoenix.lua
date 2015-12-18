
function spawn_phoenix( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)
	local max_units = ability:GetLevelSpecialValueFor("units", ability:GetLevel()-1)

	local unitsToSpawn = {"npc_phoenix_I","npc_phoenix_I"}
	if hero:IsRealHero() then
		if hero.phoenixes == nil then
			hero.phoenixes = {}
		end
		for _,u in pairs(hero.phoenixes) do
			if IsValidEntity(u) then
				u:RemoveSelf()
			end
		end

		hero.phoenixes = {}

		for i = 1,max_units do
			local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()], hero:GetAbsOrigin()+150*hero:GetForwardVector(), true, nil, hero, hero:GetTeam())
			ability:ApplyDataDrivenModifier(hero, unit, "modifier_phoenix_rebirth", {})
			unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
			table.insert(hero.phoenixes,1,unit)
		end
	end 
end

function spawn_egg(event)
	-- body

	local hero = event.caster
	local unit = event.unit
	local ability = event.ability

	local egg = CreateUnitByName("npc_phoenix_egg", unit:GetAbsOrigin(), true, nil, hero, hero:GetTeam())
	egg:SetAbsOrigin(egg:GetAbsOrigin()+Vector(0,0,200))
	ability:ApplyDataDrivenModifier(hero, egg, "modifier_egg", {})

	table.insert(hero.phoenixes,1,egg)

	for k,v in pairs(hero.phoenixes) do
		if v == unit then
			table.remove(hero.phoenixes,k)
			if IsValidEntity(unit) then
				unit:RemoveSelf()
			end
			break
		end
	end

end

function spawn_phoenix_from_egg(event)
	-- body

	local hero = event.caster
	local target = event.target
	local ability = event.ability

	local unitsToSpawn = {"npc_phoenix_I","npc_phoenix_I"}

	if target:GetHealth() > 0 then 
		local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()], target:GetAbsOrigin(), true, nil, hero, hero:GetTeam())
		ability:ApplyDataDrivenModifier(hero, unit, "modifier_phoenix_rebirth", {})
		unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
		
		table.insert(hero.phoenixes,1,unit)
	end

	for k,v in pairs(hero.phoenixes) do
		if v == target then
			table.remove(hero.phoenixes,k)
			if IsValidEntity(target) then
				target:RemoveSelf()
			end
			break
		end
	end

end