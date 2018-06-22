local T, C, L, _ = unpack(select(2, ...))

if C.misc.WatchFrame then
----------------------------------------------------------------------------------------
--	Move ObjectiveTrackerFrame
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame", "WatchFrameAnchor", oUF_PetBattleFrameHider)
frame:SetPoint("TOPRIGHT", CPMinimb1, "BOTTOMLEFT", 0, 10)
frame:SetHeight(150)
frame:SetWidth(224)

ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
ObjectiveTrackerFrame:SetHeight(T.getscreenheight / 1.6)
ObjectiveTrackerFrame:SetWidth(180)

hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(_, _, parent)
	if parent ~= frame then
		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, 0)
	end
end)

ObjectiveTrackerBlocksFrame.QuestHeader:SetAlpha(0)

for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
	ObjectiveTrackerFrame.BlocksFrame[headerName].Background:Hide()
end

ObjectiveTrackerFrame.HeaderMenu.Title:SetAlpha(0)
BONUS_OBJECTIVE_TRACKER_MODULE.Header.Background:Hide()
WORLD_QUEST_TRACKER_MODULE.Header.Background:Hide()

hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetStringText", function(_, fontString, _, useFullHeight)
	local _, fontHeight = SystemFont_Shadow_Med1:GetFont()
	local stringHeight = fontString:GetHeight()
	if stringHeight > OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT * 2 - (fontHeight * 2) and not useFullHeight then
		fontString:SetHeight(fontHeight * 2)
	end
end)

--ScenarioObjectiveTracker_AnimateReward = T.dummy
--BonusObjectiveTracker_AnimateReward = T.dummy

function watchFButton()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[format("ChatFrame%d",  i)]
		local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
		button:SetHeight(CPMinimb1:GetHeight())
		button:SetWidth(CPMinimb1:GetWidth())
		button:SetPoint("CENTER", CPMinimb1, "CENTER")
			
		local buttontext = button:CreateFontString(nil,"OVERLAY",nil)
		buttontext:SetFont(C.media.pixel_font,C.media.pixel_font_size,"OUTLINE")
		buttontext:SetText("Watch")
		buttontext:SetPoint("CENTER", 1, 1)
		buttontext:SetJustifyH("CENTER")
		buttontext:SetJustifyV("CENTER")
		buttontext:SetTextColor(unpack(C.media.pxcolor1)) 
		button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(CPMinimb2, "ANCHOR_BOTTOMLEFT", -4, 16)
			GameTooltip:AddLine("Left-click to toggle the Watch Frame.")
			GameTooltip:AddLine("Shift-click to toggle the achievements window.")
			GameTooltip:AddLine("Right-click to open the Quest Frame")
			GameTooltip:Show()
		end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)				
		button:SetScript("OnMouseUp", function(self, btn)
			if IsShiftKeyDown() then
			ToggleAchievementFrame()
			elseif btn == "RightButton" then
				ToggleQuestLog()
			else
				    if ( ObjectiveTrackerFrame.collapsed ) then
					ObjectiveTracker_Expand();
					else
					ObjectiveTracker_Collapse();
					end
			end
		end)
	end

end
watchFButton()

----------------------------------------------------------------------------------------
--	Skin ObjectiveTrackerFrame item buttons
----------------------------------------------------------------------------------------
hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	local item = block.itemButton

	if item and not item.skinned then
		item:SetHeight(22, 22)
		item:SetTemplate("Default")
		item:StyleButton()

		item:SetNormalTexture(nil)

		item.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		item.icon:SetPoint("TOPLEFT", item, 2, -2)
		item.icon:SetPoint("BOTTOMRIGHT", item, -2, 2)

		item.Cooldown:SetAllPoints(item.icon)
		
		item.HotKey:ClearAllPoints()
		item.HotKey:SetPoint("BOTTOMRIGHT", 0, 2)
		item.HotKey:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
		item.HotKey:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)

		item.Count:ClearAllPoints()
		item.Count:SetPoint("TOPLEFT", 1, -1)
		item.Count:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
		item.Count:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)

		item.skinned = true
	end
end)

hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", function(_, block)
	local item = block.itemButton

	if item and not item.skinned then
		item:SetSize(C.actionbar.button_size, C.actionbar.button_size)
		item:SetTemplate("Default")
		item:StyleButton()

		item:SetNormalTexture(nil)

		item.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		item.icon:SetPoint("TOPLEFT", item, 2, -2)
		item.icon:SetPoint("BOTTOMRIGHT", item, -2, 2)

		item.Cooldown:SetAllPoints(item.icon)

		item.Count:ClearAllPoints()
		item.Count:SetPoint("TOPLEFT", 1, -1)
		item.Count:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
		item.Count:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)

		item.skinned = true
	end
end)
----------------------------------------------------------------------------------------
--	Difficulty color for ObjectiveTrackerFrame lines
----------------------------------------------------------------------------------------
hooksecurefunc(QUEST_TRACKER_MODULE, "Update", function()
	for i = 1, GetNumQuestWatches() do
		local questID, _, questIndex = GetQuestWatchInfo(i)
		if not questID then
			break
		end
		local _, level = GetQuestLogTitle(questIndex)
		local col = GetQuestDifficultyColor(level)
		local block = QUEST_TRACKER_MODULE:GetExistingBlock(questID)
		if block then
			block.HeaderText:SetTextColor(col.r, col.g, col.b)
			block.HeaderText.col = col
		end
	end
end)

hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", function(self, block)
	if block.module == ACHIEVEMENT_TRACKER_MODULE then
		block.HeaderText:SetTextColor(0.75, 0.61, 0)
		block.HeaderText.col = nil
	end
end)

hooksecurefunc("ObjectiveTrackerBlockHeader_OnLeave", function(self)
	local block = self:GetParent()
	if block.HeaderText.col then
		block.HeaderText:SetTextColor(block.HeaderText.col.r, block.HeaderText.col.g, block.HeaderText.col.b)
	end
end)

----------------------------------------------------------------------------------------
--	Skin ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
----------------------------------------------------------------------------------------
if C.skins.blizzard_frames == true then
	local button = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	button:SetSize(17, 17)
	button:StripTextures()
	button:SetTemplate("Overlay")

	button.minus = button:CreateTexture(nil, "OVERLAY")
	button.minus:SetSize(5, 1)
	button.minus:SetPoint("CENTER")
	button.minus:SetTexture(C.media.blank)

	button.plus = button:CreateTexture(nil, "OVERLAY")
	button.plus:SetSize(1, 5)
	button.plus:SetPoint("CENTER")
	button.plus:SetTexture(C.media.blank)

	button:HookScript("OnEnter", T.SetModifiedBackdrop)
	button:HookScript("OnLeave", T.SetOriginalBackdrop)

	button.plus:Hide()
	hooksecurefunc("ObjectiveTracker_Collapse", function()
		button.plus:Show()
	end)

	hooksecurefunc("ObjectiveTracker_Expand", function()
		button.plus:Hide()
	end)
	ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:Hide()
end
end
----------------------------------------------------------------------------------------
--	Mouseover for ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
----------------------------------------------------------------------------------------
if C.misc.minimize_mouseover then
	local MinimizeButton = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	MinimizeButton:SetAlpha(0)
	MinimizeButton:HookScript("OnEnter", function() MinimizeButton:SetAlpha(1) end)
	MinimizeButton:HookScript("OnLeave", function() MinimizeButton:SetAlpha(0) end)
end

----------------------------------------------------------------------------------------
--	Skin bonus/world quest objective progress bar
----------------------------------------------------------------------------------------
local function SkinBar(line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local icon = bar.Icon
	local label = bar.Label

	if not progressBar.styled then
		bar.BarFrame:Hide()
		bar.BarGlow:Kill()
		bar.Sheen:Hide()
		bar.IconBG:Kill()
		bar:SetSize(200, 20)
		bar:SetStatusBarTexture(C.media.texture)
		bar:SetTemplate("Transparent")
		bar:SetBackdropColor(0, 0, 0, 0)

		label:ClearAllPoints()
		label:SetPoint("CENTER", 0, -1)
		label:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)

		icon:SetPoint("RIGHT", 24, 0)
		icon:SetSize(20, 20)

		local border = CreateFrame("Frame", "$parentBorder", bar)
		border:SetAllPoints(icon)
		border:SetTemplate("Transparent")
		border:SetBackdropColor(0, 0, 0, 0)
		bar.newIconBg = border

		bar.AnimIn.Play = T.dummy
		BonusObjectiveTrackerProgressBar_PlayFlareAnim = T.dummy
		progressBar.styled = true
	end

	bar.newIconBg:SetShown(icon:IsShown())
end

hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(_, _, line)
	SkinBar(line)
end)
hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", function(_, _, line)
	SkinBar(line)
end)
local frame1 = CreateFrame("Frame")
frame1:RegisterEvent("PLAYER_ENTERING_WORLD")
frame1:SetScript("OnEvent", function(self, event)
		ObjectiveTracker_Collapse()
end)

----------------------------------------------------------------------------------------
--	Skin default quest objective progress bar
----------------------------------------------------------------------------------------
hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(self, block, line)
	local progressBar = self.usedProgressBars[block] and self.usedProgressBars[block][line]
	local bar = progressBar.Bar
	local label = bar.Label

	if not progressBar.styled then
		bar:SetSize(200, 20)
		bar:SetStatusBarTexture(C.media.texture)
		bar:SetTemplate("Transparent")
		bar:SetBackdropColor(0, 0, 0, 0)
		bar:DisableDrawLayer("ARTWORK")

		label:ClearAllPoints()
		label:SetPoint("CENTER", 0, -1)
		label:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
		label:SetDrawLayer("OVERLAY")

		progressBar.styled = true
	end
end)

----------------------------------------------------------------------------------------
--	Set tooltip depending on position
----------------------------------------------------------------------------------------
local function IsFramePositionedLeft(frame)
	local x = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local positionedLeft = false

	if x and x < (screenWidth / 2) then
		positionedLeft = true
	end

	return positionedLeft
end

hooksecurefunc("BonusObjectiveTracker_ShowRewardsTooltip", function(block)
	if IsFramePositionedLeft(ObjectiveTrackerFrame) then
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPLEFT", block, "TOPRIGHT", 0, 0)
	end
end)

----------------------------------------------------------------------------------------
--	Kill reward animation when finished dungeon or bonus objectives
----------------------------------------------------------------------------------------
ObjectiveTrackerScenarioRewardsFrame.Show = T.dummy

hooksecurefunc("BonusObjectiveTracker_AnimateReward", function()
	ObjectiveTrackerBonusRewardsFrame:ClearAllPoints()
	ObjectiveTrackerBonusRewardsFrame:SetPoint("BOTTOM", UIParent, "TOP", 0, 90)
end)
