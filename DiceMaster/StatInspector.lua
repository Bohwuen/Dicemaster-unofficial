-------------------------------------------------------------------------------
-- Dice Master (C) 2019 <The League of Lordaeron> - Moon Guard
-------------------------------------------------------------------------------

--
-- Trait Editing Panel
--

local Me      = DiceMaster4
local Profile = Me.Profile

local StatsListEntries = { };

-------------------------------------------------------------------------------
-- Refresh the statistics list.
--
--
function Me.StatInspector_Update()

	if Me.inspectName then
		Me.statInspectName = Me.inspectName
	end
	
	if not Me.statInspectName then
		return
	end
	
	SetPortraitTexture( Me.statinspector.portrait, "target" )
	Me.statinspector.TitleText:SetText( UnitName("target") )
	
	local store = Me.inspectData[Me.statInspectName]
	local stats = store.stats

	if ( not Me.statinspector:IsShown() ) then
		return;
	end
	
	Me.statinspector.experienceBar.level:SetText(store.level or 1)
	Me.statinspector.experienceBar:SetValue(store.experience or 0)

	local addButtonIndex = 0;
	local totalButtonHeight = 0;
	local function AddButtonInfo(id)
		addButtonIndex = addButtonIndex + 1;
		if ( not StatsListEntries[addButtonIndex] ) then
			StatsListEntries[addButtonIndex] = { };
		end
		StatsListEntries[addButtonIndex].id = id;
		totalButtonHeight = totalButtonHeight + 24
	end
	
	if #stats == 0 then
		Me.statinspector.scrollFrame.totals:Show()
	else
		Me.statinspector.scrollFrame.totals:Hide()
	end

	-- saved statistics
	for i = 1, #stats do
		AddButtonInfo(i);
	end

	Me.statinspector.scrollFrame.totalStatsListEntriesHeight = totalButtonHeight;
	Me.statinspector.scrollFrame.numStatsListEntries = addButtonIndex;

	Me.StatInspector_UpdateStats();
	
end

-------------------------------------------------------------------------------
-- Refresh the pet tab.
--
--
function Me.StatInspector_UpdatePet()
	
	if Me.inspectName and Me.inspectData[Me.inspectName] and Me.inspectData[Me.inspectName].pet and Me.inspectData[Me.inspectName].pet.enable then
		local pet = Me.inspectData[Me.inspectName].pet
		Me.statinspector.petFrame.petIcon:SetTexture( pet.icon )
		Me.statinspector.petFrame.petName:SetText( pet.name )
		Me.statinspector.petFrame.levelText:SetText( pet.type )
		Me.statinspector.petFrame.petModel:SetDisplayInfo( pet.model )
		PanelTemplates_EnableTab(DiceMasterStatInspector, 2)
	else
		if PanelTemplates_GetSelectedTab(DiceMasterStatInspector) == 2 then
			PanelTemplates_SetTab(DiceMasterStatInspector, 1);
			DiceMasterStatInspectorStatsFrame:Show();
			DiceMasterStatInspectorPetFrame:Hide();
			PlaySound(841)
		end
		PanelTemplates_DisableTab(DiceMasterStatInspector, 2)
	end
	
end

-------------------------------------------------------------------------------
-- Update the stat buttons.
--
--
function Me.StatInspector_UpdateStats()
	local scrollFrame = Me.statinspector.scrollFrame;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local numStatButtons = scrollFrame.numStatsListEntries;

	local usedHeight = 0;

	for i = 1, numButtons do
		local button = buttons[i];
		local index = offset + i;
		if ( index <= numStatButtons ) then
			button.index = index;
			local height = Me.StatInspector_UpdateStatButton(button)
			button:SetHeight(height);
			usedHeight = usedHeight + height;
			
			button:Show()
		else
			button.index = nil;
			button:Hide();
		end
	end
	HybridScrollFrame_Update(scrollFrame, scrollFrame.totalStatsListEntriesHeight, usedHeight);
end

function Me.StatInspector_UpdateStatButton(button)
	local index = button.index;
	button.id = StatsListEntries[index].id;
	local stats = Me.inspectData[Me.statInspectName].stats
	local stat = stats[StatsListEntries[index].id]
	
	-- finish setting up button if it's not a header
	if ( stat ) then
	
		if stat.value then
		
			button.name:SetText(stat.name .. ":");
			button.title:SetText("");
			button.value:Show()
			button.value:SetText(stat.value);
			
			if Me.statInspectName == UnitName("player") then
				local buffValue = Me.TraitEditor_AddStatisticsToValue( stat.name )
				button.value:SetText(stat.value + buffValue);
			end
			
			Me.SetupTooltip( button, nil, stat.name )
			
			local skills = {}
			
			for i = 1, #stats do
				if stat.attribute then
					local desc = ""
					if stat.desc then
						desc = gsub( stat.desc, "Roll", "An attempt" )
						Me.SetupTooltip( button, nil, stat.name, nil, nil, "|cFFFFD100" .. desc .. "|n|cFF707070(Modificado por " .. stat.attribute .. ")|r" )
					else
						Me.SetupTooltip( button, nil, stat.name, nil, nil, "|cFF707070(Modificado por " .. stat.attribute .. ")|r" )
					end
				end
				if stats[i].attribute and stats[i].attribute == stat.name then
					tinsert( skills, stats[i].name )
				end
			end
			
			if Me.AttributeList[ stat.name ] then
				local skillsList = "|n|cFF707070(Modifica "
				for i = 1, #skills do
					if i > 1 and i == #skills then
						skillsList = skillsList .. ", y "
					elseif i > 1 then
						skillsList = skillsList .. ", "
					end
					skillsList = skillsList .. skills[i]
				end
				Me.SetupTooltip( button, nil, stat.name, nil, nil, "|cFFFFD100" .. Me.AttributeList[stat.name].desc .. skillsList .. ")|r" )
			end
			
		else
			Me.SetupTooltip( button, nil )
			button.name:SetText("");
			button.title:SetText(stat.name);
			button.value:Hide()
		end
		
		button:Show();
	else
		button:Hide();
	end
	return 24;
end

function Me.StatInspector_GetScrollFrameTopButton(offset)
	local usedHeight = 0;
	for i = 1, #StatsListEntries do
		local buttonHeight = 24
		if ( usedHeight + buttonHeight >= offset ) then
			return i - 1, offset - usedHeight;
		else
			usedHeight = usedHeight + buttonHeight;
		end
	end
end

-------------------------------------------------------------------------------
-- OnLoad handler
--
-- Be careful in here because it's run before the addon is loaded.
--
function Me.StatInspector_OnLoad( self )
	Me.statinspector = self
		
	self:SetClampedToScreen( true )
	self:RegisterForDrag( "LeftButton" )
	self:SetScript( "OnDragStart", self.StartMoving )
	self:SetScript( "OnDragStop", self.StopMovingOrSizing )	 
end

-------------------------------------------------------------------------------
-- When the stat inspector's close button is pressed.
--
function Me.StatInspector_OnCloseClicked() 
	PlaySound(840); 
	DiceMasterStatInspector:Hide()
end

-------------------------------------------------------------------------------
-- Show the stat inspector.
--
function Me.StatInspector_Open()	
	--SetPortraitTexture( Me.statinspector.portrait, "target" )
	
	--Me.statinspector.TitleText:SetText( UnitName( "target" ) )
	
	Me.statinspector.CloseButton:SetScript("OnClick",Me.StatInspector_OnCloseClicked)

	Me.StatInspector_Update()
	Me.StatInspector_UpdatePet()
	Me.statinspector:Show()
end