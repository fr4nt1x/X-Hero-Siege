require('libraries/notifications')

function drop_tome(event)
	-- body
	
	local caster = event.caster
	local point = caster:GetAbsOrigin()

	local hero = EntIndexToHScript(GameMode.heroid_doing_illusions)

	if caster:GetHealth()== 0 then
		Timers:CreateTimer( 1,function () FireGameEventLocal("end_special_event_illusion", {hero_index = GameMode.heroid_doing_illusions}) end)
     	if IsValidEntity(hero) then
	     	local msg = hero:GetName().." got 100 bonus stats for finishing the illusion event!"
	     	Notifications:TopToAll({text=msg, duration=5.0})
	     	hero:ModifyAgility(100)
			hero:ModifyStrength(100)
			hero:ModifyIntellect(100)
		end
	end
end
