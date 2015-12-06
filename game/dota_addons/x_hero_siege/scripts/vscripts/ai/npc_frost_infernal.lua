
require('libraries/timers')

function Spawn( entityKeyValues )
	Ability_Frost_bolt = thisEntity:FindAbilityByName("frost_infernal_frost_bolt")
	Timers:CreateTimer(0,InfernalThink)
	DebugPrint("Starting AI for "..thisEntity:GetUnitName().." "..thisEntity:GetEntityIndex())
end

function InfernalThink()
	-- body

	if not IsValidAlive(thisEntity) then
		return nil
	elseif Ability_Frost_bolt:IsFullyCastable() then
		--FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
		if units ~= nil then
			thisEntity:CastAbilityOnTarget(units[1], Ability_Frost_bolt, -1)
		end
	end
	return 2
end