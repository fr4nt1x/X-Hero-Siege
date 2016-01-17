local hero = nil
function spawn_tornado( event )
	-- body

	hero = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor("channel_duration", ability:GetLevel()-1)

	local point = event.target_points[1]

	if hero:IsRealHero() then
		if hero.tornados == nil then
			hero.tornados = {}
		end
		local unit = CreateUnitByName("npc_panda_tornado", point, true, nil, hero, hero:GetTeam())
		ability:ApplyDataDrivenModifier(hero, unit, "modifier_panda_tornado",{Duration = duration})
		unit:SetControllableByPlayer(hero:GetPlayerOwnerID(), true)
		table.insert(hero.tornados,1,unit)
	end 
end

function despawn_tornado(event)
	-- body
	local unit = event.caster
	for k,v in pairs(hero.tornados) do
		if IsValidEntity(v) then
			v:RemoveSelf()
		end
	end
	hero.tornados = {}
end