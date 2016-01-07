
function tome_use(event)
	local hero = event.caster
	
	if IsValidEntity(hero) then 
		hero:HeroLevelUp(true)
	end 
end