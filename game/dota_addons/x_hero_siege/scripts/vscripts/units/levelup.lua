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
		for i= 1,(GameMode.level_state.level-2)^2 do 
			for j = 1,i do
				ability:ApplyDataDrivenModifier(unit,unit , "modifier_upgrade", nil)
				unit:SetBaseMaxHealth(unit:GetMaxHealth() +health_bonus)
				unit:SetHealth(unit:GetMaxHealth())
			end
		end
	end

end 