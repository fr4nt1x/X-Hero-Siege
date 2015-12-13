--[[
npc_priest ai
]]
-- "vscripts"			"ai/npc_priest.lua"
require('libraries/timers')

function Spawn( entityKeyValues )
	Ability_innerfire = thisEntity:FindAbilityByName("priest_innerfire")

	Timers:CreateTimer(0,PriestThink)
	DebugPrint("Starting AI for "..thisEntity:GetUnitName().." "..thisEntity:GetEntityIndex())

end

function PriestThink()
	-- body

	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		return nil
	elseif Ability_innerfire:IsFullyCastable() then
		DebugPrint("can cast innerfire")
		--FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, Ability_innerfire:GetCastRange()-5, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
		if units ~= nil then
			--get last unit of units that does not allready have the innerfire modifier
			local target = nil
			for _,unit in pairs(units) do
				if not unit:HasModifier("modifier_innerfire") then
					DebugPrint("unit found")
					target = unit
				end
			end
			
			if target ~= nil then
				DebugPrint("castingAbility innerfire")
				thisEntity:CastAbilityOnTarget(target, Ability_innerfire,-1)
			end
		end
	end
	if thisEntity:GetInitialGoalEntity() == nil then
		thisEntity:SetInitialGoalEntity(Entities:FindByName(nil, "base"))
	end
	return 2

end