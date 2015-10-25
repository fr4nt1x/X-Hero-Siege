
function end_game( event )
	-- body
	local caster = event.caster
	local killer = event.attacker:GetPlayerOwner():GetAssignedHero()
	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)

end