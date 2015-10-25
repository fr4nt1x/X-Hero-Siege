

function moon_explosions( event )
	-- body
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel()-1)
	local radius_explosion = ability:GetLevelSpecialValueFor("radius_explosion", ability:GetLevel()-1)
	local damage_per_unit = ability:GetLevelSpecialValueFor("damage_per_unit", ability:GetLevel()-1)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel()-1)
	local explosions_per_tick = ability:GetLevelSpecialValueFor("explosions_per_tick", ability:GetLevel()-1)

	for i = 1, explosions_per_tick do
		local point = caster:GetAbsOrigin()+ RandomInt(1,radius)*RandomVector(1)
		local units = FindUnitsInRadius(caster:GetTeam(), point,nil, radius_explosion, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,unit in pairs(units) do
			ApplyDamage({victim = unit,
						attacker = caster,
						damage = damage_per_unit,
						damage_type = DAMAGE_TYPE_MAGICAL})
			unit:AddNewModifier(caster, nil, "modifier_stunned", {duration = stun_duration})		
		end

		local meteor = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_impact_shared_ti_5.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(meteor, 1, point)
		ParticleManager:SetParticleControl(meteor, 5, point)

	end

end

