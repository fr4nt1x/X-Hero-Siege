local dummy = nil

function modifier_start( event )
	-- body
	dummy = event.target
end

function channel_end( event )
	-- body
	local caster = event.caster
	if IsValidAlive(caster) then
		caster:RemoveModifierByName("modifier_frost_chaos_channelling")
	end
	if IsValidEntity(dummy) then
		dummy:RemoveSelf()
		dummy = nil
	end
end

function apply_damage( event )
	-- body
	local caster = event.caster
	local ability = event.ability
	local hp_loss_per_tick = ability:GetLevelSpecialValueFor("hp_loss_per_tick", (ability:GetLevel() - 1))

	for _,target in pairs(event.target_entities) do
		if IsValidAlive(target) then
			local max_health = target:GetMaxHealth()

			local damage_table = {}

		    damage_table.attacker = caster
		    damage_table.victim = target
		    damage_table.damage_type = DAMAGE_TYPE_PURE
		    damage_table.ability = ability
		    damage_table.damage =  max_health * (hp_loss_per_tick/100.0)
		    damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS -- Doesnt trigger abilities and items that get disabled by damage

		    ApplyDamage(damage_table)
		end
	end
end

function ApplyAnimation( event )
	local ability = event.ability
	local caster = event.caster
	local start_time = ability:GetChannelStartTime()
	local time_channeled = GameRules:GetGameTime() - start_time
	local max_channel_time = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	if ability:IsChanneling() and (time_channeled < max_channel_time - 1.5) then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_channeling", { duration = 1.4 })
	end
end