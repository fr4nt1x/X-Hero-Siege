
function arena_kill( event )
	-- body
	local dead_unit = event.unit

	local heroid = dead_unit.heroid
	
	GameMode.player_spawn_round_kills[heroid]["kills"] = GameMode.player_spawn_round_kills[heroid]["kills"]+1

	if GameMode.player_spawn_round_kills[heroid]["kills"] == 10 then

		GameMode.player_spawn_round_kills[heroid]["kills"]  = 0
		GameMode.player_spawn_round_kills[heroid]["round"] = (GameMode.player_spawn_round_kills[heroid]["round"] + 1) % 9

		for j = 1,10 do
        	local unit = CreateUnitByName(GameMode.specialEventCreeps[GameMode.player_spawn_round_kills[heroid]["round"]+1], GameMode.player_spawn_round_kills[heroid]["spawn_point"], true, nil, nil, DOTA_TEAM_NEUTRALS)
        	unit.heroid = heroid
      	end

	end
		
	
end