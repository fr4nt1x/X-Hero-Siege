
function spawn_beetle( event )
	-- body

	local hero = event.caster
	local ability = event.ability
	local max_beetles = ability:GetLevelSpecialValueFor("max_beetles", ability:GetLevel()-1)
	local unitsToSpawn = {"npc_carrion_beetle_I","npc_carrion_beetle_II","npc_carrion_beetle_III","npc_carrion_beetle_IV"}
	if hero:IsRealHero() then
		if hero.beetles == nil then
			hero.beetles = {}
		end
		if #hero.beetles >= max_beetles then
			local a = table.remove(hero.beetles)
			a:RemoveSelf()
		end 

		local unit = CreateUnitByName(unitsToSpawn[ability:GetLevel()], hero:GetAbsOrigin()+150*hero:GetForwardVector(), true, nil, hero, hero:GetTeam())
		unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
		table.insert(hero.beetles,1,unit)
	end 
end