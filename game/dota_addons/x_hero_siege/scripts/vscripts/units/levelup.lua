require('libraries/tools')

function upgrade_unit(event)
	-- body

	local unit = event.caster
	local ability = event.ability
	local health_bonus = ability:GetLevelSpecialValueFor("bonus_health", ability:GetLevel()-1)

	if not IsValidAlive(unit) or ability == nil then
		return nil
	end

	if GameMode.level_state.level >= 3 then
		ability:ApplyDataDrivenModifier(unit,unit, "modifier_upgrade", nil)
		local end_index = (GameMode.level_state.level-2)^2
		local amount_of_stack = math.floor((end_index+1)*end_index*0.5)
		unit:SetModifierStackCount("modifier_upgrade", unit, amount_of_stack)
		unit:SetMaxHealth(unit:GetMaxHealth() +amount_of_stack*health_bonus)
		unit:SetBaseMaxHealth(unit:GetMaxHealth() +amount_of_stack*health_bonus)
		unit:SetHealth(unit:GetMaxHealth())

		--[[
		for i = 1,(GameMode.level_state.level-2)^2 do 
			for j = 1,i do
				ability:ApplyDataDrivenModifier(unit,unit , "modifier_upgrade", nil)
				unit:SetBaseMaxHealth(unit:GetMaxHealth() +health_bonus)
				unit:SetHealth(unit:GetMaxHealth())
			end
		end
	]]
	end

end 