local SSA, Auras, L, LSM = unpack(select(2,...))
Auras.version = GetAddOnMetadata(..., 'Version')

local font = LSM.MediaTable.font['PT Sans Narrow'] or LSM.DefaultMedia.font

local FrameBackdrop = {
	bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
	edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 }
}

local PaneBackdrop  = {
	bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
}

local frame = CreateFrame("Frame", nil, UIParent)
frame:Hide()

frame:EnableMouse(true)
frame:SetMovable(true)
frame:SetResizable(true)
frame:SetFrameStrata("DIALOG")
frame:SetBackdrop(FrameBackdrop)
frame:SetBackdropColor(0, 0, 0, 1)
--frame:SetMinResize(400, 200)
frame:SetToplevel(true)
frame:SetScript("OnShow", Frame_OnShow)
frame:SetScript("OnHide", Frame_OnClose)
frame:SetScript("OnMouseDown", Frame_OnMouseDown)
frame:SetSize(500,603)
frame:SetPoint("CENTER",0,0)

local function BuildButtons()
	local closebutton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	closebutton:SetScript("OnClick", function(self) self:GetParent():Hide() end)
	closebutton:SetPoint("BOTTOMRIGHT", -27, 17)
	closebutton:SetHeight(20)
	closebutton:SetWidth(100)
	closebutton:SetText(CLOSE)

	local button_new = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	button_new:SetPoint("BOTTOMLEFT", 27, 17)
	button_new:SetHeight(20)
	button_new:SetWidth(100)
	button_new:SetText(NEW)
	--button_new:Disable()
	button_new:SetScript("OnClick", function(self) 
		self:GetParent().body_new:Show()
		self:GetParent().body_fix:Hide()
	end)

	local button_fix = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	button_fix:SetPoint("BOTTOMLEFT", 130, 17)
	button_fix:SetHeight(20)
	button_fix:SetWidth(100)
	button_fix:SetText(L["LABEL_FIXES"])
	--button_fix:Disable()
	button_fix:SetScript("OnClick", function(self)
		self:GetParent().body_fix:Show()
		self:GetParent().body_new:Hide()
	end)
end

local function BuildTitleBar()
	local titlebg = frame:CreateTexture(nil, "OVERLAY")
	titlebg:SetTexture([[Interface\DialogFrame\UI-DialogBox-Header]])
	titlebg:SetTexCoord(0.31, 0.67, 0, 0.63)
	titlebg:SetPoint("TOP", 0, 12)
	titlebg:SetWidth(100)
	titlebg:SetHeight(40)

	local title = CreateFrame("Frame", nil, frame)
	title:EnableMouse(true)
	title:SetScript("OnMouseDown", Title_OnMouseDown)
	title:SetScript("OnMouseUp", MoverSizer_OnMouseUp)
	title:SetAllPoints(titlebg)

	local titletext = title:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titletext:SetPoint("TOP", titlebg, "TOP", 0, -14)
	titletext:SetText("Bulletin Board")

	local titlebg_l = frame:CreateTexture(nil, "OVERLAY")
	titlebg_l:SetTexture([[Interface\DialogFrame\UI-DialogBox-Header]])
	titlebg_l:SetTexCoord(0.21, 0.31, 0, 0.63)
	titlebg_l:SetPoint("RIGHT", titlebg, "LEFT")
	titlebg_l:SetWidth(30)
	titlebg_l:SetHeight(40)

	local titlebg_r = frame:CreateTexture(nil, "OVERLAY")
	titlebg_r:SetTexture([[Interface\DialogFrame\UI-DialogBox-Header]])
	titlebg_r:SetTexCoord(0.67, 0.77, 0, 0.63)
	titlebg_r:SetPoint("LEFT", titlebg, "RIGHT")
	titlebg_r:SetWidth(30)
	titlebg_r:SetHeight(40)
end

