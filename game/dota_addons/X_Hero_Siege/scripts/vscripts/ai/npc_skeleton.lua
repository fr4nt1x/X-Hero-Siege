--[[
npc_skeleton ability
]]
-- "vscripts"			"ai/npc_skeleton.lua"


function Spawn(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local goal = caster:GetInitialGoalEntity()
	target:SetInitialGoalEntity(goal)
end