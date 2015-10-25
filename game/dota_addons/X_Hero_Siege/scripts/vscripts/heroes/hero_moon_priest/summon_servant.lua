
function spawn_servant( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor("max_servants", ability:GetLevel()-1)
	local servant_units = ability:GetLevelSpecialValueFor("servant_units", ability:GetLevel()-1)

	local unitsToSpawn = {"npc_water_servant_I","npc_water_servant_II","npc_water_servant_III","npc_water_servant_III"}
	if hero:IsRealHero() then
		if hero.servants == nil then
			hero.servants = {}
		end
		for i = 1,servant_units do
			local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()], hero:GetAbsOrigin()+150*hero:GetForwardVector(), true, nil, hero, hero:GetTeam())
			unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
			ability:ApplyDataDrivenModifier(hero, unit, "modifier_water_servant", {})
			table.insert(hero.servants,1,unit)
		end
	end 
end

function despawn_servant(event)
	-- body
	local hero = event.caster
	local unit = event.target
	for k,v in pairs(hero.servants) do
		if v == unit then
			table.remove(hero.servants,k)
			unit:RemoveSelf()
			break
		end
	end
end