-------------------------------------------------------------------------------
-- Dice Master (C) 2019 <The League of Lordaeron> - Moon Guard
-------------------------------------------------------------------------------

local Me = DiceMaster4

-------------------------------------------------------------------------------
Me.playerTraitTooltipOpen = false
Me.playerTraitTooltipName = nil
Me.playerTraitTooltipIndex = nil

-------------------------------------------------------------------------------

function Me.CheckTooltipForTerms( text )
	local termsTable = {}
	for k, v in pairs( Me.RollList ) do
		for i = 1, #v do
			local matchFound = string.match( text, "<" .. v[i].subName .. ">" )
			if matchFound then
				local desc = gsub( v[i].desc, "Roll", "An attempt" )
				local termsString = Me.FormatIcon( v[i].iconID ) .. " |cFFFFFFFF" .. v[i].name .. "|r|n|cFFffd100" .. desc .. "|r|n|cFF707070(Modified by " .. v[i].stat .. " + " .. v[i].name .. ")|r"
				
				if not tContains( termsTable, termsString ) then
					tinsert( termsTable, termsString )
				end
			end
		end
	end
	for k, v in pairs( Me.TermsList ) do
		for i = 1, #v do
			local matchFound = string.match( text, "<" .. v[i].subName .. ">" )
			if matchFound then
				local termsString = Me.FormatIcon( v[i].iconID ) .. " |cFFFFFFFF" .. v[i].name .. "|r|n|cFFffd100" .. v[i].desc .. "|r"
				if not tContains( termsTable, termsString ) then
					tinsert( termsTable, termsString )
				end
			end
		end
	end
	if #termsTable > 0 then
		table.sort( termsTable )
		local tooltip = termsTable[1]
		for i = 2, #termsTable do
			tooltip = tooltip .. "|n|n" .. termsTable[i]
		end
		DiceMasterTooltip.TextLeft1:SetText( tooltip )
		DiceMasterTooltip:Show()
	end
end

-------------------------------------------------------------------------------
function Me.UpdateTraitTooltip( name, index )
	
	if Me.playerTraitTooltipOpen and Me.playerTraitTooltipName == name and Me.playerTraitTooltipIndex == index then
		Me.OpenTraitTooltip( nil, name, index )
	end
end

-------------------------------------------------------------------------------
function Me.OpenTraitTooltip( owner, trait, index )
	local playername = nil
	
	if type(trait) == "string" then
		-- player trait
		
		playername = trait
		
		Me.playerTraitTooltipOpen  = true
		Me.playerTraitTooltipName  = trait
		Me.playerTraitTooltipIndex = index
		trait = Me.inspectData[trait].traits[index]
	end
	
	if owner then
		
		GameTooltip:SetOwner( owner, "ANCHOR_RIGHT" )
	end
	
	GameTooltip:ClearLines()
	
	if trait.name then		
		if trait.icon then
			-- icon with name
			DiceMasterTooltipIcon.icon:SetTexture( trait.icon )
			DiceMasterTooltipIcon:Show()
			if index == 5 then
				DiceMasterTooltipIcon.elite:Show()
			else
				DiceMasterTooltipIcon.elite:Hide()
			end
		else
			DiceMasterTooltipIcon:Hide()
			DiceMasterTooltipIcon.elite:Hide()
		end
		GameTooltip:AddLine( trait.name, 1, 1, 1, true )
	end
	 
	if trait.usage then
		local usage = Me.FormatUsage( trait.usage, playername )
		
		if trait.usage ~= "PASSIVE" and trait.range and trait.range ~= "NONE" then
			local range = Me.FormatRange( trait.range )
			GameTooltip:AddDoubleLine( usage, range, 1, 1, 1, 1, 1, 1, true )
		else
			GameTooltip:AddDoubleLine( usage, nil, 1, 1, 1, 1, 1, 1, true )
		end
		
		if trait.usage ~= "PASSIVE" and trait.castTime then
			local castTime = Me.FormatCastTime( trait.castTime )
			GameTooltip:AddLine( castTime, 1, 1, 1, true )
		end
	end
	
	DiceMasterTooltipIcon.approved:Hide()
	if trait.approved and trait.approved > 0 and Me.PermittedUse() then
		if trait.approved == 1 then
			DiceMasterTooltipIcon.approved:SetTexCoord( 0, 0.5, 0.5, 1 )
		elseif trait.approved == 2 then
			DiceMasterTooltipIcon.approved:SetTexCoord( 0, 0.5, 0, 0.5 )
		end
		DiceMasterTooltipIcon.approved:Show()
	end
	 
    GameTooltip:AddLine( nil, 1, 1, 1, true )
	
	if trait.desc then
		if Me.db.global.hideTips then
			Me.CheckTooltipForTerms( trait.desc )
		end
		local desc = Me.FormatDescTooltip( trait.desc )
		GameTooltip:AddLine( desc, 1, 0.82, 0, true )
	end
	
	local usable = ""
	local guildName, guildRankName, guildRankIndex = GetGuildInfo( "player" )
	
	if owner and owner:GetParent():GetName() == "DiceMasterInspectFrame" and not UnitIsUnit("target", "player") and Me.IsOfficer() then
		local found = false;
		if trait.officers then
			for i=1,#trait.officers do
				if trait.officers[i] == UnitName("player") then	
					found = true;
					break;
				end
			end
		end
		if not found then
			usable = "<Right Click to Approve>|n"
		else
			usable = "<Right Click to Remove Approval>|n"
		end
	end
	
	if owner and owner.editable_trait then
		if Me.Profile.buffs[ index ] and owner:GetParent():GetName() == "DiceMasterPanel" then
			if Me.Profile.buffs[ index ].blank == false then
				usable = usable .. "<Right Click to Use>|n"
			end
		end
		if Me.Profile.removebuffs[ index ] and owner:GetParent():GetName() == "DiceMasterPanel" then
			if Me.Profile.removebuffs[ index ].blank == false then
				usable = usable .. "<Right Click to Use>|n"
			end
		end
		if Me.Profile.setdice[ index ] and owner:GetParent():GetName() == "DiceMasterPanel" then
			if Me.Profile.setdice[ index ].blank == false then
				usable = usable .. "<Right Click to Use>|n"
			end
		end
		usable = usable .. "<Left Click to Edit>|n"
	end
	GameTooltip:AddLine( usable .. "<Shift+Click to Link to Chat>", 0.44, 0.44, 0.44, true )
	
	if trait.officers and Me.PermittedUse() then
		local approval
		if trait.officers[2] then
			approval = "|TInterface/AddOns/DiceMaster/Texture/trait-approved:14:14:0:0:32:32:2:14:2:14|t Approved by " .. trait.officers[1] .. " and " .. trait.officers[2]
			GameTooltip:AddLine( approval, 0, 1, 0, true )
		elseif trait.officers[1] then
			approval = "|TInterface/AddOns/DiceMaster/Texture/trait-approved:14:14:0:0:32:32:2:14:18:30|t Approved by " .. trait.officers[1]
			GameTooltip:AddLine( approval, 1, 1, 0, true )
		end
	end
	
	if Me.useCorruptedSkins then
		GameTooltip_SetBackdropStyle( GameTooltip, GAME_TOOLTIP_BACKDROP_STYLE_CORRUPTED_ITEM );
	end
	
    GameTooltip:Show()
