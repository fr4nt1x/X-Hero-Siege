local doors_open = 2

function open_gates( event )
	-- body
	DebugPrint("open gate")
	
	FireGameEventLocal("destroy_door", {door_name = "door_top_"..doors_open, obstruction_name = "obstruction_top_"..doors_open})



	--disable arthas door enable trigger for second trap	
	if doors_open == 5 then
		FireGameEventLocal("destroy_door", {door_name = "door_arthas", obstruction_name = "obstruction_arthas"})
		local trigger = Entities:FindByName(nil,"trigger_top_waves_2")
		trigger:Enable()
	end
	doors_open = doors_open+1
end