local function BuildHeader()
	local header = CreateFrame("Frame", nil, frame)
	header:SetFrameStrata("DIALOG")
	header:SetWidth(460)
	header:SetHeight(265)
	header:SetPoint("TOP",0,-25)
	header:SetBackdrop(PaneBackdrop)
	header:SetBackdropColor(0, 0, 0, 0.6)
	header:SetBackdropBorderColor(0.4, 0.4, 0.4)
	frame.header = header

	local titletext = header:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	titletext:SetPoint("TOP", 0, -20)
	--titletext:SetPoint("TOPRIGHT", -14, 0)
	titletext:SetJustifyH("LEFT")
	titletext:SetHeight(18)
	titletext:SetFont(font,30)
	titletext:SetText("Sweetsour's Shaman Auras: "..Auras.version)
	titletext:SetTextColor(1,1,1,1)
	frame.header.titletext = titletext

	local bodytext = header:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	bodytext:SetPoint("TOPLEFT", 15, -50)
	--bodytext:SetPoint("TOPRIGHT", -14, 0)
	bodytext:SetJustifyH("LEFT")
	bodytext:SetWidth(440)
	bodytext:SetWordWrap(true)
	bodytext:SetFont(font,14)
	bodytext:SetText("Just a quick update to fix some minor bugs and add a new aura to Elemental, despite it being long overdue!. \n\nBelow are ways that you can help support future development of this addon!\n\nDiscord: sweetsour.live/|cFF82BBFFdiscord|r\nPatreon: sweetsour.live/|cFF82BBFFpatreon|r\nDonate: sweetsour.live/|cFF82BBFFdonate|r\nTranslate: sweetsour.live/|cFF82BBFFtranslate|r")
	bodytext:SetTextColor(1,1,1,1)
	frame.header.bodytext = bodytext
end


local body_new = CreateFrame("Frame", nil, frame)
body_new:SetFrameStrata("DIALOG")
body_new:SetWidth(460)
body_new:SetHeight(535)
body_new:SetPoint("TOP",0,-25)
body_new:SetBackdrop(PaneBackdrop)
body_new:SetBackdropColor(0, 0, 0, 0.5)
body_new:SetBackdropBorderColor(0.4, 0.4, 0.4)
body_new:Show()
frame.body_new = body_new

local title_new = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
title_new:SetPoint("TOPLEFT", 15, -275)
--title_new:SetPoint("TOPRIGHT", -14, 0)
title_new:SetJustifyH("LEFT")
title_new:SetHeight(18)
title_new:SetFont(font,16)
title_new:SetText(strupper(NEW))
title_new:SetTextColor(1,1,1,1)
frame.body_new.title_new = title_new


local body_fix = CreateFrame("Frame", nil, frame)
body_fix:SetFrameStrata("DIALOG")
body_fix:SetWidth(460)
body_fix:SetHeight(535)
body_fix:SetPoint("TOP",0,-25)
body_fix:SetBackdrop(PaneBackdrop)
body_fix:SetBackdropColor(0, 0, 0, 0.5)
body_fix:SetBackdropBorderColor(0.4, 0.4, 0.4)
body_fix:Hide()
frame.body_fix = body_fix

local title_fix = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
title_fix:SetPoint("TOPLEFT", 15, -275)
--title_fix:SetPoint("TOPRIGHT", -14, 0)
title_fix:SetJustifyH("LEFT")
title_fix:SetHeight(18)
title_fix:SetFont(font,16)
title_fix:SetText("FIXES")
title_fix:SetTextColor(1,1,1,1)
frame.body_fix.title_fix = title_fix

