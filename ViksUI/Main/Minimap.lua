local T, C, L, _ = unpack(select(2, ...))
if C.minimapp.enable ~= true then return end
--[[
--ViksMiniMap, Must be used with ViksUI!
-- Based on qMap and using Picomenu
--]]

local dummy = function() end
local _G = getfenv(0)
mult = T.mult

----------------------------------------------------------------------------------------
--	Shape, location and scale
----------------------------------------------------------------------------------------

Minimap:ClearAllPoints()
Minimap:SetPoint("TOPLEFT", AnchorMinimap, "TOPLEFT", -1, 2)
Minimap:SetPoint("BOTTOMRIGHT", AnchorMinimap, "BOTTOMRIGHT", -1, 1)
Minimap:SetSize(AnchorMinimap:GetWidth()-4, AnchorMinimap:GetWidth()-4)

----------------------------------------------------------------------------------------
--	Shape, location and scale
----------------------------------------------------------------------------------------

-- Hide Border
MinimapBorder:Hide()
MinimapBorderTop:Hide()

-- Hide Zoom Buttons
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- Hide Blob Ring
Minimap:SetArchBlobRingScalar(0)
Minimap:SetQuestBlobRingScalar(0)

-- Hide Voice Chat Frame
--BETA MiniMapVoiceChatFrame:Kill()
-- VoiceChatTalkers:Kill()
-- ChannelFrameAutoJoin:Kill()

-- Hide North texture at top
MinimapNorthTag:SetTexture(nil)

-- Hide Zone Frame
MinimapZoneTextButton:Hide()

-- Hide Game Time
GameTimeFrame:Hide()

-- Hide Mail Button
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, 0, 0)
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture("Interface\\AddOns\\ViksUI\\media\\Other\\mail")
MiniMapMailIcon:SetSize(16, 16)

-- Move QueueStatus icon
QueueStatusFrame:SetClampedToScreen(true)
QueueStatusFrame:SetFrameStrata("TOOLTIP")
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("TOP", Minimap, "TOP", 1, 6)
QueueStatusMinimapButton:SetHighlightTexture(nil)
QueueStatusMinimapButtonBorder:Hide()

-- Hide world map button
MiniMapWorldMapButton:Hide()

-- Garrison icon
GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 2)
GarrisonLandingPageMinimapButton:SetSize(32, 32)

-- Instance Difficulty icon
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 3, 2)
MiniMapInstanceDifficulty:SetScale(0.75)

-- Guild Instance Difficulty icon
GuildInstanceDifficulty:SetParent(Minimap)
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -2, 2)
GuildInstanceDifficulty:SetScale(0.75)

-- Challenge Mode icon
MiniMapChallengeMode:SetParent(Minimap)
MiniMapChallengeMode:ClearAllPoints()
MiniMapChallengeMode:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -2, -2)
MiniMapChallengeMode:SetScale(0.75)

-- Invites icon
GameTimeCalendarInvitesTexture:ClearAllPoints()
GameTimeCalendarInvitesTexture:SetParent(Minimap)
GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)

-- Default LFG icon
LFG_EYE_TEXTURES.raid = LFG_EYE_TEXTURES.default
LFG_EYE_TEXTURES.unknown = LFG_EYE_TEXTURES.default

--Tracking
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetParent(Minimap)
MiniMapTracking:SetPoint('TOPLEFT', 0, -25)
MiniMapTracking:SetAlpha(0)
MiniMapTrackingBackground:Hide()
MiniMapTrackingButtonBorder:SetTexture(nil)
MiniMapTrackingButton:SetHighlightTexture(nil)
MiniMapTrackingIconOverlay:SetTexture(nil)
MiniMapTrackingIcon:SetTexCoord(0.065, 0.935, 0.065, 0.935)
MiniMapTrackingIcon:SetWidth(20)
MiniMapTrackingIcon:SetHeight(20)

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Hide()
			else
				region:SetTexture(nil)
			end
		end
	end		
end

-- Feedback icon
if FeedbackUIButton then
	FeedbackUIButton:ClearAllPoints()
	FeedbackUIButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 0)
	FeedbackUIButton:SetScale(0.8)
end

-- Streaming icon
if StreamingIcon then
	StreamingIcon:ClearAllPoints()
	StreamingIcon:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -10)
	StreamingIcon:SetScale(0.8)
	StreamingIcon:SetFrameStrata("BACKGROUND")
end

