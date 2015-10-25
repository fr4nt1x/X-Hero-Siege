function start_owl_lightning(event)
	-- body
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel()-1)
	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability:GetLevel()-1)

	for j = 1,max_targets-1 do
		ability:ApplyDataDrivenModifier(caster, target, "modifier_owl_lightning", {})
		local next_target = nil
		local units = FindUnitsInRadius(target:GetTeam(), target:GetAbsOrigin(),nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,v in pairs(units) do
			if not v:HasModifier("modifier_owl_lightning") then
				next_target = v
			end
		end

		if next_target == nil then
			break
		end
		local particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_CUSTOMORIGIN , nil)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, next_target:GetAbsOrigin())
		target = next_target
	end
end