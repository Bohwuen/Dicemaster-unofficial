-------------------------------------------------------------------------------
-- Dice Master (C) 2019 <The League of Lordaeron> - Moon Guard
-------------------------------------------------------------------------------

--
-- Roll banners.
--

local Me = DiceMaster4
local Profile = Me.Profile

local options = {
	{
		name = "Combat Begins",
		description = "Combat has officially begun.",
		options = {
			{ icon = "Interface/Icons/VAS_NameChange", name = "Hold Emotes", desc = "Hold posts until the Emote Phase.", details = "Please hold off from posting any emotes at this time. You can still engage in brief dialogue, but save any descriptive emotes for the next Emote Phase, or when combat ends.", },
		},
	},
	{
		name = "Action Phase",
		description = "Choose one of the following:",
		options = {
			{ icon = "Interface/Icons/Garrison_Building_SparringArena", name = "Combat Action", desc = "Attempt a Combat Action.", details = "A Combat Action represents your character's attempt to deal or defend against damage on your turn.|n|nExample: Melee Attack, Ranged Attack, Spell Attack" },
			{ icon = "Interface/Icons/achievement_guild_doctorisin", name = "Skill", desc = "Attempt to use a Skill.", details = "Skills represent some of the most basic, fundamental abilities your character possesses, and most character non-combat actions can be categorised into at least one of the default Skills.|n|nExample: Bluff, Healing, Perception, Spellcraft" },
			{ icon = "Interface/Icons/achievement_guildperk_quick and dead", name = "Trait", desc = "Use an active-use Trait.", details = "Traits represent your character's strengths, weaknesses, and unique abilities. You can choose to use one of your active-use traits this turn.", },
			{ icon = "Interface/Icons/achievement_guildperk_fasttrack_rank2", name = "Move", desc = "Move to another location.", details = "Movement is restricted during combat. You can use your turn to move up to 20 yards in any direction, or reposition yourself.", },
			{ icon = "Interface/Icons/ACHIEVEMENT_GUILDPERK_EVERYONES A HERO", name = "Stand", desc = "Stand still and forego your turn.", details = "You can choose to forfeit your action this turn and stand still.", },
			{ icon = "Interface/Icons/achievement_guildperk_reinforce", name = "Protect", desc = "Grant you or an ally |cFF00FF00+3|r Defence.", details = "You can use your turn to defend yourself or another character, granting the chosen target |cFF00FF00+3|r to their next Defence roll.", },
		},
	},
	{
		name = "Reaction Phase",
		description = "You may be prompted to roll for one of the following:",
		options = {
			{ icon = "Interface/Icons/Garrison_Building_SparringArena", name = "Combat Action", desc = "Attempt a Combat Action.", details = "A Combat Action represents your character's attempt to deal or defend against damage on your turn.|n|nExample: Defence, Spell Defence" },
			{ icon = "Interface/Icons/achievement_guildperk_massresurrection", name = "Saving Throw", desc = "Attempt a Saving Throw.", details = "Generally, when your character is subject to an unusual or magical attack, you are allowed to roll a Saving Throw to avoid or reduce the effect.|n|nExample: Fortitude Save, Reflex Save, Will Save", },
		},
	},
	{
		name = "Emote Phase",
		description = "You may now post your emote in chat.",
		options = {
			{ icon = "Interface/Icons/vas_guildnamechange", name = "Emote", desc = "Post your emote in chat.", details = "You can now post a descriptive emote of your character's actions from the last turn in party or raid chat.", },
		},
	},
	{
		name = "Combat Ends",
		description = "Combat has officially ended.",
		options = {
			{ icon = "Interface/Icons/VAS_NameChange", name = "Hold Emotes", desc = "Continue holding posts for now.", details = "Please hold off from posting any emotes at this time. You can still engage in brief dialogue, but save any descriptive emotes for later.", },
			{ icon = "Interface/Icons/vas_guildnamechange", name = "Emote", desc = "You may resume posting in chat.", details = "You can now post a descriptive emote of your character's actions from the last turn in party or raid chat.", },
		},
	},
	{
		name = "Custom",
		description = "Banner Subtitle",
	},
}

