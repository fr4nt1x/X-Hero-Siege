function ApplyAnimation( event )

	local ability = event.ability
	local caster = event.caster
	local start_time = ability:GetChannelStartTime()
	local time_channeled = GameRules:GetGameTime() - start_time
	local max_channel_time = ability:GetLevelSpecialValueFor("channel_duration", ability:GetLevel() - 1)
	local duration = event.duration
	if ability:IsChanneling() and (time_channeled < math.floor(max_channel_time - duration)) then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_channeling", { duration = duration })
	end
end
