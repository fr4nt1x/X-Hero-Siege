function blink( event )
	-- body

	local point = event.target_points
	local caster = event.caster
	if point ~=nil then
		FindClearSpaceForUnit(caster, point[1],  true)
	end
end