function Me.RollBannerDropDown_OnClick(self, arg1)
	if arg1 then
		UIDropDownMenu_SetSelectedID(DiceMasterBannerPromptDialog.OptionsDropdown, arg1)
		UIDropDownMenu_SetText(DiceMasterBannerPromptDialog.OptionsDropdown, options[arg1].name)
		
		if options[arg1].name == "Custom" then
			DiceMasterBannerPromptDialog.BannerTitle:SetText("Banner Title")
		else
			DiceMasterBannerPromptDialog.BannerTitle:SetText(options[arg1].name)
		end
		
		DiceMasterBannerPromptDialog.BannerSubtitle:SetText(options[arg1].description)
		DiceMasterBannerPromptDialog.Desc:SetText("")
		
		-- Update the checkboxes
		local checkboxes = DiceMasterBannerPromptDialog.checkboxes
		for i = 1, #checkboxes do
			checkboxes[i]:SetChecked( false )
			checkboxes[i]:Hide()
			DiceMasterBannerPromptDialog:SetHeight( 160 )
		end
		
		if options[arg1].options then
			DiceMasterBannerPromptDialog.Desc:SetText("Select which options are available to players:")
			local checkOptions = options[arg1].options
			for i = 1, #checkOptions do
				checkboxes[i]:Show()
				_G["DiceMasterBannerPromptDialogCheckbox"..i.."Text"]:SetText( "|T" .. checkOptions[i].icon .. ":16|t |cFFFFD100" .. checkOptions[i].name .. ":|r " ..  checkOptions[i].desc .. "|r")
				DiceMasterBannerPromptDialog:SetHeight( 190 + 20*i )
			end
		end
	end
end

