function reset_cooldown( keys )
	-- body
	local caster = keys.caster
	local target = keys.target
	for i = 0,15 do 
		local ability = target:GetAbilityByIndex(i)
		if IsValidEntity(ability) and ability:GetName() ~= "paladin_light_frenzy_XX" then 
			ability:EndCooldown()
		end
	end
end
