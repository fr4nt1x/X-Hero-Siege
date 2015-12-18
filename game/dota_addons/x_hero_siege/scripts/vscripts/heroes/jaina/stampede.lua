function create_projectile( event )
	-- body
	local caster = event.caster
	local ability = event.ability
	local distance = ability:GetLevelSpecialValueFor("distance", ability:GetLevel()-1)
	local speed = ability:GetLevelSpecialValueFor("speed", ability:GetLevel()-1)
	local radius_explosion = ability:GetLevelSpecialValueFor("radius_explosion", ability:GetLevel()-1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel()-1)
	local point = caster:GetAbsOrigin()
	local skulls_per_tick = ability:GetLevelSpecialValueFor("elementals_per_tick", ability:GetLevel()-1)

	local vector_line = caster:GetForwardVector():Cross(Vector(0,0,1))

	vector_line = vector_line:Normalized()
	
	for j = 1,skulls_per_tick do
		--A Linear Projectile must have a table with projectile info
		--spawn orgin on a random point behind the caster, on a line orthogonal to the caster facing direction
		local info = 
		{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_jaina/jaina_elemental_wave_elemental.vpcf",
        	vSpawnOrigin = point-(distance/2.0)*caster:GetForwardVector() + (RandomInt(-radius/2.0, radius/2.0)) * vector_line,
        	fDistance = distance,
        	fStartRadius = radius_explosion,
        	fEndRadius = radius_explosion,
        	Source = caster,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = true,
			vVelocity = caster:GetForwardVector() * speed,
			bProvidesVision = false,
		}
		local projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end