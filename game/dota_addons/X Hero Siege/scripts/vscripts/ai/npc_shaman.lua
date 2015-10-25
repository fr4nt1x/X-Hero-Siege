--[[
npc_shaman ai
]]
-- "vscripts"			"ai/npc_shaman.lua"

require('libraries/timers')

function Spawn( entityKeyValues )
	Ability_bloodlust = thisEntity:FindAbilityByName("shaman_bloodlust")

	Timers:CreateTimer(0,ShamanThink)
	DebugPrint("Starting AI for "..thisEntity:GetUnitName().." "..thisEntity:GetEntityIndex())

end

function ShamanThink()
	-- body

	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		return nil
	elseif Ability_bloodlust:IsFullyCastable() then
		DebugPrint("can cast bloodlust")
		
		--FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, Ability_bloodlust:GetCastRange()-5, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
		
		if units ~= nil then
			local target = nil
			--Find unit that does not allready have the modifier
			for _,unit in pairs(units) do
				if not unit:HasModifier("modifier_bloodlust") then
					target = unit
				end
			end
			
			if target ~= nil then
				DebugPrint("castingAbility bloodlust")
				thisEntity:CastAbilityOnTarget(target, Ability_bloodlust,-1)
			end
		end
	end
	return 2

end