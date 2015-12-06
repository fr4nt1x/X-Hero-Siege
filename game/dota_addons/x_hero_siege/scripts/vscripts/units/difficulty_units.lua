function upgrade_unit(event)
	-- body
	local unit = event.caster
	local ability = event.ability
	local health_bonus = ability:GetLevelSpecialValueFor("bonus_health", ability:GetLevel()-1)

	if unit:IsNull() or not unit:IsAlive() or ability == nil then
		return nil
	end
	local difficulty = GameRules:GetCustomGameDifficulty()
	if difficulty >= 3 then
		ability:ApplyDataDrivenModifier(unit,unit, "modifier_upgrade_diff", nil)
		local end_index = (difficulty-2)
		local amount_of_stack = math.floor((end_index+1)*end_index*0.5)
		unit:SetModifierStackCount("modifier_upgrade_diff", unit, amount_of_stack)
		unit:SetMaxHealth(unit:GetMaxHealth() +amount_of_stack*health_bonus)
		unit:SetBaseMaxHealth(unit:GetMaxHealth() +amount_of_stack*health_bonus)
		unit:SetHealth(unit:GetMaxHealth())
	end

end 

function upgrade_boss(event)
	-- body
	local unit = event.caster
	local ability = event.ability
	local health_bonus = ability:GetLevelSpecialValueFor("bonus_health", ability:GetLevel()-1)
	if unit:IsNull() or not unit:IsAlive() or ability == nil then
		return nil
	end
	
	local difficulty = GameRules:GetCustomGameDifficulty()

	if difficulty >= 2 then
		ability:ApplyDataDrivenModifier(unit,unit, "modifier_upgrade_boss_diff", nil)
		local end_index = (difficulty-1)
		local amount_of_stack = math.floor((end_index+1)*end_index*0.5)
		unit:SetModifierStackCount("modifier_upgrade_boss_diff", unit, amount_of_stack)
		unit:SetMaxHealth(unit:GetMaxHealth() +amount_of_stack*health_bonus)
		unit:SetBaseMaxHealth(unit:GetMaxHealth() +amount_of_stack*health_bonus)
		unit:SetHealth(unit:GetMaxHealth())
	end

end 