local function BuildNewAllList()
	local new_ele = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	new_ele:SetPoint("TOPLEFT", 27, -295)
	--new_ele:SetPoint("TOPRIGHT", -14, 0)
	new_ele:SetJustifyH("LEFT")
	new_ele:SetHeight(18)
	new_ele:SetFont(font,15)
	new_ele:SetText("All Specs")
	new_ele:SetTextColor(1,1,1,1)
	frame.body_new.new_ele = new_ele

		local list_new_1 = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_new_1:SetPoint("TOPLEFT", 39, -315)
		--list_new_1:SetPoint("TOPRIGHT", -14, 0)
		list_new_1:SetJustifyH("LEFT")
		--list_new_1:SetHeight(18)
		list_new_1:SetWidth(420)
		list_new_1:SetWordWrap(true)
		list_new_1:SetFont(font,12)
		list_new_1:SetText("• Major code and spell updates for 8.0")
		list_new_1:SetTextColor(1,1,1,1)
		frame.body_new.new_ele.list_new_1 = list_new_1

		local list_new_2 = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_new_2:SetPoint("TOPLEFT", 39, -335)
		--list_new_2:SetPoint("TOPRIGHT", -14, 0)
		list_new_2:SetJustifyH("LEFT")
		--list_new_2:SetHeight(18)
		list_new_2:SetWidth(420)
		list_new_2:SetWordWrap(true)
		list_new_2:SetFont(font,12)
		list_new_2:SetText("• All specs now have a \"Buff\" aura group and a \"PvP\" aura group!")
		list_new_2:SetTextColor(1,1,1,1)
		frame.body_new.new_ele.list_new_2 = list_new_2
end

local function BuildNewEleList()
	local new_ele = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	new_ele:SetPoint("TOPLEFT", 27, -295)
	--new_ele:SetPoint("TOPRIGHT", -14, 0)
	new_ele:SetJustifyH("LEFT")
	new_ele:SetHeight(18)
	new_ele:SetFont(font,15)
	new_ele:SetText("Elemental")
	new_ele:SetTextColor(1,1,1,1)
	frame.body_new.new_ele = new_ele

		local list_new_1 = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_new_1:SetPoint("TOPLEFT", 39, -315)
		--list_new_1:SetPoint("TOPRIGHT", -14, 0)
		list_new_1:SetJustifyH("LEFT")
		--list_new_1:SetHeight(18)
		list_new_1:SetWidth(420)
		list_new_1:SetWordWrap(true)
		list_new_1:SetFont(font,12)
		list_new_1:SetText("• A new aura for |cFFFFe961Earthen Strength|r (T21 2-set bonus) has been added.")
		list_new_1:SetTextColor(1,1,1,1)
		frame.body_new.new_ele.list_new_1 = list_new_1

		--[[local list_new_2 = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_new_2:SetPoint("TOPLEFT", 39, -335)
		--list_new_2:SetPoint("TOPRIGHT", -14, 0)
		list_new_2:SetJustifyH("LEFT")
		--list_new_2:SetHeight(18)
		list_new_2:SetWidth(420)
		list_new_2:SetWordWrap(true)
		list_new_2:SetFont(font,12)
		list_new_2:SetText("• Added functionality to prevent |cFFFFe961Blizzard's default|r cooldown numbers from appearing; eliminating dual cooldown number overlapping.")
		list_new_2:SetTextColor(1,1,1,1)
		frame.body_new.new_ele.list_new_2 = list_new_2]]
end

