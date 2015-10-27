function buy_tomes( event )
	-- body
	local hero = event.caster
	local ability = event.ability
	local gold = hero:GetGold()
	local cost = 8000
	local numberOfTomes = math.floor(gold / cost)
	local playerid = hero:GetPlayerID()
	
	PlayerResource:SpendGold(playerid, (numberOfTomes-1)*cost, DOTA_ModifyGold_PurchaseItem)
	hero:ModifyAgility(numberOfTomes*100)
	hero:ModifyStrength(numberOfTomes*100)
	hero:ModifyIntellect(numberOfTomes*100)
end

function tome_use(event)
	local hero = event.caster
	local ability = event.ability
	local stats = ability:GetSpecialValueFor("stat_bonus")
	
	hero:ModifyAgility(stats)
	hero:ModifyStrength(stats)
	hero:ModifyIntellect(stats)
end