function force_attack( keys )
	-- body
	local caster = keys.caster
	local target = keys.target

	local order_target = 
    {
        UnitIndex = target:entindex(),
        OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
        TargetIndex = caster:entindex()
    }
    target:Stop()
    ExecuteOrderFromTable(order_target)
    target:SetForceAttackTarget(caster)
end

function force_attack_remove( keys )
	-- body

	local caster = keys.caster
	local target = keys.target
	if IsValidAlive(target) then
		target:SetForceAttackTarget(nil)
	end
end