-- Ticket icon
HelpOpenTicketButton:SetParent(Minimap)
HelpOpenTicketButton:CreateBackdrop("ClassColor")
HelpOpenTicketButton:SetFrameLevel(4)
HelpOpenTicketButton:ClearAllPoints()
HelpOpenTicketButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 2)
HelpOpenTicketButton:SetHighlightTexture(nil)
HelpOpenTicketButton:SetPushedTexture("Interface\\Icons\\inv_misc_note_03")
HelpOpenTicketButton:SetNormalTexture("Interface\\Icons\\inv_misc_note_03")
HelpOpenTicketButton:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
HelpOpenTicketButton:GetPushedTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
HelpOpenTicketButton:SetSize(16, 16)

-- GhostFrame
GhostFrame:StripTextures()
GhostFrame:SetTemplate("Overlay")
GhostFrame:StyleButton()
GhostFrame:ClearAllPoints()
GhostFrame:SetPoint(unpack(C.position.ghost))
GhostFrameContentsFrameIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
GhostFrameContentsFrameIcon:SetSize(34, 34)
GhostFrameContentsFrame:SetFrameLevel(GhostFrameContentsFrame:GetFrameLevel() + 2)
GhostFrameContentsFrame:CreateBackdrop("Overlay")
GhostFrameContentsFrame.backdrop:SetPoint("TOPLEFT", GhostFrameContentsFrameIcon, -2, 2)
GhostFrameContentsFrame.backdrop:SetPoint("BOTTOMRIGHT", GhostFrameContentsFrameIcon, 2, -2)

-- Enable mouse scrolling
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

-- Hide Game Time
AnchorMinimap:RegisterEvent("PLAYER_LOGIN")
AnchorMinimap:RegisterEvent("ADDON_LOADED")
AnchorMinimap:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_TimeManager" then
		TimeManagerClockButton:Kill()
	end
end)


----------------------------------------------------------------------------------------
--	Right click menu
----------------------------------------------------------------------------------------
local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local guildText = IsInGuild() and ACHIEVEMENTS_GUILD_TAB or LOOKINGFORGUILD
local micromenu = {
	{text = CHARACTER_BUTTON, notCheckable = 1, func = function()
		ToggleCharacter("PaperDollFrame")
	end},
	{text = SPELLBOOK_ABILITIES_BUTTON, notCheckable = 1, func = function()
		if InCombatLockdown() then
			print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return
		end
		ToggleFrame(SpellBookFrame)
	end},
	{text = TALENTS_BUTTON, notCheckable = 1, func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end
		if T.level >= SHOW_TALENT_LEVEL then
			ShowUIPanel(PlayerTalentFrame)
		else
			if C.error.white == false then
				UIErrorsFrame:AddMessage(format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_TALENT_LEVEL), 1, 0.1, 0.1)
			else
				print("|cffffff00"..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_TALENT_LEVEL).."|r")
			end
		end
	end},
	{text = ACHIEVEMENT_BUTTON, notCheckable = 1, func = function()
		ToggleAchievementFrame()
	end},
	{text = QUESTLOG_BUTTON, notCheckable = 1, func = function()
		ToggleQuestLog()
	end},
	{text = guildText, notCheckable = 1, func = function()
		ToggleGuildFrame()
		if IsInGuild() then
			GuildFrame_TabClicked(GuildFrameTab2)
		end
	end},
	{text = SOCIAL_BUTTON, notCheckable = 1, func = function()
		ToggleFriendsFrame()
	end},
	{text = PLAYER_V_PLAYER, notCheckable = 1, func = function()
		if T.level >= SHOW_PVP_LEVEL then
			TogglePVPUI()
		else
			if C.error.white == false then
				UIErrorsFrame:AddMessage(format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_PVP_LEVEL), 1, 0.1, 0.1)
			else
				print("|cffffff00"..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_PVP_LEVEL).."|r")
			end
		end
	end},
	{text = DUNGEONS_BUTTON, notCheckable = 1, func = function()
		if T.level >= SHOW_LFD_LEVEL then
			PVEFrame_ToggleFrame("GroupFinderFrame", nil)
		else
			if C.error.white == false then
				UIErrorsFrame:AddMessage(format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_LFD_LEVEL), 1, 0.1, 0.1)
			else
				print("|cffffff00"..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_LFD_LEVEL).."|r")
			end
		end
	end},
	{text = ADVENTURE_JOURNAL, notCheckable = 1, func = function()
		if C_AdventureJournal.CanBeShown() then
			ToggleEncounterJournal()
		else
			if C.error.white == false then
				UIErrorsFrame:AddMessage(FEATURE_NOT_YET_AVAILABLE, 1, 0.1, 0.1)
			else
				print("|cffffff00"..FEATURE_NOT_YET_AVAILABLE.."|r")
			end
		end
	end},
	{text = COLLECTIONS, notCheckable = 1, func = function()
		if InCombatLockdown() then
			print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return
		end
		ToggleCollectionsJournal()
	end},
	{text = HELP_BUTTON, notCheckable = 1, func = function()
		ToggleHelpFrame()
	end},
	{text = L_MINIMAP_CALENDAR, notCheckable = 1, func = function()
		ToggleCalendar()
	end},
	{text = BATTLEFIELD_MINIMAP, notCheckable = 1, func = function()
		ToggleBattlefieldMap()
	end},
	{text = LOOT_ROLLS, notCheckable = 1, func = function()
		ToggleFrame(LootHistoryFrame)
	end},
}

