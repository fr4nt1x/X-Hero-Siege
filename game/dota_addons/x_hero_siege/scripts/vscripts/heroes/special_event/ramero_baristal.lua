

function drop_lightning_sword(event)
	-- body
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local attacker = event.attacker
	local player = PlayerResource:GetPlayer(attacker:GetPlayerOwnerID())

	if IsValidEntity(player) then
		local hero = player:GetAssignedHero()
		GameMode.eventWaveKills = GameMode.eventWaveKills +1

		if GameMode.eventWaveKills == 2 then
			local sword = CreateItem("item_lightning_sword", hero,hero)
			CreateItemOnPositionSync( point, sword )
		 	GameMode.eventWaveKills = nil
			sword:LaunchLoot(false, 400, 0.75, point)
		elseif GameMode.eventWaveKills == 1 then
			local tome = CreateItem("item_tome_big", hero,hero)
			CreateItemOnPositionSync( point, tome )
			tome:SetCurrentCharges(1)
			tome:LaunchLoot(false, 400, 0.75, point+RandomVector(50))
		end
	end
end

function drop_ring(event)
	-- body
	local caster = event.caster
	local attacker = event.attacker
	local player = PlayerResource:GetPlayer(attacker:GetPlayerOwnerID())

	if IsValidEntity(player) then

		local hero = player:GetAssignedHero()
		local point = caster:GetAbsOrigin()
		local tome = CreateItem("item_ring_of_superiority", hero,hero)

		CreateItemOnPositionSync( point, tome )
		tome:LaunchLoot(false, 400, 0.75, point+RandomVector(50))
	end
end