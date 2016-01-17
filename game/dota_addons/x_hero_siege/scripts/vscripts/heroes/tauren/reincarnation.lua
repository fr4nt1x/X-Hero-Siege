
function reincarnate( event )
	-- body
	local ability = event.ability
	local hero = event.caster
	local position = hero:GetAbsOrigin()
	local respawntime = ability:GetSpecialValueFor("reincarnation_time")
	local cooldown = ability:GetCooldown(ability:GetLevel()-1)

	if hero:IsRealHero() and ability:IsCooldownReady() and not hero.ankh_respawn then

		hero:SetRespawnsDisabled(true)
		ability:StartCooldown(cooldown)
		hero.respawn_timer = Timers:CreateTimer(respawntime,function () 
			hero:SetRespawnPosition(position)
			hero:RespawnHero(false, false, false)
			ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
			hero.ankh_respawn = false
			hero:SetRespawnsDisabled(false)
			end)
		hero.ankh_respawn = true

	end


end