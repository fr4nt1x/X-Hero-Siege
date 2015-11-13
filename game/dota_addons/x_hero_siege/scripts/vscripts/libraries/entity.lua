require('libraries/timers')
require('libraries/spawncreeps')
require('libraries/notifications')


function killed_baracks( keys )
	-- body
	caller = keys.caller


	Timers:CreateTimer(function()
    	local unit = CreateUnitByName("npc_magnataur_destroyer_crypt", caller:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
      	unit:SetInitialGoalEntity(waypoint)
      	end)
	--find the lanenumber of the killed rax
	local i,j = string.find(caller:GetName(),"%d")
	local lane = string.sub(caller:GetName(),i,j)
	GameMode.openLanes["spawn"..lane] = nil
	local openlanes = 0
	

	--count the number of lanes that still spawn creeps
	for _,v in pairs(GameMode.openLanes) do
		openlanes = openlanes+1
	end
	--if there all the baracks of openlanes were killed start the countdown to the final wave

	if  openlanes == 0 then
		print("secondphase")
		
		Timers:RemoveTimer(GameMode.timers.timer_creep_spawn)
		GameMode.timers.timer_creep_spawn = nil

		local trigger = Entities:FindByName(nil,"trigger_phase2_left")
		trigger:Enable()
		local trigger = Entities:FindByName(nil,"trigger_phase2_right")
		trigger:Enable()
		GameMode.Phase2_openlanes = 0
		local door = Entities:FindByName(nil,"door_left") 
		door:Kill()
		local door = Entities:FindByName(nil,"door_right") 
		door:Kill()
		local gridobs = Entities:FindAllByName("obstruction_left")
		for _,obs in pairs(gridobs) do 
			obs:SetEnabled(false, true)
		end

		local gridobs = Entities:FindAllByName("obstruction_right")
		for _,obs in pairs(gridobs) do 
			obs:SetEnabled(false, true)
		end
	end
end

function trigger_second_wave_left()
	-- body
	DoEntFire("trigger_phase2_left","Kill",nil,0,nil,nil)
	PrecacheUnitByNameAsync("npc_ghul_II", function() end)
	GameMode.timer_second_phase_left = Timers:CreateTimer(10,spawn_second_phase_left)
end

function trigger_second_wave_right()
	-- body
	DoEntFire("trigger_phase2_right","Kill",nil,0,nil,nil)

	PrecacheUnitByNameAsync("npc_orc_II", function() end)  
	GameMode.timer_second_phase_right  =Timers:CreateTimer(10,spawn_second_phase_right)
end

function killed_frost_tower_left(keys)
	--body
	caller = keys.caller
	GameMode.FrostTowers_killed = GameMode.FrostTowers_killed +1
	Timers:RemoveTimer(GameMode.timer_second_phase_left)
	GameMode.timer_second_phase_left = nil

	if GameMode.FrostTowers_killed >= 2 then
		Timers:RemoveTimer( timer_wave_spawn)
		timer_wave_spawn = nil
		Timers:RemoveTimer( timer_wave_message)
		timer_wave_message = nil
		print("FinalWave timer started")
		Notifications:TopToAll({text="Warning. Final Wave incoming. Arriving in 20 seconds! Protect Your Basis!" , duration=5.0})
		Timers:CreateTimer(20,FinalWave)
		local directions = {"west","north","east","south"}
		for _,direction in pairs(directions) do
			for i =1,4 do
				PrecacheUnitByNameAsync(final_wave_creeps[direction][i], function() end) 
			end
		end
	end
end

function killed_frost_tower_right(keys)
	--body
	caller = keys.caller
	GameMode.FrostTowers_killed = GameMode.FrostTowers_killed +1
	Timers:RemoveTimer(GameMode.timer_second_phase_right)
	GameMode.timer_second_phase_right = nil

	if GameMode.FrostTowers_killed >= 2 then
		Timers:RemoveTimer( timer_wave_spawn)
		timer_wave_spawn = nil
		Timers:RemoveTimer( timer_wave_message)
		timer_wave_message = nil
		DebugPrint("FinalWave timer started")
		Notifications:TopToAll({text="Warning. Final Wave incoming. Arriving in 20 seconds! Protect Your Basis!" , duration=5.0})
		Timers:CreateTimer(20,FinalWave)
		local directions = {"west","north","east","south"}
		for _,direction in pairs(directions) do
			for i =1,5 do
				PrecacheUnitByNameAsync(final_wave_creeps[direction][i], function() end) 
			end
		end
	end
end


function teleport_to_top(keys)
	-- body
	--spawns magtheridon and the other four heroes 
	DebugPrint("teleport trigger")
	local caller = keys.caller
	local activator = keys.activator
	local teleporters = Entities:FindAllByName("teleport")
	local point = Entities:FindByName(nil,"point_teleport_boss"):GetAbsOrigin()
	local point_mag = Entities:FindByName(nil,"spawn_magtheridon"):GetAbsOrigin()  
	if GameMode.first_time_teleport then
  		local heroes = HeroList:GetAllHeroes()

  		magtheridon = CreateUnitByName("npc_dota_hero_magtheridon",Entities:FindByName(nil,"spawn_magtheridon"):GetAbsOrigin()  ,true,nil,nil,DOTA_TEAM_NEUTRALS)
  		magtheridon:SetAngles(0, 180, 0)
  		local ankh = CreateItem("item_magtheridon_ankh", mag, mag)
	  	
	  	local grom = CreateUnitByName("npc_dota_hero_grom_hellscream",Entities:FindByName(nil,"spawn_grom_hellscream"):GetAbsOrigin(),true,nil,nil,DOTA_TEAM_NEUTRALS)
  		grom:SetAngles(0, 270, 0)

  		local illidan = CreateUnitByName("npc_dota_hero_illidan",Entities:FindByName(nil,"spawn_illidan"):GetAbsOrigin(),true,nil,nil,DOTA_TEAM_NEUTRALS)
  		illidan:SetAngles(0, 0, 0)

  		local balanar = CreateUnitByName("npc_dota_hero_balanar",Entities:FindByName(nil,"spawn_balanar"):GetAbsOrigin(),true,nil,nil,DOTA_TEAM_NEUTRALS)
  		balanar:SetAngles(0, 90, 0)

  		local proudmoore = CreateUnitByName("npc_dota_hero_proudmoore",Entities:FindByName(nil,"spawn_proudmoore"):GetAbsOrigin(),true,nil,nil,DOTA_TEAM_NEUTRALS)
  		proudmoore:SetAngles(0, 180, 0)

	  	ankh:SetCurrentCharges(PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS))
	  	magtheridon:AddItem(ankh)

	  	magtheridon:AddNewModifier(nil, nil, "modifier_stunned",nil)
    	magtheridon:AddNewModifier(nil, nil, "modifier_invulnerable",nil)
    	Timers:CreateTimer(10,StartMagtheridonFight)

	  	for _,hero in pairs(heroes) do
	  		if hero.disconnected ~= true and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
	  			FindClearSpaceForUnit(hero, point, true)
	       		hero:AddNewModifier(nil, nil, "modifier_stunned",nil)
	        	hero:AddNewModifier(nil, nil, "modifier_invulnerable",nil)
	  			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)
				GameMode.first_time_teleport = false
	  		end
	  	end

	elseif activator:GetTeam() == DOTA_TEAM_GOODGUYS then
		FindClearSpaceForUnit(activator, point, true)
	end
