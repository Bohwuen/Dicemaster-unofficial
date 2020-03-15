-------------------------------------------------------------------------------
-- Dice Master (C) 2019 <The League of Lordaeron> - Moon Guard
-------------------------------------------------------------------------------

local Me = DiceMaster4
 
-------------------------------------------------------------------------------
-- Get info about the character.
--
-- @returns name, race, class, class color
--
function Me.GetCharInfo()
	
	local name  = UnitName( "player" )
	local race  = UnitRace( "player" )
	local class, classID = UnitClass( "player" )
	local class_color = RAID_CLASS_COLORS[ classID ].colorStr
	
	if TRP3_API then
		-- Player is using TRP3.
		
		local data = TRP3_API.profile.getData("player").characteristics
		if data.FN and data.FN ~= "" then
			name = data.FN
			if data.LN and data.LN ~= "" then
				name = name .. " " .. data.LN
			end
		end
		if data.RA and data.RA ~= "" then race = data.RA end
		if data.CL and data.CL ~= "" then class = data.CL end
		if data.CH and data.CH ~= "" then class_color = "ff" .. data.CH:lower() end
		
	elseif xrp then
		-- Player is using XRP.
		
		local data = xrp.current
		if data.NA and data.NA ~= "" then
			name = xrp.Strip( data.NA )
		end
		
		if data.RA and data.RA ~= "" then race = data.RA end
		if data.RC and data.RC ~= "" then class = data.RC end
	elseif mrp then
		-- 2019 and still using mrp? x)))
		
		local data = msp.char[UnitName("player")].field
		if data.NA and data.NA ~= "" then name = data.NA end
		if data.RA and data.RA ~= "" then race = data.RA end
		if data.RC and data.RC ~= "" then class = data.RC end
	end
	
	return name, race, class, class_color
end