local function BuildNewEnhList()
	local new_enh = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	new_enh:SetPoint("TOPLEFT", 27, -345)
	--new_enh:SetPoint("TOPRIGHT", -14, 0)
	new_enh:SetJustifyH("LEFT")
	new_enh:SetHeight(18)
	new_enh:SetFont(font,15)
	new_enh:SetText("Enhancement")
	new_enh:SetTextColor(1,1,1,1)
	frame.body_new.new_enh = new_enh

		local list_new_1 = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_new_1:SetPoint("TOPLEFT", 39, -365)
		--list_new_1:SetPoint("TOPRIGHT", -14, 0)
		list_new_1:SetJustifyH("LEFT")
		--list_new_1:SetHeight(18)
		list_new_1:SetWidth(420)
		list_new_1:SetWordWrap(true)
		list_new_1:SetFont(font,12)
		list_new_1:SetText("• Lava Lash's aura will now display stacks of Lashing Flames and glow at 99 stacks (configurable in options). |cFF82BBFFThanks, Kirix!|r")
		list_new_1:SetTextColor(1,1,1,1)
		frame.body_new.new_enh.list_new_1 = list_new_1

		--[[local list_new_2 = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_new_2:SetPoint("TOPLEFT", 39, -345)
		--list_new_2:SetPoint("TOPRIGHT", -14, 0)
		list_new_2:SetJustifyH("LEFT")
		--list_new_2:SetHeight(18)
		list_new_2:SetWidth(420)
		list_new_2:SetWordWrap(true)
		list_new_2:SetFont(font,12)
		list_new_2:SetText("• A \"|cFFFFe961mini aura|r\" has been attached the Crash Lightning aura to track the T20 4-set bonus: |cFFFFe961Crashing Lightning|r. |cFF74ff6cSpecial Thanks to Sky for helping with testing!|r")
		list_new_2:SetTextColor(1,1,1,1)
		frame.body_new.new_enh.list_new_2 = list_new_2]]
end

local function BuildNewRestoList()
	local new_res = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	new_res:SetPoint("TOPLEFT", 27, -295)
	--new_res:SetPoint("TOPRIGHT", -14, 0)
	new_res:SetJustifyH("LEFT")
	new_res:SetHeight(18)
	new_res:SetFont(font,15)
	new_res:SetText("Restoration")
	new_res:SetTextColor(1,1,1,1)
	frame.body_new.new_res = new_res

		list_new_1 = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_new_1:SetPoint("TOPLEFT", 39, -315)
		--list_new_1:SetPoint("TOPRIGHT", -14, 0)
		list_new_1:SetJustifyH("LEFT")
		--list_new_1:SetHeight(18)
		list_new_1:SetWidth(420)
		list_new_1:SetWordWrap(true)
		list_new_1:SetFont(font,12)
		list_new_1:SetText("• Auras for |cFFFFe961Flash Flood|r and |cFFFFe961Downpour|r have been added. |cFF82BBFFThanks, Greenan!|r")
		list_new_1:SetTextColor(1,1,1,1)
		frame.body_new.new_res.list_new_1 = list_new_1

		--[[list_new_2 = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_new_2:SetPoint("TOPLEFT", 39, -365)
		--list_new_2:SetPoint("TOPRIGHT", -14, 0)
		list_new_2:SetJustifyH("LEFT")
		--list_new_2:SetHeight(18)
		list_new_2:SetWidth(420)
		list_new_2:SetWordWrap(true)
		list_new_2:SetFont(font,12)
		list_new_2:SetText("• A glow effect has been added to |cFFFFe961Healing Rain|r for the T20 4-piece bonus. |cFF82BBFFThanks, Araren!|r")
		list_new_2:SetTextColor(1,1,1,1)
		frame.body_new.new_res.list_new_2 = list_new_2]]
end

local function BuildNewUIList()	
	local new_ui = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	new_ui:SetPoint("TOPLEFT", 27, -345)
	--new_ui:SetPoint("TOPRIGHT", -14, 0)
	new_ui:SetJustifyH("LEFT")
	new_ui:SetHeight(18)
	new_ui:SetFont(font,15)
	new_ui:SetText("User-Interface")
	new_ui:SetTextColor(1,1,1,1)
	frame.body_new.new_ui = new_ui

		list_new_1 = body_new:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_new_1:SetPoint("TOPLEFT", 39, -365)
		--list_new_1:SetPoint("TOPRIGHT", -14, 0)
		list_new_1:SetJustifyH("LEFT")
		--list_new_1:SetHeight(18)
		list_new_1:SetWidth(420)
		list_new_1:SetWordWrap(true)
		list_new_1:SetFont(font,12)
		list_new_1:SetText("• Enabling the addon on a different character should no longer reset all settings.")
		list_new_1:SetTextColor(1,1,1,1)
		frame.body_new.new_ui.list_new_1 = list_new_1
