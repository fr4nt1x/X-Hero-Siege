local doors_open = 2
local bosses_to_spawn = {{"npc_dota_hero_illidan","spawn_illidan",0},
 						{"npc_dota_hero_balanar","spawn_balanar",90},
 						{"npc_dota_hero_proudmoore","spawn_proudmoore",180}}



function open_gates( event )
	-- body
	DebugPrint("open gate")
	
	FireGameEventLocal("destroy_door", {door_name = "door_top_"..doors_open, obstruction_name = "obstruction_top_"..doors_open})

	if doors_open <=4 then

		local boss = CreateUnitByName(bosses_to_spawn[doors_open-1][1],Entities:FindByName(nil,bosses_to_spawn[doors_open-1][2]):GetAbsOrigin(),true,nil,nil,DOTA_TEAM_NEUTRALS)
		boss:SetAngles(0, bosses_to_spawn[doors_open-1][3], 0)
		
	end

	--disable arthas door enable trigger for second trap	
	if doors_open == 5 then
		FireGameEventLocal("destroy_door", {door_name = "door_arthas", obstruction_name = "obstruction_arthas"})
		local trigger = Entities:FindByName(nil,"trigger_top_waves_2")
		trigger:Enable()
	end

	doors_open = doors_open+1
end