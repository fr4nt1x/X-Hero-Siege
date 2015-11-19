function grow( event )
	-- body
	local ability = event.ability
	local caster = event.caster
	local scale = ability:GetLevelSpecialValueFor("model_scale", ability:GetLevel()-1)
	caster.model_scale = caster:GetModelScale()
	caster:SetModelScale(scale)
	
end

function end_grow( event )
	-- body
	local ability = event.ability
	local caster = event.caster
	local scale = ability:GetLevelSpecialValueFor("model_scale", ability:GetLevel()-1)
	
	caster:SetModelScale(caster.model_scale)
	
end