end

local function BuildFixAllList()
	local fix_all = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	fix_all:SetPoint("TOPLEFT", 27, -295)
	--fix_all:SetPoint("TOPRIGHT", -14, 0)
	fix_all:SetJustifyH("LEFT")
	fix_all:SetHeight(18)
	fix_all:SetFont(font,15)
	fix_all:SetText("All Specs")
	fix_all:SetTextColor(1,1,1,1)
	frame.body_new.fix_all = fix_all

		local list_fix_1 = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_fix_1:SetPoint("TOPLEFT", 39, -315)
		--list_fix_1:SetPoint("TOPRIGHT", -14, 0)
		list_fix_1:SetJustifyH("LEFT")
		--list_fix_1:SetHeight(18)
		list_fix_1:SetWidth(420)
		list_fix_1:SetWordWrap(true)
		list_fix_1:SetFont(font,12)
		list_fix_1:SetText("• Disabling auras for specific specs should now remain disabled after reloading the UI. |cFF82BBFFThanks, ernetlo!|r")
		list_fix_1:SetTextColor(1,1,1,1)
		frame.body_new.fix_all.list_fix_1 = list_fix_1
end

local function BuildFixEleList()
	local fix_ele = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	fix_ele:SetPoint("TOPLEFT", 27, -295)
	--fix_ele:SetPoint("TOPRIGHT", -14, 0)
	fix_ele:SetJustifyH("LEFT")
	fix_ele:SetHeight(18)
	fix_ele:SetFont(font,15)
	fix_ele:SetText("Elemental")
	fix_ele:SetTextColor(1,1,1,1)
	frame.body_new.fix_ele = fix_ele

		local list_fix_1 = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_fix_1:SetPoint("TOPLEFT", 39, -315)
		--list_fix_1:SetPoint("TOPRIGHT", -14, 0)
		list_fix_1:SetJustifyH("LEFT")
		--list_fix_1:SetHeight(18)
		list_fix_1:SetWidth(420)
		list_fix_1:SetWordWrap(true)
		list_fix_1:SetFont(font,12)
		list_fix_1:SetText("• The aura for |cFFFFe961Hex|r should no longer disappear when selecting the |cFFFFe961Static Charge|r talent. |cFF82BBFFThanks, Nebuloz!|r")
		list_fix_1:SetTextColor(1,1,1,1)
		frame.body_new.fix_ele.list_fix_1 = list_fix_1
end

local function BuildFixEnhList()
	local fix_enh = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	fix_enh:SetPoint("TOPLEFT", 27, -295)
	--fix_enh:SetPoint("TOPRIGHT", -14, 0)
	fix_enh:SetJustifyH("LEFT")
	fix_enh:SetHeight(18)
	fix_enh:SetFont(font,15)
	fix_enh:SetText("Enhancement")
	fix_enh:SetTextColor(1,1,1,1)
	frame.body_new.fix_enh = fix_enh

		local list_fix_1 = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_fix_1:SetPoint("TOPLEFT", 39, -315)
		--list_fix_1:SetPoint("TOPRIGHT", -14, 0)
		list_fix_1:SetJustifyH("LEFT")
		--list_fix_1:SetHeight(18)
		list_fix_1:SetWidth(420)
		list_fix_1:SetWordWrap(true)
		list_fix_1:SetFont(font,12)
		list_fix_1:SetText("• The |cFFFFe961Crash Lightning|r aura will now update when gaining/losing the T21 4-set bonus due to unequipping pieces.")
		list_fix_1:SetTextColor(1,1,1,1)
		frame.body_new.fix_enh.list_fix_1 = list_fix_1
end

