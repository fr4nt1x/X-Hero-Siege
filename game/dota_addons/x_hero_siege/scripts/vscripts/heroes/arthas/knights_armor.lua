function return_damage( event )
	-- body
	local damage = event.Attack_Damage 
	local hero = event.caster 
	local attacker = event.attacker
	local ability = event.ability
	local damage_returned_factor = ability:GetLevelSpecialValueFor("damage_return_factor", ability:GetLevel()-1)
	
	if IsValidEntity(attacker) and not attacker:IsTower() and IsValidEntity(hero) then
	    local armor = hero:GetPhysicalArmorValue()
	    local damage_multiplier = 1 - (0.06 * armor)/(1 + (0.06 * math.abs(armor)))
	    
	    damage_multiplier = math.min(math.max(0.02,damage_multiplier),1)
	    DebugPrint("Damage Multiplier:")
	    DebugPrint(damage_multiplier)
	    if hero:IsAlive() then
		    local damageTable = {
					victim = attacker,
					attacker = hero,
					damage = damage_returned_factor*damage/damage_multiplier,
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
	 
			ApplyDamage(damageTable)
		end
	end
end