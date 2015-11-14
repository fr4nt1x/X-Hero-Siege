require('libraries/notifications')

function drop_tome(event)
	-- body
	
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local attacker = event.attacker
	local player = attacker:GetPlayerOwner()
	local hero = attacker:GetPlayerOwner():GetAssignedHero()

	if caster:GetHealth()== 0 then
		Timers:CreateTimer( 3,function () FireGameEventLocal("end_special_event_illusion", {hero_index = hero:GetEntityIndex()}) end)
     	local msg = hero:GetName().." got 100 bonus stats for finishing the illusion event!"
     	Notifications:TopToAll({text=msg, duration=5.0})
     	hero:ModifyAgility(100)
		hero:ModifyStrength(100)
		hero:ModifyIntellect(100)
	end
end
