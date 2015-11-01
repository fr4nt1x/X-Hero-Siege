local dummy = nil

function modifier_start( event )
	-- body
	dummy = event.target
end

function channel_end( event )
	-- body
	
	if dummy ~= nil then
		dummy:RemoveSelf()
		dummy = nil
	end
end