end

-------------------------------------------------------------------------------
function Me.CloseTraitTooltip()
	Me.playerTraitTooltipOpen = false
    GameTooltip:Hide()
	DiceMasterTooltipIcon:Hide()
	DiceMasterTooltipIcon.approved:Hide()
	DiceMasterTooltipIcon.elite:Hide()
	DiceMasterTooltip:Hide()
end

-------------------------------------------------------------------------------
-- Handler for trait tooltips.
--
local function OnEnter( self )
	
	self.highlight:Show()
	
	if self.customTooltip then
		GameTooltip:SetOwner( self, "ANCHOR_RIGHT" )
		GameTooltip:ClearLines()
		GameTooltip:AddLine( self.customTooltip, 1, 1, 1, true )
		GameTooltip:Show()
		return
	end
	
	if not self.trait and not self.traitPlayer then return end
	
	if self.trait then
		Me.OpenTraitTooltip( self, self.trait )
	elseif self.traitPlayer then 
		Me.OpenTraitTooltip( self, self.traitPlayer, self.traitIndex )
	else
		return
	end
	 
end

local function OnLeave( self )
	if not self.selected then
		self.highlight:Hide()
	end
	if self.traitPlayer then
		Me.playerTraitTooltipOpen = false
	end
    GameTooltip:Hide()
	DiceMasterTooltipIcon:Hide()
	DiceMasterTooltipIcon.approved:Hide()
	DiceMasterTooltipIcon.elite:Hide()
	DiceMasterTooltip:Hide()
end

-------------------------------------------------------------------------------
local methods = {
	---------------------------------------------------------------------------
	-- Set a static texture for this button.
	--
	-- Overrides SetTrait.
	--
	SetTexture = function( self, tex )
		self.trait       = nil
		self.traitPlayer = nil
		self.traitIndex  = nil
		self.icon:SetTexture( tex )
	end;
	
	---------------------------------------------------------------------------
	-- Hook this button up to a direct trait.
	--
	SetTrait = function( self, trait )
		self.trait = trait
		self:Refresh()
	end;
	
	---------------------------------------------------------------------------
	-- Hook this button up to a player trait.
	--
	SetPlayerTrait = function( self, player, index )
		self.trait = nil
		self.traitPlayer = player
		self.traitIndex  = index
		-- Add the gold dragon border if this is the command trait.
		if self.traitIndex == 5 then
			self.border:SetTexture("Interface/AddOns/DiceMaster/Texture/elite-trait-border")
			local bx, by = self:GetSize()
			self.border:SetSize( bx*3 ,by*3 )
		end
		self:Refresh()
	end;
	
	---------------------------------------------------------------------------
	-- Refresh after a trait changes.
	--
	Refresh = function( self )
		if self.trait then
			self.icon:SetTexture( self.trait.icon )
		elseif self.traitPlayer then
			self.icon:SetTexture( Me.inspectData[self.traitPlayer].traits[self.traitIndex].icon )
		end
	end;
	
	---------------------------------------------------------------------------
	-- "Select" this trait, i.e. make it glow.
	--
	Select = function( self, selected )
		self.selected = selected
		if selected then
			self.highlight:SetTexture( "Interface/Addons/DiceMaster/Texture/trait-highlight" )
			self.highlight:Show()
		else
			self.highlight:SetTexture( "Interface/Addons/DiceMaster/Texture/trait-select" )
			self.highlight:Hide()
		end
	end;
	
	SetCustomTooltip = function( self, text )
		self.customTooltip = text
	end;
}

-------------------------------------------------------------------------------
-- Initialize a new trait button.
--
function Me.TraitButton_Init( self )

	for k, v in pairs( methods ) do
		self[k] = v
	end
	 
	self:SetScript( "OnEnter", OnEnter )
	self:SetScript( "OnLeave", OnLeave ) 
	self.editable_trait = false 
end

