
--[[Author: Pizzalol, Noya, Ractidous
	Date: 08.04.2015.
	Creates illusions while shuffling the positions]]
function partition( keys )
	local caster = keys.caster
	local player = caster:GetPlayerOwnerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local unit_name = caster:GetUnitName()
	local unit_count = ability:GetLevelSpecialValueFor( "unit_count", ability_level )
	local duration = ability:GetLevelSpecialValueFor( "split_duration", ability_level )

	local casterOrigin = caster:GetAbsOrigin()
	local casterAngles = caster:GetAngles()

	-- Stop any actions of the caster otherwise its obvious which unit is real
	caster:Stop()
	caster:AddNoDraw()
	-- Initialize the illusion table to keep track of the units created by the spell
	if not caster.partition then
		caster.partition = {}
	end

	-- Kill the old images
	for k,v in pairs(caster.partition) do
		if v and IsValidEntity(v) then 
			v:ForceKill(false)
		end
	end


	-- Start a clean illusion table
	caster.partition = {}

	-- Spawn illusions
	for i=1, unit_count do

		local origin = casterOrigin

		-- handle_UnitOwner needs to be nil, else it will crash the game.
		local illusion = CreateUnitByName("npc_blademaster_samuro", origin, true, caster, caster, caster:GetTeamNumber())
		illusion:SetControllableByPlayer(player, true)

		illusion:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		ability:ApplyDataDrivenModifier(caster, illusion, "modifier_samuro", {})
		--illusion:SetPlayerID(caster:GetPlayerOwnerID())

		-- Add the illusion created to a table within the caster handle, to remove the illusions on the next cast if necessary
		table.insert(caster.partition, illusion)
	end
end

--[[Creates vision around the caster while shuffling the illusions]]
function Vision( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level) 
	local vision_duration = ability:GetLevelSpecialValueFor("invuln_duration", ability_level)

	ability:CreateVisibilityNode(caster_location, vision_radius, vision_duration)
end

--on samuro death delete the illusion
function SamuroDeath( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit
	local ability_level = ability:GetLevel() - 1
	local position = target:GetAbsOrigin()
	
	for k,v in pairs(caster.partition) do 
		if IsValidEntity(target) then 
			if v == target then
				table.remove(caster.partition,k)
				v:RemoveSelf()
			end
		end
	end


	if #caster.partition == 0 then
		if IsValidAlive(caster) then
			FindClearSpaceForUnit(caster, position, true)
			caster:RemoveModifierByName("modifier_blademaster_partition")
		end
	end
end

function EndPartition( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	caster:RemoveNoDraw()

	if #caster.partition == 0 then
		if IsValidAlive(caster) then
			caster:ForceKill(false)
		end
	end

	for _,v in pairs(caster.partition) do 
		if IsValidAlive(v) then 
			FindClearSpaceForUnit(caster, v:GetAbsOrigin(), true)
			v:RemoveSelf()
		end
	end
	
	caster.partition = {}
    PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(),caster)
    Timers:CreateTimer(0.5,function () PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(),nil) 
                            end)
end
