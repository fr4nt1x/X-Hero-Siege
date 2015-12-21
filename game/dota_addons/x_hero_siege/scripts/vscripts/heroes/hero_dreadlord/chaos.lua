require('libraries/timers')


function chaos( event )
	-- body
	local target = event.target
	
	local ability = event.ability
	local time_to_damage = 2.0
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel()-1)

	local point = target:GetAbsOrigin()

	local meteor = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(meteor, 0, point + Vector(0,0,500))
	ParticleManager:SetParticleControl(meteor, 1, point)
	ParticleManager:SetParticleControl(meteor, 2, Vector(1.2,0,0))
end

function target_modifier_remove(event)
	-- body
	local target = event.target
	local caster = event.caster

	local soil = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_land_soil.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(soil, 3, target:GetAbsOrigin()+Vector(0,0,40))
	local crumble = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_crumble.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(crumble, 3, target:GetAbsOrigin())
	target:RemoveSelf()
end

function target_modifier_remove_spawn(event)
	-- body
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	local duration = ability:GetLevelSpecialValueFor("duration" , ability:GetLevel()-1)

	local unit = CreateUnitByName("npc_dreadlord_infernal_I", target:GetAbsOrigin(), true, caster,caster, caster:GetTeamNumber())
	if IsValidEntity(caster:GetPlayerOwner()) then
		unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	end
	unit:AddNewModifier(caster, nil, "modifier_kill",{Duration = duration})

	local soil = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_land_soil.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(soil, 3, target:GetAbsOrigin()+Vector(0,0,40))
	local crumble = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_crumble.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(crumble, 3, target:GetAbsOrigin())
	target:RemoveSelf()
end
