
function spawn_wolf( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)
	local max_units = ability:GetLevelSpecialValueFor("units", ability:GetLevel()-1)

	local unitsToSpawn = {"npc_spirit_wolf_I","npc_spirit_wolf_II","npc_spirit_wolf_III","npc_spirit_wolf_III"}
	if hero:IsRealHero() then
		if hero.wolfs == nil then
			hero.wolfs = {}
		end
		for _,u in pairs(hero.wolfs) do
			if IsValidEntity(u) then
				u:RemoveSelf()
			end
		end

		hero.wolfs = {}

		for i = 1,max_units do
			local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()], hero:GetAbsOrigin()+150*hero:GetForwardVector()+RandomVector(RandomInt(0, 50)), true, nil, hero, hero:GetTeam())
			ability:ApplyDataDrivenModifier(hero, unit, "modifier_wolf", {})
			ability:ApplyDataDrivenModifier(hero, unit, "modifier_phased", {Duration= 0.05})
			unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
			table.insert(hero.wolfs,1,unit)
		end
	end 
end


function despawn_servant(event)
	-- body
	local hero = event.caster
	local unit = event.target
	for k,v in pairs(hero.wolfs) do
		if v == unit then
			table.remove(hero.wolfs,k)
			if IsValidEntity(unit) then
				unit:RemoveSelf()
			end
			break
		end
	end
end