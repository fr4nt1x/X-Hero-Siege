
function end_game( event )
	-- body
	local caster = event.caster
	GameRules:SetPostGameTime(35)
	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
end