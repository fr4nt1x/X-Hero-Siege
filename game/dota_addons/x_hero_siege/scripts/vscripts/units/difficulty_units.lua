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
		for i= 1,difficulty-2 do 
			for j = 1,i do
				ability:ApplyDataDrivenModifier(unit,unit , "modifier_upgrade_diff", nil)
				unit:SetBaseMaxHealth(unit:GetMaxHealth() +health_bonus)
				unit:SetHealth(unit:GetMaxHealth())
			end
		end
	end

end 