end

function StartMagtheridonFight()
  -- body
  local heroes = HeroList:GetAllHeroes()

  magtheridon:RemoveModifierByName("modifier_stunned")
  magtheridon:RemoveModifierByName("modifier_invulnerable")

  magtheridon = nil

  for _,hero in pairs(heroes) do
	  if hero.disconnected ~= true and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
	    PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),nil)
	    hero:RemoveModifierByName("modifier_stunned")
	    hero:RemoveModifierByName("modifier_invulnerable")
	  end
   end
   return nil
end

function spawn_deathghost( event )
	-- body
	local caller = event.caller
 	Timers:CreateTimer(function()
    	local unit = CreateUnitByName("npc_death_ghost_tower", caller:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
      	unit:SetInitialGoalEntity(waypoint)
      	end)
end

function start_top_waves( event )
	-- body
	local heroes = HeroList:GetAllHeroes()
	local caller = event.caller
	local point = Entities:FindByName(nil,"point_teleport_waves_top"):GetAbsOrigin()
	for _,hero in pairs(heroes) do
	  	if hero.disconnected ~= true and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
	  		FindClearSpaceForUnit(hero, point, true)
	  		hero:AddNewModifier(nil, nil, "modifier_stunned",nil)
	       	hero:AddNewModifier(nil, nil, "modifier_invulnerable",nil)	
  			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)

	  	end
	end
	Timers:CreateTimer(TimeBetweenCreepWavesTop,spawn_creeps_top_first)
end

function start_top_waves_second( event )
	-- body
	local heroes = HeroList:GetAllHeroes()
	local caller = event.caller
	local point = Entities:FindByName(nil,"point_teleport_waves_top"):GetAbsOrigin()
	for _,hero in pairs(heroes) do
	  	if hero.disconnected ~= true and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
	  		FindClearSpaceForUnit(hero, point, true)
	  		hero:AddNewModifier(nil, nil, "modifier_stunned",nil)
	       	hero:AddNewModifier(nil, nil, "modifier_invulnerable",nil)	
  			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(),hero)

	  	end
	end
	Timers:CreateTimer(TimeBetweenCreepWavesTop,spawn_creeps_top_second)
end

function teleporter_frost_infernal( event )
	-- SetBodygroup(int iGroup, int iValue)					
	local hero = event.activator
	local event_to_sent = nil

	if GameMode.spirit_beast_event ~= nil then
		event_to_sent = "end_special_event_spirit_beast"

	elseif GameMode.frost_infernal_event ~=nil then
		event_to_sent = "end_special_event_frost_infernal"
	else
		return nil 
	end
	FireGameEventLocal(event_to_sent, {hero_index = hero:GetEntityIndex()})
end

function teleporter_illusions( event )
	-- SetBodygroup(int iGroup, int iValue)					
	local hero = event.activator
	local event_to_sent = nil

	if GameMode.illusion_event  ~= nil then
		event_to_sent = "end_special_event_illusion"

	--elseif GameMode.frost_infernal_event ~=nil then
		--event_to_sent = "end_special_event_frost_infernal"
	else
		return nil 
	end
	FireGameEventLocal(event_to_sent, {hero_index = hero:GetEntityIndex()})
end