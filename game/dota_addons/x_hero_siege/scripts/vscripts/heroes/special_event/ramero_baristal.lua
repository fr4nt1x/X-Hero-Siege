

function drop_lightning_sword(event)
	-- body
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local attacker = event.attacker
	local player = attacker:GetPlayerOwner()
	local hero = attacker:GetPlayerOwner():GetAssignedHero()
	GameMode.eventWaveKills = GameMode.eventWaveKills +1

	if GameMode.eventWaveKills == 2 then
		local sword = CreateItem("item_lightning_sword", hero,hero)
		CreateItemOnPositionSync( point, sword )
	 	Timers:CreateTimer( 10,function () FireGameEventLocal("end_special_event_wave_kills", {hero_index = hero:GetEntityIndex()}) end)
	 	GameMode.eventWaveKills = nil
		sword:LaunchLoot(false, 400, 0.75, point)
	elseif GameMode.eventWaveKills == 1 then
		local tome = CreateItem("item_tome_big", hero,hero)
		CreateItemOnPositionSync( point, tome )
		tome:SetCurrentCharges(1)
		tome:LaunchLoot(false, 400, 0.75, point+RandomVector(50))
	end
end

function drop_ring(event)
	-- body
	local caster = event.caster
	local attacker = event.attacker
	local hero = attacker:GetPlayerOwner():GetAssignedHero()
	local player = attacker:GetPlayerOwner()
	local point = caster:GetAbsOrigin()
	local tome = CreateItem("item_ring_of_superiority", hero,hero)


	CreateItemOnPositionSync( point, tome )

 	Timers:CreateTimer( 10,function () FireGameEventLocal("end_special_event_kills", {hero_index = hero:GetEntityIndex()}) end) 
	tome:LaunchLoot(false, 400, 0.75, point+RandomVector(50))
end