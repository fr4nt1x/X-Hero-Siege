function ApplyFlameModifier( event )
	-- body

	local caster = event.caster
	local target = event.target
	local ability = event.ability
	
	if IsValidAlive(target) and IsValidAlive(caster) then
		if target:HasModifier("modifier_drunken_haze") then 
			ability:ApplyDataDrivenModifier(caster, target, "modifier_flame_breath_burn", {})
		end
	end  
end