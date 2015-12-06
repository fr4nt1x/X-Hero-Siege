
function spawn_ward( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local  point = event.target_points[1]
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)

	local unitsToSpawn = {"npc_serpentine_ward_I","npc_serpentine_ward_II","npc_serpentine_ward_III","npc_serpentine_ward_IV"}

	if IsValidAlive(hero) and hero:IsRealHero() then
		local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()],point, true, nil, hero, hero:GetTeam())
		unit:AddNewModifier(nil, nil, "modifier_phased", {Duration = 0.05})
		unit:AddNewModifier(hero, nil, "modifier_kill", {Duration = duration})
		unit:AddNewModifier(hero, nil, "modifier_kill", {Duration = duration})

		ability:ApplyDataDrivenModifier(hero, unit, "modifier_serpentine_ward", {})

		unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
	end 
end

function spawn_laser_trap( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local  point = event.target_points[1]
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)

	local unitsToSpawn = {"npc_laser_trap_I","npc_laser_trap_II"}

	if IsValidAlive(hero) and hero:IsRealHero() then
		local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()],point, true, nil, hero, hero:GetTeam())
		unit:AddNewModifier(nil, nil, "modifier_phased", {Duration = 0.05})
		unit:AddNewModifier(hero, nil, "modifier_kill", {Duration = duration})
		ability:ApplyDataDrivenModifier(hero, unit, "modifier_laser_trap", {})
		unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
	end 
end

function spawn_healing_ward( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local  point = event.target_points[1]
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)

	local unitsToSpawn = {"npc_healing_ward"}

	if IsValidAlive(hero) and hero:IsRealHero() then
		local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()],point, true, nil, hero, hero:GetTeam())
		unit:AddNewModifier(nil, nil, "modifier_phased", {Duration = 0.05})
		unit:AddNewModifier(hero, nil, "modifier_kill", {Duration = duration})
		ability:ApplyDataDrivenModifier(hero, unit, "modifier_healing_ward_aura", {})
		unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
	end 
end