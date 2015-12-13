function applyRegeneration( event )
	-- body
	local caster = event.caster
	local ability = event.ability
	if IsValidAlive(caster) then 

		if IsValidAlive(GameMode.bane) then

			ability:ApplyDataDrivenModifier(caster, GameMode.bane, "modifier_banehallow_heal", {})
		end
	end
end