if not IsTrialAccount() and not C_StorePublic.IsDisabledByParentalControls() then
	tinsert(micromenu, {text = BLIZZARD_STORE, notCheckable = 1, func = function() StoreMicroButton:Click() end})
end

if T.level > 99 then
	tinsert(micromenu, {text = ORDER_HALL_LANDING_PAGE_TITLE, notCheckable = 1, func = function() GarrisonLandingPage_Toggle() end})
elseif T.level > 89 then
	tinsert(micromenu, {text = GARRISON_LANDING_PAGE_TITLE, notCheckable = 1, func = function() GarrisonLandingPage_Toggle() end})
end

Minimap:SetScript("OnMouseUp", function(self, button)
	local position = AnchorMinimap:GetPoint()
	if button == "RightButton" then
		if position:match("LEFT") then
			EasyMenu(micromenu, menuFrame, "cursor", 0, 0, "MENU")
		else
			EasyMenu(micromenu, menuFrame, "cursor", -160, 0, "MENU")
		end
	elseif button == "MiddleButton" then
		if position:match("LEFT") then
			ToggleDropDownMenu(nil, nil, MiniMapTrackingDropDown, "cursor", 0, 0, "MENU", 2)
		else
			ToggleDropDownMenu(nil, nil, MiniMapTrackingDropDown, "cursor", -160, 0, "MENU", 2)
		end
	elseif button == "LeftButton" then
		Minimap_OnClick(self)
	end
end)

-- Set Square Map Mask
Minimap:SetMaskTexture(C.media.blank)
Minimap:SetArchBlobRingAlpha(0)
Minimap:SetQuestBlobRingAlpha(0)

-- For others mods with a minimap button, set minimap buttons position in square mode
function GetMinimapShape() return "SQUARE" end

----------------------------------------------------------------------------------------------------------------------------------------
if C.minimapp.compass then
		function compass()

			frameC = CreateFrame("Frame", "Compass", Minimap)
			frameC:SetAllPoints()
			local north = frameC:CreateFontString(frameC:GetName())
			north:SetPoint("TOP", Minimap, "TOP", 0, -2)
			north:SetFont("Interface\\Addons\\ViksUI\\Media\\Font\\HandelGothicBT.ttf",12,"OUTLINE")
			north:SetTextColor(1,1,0,1) 
			north:SetText("N")

			local east = frameC:CreateFontString(frameC:GetName())
			east:SetPoint("RIGHT", Minimap, "RIGHT", -2, 0)
			east:SetFont("Interface\\Addons\\ViksUI\\Media\\Font\\HandelGothicBT.ttf",10,"OUTLINE")
			east:SetTextColor(1,1,.251,1) 
			east:SetText("E")

			local south = frameC:CreateFontString(frameC:GetName())
			south:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 2)
			south:SetFont("Interface\\Addons\\ViksUI\\Media\\Font\\HandelGothicBT.ttf",10,"OUTLINE")
			south:SetTextColor(1,1,.251,1) 
			south:SetText("S")

			local west = frameC:CreateFontString(frameC:GetName())
			west:SetPoint("LEFT", Minimap, "LEFT", 4, 0)
			west:SetFont("Interface\\Addons\\ViksUI\\Media\\Font\\HandelGothicBT.ttf",10,"OUTLINE")
			west:SetTextColor(1,1,.251,1) 
			west:SetText("W")
		end
		compass()
end