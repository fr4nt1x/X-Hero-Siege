local number = 0
function explosions( event )
	-- body
	--is the dummy target
	local caster = event.target
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel()-1)
	local radius_explosion = ability:GetLevelSpecialValueFor("radius_explosion", ability:GetLevel()-1)
	local damage_per_unit = ability:GetLevelSpecialValueFor("damage_per_unit", ability:GetLevel()-1)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel()-1)
	local explosions_per_tick = ability:GetLevelSpecialValueFor("explosions_per_tick", ability:GetLevel()-1)
	local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel()-1)

	for i = 1, explosions_per_tick do
		local point = caster:GetAbsOrigin() + RandomInt(1,radius-(math.floor(radius_explosion/2.0)))*RandomVector(1)
		Timers:CreateTimer( delay,function ()
			local units = FindUnitsInRadius(caster:GetTeam(), point,nil, radius_explosion, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			for _,unit in pairs(units) do
	 			ApplyDamage({victim = unit,
																	attacker = caster,
																	damage = damage_per_unit,
																	damage_type = DAMAGE_TYPE_MAGICAL})
																	unit:AddNewModifier(caster, nil, "modifier_stunned", {duration = stun_duration})

		
			end
		end)
		local meteor = ParticleManager:CreateParticle("particles/rocketswarm.vpcf", PATTACH_CUSTOMORIGIN, caster)
		local distance = event.caster:GetAbsOrigin() - point
		distance = distance:Length2D()
		distance = math.min(distance,800)
		distance = math.max(distance,100)
		local factor = (distance-100)/700.0
		ParticleManager:SetParticleControl(meteor, 0, event.caster:GetAbsOrigin()+Vector(0,0,64))
		ParticleManager:SetParticleControl(meteor, 1, point)
		ParticleManager:SetParticleControl(meteor, 3, Vector(delay+factor*0.7,0,0))
	end
end

