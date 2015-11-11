
function drop_tome(event)
	-- body
	
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local attacker = event.attacker
	local player = attacker:GetPlayerOwner()
	local hero = attacker:GetPlayerOwner():GetAssignedHero()

	if caster:GetHealth()== 0 then
		local sword = CreateItem("item_tome_big", hero,hero)
		CreateItemOnPositionSync( point, sword )
		Timers:CreateTimer( 8,function () FireGameEventLocal("end_special_event_illusion", {hero_index = hero:GetEntityIndex()}) end)
		sword:LaunchLoot(false, 400, 0.75, point)
		hero.illusion_done = true
	end
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