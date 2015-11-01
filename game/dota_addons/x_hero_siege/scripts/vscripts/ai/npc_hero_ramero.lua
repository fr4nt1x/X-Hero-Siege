
require('libraries/timers')

function Spawn( entityKeyValues )

	Ability_divine_shield = thisEntity:FindAbilityByName("proudmoore_divine_shield")

	Timers:CreateTimer(0,RameroThink)
	DebugPrint("Starting AI for "..thisEntity:GetUnitName().." "..thisEntity:GetEntityIndex())

end

function RameroThink()
	-- body
	if thisEntity:IsNull() then
		return nil
	elseif not thisEntity:IsAlive() then
		return nil
	elseif Ability_divine_shield:IsFullyCastable() then		
		if thisEntity:GetHealthPercent() <= 90 then
			thisEntity:CastAbilityNoTarget(Ability_divine_shield,-1)
		end
	end
	return 1
end