function channel_end( event )
	-- body
	local caster = event.caster
	if IsValidAlive(caster) then
		caster:RemoveModifierByName("modifier_frost_chaos_channelling")
	end
end

function ApplyAnimation( event )
	local ability = event.ability
	local caster = event.caster
	local start_time = ability:GetChannelStartTime()
	local time_channeled = GameRules:GetGameTime() - start_time
	local max_channel_time = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	if ability:IsChanneling() and (time_channeled < max_channel_time - 1.4) then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_channeling", { duration = 1.3 })
	end
end