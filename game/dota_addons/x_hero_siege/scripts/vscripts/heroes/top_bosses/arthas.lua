
function spawn_bane( event )
	-- body
	print("spawn_bane")
	local caster = event.caster
	Timers:CreateTimer(5,function()
    local bane = CreateUnitByName("npc_dota_hero_banehallow",Entities:FindByName(nil,"spawn_arthas"):GetAbsOrigin(),true,nil,nil,DOTA_TEAM_NEUTRALS)
    bane:SetAngles(0, 180, 0)
    end)

end