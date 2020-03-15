-------------------------------------------------------------------------------
-- Dice Master (C) 2019 <The League of Lordaeron> - Moon Guard
-------------------------------------------------------------------------------

-- comm message handling

local Me = DiceMaster4 

-------------------------------------------------------------------------------
-- Routing table for DCM4 addon messages.
--
local MessageHandlers = {
 
	INSP    = "Inspect_OnInspectMessage";
	TRAIT   = "Inspect_OnTraitMessage";
	STATUS  = "Inspect_OnStatusMessage";
	STATS   = "Inspect_OnStatsMessage";
	APPROVE = "Inspect_OnTraitApprove";
	EXP     = "Inspect_OnExperience";
	SETHP   = "Inspect_OnSetHPMessage";
	
	R       = "Dice_OnRollMessage";
	ROLL    = "Dice_OnRollMessage";
	
	TYPE    = "PostTracker_OnTyping";
	
	TARGET  = "RollTracker_OnTargetMessage";
	NOTES   = "RollTracker_OnNoteMessage";
	NOTREQ  = "RollTracker_OnStatusRequest";
	
	BANNER  = "RollBanner_OnBanner";
	
	BUFF    = "BuffFrame_OnBuffMessage";
	REMOVE  = "BuffFrame_OnRemoveBuffMessage";
	
	MORALE  = "MoraleBar_OnStatusMessage";
	MORREQ  = "MoraleBar_OnStatusRequest";
	
	UFANIM  = "UnitFrame_OnAnimationMessage";
	DMSAY   = "UnitFrame_OnDMSAY";
	UFSTAT  = "UnitFrame_OnStatusMessage";
	UFREQ   = "UnitFrame_OnStatusRequest";
	UFBUFF	= "UnitFrame_OnBuffMessage";
	UFREMOVE = "UnitFrame_OnRemoveBuffMessage";
}

-------------------------------------------------------------------------------
-- Comm Handler for when an DCM4 message is received.
--
function Me:OnCommMessage( prefix, packed_message, dist, sender )
	local success, msgtype, data = Me:Deserialize( packed_message )
	
	if not success then return end
	
	if sender:find("-") then
		-- this is the best xrealm support ur gonna get :)
		-- sender = sender:match( "(.+)%-")
	end
	
	if dist == "RAID" and IsInGroup( LE_PARTY_CATEGORY_INSTANCE ) and IsInGroup( LE_PARTY_CATEGORY_HOME ) then
		-- Prevents "You are not in a raid group" spam.
		dist = "PARTY";
	end
	
	local handler = MessageHandlers[msgtype]
	if Me[handler] then
		Me[handler]( data, dist, sender )
	end
end

---------------------------------------------------------------------------
-- Received a talking head request.
--  na = name							string
--	md = model							number
-- 	ms = message						string
--  so = sound							number

function Me.UnitFrame_OnDMSAY( data, dist, sender )	
	-- Ignore our own data.
	if sender == UnitName( "player" )  then return end
 
	-- sanitize message
	if not data.na and not data.md and not data.ms then
	   
		return
	end
	
	if ( UnitIsGroupLeader( sender ) or UnitIsGroupAssistant( sender ) ) and not DiceMasterTalkingHeadFrame then
		Me.PrintMessage("|cFFE6E68E"..(data.na or "Unknown").." says: "..data.ms, "RAID")
	end
end

-------------------------------------------------------------------------------
function Me.Comm_Init() 
	Me:RegisterComm( "DCM4", "OnCommMessage" ) 
end
