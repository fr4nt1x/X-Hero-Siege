
function drop_keys_of_three_moons(event)
	-- body
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local attacker = event.attacker
	local player = PlayerResource:GetPlayer(attacker:GetPlayerOwnerID())

	if IsValidEntity(player) then
		local hero = player:GetAssignedHero()
		local sword = CreateItem("item_key_of_the_three_moons", hero,hero)
		CreateItemOnPositionSync( point, sword )
		
		sword:LaunchLoot(false, 400, 0.75, point)
		GameMode.FrostInfernalDead = true
	end
end

function drop_shield_of_invincibility(event)
	-- body
	local caster = event.caster
	local attacker = event.attacker
	local player = PlayerResource:GetPlayer(attacker:GetPlayerOwnerID())
	
	if IsValidEntity(player) then
		local hero = player:GetAssignedHero()
		
		local point = caster:GetAbsOrigin()
		local tome = CreateItem("item_shield_of_invincibility", hero,hero)

		CreateItemOnPositionSync( point, tome )

		tome:LaunchLoot(false, 400, 0.75, point+RandomVector(50))
	  	GameMode.SpiritBeastDead = true
	end
end