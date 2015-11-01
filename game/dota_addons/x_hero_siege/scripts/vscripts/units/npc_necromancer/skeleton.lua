--[[
npc_skeleton ability
]]

--sets the initial goal of summoned unit to the goal of the summoner

function SetGoal(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local goal = caster:GetInitialGoalEntity()
	target:SetInitialGoalEntity(goal)
end