local function BuildFixResList()
	local fix_res = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	fix_res:SetPoint("TOPLEFT", 27, -345)
	--fix_res:SetPoint("TOPRIGHT", -14, 0)
	fix_res:SetJustifyH("LEFT")
	fix_res:SetHeight(18)
	fix_res:SetFont(font,15)
	fix_res:SetText("Restoration")
	fix_res:SetTextColor(1,1,1,1)
	frame.body_new.fix_res = fix_res

		local list_fix_1 = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_fix_1:SetPoint("TOPLEFT", 39, -365)
		--list_fix_1:SetPoint("TOPRIGHT", -14, 0)
		list_fix_1:SetJustifyH("LEFT")
		--list_fix_1:SetHeight(18)
		list_fix_1:SetWidth(420)
		list_fix_1:SetWordWrap(true)
		list_fix_1:SetFont(font,12)
		list_fix_1:SetText("• The cooldown timer for |cFFFFe961Riptide|r should now disappear when reaching zero seconds remaining.")
		list_fix_1:SetTextColor(1,1,1,1)
		frame.body_new.fix_res.list_fix_1 = list_fix_1
end

local function BuildFixUIList()	
	local fix_ui = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
	fix_ui:SetPoint("TOPLEFT", 27, -345)
	--fix_ui:SetPoint("TOPRIGHT", -14, 0)
	fix_ui:SetJustifyH("LEFT")
	fix_ui:SetHeight(18)
	fix_ui:SetFont(font,15)
	fix_ui:SetText("User-Interface")
	fix_ui:SetTextColor(1,1,1,1)
	frame.body_fix.fix_ui = fix_ui

		list_fix_1 = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_fix_1:SetPoint("TOPLEFT", 39, -365)
		--list_fix_1:SetPoint("TOPRIGHT", -14, 0)
		list_fix_1:SetJustifyH("LEFT")
		--list_fix_1:SetHeight(18)
		list_fix_1:SetWidth(420)
		list_fix_1:SetWordWrap(true)
		list_fix_1:SetFont(font,12)
		list_fix_1:SetText("• An issue of PvP auras not re-appearing after leaving some sanctuary areas should now re-appear as intended.")
		list_fix_1:SetTextColor(1,1,1,1)
		frame.body_fix.fix_ui.list_fix_1 = list_fix_1
		
		--[[list_fix_2 = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_fix_2:SetPoint("TOPLEFT", 39, -300)
		--list_fix_2:SetPoint("TOPRIGHT", -14, 0)
		list_fix_2:SetJustifyH("LEFT")
		--list_fix_2:SetHeight(18)
		list_fix_2:SetWidth(420)
		list_fix_2:SetWordWrap(true)
		list_fix_2:SetFont(font,12)
		list_fix_2:SetText("• An issue preventing all progress bars from being modified when playing WoW in a non-English language has been fixed.")
		list_fix_2:SetTextColor(1,1,1,1)
		frame.body_fix.fix_ui.list_fix_2 = list_fix_2
		
		list_fix_3 = body_fix:CreateFontString(nil, "FULLSCREEN_DIALOG", "GameFontNormal")
		list_fix_3:SetPoint("TOPLEFT", 39, -330)
		--list_fix_3:SetPoint("TOPRIGHT", -14, 0)
		list_fix_3:SetJustifyH("LEFT")
		--list_fix_3:SetHeight(18)
		list_fix_3:SetWidth(420)
		list_fix_3:SetWordWrap(true)
		list_fix_3:SetFont(font,12)
		list_fix_3:SetText("• Added more asian-compatible fonts.")
		list_fix_3:SetTextColor(1,1,1,1)
		frame.body_fix.fix_ui.list_fix_3 = list_fix_3]]
end

BuildButtons()
BuildTitleBar()
BuildHeader()

--BuildNewAllList()
BuildNewEleList()
--BuildNewEnhList()
--BuildNewRestoList()
--BuildNewUIList()

--BuildFixAllList()
--BuildFixEleList()
BuildFixEnhList()
--BuildFixResList()
BuildFixUIList()

SSA.Bulletin = frame
_G["SSA_Bulletin"] = frame

