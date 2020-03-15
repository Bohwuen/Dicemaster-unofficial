-------------------------------------------------------------------------------
-- Dice Master (C) 2019 <The League of Lordaeron> - Moon Guard
-------------------------------------------------------------------------------

--
-- Chat commands.
--

local Me = DiceMaster4
local Profile = Me.Profile

-------------------------------------------------------------------------------
function Me.Console_Init()
	SLASH_DICE1       = '/dice';
	SLASH_DICEMASTER1 = '/dicemaster';
end

-------------------------------------------------------------------------------
-- /dice
--
function SlashCmdList.DICE( msg, editBox )
	
	if msg == "" then
		-- show usage
		Me.PrintMessage("/dice (rollType or XDY[+/-]Z)", "SYSTEM");
		Me.PrintMessage("- X Es el número de dados a lanzar.", "SYSTEM");
		Me.PrintMessage("- Y Es el número de caras de los dados a lanzar.", "SYSTEM");
		Me.PrintMessage("- Z Es el número a sumar o restar al resultado de los dados a lanzar.", "SYSTEM");
		return
	end
	
	local dice = DiceMasterPanelDice:GetText()
	local rollType = nil
	local stat = nil
	local modifier = 0
	
	for k, v in pairs( Me.RollList ) do
		for i = 1, #v do
			if v[i].name:lower() == msg:lower() then
				rollType = v[i].name
				stat = v[i].stat
			end
		end
	end
	
	if rollType and stat then
		for i = 1,#Profile.stats do
			if Profile.stats[i] and ( Profile.stats[i].name == stat or Profile.stats[i].name == rollType ) then
				modifier = modifier + Profile.stats[i].value
			end
		end
		msg = Me.FormatDiceString( dice, modifier ) or "D20"
	end
	
	Me.Roll( msg, rollType ) 
end 

-------------------------------------------------------------------------------
-- /dicemaster
--
function SlashCmdList.DICEMASTER(msg, editbox)
	local command, rest = msg:match("^(%S*)%s*(.-)$");
	command = command:lower()
	
	
	if command == "config" then
	
		Me.OpenConfig()
		
	elseif command == "scale" then
	
		rest = tonumber(rest)
		if rest then
			rest = Me.Clamp( rest, 0.25, 10 )
			Me.db.char.uiScale = rest
			Me.ApplyUiScale() 
		end
		
	elseif command == "show" then
	
		Me.ShowPanel( true )
		
	elseif command == "hide" then
	
		Me.ShowPanel( false )
		
	elseif command == "lock" then
	
		Me.LockFrames()
		
	elseif command == "unlock" then
	
		Me.UnlockFrames()
		
	elseif command == "charges" then
	
		if rest:lower() == "show" then
			Profile.charges.enable = true;
			Me.OnChargesChanged()
		elseif rest:lower() == "hide" then
			Profile.charges.enable = false;
			Me.OnChargesChanged()
		end
		
	elseif command == "chargesname" and rest ~= "" then
	
		Profile.charges.name = rest
		Me.OnChargesChanged()
		
		Me.TraitEditor_Refresh()
		
	elseif command == "maxcharges" then
		
		rest = tonumber(rest)
		if not rest or rest < 1 or rest > 8 then return end
		
		Profile.charges.max = rest
		Profile.charges.count = math.min( Profile.charges.count, Profile.charges.max )
		Me.OnChargesChanged()
		 
	elseif command == "chargescolor" then
	
		local r, g, b = string.match( rest, "(%d+%.?%d*)%s+(%d+%.?%d*)%s+(%d+%.?%d*)")
		r = tonumber(r)
		g = tonumber(g)
		b = tonumber(b)
		
		if r and g and b then
			Profile.charges.color = { r, g, b }
			Me.OnChargesChanged()
		end
	elseif command == "showraidrolls" then
		if rest:lower() == "true" then
			Me.db.char.showRaidRolls = true
		else
			Me.db.char.showRaidRolls = false
		end
	elseif command == "manager" then
	
		if rest:lower() == "show" then
			Me.db.global.hideTracker = true
			DiceMasterRollFrame:Show()
		elseif rest:lower() == "hide" then
			Me.db.global.hideTracker = false
			DiceMasterRollFrame:Hide()
		elseif DiceMasterRollFrame:IsShown() then
			Me.db.global.hideTracker = false
			DiceMasterRollFrame:Hide()
		else
			Me.db.global.hideTracker = true
			DiceMasterRollFrame:Show()
		end
	elseif command == "managerscale" then
	
		rest = tonumber(rest)
		if rest then
			rest = Me.Clamp( rest, 0.25, 10 )
			Me.db.char.trackerScale = rest
			Me.ApplyUiScale() 
		end
	elseif command == "progressbar" then
	
		if rest:lower() == "show" then
			Me.db.profile.morale.enable = true; 
			Me.RefreshMoraleFrame() 
		elseif rest:lower() == "hide" then
			Me.db.profile.morale.enable = false; 
			Me.RefreshMoraleFrame() 
		end
		Me.ApplyUiScale() 
	else
		Me.PrintMessage("- /dicemaster config", "SYSTEM");
		Me.PrintMessage("- /dicemaster scale (number)", "SYSTEM");
		Me.PrintMessage("- /dicemaster (show || hide)", "SYSTEM");
		Me.PrintMessage("- /dicemaster charges (show || hide)", "SYSTEM");
		Me.PrintMessage("- /dicemaster chargesname (name)", "SYSTEM");
		Me.PrintMessage("- /dicemaster maxcharges (number)", "SYSTEM");
		Me.PrintMessage("- /dicemaster chargescolor (r g b)", "SYSTEM");
		Me.PrintMessage("- /dicemaster showraidrolls (true || false)", "SYSTEM");
		Me.PrintMessage("- /dicemaster manager (show || hide)", "SYSTEM");
		Me.PrintMessage("- /dicemaster managerscale (number)", "SYSTEM");
		Me.PrintMessage("- /dicemaster progressbar (show || hide)", "SYSTEM");
		Me.PrintMessage("- /dicemaster (lock || unlock)", "SYSTEM");
	end
end 
