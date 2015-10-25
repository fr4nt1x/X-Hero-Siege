local doors_open = 2

function open_gates( event )
	-- body
	DebugPrint("open gate")
	
	local doors = Entities:FindAllByName("door_top_"..doors_open) 
	
	for _,door in pairs(doors) do
		door:Kill()
	end

	local gridobs = Entities:FindAllByName("obstruction_top_" ..doors_open)
	
	for _,obs in pairs(gridobs) do 
		obs:SetEnabled(false, true)
	end

	--disable arthas door enable trigger for second trap	
	if doors_open == 5 then
		DoEntFire( "door_arthas", "Disable", nil, 0, nil, nil )
		local trigger = Entities:FindByName(nil,"trigger_top_waves_2")
		trigger:Enable()
		local gridobs = Entities:FindAllByName("obstruction_arthas")
	
		for _,obs in pairs(gridobs) do 
			obs:SetEnabled(false, true)
		end
	end
	doors_open = doors_open+1
end