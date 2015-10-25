--[[
	Author: Noya
	Date: 07.02.2015.
	Burrows Up or Down
]]
function Burrow( event )
	local caster = event.caster
	local move = event.Move
	local caster_x = event.caster:GetAbsOrigin().x
	local caster_y = event.caster:GetAbsOrigin().y
	local caster_z = event.caster:GetAbsOrigin().z
	local position = Vector(caster_x, caster_y, caster_z)

	if move == "up" then
		position.z = position.z + 128
		caster:SetAbsOrigin(position)
		print(position)
	else
		position.z = position.z - 128
		caster:SetAbsOrigin(position)
		print(position)
	end

end