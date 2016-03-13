
function spawn_servant( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)
	local servant_units = ability:GetLevelSpecialValueFor("units", ability:GetLevel()-1)

	local unitsToSpawn = {"npc_boar"}
	if hero:IsRealHero() then
		if hero.boars == nil then
			hero.boars = {}
		end
		for i = 1,servant_units do
			local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()], hero:GetAbsOrigin()+150*hero:GetForwardVector(), true, nil, hero, hero:GetTeam())
			unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
			ability:ApplyDataDrivenModifier(hero, unit, "modifier_boar", {})
			ability:ApplyDataDrivenModifier(hero, unit, "modifier_phased", {Duration= 0.05})
			unit:AddNewModifier(hero,nil, "modifier_kill", {Duration = duration})
			table.insert(hero.boars,1,unit)
		end
	end 
end

function despawn_servant(event)
	-- body
	local hero = event.caster
	local unit = event.target
	for k,v in pairs(hero.boars) do
		if v == unit then
			table.remove(hero.boars,k)
			if IsValidEntity(unit) then
				unit:RemoveSelf()
			end
			break
		end
	end
end