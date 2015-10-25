
function drop_keys_of_three_moons(event)
	-- body
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local attacker = event.attacker
	local player = attacker:GetPlayerOwner()
	local hero = attacker:GetPlayerOwner():GetAssignedHero()

	local sword = CreateItem("item_key_of_the_three_moons", hero,hero)
	CreateItemOnPositionSync( point, sword )
	Timers:CreateTimer( 8,function () FireGameEventLocal("end_special_event_frost_infernal", {hero_index = hero:GetEntityIndex()}) end)
	sword:LaunchLoot(false, 400, 0.75, point)
	GameMode.FrostInfernalDead = true
end

function drop_shield_of_invincibility(event)
	-- body
	local caster = event.caster
	local attacker = event.attacker
	local hero = attacker:GetPlayerOwner():GetAssignedHero()
	local player = attacker:GetPlayerOwner()
	local point = caster:GetAbsOrigin()
	local tome = CreateItem("item_shield_of_invincibility", hero,hero)

	CreateItemOnPositionSync( point, tome )

 	Timers:CreateTimer( 8,function () FireGameEventLocal("end_special_event_spirit_beast", {hero_index = hero:GetEntityIndex()}) end) 
	tome:LaunchLoot(false, 400, 0.75, point+RandomVector(50))
  	GameMode.SpiritBeastDead = true
end