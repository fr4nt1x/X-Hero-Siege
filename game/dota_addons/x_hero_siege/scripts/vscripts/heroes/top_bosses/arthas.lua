
function spawn_bane( event )
	-- body
	print("spawn_bane")
	local caster = event.caster
	Timers:CreateTimer(5,function()
    GameMode.bane = CreateUnitByName("npc_dota_hero_banehallow",Entities:FindByName(nil,"spawn_arthas"):GetAbsOrigin(),true,nil,nil,DOTA_TEAM_NEUTRALS)
    GameMode.bane:SetAngles(0, 180, 0)
    end)
 	
 	local tombs  = Entities:FindAllByName("bane_tombs")
 	for _,tomb in pairs(tombs) do
 		print(" tombs")
 		tomb:RemoveModifierByName("modifier_invulnerable")
 		local ability = tomb:FindAbilityByName("banehallow_tombs")
 		ability:ApplyDataDrivenModifier(tomb, tomb, "modifier_banehallow_apply_heal", {})
 	end

end