function Me.RollBannerDropDown_OnLoad(frame, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	
	info.text = "|cFFffd100Combat Phases:"
	info.notClickable = true;
	info.notCheckable = true;
	UIDropDownMenu_AddButton(info, level)
	info.notClickable = false;
	info.disabled = false;
	
	for i = 1, #options do
	   info.text = options[i].name;
	   info.arg1 = i;
	   info.notCheckable = true;
	   info.func = Me.RollBannerDropDown_OnClick;
	   UIDropDownMenu_AddButton(info, level)
	end
	
	UIDropDownMenu_SetSelectedID(DiceMasterBannerPromptDialog.OptionsDropdown, #options)
end

function Me.RollBanner_OnLoad( self )
	self:SetScale( 0.8 )

	for i = 2, 6 do
		local button = CreateFrame("Frame", "DiceMasterRollBannerOptionFrame"..i, self, "DiceMasterRollBannerOptionFrameTemplate");
		button:SetID(i)
		button:SetPoint("TOP", _G["DiceMasterRollBannerOptionFrame"..(i-1)], "BOTTOM", 0, -2);
		button:SetScript( "OnShow", function( self ) self.Anim:Play() end)
	end	
	
end

function Me.RollBanner_UpdateOptions( id, data )

	if not id or not data then
		DiceMasterRollBanner:SetHeight( 180 )
		return
	end
	
	for i = 1, 6 do
		local button = _G[ "DiceMasterRollBannerOptionFrame" .. i ]
		
		if data[i] then
			button.Icon:SetTexture( data[i].icon )
			button.Title:SetText( data[i].name )
			button.Description:SetText( data[i].desc )
			button.IconHitBox.details = data[i].details
			button:Show()
			
			DiceMasterRollBanner:SetHeight( 180 + 45*i )
		else
			button.Icon:SetTexture( nil )
			button.Title:SetText( "" )
			button.Description:SetText( "" )
			button.IconHitBox.details = nil
			button:Hide()
		end
	end
	
end

function Me.RollBanner_OnMouseEnter( self, button )
	
	DiceMasterRollBanner.MouseIsOver = true;
	
	if DiceMasterRollBanner.AnimOut:IsPlaying() then
		DiceMasterRollBanner.AnimOut:Stop()
	end
	
end

function Me.RollBanner_OnMouseLeave( self, button )
	
	DiceMasterRollBanner.MouseIsOver = false;
	
	if DiceMasterRollBanner:IsShown() and not ( DiceMasterRollBanner.AnimIn:IsPlaying() or DiceMasterRollBanner.AnimOut:IsPlaying() ) then
		DiceMasterRollBanner.AnimOut:Play()
	end
	
end

function Me.RollBanner_SendBanner()
	
	if DiceMasterRollBanner:IsShown() then
		UIErrorsFrame:AddMessage( "A banner is already playing.", 1.0, 0.0, 0.0, 53, 5 );
		return
	end
	
	if DiceMasterBannerPromptDialog.BannerTitle:GetText() == "" then
		UIErrorsFrame:AddMessage( "Enter a title for this banner.", 1.0, 0.0, 0.0, 53, 5 );
		return
	end
	
	local type = UIDropDownMenu_GetSelectedID(DiceMasterBannerPromptDialog.OptionsDropdown)
	local data = {}
	
	-- Collect options data.
	if type and options[type].options then
		local checkboxes = DiceMasterBannerPromptDialog.checkboxes
		local checkOptions = options[type].options
		for i = 1, 6 do
			if checkboxes[i]:IsShown() and checkboxes[i]:GetChecked() then
				tinsert( data, checkOptions[i] )
			end
		end
	end
	
	local channel = "RAID";
	local name = nil;
	
	if DiceMasterBannerPromptDialog.target ~= "RAID" then
		channel = "WHISPER";
		name = DiceMasterBannerPromptDialog.target
	end
	
	if GetNumGroupMembers() == 0 then
		channel = "WHISPER";
		name = UnitName("player")
	end

	local msg = Me:Serialize( "BANNER", {
		na = tostring( UnitName("player") );
		id = tonumber( type );
		ti = tostring( DiceMasterBannerPromptDialog.BannerTitle:GetText() );
		su = tostring( DiceMasterBannerPromptDialog.BannerSubtitle:GetText() );
		op = data;
	})
	Me:SendCommMessage( "DCM4", msg, channel, name or nil, "ALERT" )
end

---------------------------------------------------------------------------
-- Received a banner request.
--  na = name							string
--  id = index							number
--	ti = title							string
--  su = subtitle						string
--  op = options						table

function Me.RollBanner_OnBanner( data, dist, sender )	
	-- Only the party leader can send us these.
	if not UnitIsGroupLeader(sender, 1) and not Me.IsLeader( false ) then return end
 
	-- sanitize message
	if not data.na or not data.id or not data.ti then
	   
		return
	end
	
	if not DiceMasterRollBanner:IsShown() then
		
		-- if banners are off, just show the message.
		if not Me.db.global.enableRoundBanners then
			Me.PrintMessage("|TInterface/AddOns/DiceMaster/Texture/logo:12|t "..data.ti , "RAID")
			return
		end
		
		-- Look for punctuation at the end of the string
		if not data.ti:match("%p$") then
			data.ti = data.ti.."!"
		end
		
		DiceMasterRollBanner.Title:ClearAllPoints()
		DiceMasterRollBanner.Title:SetPoint( "TOP", DiceMasterRollBanner.BannerTop, 0, -47 )
		DiceMasterRollBanner.SubTitle:ClearAllPoints()
		DiceMasterRollBanner.SubTitle:SetPoint( "TOP", DiceMasterRollBanner.Title, "BOTTOM", 0, 0 )
		
		DiceMasterRollBanner.Title:SetText( data.ti )
		DiceMasterRollBanner.SubTitle:SetText( data.su )
		Me.RollBanner_UpdateOptions( data.id, data.op )
		
		Me.PrintMessage("|TInterface/AddOns/DiceMaster/Texture/logo:12|t "..data.ti , "RAID")
		
		DiceMasterRollBanner.AnimIn:Play()
		
		local timer = C_Timer.NewTimer(8, function()
			if DiceMasterRollBanner:IsShown() and not DiceMasterRollBanner.MouseIsOver then
				Me.RollBanner_OnMouseLeave( self, button )
			end
		end)
		
	end
end