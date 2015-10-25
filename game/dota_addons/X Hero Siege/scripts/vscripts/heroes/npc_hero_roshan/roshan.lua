function grow( event )
	-- body
	local ability = event.ability
	local caster = event.caster
	local scale = ability:GetLevelSpecialValueFor("model_scale", ability:GetLevel()-1)
	local base_attack_rate = ability:GetLevelSpecialValueFor("base_attack_rate", ability:GetLevel()-1)
	caster:SetModelScale(scale)
	
end