local FOLDER_NAME = ...
local SSA, Auras, L, LSM = unpack(select(2,...))
local ErrorMsg = ''
SSA.InterfaceListItem = nil

local _G = _G
local floor, fmod = math.floor, math.fmod
local pairs, select, tonumber, tostring = pairs, select, tonumber, tostring
local format, lower, match = string.format, string.lower, string.match
local twipe = table.wipe
-- WoW API / Variables
local C_ArtifactUI = C_ArtifactUI
local CreateFrame = CreateFrame
local GetAddOnMetadata = GetAddOnMetadata
local GetScreenHeight, GetScreenWidth = GetScreenHeight, GetScreenWidth
local GetSpecialization = GetSpecialization
local UnitAffectingCombat = UnitAffectingCombat
local UnitLevel = UnitLevel
local UnitPowerMax = UnitPowerMax
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME


-------------------------------------------------------------------------------------------------------
----- Functions that affect frame objects & elements
-------------------------------------------------------------------------------------------------------

-- Adjusts the "spark" of a statusbar.
function Auras:AdjustStatusBarSpark(self,db,offset)
	if (db.spark) then
		local position = self:GetWidth() * offset
		
		self.spark:Show()
		self.spark:SetSize(20,(self:GetHeight() * 2.5))
		
		self.spark:SetPoint('CENTER', self, 'LEFT', position, 0)
	else
		self.spark:Hide()
	end
end

-- Adjusts the icon of a statusbar.
function Auras:AdjustStatusBarIcon(self,db,texture)
	if (db.icon.isEnabled) then
		local parentJustify
		
		self.icon:Show()
		
		if (db.icon.justify == 'LEFT') then
			parentJustify = 'RIGHT'
			self:SetPoint(db.layout.point,self:GetParent(),'CENTER',db.layout.x + floor(db.layout.height / 2),db.layout.y)
		else
			parentJustify = 'LEFT'
			self:SetPoint(db.layout.point,self:GetParent(),'CENTER',db.layout.x - floor(db.layout.height / 2),db.layout.y)
		end
		
		self.icon:ClearAllPoints()
		self.icon:SetWidth(db.layout.height)
		self.icon:SetHeight(db.layout.height)
		self.icon:SetPoint(parentJustify,self,db.icon.justify,0,0)
		self.icon:SetTexture(texture)
	
		self:SetWidth(db.layout.width - db.layout.height)
	else
		self:SetPoint(db.layout.point,self:GetParent(),db.layout.point,db.layout.x,db.layout.y)
		self:SetWidth(db.layout.width)
		self.icon:Hide()
	end
end



-- Adjusts the text of a statusbar.
function Auras:AdjustStatusBarText(self,db)
	if (db.isDisplayText) then
		self:SetAlpha(1)
		
		if (db.font.shadow.isEnabled) then
			self:SetShadowColor(db.font.shadow.color.r,db.font.shadow.color.g,db.font.shadow.color.b,db.font.shadow.color.a)
			self:SetShadowOffset(db.font.shadow.offset.x,db.font.shadow.offset.y)
		else
			self:SetShadowColor(0,0,0,0)
		end

		self:ClearAllPoints()
		self:SetPoint(db.justify,db.x,db.y)
		self:SetFont(LSM.MediaTable.font[db.font.name] or LSM.DefaultMedia.font,db.font.size,db.font.flag)
		self:SetTextColor(db.font.color.r,db.font.color.g,db.font.color.b)
	else
		self:SetAlpha(0)
	end
end

-- Toggles the movement of a frame.
function Auras:ToggleFrameMove(self,isMoving)
	if (isMoving) then
		if (not self:IsMouseEnabled()) then
			self:EnableMouse(true)
			self:SetMovable(true)
		end
		
		if (not self:GetBackdrop()) then
			self:SetBackdrop(backdrop)
			self:SetBackdropColor(0,0,0,0.85)
		end
	else
		if (self:IsMouseEnabled()) then
			self:EnableMouse(false)
			self:SetMovable(false)
		end
		
		if (self:GetBackdrop()) then
			--self:SetBackdrop(nil)
		end
	end
end

-- Toggles the movement of a progress bar.
function Auras:ToggleProgressBarMove(self,isMoving,db)
	if (isMoving) then
		db.adjust.isEnabled = false
		
		if (not self:IsMouseEnabled()) then
			self:EnableMouse(true)
			self:SetMovable(true)
		end
		self:SetAlpha(1)
	else
		if (self:IsMouseEnabled()) then
			self:EnableMouse(false)
			self:SetMovable(false)
		end
	end
end



-------------------------------------------------------------------------------------------------------
----- Functions that retrieve and return information
-------------------------------------------------------------------------------------------------------

-- Checks to see if the player is the proper level to use a specific spell, by spell ID.
function Auras:CheckSpellLevel(spellID)
	for i=1,UnitLevel('player') do
		local spells = { GetCurrentLevelSpells(i) }
		
		for j=1,getn(spells) do
			if (spellID == spells[j]) then
				return true
			end
		end
	end
	
	return false
end

-- Converts RGB values from 0-255 scale to 0-1.
function Auras:GetColorVal(r,g,b)
	r = format("%.2f",(r / 255))
	g = format("%.2f",(g / 255))
	b = format("%.2f",(b / 255))
	return tonumber(r),tonumber(g),tonumber(b)
end

-- Checks if the player is in combat and whether they are targetting an enemy or not.
function Auras:IsPlayerInCombat(isTargetNotRequired)
	if ((UnitAffectingCombat('player') and Auras:IsTargetEnemy() and not isTargetNotRequired) or (UnitAffectingCombat('player') and isTargetNotRequired)) then
		return true
	else
		return false
	end
end

-- Searches through the unit's buffs for a specific buff, by name
function Auras:RetrieveAuraInfo(unit,spellID,filter)
	local auraMax = ((match((filter or ''),"HELPFUL") or not filter) and BUFF_MAX_DISPLAY) or (match((filter or ''),"HARMFUL") and DEBUFF_MAX_DISPLAY)
	
	for i=1,auraMax do
		local _,_,_,_,_,_,_,_,_,auraID = UnitAura(unit,i,filter or "HELPFUL PLAYER")

		if (auraID == spellID) then
			return UnitAura(unit,i,filter or "HELPFUL PLAYER")
		end
	end
	
	return false
end

-- Searches through the unit's buffs for a specific buff, by name
function Auras:RetrieveBuffInfo(unit,spellName)
	for i=1,BUFF_MAX_DISPLAY do
		local name = UnitBuff(unit,i)

		if (name == spellName) then
			return UnitBuff(unit,i)
		end
	end
end


-- Searches through the unit's debuffs for a specific debuff, by name
function Auras:RetrieveDebuffInfo(unit,spellName)
	for i=1,DEBUFF_MAX_DISPLAY do
		local name = UnitDebuff(unit,i)
		
		if (name == spellName) then
			return UnitDebuff(unit,i)
		end
	end
end

-------------------------------------------------------------------------------------------------------
----- Miscellaneous Utility Functions
-------------------------------------------------------------------------------------------------------

local function CreateGrid()
	local grid = SSA.grid
	grid.boxSize = 128
	grid.isCreated = true
	grid:SetAllPoints(UIParent)
	grid:SetFrameStrata("BACKGROUND")

	local size = 1
	local width = GetScreenWidth()
	local ratio = width / GetScreenHeight()
	local height = GetScreenHeight() * ratio

	local wStep = width / 128
	local hStep = height / 128

	for i = 0, 128 do
		local tx = grid:CreateTexture(nil, 'BACKGROUND')
		if i == 128 / 2 then
			tx:SetColorTexture(1,0,0)
		else
			tx:SetColorTexture(0,0,0,0.5)
		end
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", i*wStep - (size/2), 0)
		tx:SetPoint('BOTTOMRIGHT', grid, 'BOTTOMLEFT', i*wStep + (size/2), 0)
	end
	height = GetScreenHeight()

	do
		local tx = grid:CreateTexture(nil, 'BACKGROUND')
		tx:SetColorTexture(1, 0, 0)
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(height/2 + size/2))
	end

	for i = 1, floor((height/2)/hStep) do
		local tx = grid:CreateTexture(nil, 'BACKGROUND')
		tx:SetColorTexture(0,0,0,0.5)

		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2+i*hStep) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(height/2+i*hStep + size/2))

		tx = grid:CreateTexture(nil, 'BACKGROUND')
		tx:SetColorTexture(0,0,0,0.5)

		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2-i*hStep) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(height/2-i*hStep + size/2))
	end
end

local function NavigateInterfaceOptions(index)
	local UpdateInterval = 0.001
	local LastUpdated = 0
	local listIndex

	InterfaceOptionsFrame:Show()
	InterfaceOptionsFrameTab2:Click()
	Auras.db.char.settings.grid.gridPreview = false
	SSA.grid:Hide()

	for i=2,InterfaceOptionsFrameAddOns:GetNumChildren() do
		if (select(i,InterfaceOptionsFrameAddOns:GetChildren()):GetText() == "ShamanAuras") then
			listIndex = i
			listObject = select(i,InterfaceOptionsFrameAddOns:GetChildren())

			if (select((i+1),InterfaceOptionsFrameAddOns:GetChildren()):GetText() ~= "Elemental Auras") then
				select(1,listObject:GetChildren()):Click()
			end
			break
		end
	end
	
	select(listIndex+index,InterfaceOptionsFrameAddOns:GetChildren()):Click()
end

function Auras:ChatCommand(input)	
	input = lower(input)
	if (UnitAffectingCombat('player')) then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF77Sweetsour\'s Shaman Auras|r: |cFFFF7777You cannot access options while in combat.")
	else
		if not input or input:trim() == "" then
			NavigateInterfaceOptions(0)
		elseif input == "ele" or input == "elemental" then
			NavigateInterfaceOptions(1)
		elseif input == "enh" or input == "enhance" or input == "enhancement" then
			NavigateInterfaceOptions(2)
		elseif input == "res" or input == "resto" or input == "restoration" then
			NavigateInterfaceOptions(3)
		elseif (input == "info" or input == "changelog") then
			SSA.Bulletin:Show()
		elseif input == "settings" or input == "options" or input == "option" or input == "opt" or input == "config" then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF77Sweetsour\'s Shaman Auras|r: |cFFFF7777The advanced configuration options have been embed directly in each of the specs' settings. Type /ssa <spec> and select the corresponding tabs that have been added.")
		elseif input == "version" then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF77Sweetsour\'s Shaman Auras|r: |cFF9999FF"..GetAddOnMetadata(FOLDER_NAME,"Version").."|r")
		elseif (input == "toggle") then
			Auras.db.char.elements[GetSpecialization()].isEnabled = not Auras.db.char.elements[GetSpecialization()].isEnabled
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF77Sweetsour\'s Shaman Auras|r: |cFFFF7777Invalid input.")
			DEFAULT_CHAT_FRAME:AddMessage("/|cFFFFFF77ssa|r: |cFFFFFFFFOpen addon's home page|r")
			DEFAULT_CHAT_FRAME:AddMessage("/|cFFFFFF77ssa|r |cFFBBBBFFele|r: |cFFFFFFFFOpen Elemental customizations options|r")
			DEFAULT_CHAT_FRAME:AddMessage("/|cFFFFFF77ssa|r |cFFBBBBFFenh|r: |cFFFFFFFFOpen Enhancement customizations options|r")
			DEFAULT_CHAT_FRAME:AddMessage("/|cFFFFFF77ssa|r |cFFBBBBFFresto|r: |cFFFFFFFFOpen Restoration customizations options|r")
			DEFAULT_CHAT_FRAME:AddMessage("/|cFFFFFF77ssa|r |cFFBBBBFFopt|r: |cFFFFFFFFOpen advanced customizations options|r")
			DEFAULT_CHAT_FRAME:AddMessage("/|cFFFFFF77ssa|r |cFFBBBBFFinfo|r: |cFFFFFFFFDisplay current change log|r")
			DEFAULT_CHAT_FRAME:AddMessage("/|cFFFFFF77ssa|r |cFFBBBBFFversion|r: |cFFFFFFFFRetrieve addon's version|r")
		end
	end
end

function Auras:InitMoveAuraGroups(spec)
	if (not SSA.grid.isCreated) then
		CreateGrid()
	end

	if (Auras.db.char.isMoveGrid) then
		SSA.grid:Show()
	else
		SSA.grid:Hide()
	end
	--SSA.IsMovingAuras = true
	SSA["Move"..spec]:Show()
	SSA["Move"..spec].Grid:SetChecked(Auras.db.char.isMoveGrid)
	
	InterfaceOptionsFrame:Hide()
	GameMenuFrame:Hide()
end

function Auras:BuildMoveUI(spec)
	local ButtonFont = SSA.ButtonFont
	local BackdropSB = SSA.BackdropSB
	local Move = SSA["Move"..spec]
	
	Move.Close = CreateFrame("Button","CloseButton",Move)
	Move.Grid = CreateFrame("CheckButton","Move"..spec.."Grid",Move,"ChatConfigCheckButtonTemplate")
	Move.InfoDisplay = CreateFrame("CheckButton","Move"..spec.."InfoDisplay",Move,"ChatConfigCheckButtonTemplate")
	Move.Info = CreateFrame("Frame","MoveInfoFrame",UIParent)

	Move.Info:SetWidth(446)
	Move.Info:SetHeight(115)
	Move.Info:SetPoint("TOPLEFT",UIParent,"TOPLEFT",100,-100)
	Move.Info:SetBackdrop(SSA.BackdropSB)
	Move.Info:SetBackdropColor(0.15,0.15,0.15,0.9)
	Move.Info:SetBackdropBorderColor(1,1,1,1)
	Move.Info:Hide()

	Move.Info.text = Move.Info:CreateFontString(nil, "MEDIUM", "GameFontHighlightLarge")
	Move.Info.text:SetPoint("TOPLEFT",11,-5)
	Move.Info.text:SetFont("Interface\\addons\\ShamanAurasDev\\Media\\fonts\\courbd.ttf", 14,"NONE")
	Move.Info.text:SetTextColor(1,1,1,1)
	Move.Info.text:SetJustifyH("LEFT")
	Move.Info.text:SetText("               Moving Auras Help\n\nShift + Left-Click:   Horizontal Center\nShift + Right-Click:  Vertical Center\nShift + Middle-Click: Horizonal/Vertical Center\n\nCtrl + Right-Click:   Reset Aura Group")
	_G["SSA_MoveInfoFrame"] = Move.Info

	-- Build Move Toggle Frame
	Move:SetFrameStrata("HIGH")
	Move:SetWidth(170)
	--Move:SetHeight(((getn(MoveCheckObj) - 8) * 20) + 270)
	Move:SetHeight(95)
	Move:SetPoint("CENTER",0,250)
	Move:SetBackdrop(BackdropSB)
	Move:SetBackdropColor(0,0,0)
	Move:Hide()
	
	
	-- Build Close Button
	Move.Close:SetWidth(75)
	Move.Close:SetHeight(25)
	Move.Close:SetFrameStrata("DIALOG")
	Move.Close:SetPoint("BOTTOM",0,10)
	Move.Close:SetText(CLOSE)
	Move.Close:SetBackdrop(BackdropSB)
	Move.Close:SetBackdropColor(0,0,0)
	Move.Close:SetNormalFontObject("SSAButtonFont")
	Move.Close:SetScript("OnClick",function(self,button)
		local spec = GetSpecialization()
		
		Auras.db.char.elements[spec].isMoving = false
		
		Move:Hide()
		SSA.grid:Hide()

		if (Move.Info:IsShown()) then
			Move.Info:Hide()
		end
		
		if (button ~= "MiddleButton") then
			InterfaceOptionsFrame:Show()
			InterfaceOptionsFrameCancel:SetScript("OnClick",function(self)
				InterfaceOptionsFrame:Hide()
				GameMenuFrame:Show()
			end)
			InterfaceOptionsFrameOkay:SetScript("OnClick",function(self)
				InterfaceOptionsFrame:Hide()
				GameMenuFrame:Show()
			end)
		end
	end)
	Move.Close:SetScript("OnEnter",function(self,button)
		self:SetBackdropColor(0.5,0.5,0.5)
	end)
	Move.Close:SetScript("OnLeave",function(self,button)
		self:SetBackdropColor(0,0,0)
	end)
	
	Move.Grid:SetPoint("TOPLEFT",10,-10)
	_G[Move.Grid:GetName().."Text"]:SetFont((LSM.MediaTable.font['PT Sans Narrow'] or LSM.DefaultMedia.font), 12)
	_G[Move.Grid:GetName().."Text"]:SetText(L["TOGGLE_MOVE_GRID"])
	_G[Move.Grid:GetName().."Text"]:SetPoint("LEFT",25,0)
	Move.Grid:SetScript("OnClick",function(self)
		if (self:GetChecked()) then
			Auras.db.char.isMoveGrid = true
			SSA.grid:Show()
		else
			Auras.db.char.isMoveGrid = false
			SSA.grid:Hide()
		end
	end)
	
	Move.InfoDisplay:SetPoint("TOPLEFT",10,-30)
	Move.InfoDisplay:SetChecked(true)
	_G[Move.InfoDisplay:GetName().."Text"]:SetFont((LSM.MediaTable.font['PT Sans Narrow'] or LSM.DefaultMedia.font), 12)
	_G[Move.InfoDisplay:GetName().."Text"]:SetText(L["TOGGLE_MOVE_INFO"])
	_G[Move.InfoDisplay:GetName().."Text"]:SetPoint("LEFT",25,0)
	Move.InfoDisplay:SetScript("OnClick",function(self)
		if (self:GetChecked()) then
			Move.Info:Show()
		else
			Move.Info:Hide()
		end
	end)
end



--function Auras:CreateVerticalStatusBar(statusbar,r1,g1,b1,text,duration,texture)
function Auras:CreateVerticalStatusBar(statusbar,spec,ctr)
	--local db = Auras.db.char.timerbars[spec][barName]
	--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..statusbar:GetName()..": "..tostring(db.layout.group).."\n")
	
	local timerbars = Auras.db.char.timerbars[spec]
	local timerbar = timerbars.bars[statusbar:GetName()]
	local barInfo = timerbars.groups[timerbar.layout.group]
	--local layout = Auras.db.char.layout[spec].timerbars.groups[db.group].layout
	
	
	--[[if (not db) then
		SSA.DataFrame.text:SetText("DB ERROR: Core\\functions.lua:443: "..tostring(barName)..", "..tostring(db.text)..", "..ctr)
	end]]
	

	--SSA.DataFrame.text:SetText("TIMERBAR ERROR: "..tostring(statusbar:GetName()))
	if (timerbar.isInUse) then
	--if (Auras.db.char.layout[spec].timerbars[group]) then
		--statusbar:SetStatusBarTexture(LSM.MediaTable.statusbar['Glamour2'])
		statusbar:SetStatusBarTexture(LSM.MediaTable.statusbar[timerbar.layout.texture])
		statusbar:SetWidth(barInfo.layout.width)
		statusbar:SetHeight(barInfo.layout.height)
		--statusbar:GetStatusBarTexture():SetHorizTile(true)
		--statusbar:GetStatusBarTexture():SetVertTile(false)
		statusbar:SetOrientation(barInfo.layout.orientation)
		--statusbar:SetRotatesTexture(false)
		statusbar:SetPoint(barInfo.layout.anchor,0,0)
		statusbar:SetFrameStrata("LOW")
		statusbar:SetStatusBarColor(timerbar.layout.color.r,timerbar.layout.color.g,timerbar.layout.color.b)
		--statusbar:SetStatusBarColor(r,g,b)
		statusbar:SetMinMaxValues(0,statusbar.duration)
		statusbar:Hide()

		--statusbar.duration = duration
		if (not statusbar.bg) then
			statusbar.bg = statusbar:CreateTexture(nil,"BACKGROUND")
		end
		statusbar.bg:SetTexture(LSM.MediaTable.statusbar['Blizzard'])
		statusbar.bg:SetAllPoints(true)
		statusbar.bg:SetVertexColor(0,0,0)
		statusbar.bg:SetAlpha(0.5)

		if (not statusbar.timetext) then
			statusbar.timetext = statusbar:CreateFontString(nil, "MEDIUM", "GameFontHighlightLarge")
		end
		statusbar.timetext:SetFont(LSM.MediaTable.font[barInfo.timetext.font.name], barInfo.timetext.font.size, barInfo.timetext.font.flag)
		statusbar.timetext:SetTextColor(barInfo.timetext.font.color.r,barInfo.timetext.font.color.g,barInfo.timetext.font.color.b,barInfo.timetext.font.color.a)
		statusbar.timetext:SetJustifyH("CENTER")
		statusbar.timetext:SetJustifyV("MIDDLE")
		--statusbar.timetext:ClearAllPoints()
		--statusbar.timetext:SetPoint("RIGHT",-5,0)

		if (not statusbar.nametext) then
			statusbar.nametext = statusbar:CreateFontString(nil, "MEDIUM", "GameFontHighlightLarge")
		end
		--statusbar.nametext:SetPoint("TOP",-94.5,-4)
		statusbar.nametext:SetFont(LSM.MediaTable.font[barInfo.nametext.font.name], barInfo.nametext.font.size, barInfo.nametext.font.flag)
		statusbar.nametext:SetTextColor(barInfo.nametext.font.color.r,barInfo.nametext.font.color.g,barInfo.nametext.font.color.b,barInfo.nametext.font.color.a)
		--statusbar.nametext:SetJustifyH("LEFT")
		statusbar.nametext:SetJustifyV("MIDDLE")
		statusbar.nametext:SetWordWrap(false)
		--statusbar.nametext:SetWidth(statusbar.nametext:GetParent():GetWidth())
		--statusbar.nametext:SetHeight(statusbar.nametext:GetParent():GetHeight())
		--statusbar.nametext:ClearAllPoints()
		--statusbar.nametext:SetPoint("LEFT",0,0)
		statusbar.nametext:SetText(timerbar.layout.text)
		
		if (not statusbar.rotatetime) then
			statusbar.rotatetime = statusbar.timetext:CreateAnimationGroup()
		
			statusbar.rotatetime:SetLooping("NONE")

			local rotater = statusbar.rotatetime:CreateAnimation("Rotation")
			rotater:SetOrigin("CENTER", 0, 0)
			rotater:SetDegrees(90)
			rotater:SetDuration(0.000001)
			rotater:SetEndDelay(2147483647)
		end

		if (not statusbar.rotatename) then
			statusbar.rotatename = statusbar.nametext:CreateAnimationGroup()
			statusbar.rotatename:SetLooping("NONE")

			local rotater = statusbar.rotatename:CreateAnimation("Rotation")
			rotater:SetOrigin("TOP", 0, 0)
			rotater:SetDegrees(90)
			rotater:SetDuration(0.000001)
			rotater:SetEndDelay(2147483647)
		end
		
		--[[if (not statusbar.rotatebar) then
			statusbar.rotatebar = statusbar:CreateAnimationGroup()
		
			statusbar.rotatebar:SetLooping("NONE")

			local rotater = statusbar.rotatebar:CreateAnimation("Rotation")
			rotater:SetOrigin("CENTER", 0, 0)
			rotater:SetDegrees(90)
			rotater:SetDuration(0.000001)
			rotater:SetEndDelay(2147483647)
		end]]
		
		if (barInfo.layout.orientation == "VERTICAL") then
			statusbar:GetStatusBarTexture():SetHorizTile(false)
			statusbar:SetRotatesTexture(true)
			statusbar:SetWidth(barInfo.layout.height)
			statusbar:SetHeight(barInfo.layout.width)
			statusbar.timetext:ClearAllPoints()
			statusbar.timetext:SetPoint("BOTTOM",-6,4)
			--statusbar.timetext:SetWidth(barInfo.layout.height)
			--statusbar.timetext:SetHeight(barInfo.layout.width)
			
			statusbar.nametext:SetWidth(statusbar.nametext:GetParent():GetHeight())
			statusbar.nametext:SetHeight(statusbar.nametext:GetParent():GetWidth())
			statusbar.nametext:SetJustifyH("RIGHT")
			statusbar.nametext:ClearAllPoints()
			--local width = ((statusbar.nametext:GetParent():GetHeight() - 175) + 94.5) * -1
			--local x = ((statusbar.nametext:GetParent():GetHeight() / 1.8617) + ((175 - statusbar.nametext:GetParent():GetHeight()) * 0.064)) * -1
			local x = ((statusbar.nametext:GetParent():GetHeight() / 1.8617) + ((175 - statusbar.nametext:GetParent():GetHeight()) * 0.04)) * -1
			local y = ((statusbar.nametext:GetParent():GetWidth() / 2) - 10)
			--local diff1 = (statusbar.nametext:GetParent():GetHeight() / 1.8617)
			--local diff2 = (175 - statusbar.nametext:GetParent():GetHeight()) * 0.04
			--local x = (diff1 + diff2) * -1
			--statusbar.nametext:SetPoint("TOP",-94.5,0)
			
			--statusbar.nametext:SetPoint("TOP",x,y)
			statusbar.nametext:SetPoint("TOP",x,y)
			--statusbar.nametext:SetAllPoints(statusbar)
			if (statusbar:GetName() == "AncestralGuidanceBar") then
				
				--print("X: "..tostring(width))
				local point,parent,relative,x,y = statusbar.nametext:GetPoint()
				print(statusbar.nametext:GetParent():GetWidth()..", "..y)
				--print(point..", "..parent:GetName()..", "..relative..", "..x..", "..y.." ("..diff1.." - "..diff2..")")
			end
			--statusbar.rotatebar:Play()
			statusbar.rotatetime:Play()
			statusbar.rotatename:Play()
		else
			statusbar:GetStatusBarTexture():SetHorizTile(true)
			statusbar:SetRotatesTexture(false)
			statusbar:SetWidth(barInfo.layout.width)
			statusbar:SetHeight(barInfo.layout.height)
			
			statusbar.timetext:ClearAllPoints()
			statusbar.timetext:SetPoint("LEFT",5,0)
			--statusbar.timetext:SetWidth(statusbar.nametext:GetParent():GetWidth())
			--statusbar.timetext:SetHeight(statusbar.nametext:GetParent():GetHeight())
			
			statusbar.nametext:SetJustifyH("CENTER")
			--statusbar.nametext:SetWidth(statusbar.nametext:GetParent():GetWidth())
			--statusbar.nametext:SetHeight(statusbar.nametext:GetParent():GetHeight())
			statusbar.nametext:ClearAllPoints()
			statusbar.nametext:SetPoint("RIGHT",-5,-1)
			
			--statusbar.rotatebar:Stop()
			statusbar.rotatetime:Stop()
			statusbar.rotatename:Stop()
		end
	end
end

local function BuildHorizontalIconRow(rowObj,rowList,rowVerify,spec,group)
	local rowCtr = 0
	local layout = Auras.db.char.auras[spec].groups[group]
	--local parent = rowObj[1]:GetParent()
	local iconDistribution = {}
	local validAuraCtr = 0
	
	for i=1,#rowObj do
		if (rowVerify[i]) then
			rowObj[i]:SetWidth(layout.icon)
			rowObj[i]:SetHeight(layout.icon)
			if (rowObj[i].glow) then
				rowObj[i].glow:SetWidth(layout.icon + 13)
				rowObj[i].glow:SetHeight(layout.icon + 13)
			end
			if (rowObj[i].Charges) then
				rowObj[i].Charges.text:SetFont((LSM.MediaTable.font['ABF'] or LSM.DefaultMedia.font), layout.charges,"OUTLINE")
			end
		end
	end
	
	for i=1,#rowList do
		if (rowList[i] and rowVerify[i]) then
			rowCtr = rowCtr + 1
			rowObj[i]:Show()
		else
			rowObj[i]:Hide()
		end
	end

	if (rowCtr % 1) then
		local middle = (rowCtr / 2) + 0.5
		
		for i=1,#rowObj do
			local spacing

			if (rowList[i] and rowVerify[i]) then
				if (rowCtr > 1) then
					validAuraCtr = validAuraCtr + 1
					
					if (validAuraCtr < middle) then
						spacing = (0 - (layout.spacing * (middle - validAuraCtr)))
					elseif (validAuraCtr == middle) then
						spacing = 0
					else
						spacing = (0 + (layout.spacing * (validAuraCtr - middle)))
					end
				else
					spacing = 0
				end

				tinsert(iconDistribution,spacing)
			end
		end
	else
		local middle = (rowCtr / 2) + 0.5
		
		for i=1,rowCtr do
			if (rowList[i] and rowVerify[i]) then
				validAuraCtr = validAuraCtr + 1
				
				if (validAuraCtr < middle) then
					spacing = ((layout.spacing * ((middle + 0.5) - validAuraCtr)) - (layout.spacing / 2)) * -1
				else
					spacing = ((layout.spacing * (validAuraCtr - (middle - 0.5))) - (layout.spacing / 2))
				end

				tinsert(iconDistribution,spacing)
			end
		end
	end
	
	validAuraCtr = 0
	for i=1,layout.auraCount do
		if (rowList[i]) then
			validAuraCtr = validAuraCtr + 1
			rowObj[i]:SetPoint("CENTER",iconDistribution[validAuraCtr],0)
		end
	end
	
	twipe(rowObj)
	twipe(rowList)
	twipe(rowVerify)
end

local function BuildVerticalIconRow(rowObj,rowList,rowVerify,spec,group)
	local rowCtr = 0
	local layout = Auras.db.char.auras[spec].groups[group]
	local iconDistribution = {}
	local validAuraCtr = 0
	
	for i=1,#rowObj do
		if (rowVerify[i]) then
			rowObj[i]:SetWidth(layout.icon)
			rowObj[i]:SetHeight(layout.icon)
			if (rowObj[i].glow) then
				rowObj[i].glow:SetWidth(layout.icon + 10)
				rowObj[i].glow:SetHeight(layout.icon + 10)
			end
			if (rowObj[i].Charges) then
				rowObj[i].Charges.text:SetFont((LSM.MediaTable.font['ABF'] or LSM.DefaultMedia.font), layout.charges,"OUTLINE")
			end
		end
	end
	
	for i=1,#rowList do
		--if (rowList[i] and Auras:CharacterCheck(nil,0)) then
		if (rowList[i] and rowVerify[i]) then
			rowCtr = rowCtr + 1
			rowObj[i]:Show()
		else
			rowObj[i]:Hide()
		end
	end
	
	if (rowCtr % 1) then
		local middle = (rowCtr / 2) + 0.5
		
		for i=1,#rowObj do
			local spacing

			if (rowList[i] and rowVerify[i]) then
				if (rowCtr > 1) then
					validAuraCtr = validAuraCtr + 1
					
					if (validAuraCtr < middle) then
						spacing = (0 + (layout.spacing * (middle - validAuraCtr)))
					elseif (validAuraCtr == middle) then
						spacing = 0
					else
						spacing = (0 - (layout.spacing * (validAuraCtr - middle)))
					end
				else
					spacing = 0
				end

				tinsert(iconDistribution,spacing)
			end
		end
	else
		local middle = (rowCtr / 2) + 0.5
		
		for i=1,rowCtr do
			if (rowList[i] and rowVerify[i]) then
				validAuraCtr = validAuraCtr + 1
				
				if (validAuraCtr < middle) then
					spacing = ((layout.spacing * ((middle + 0.5) - validAuraCtr)) - (layout.spacing / 2)) * -1
				else
					spacing = ((layout.spacing * (validAuraCtr - (middle - 0.5))) - (layout.spacing / 2))
				end

				tinsert(iconDistribution,spacing)
			end
		end
	end
	
	validAuraCtr = 0
	for i=1,layout.auraCount do
		if (rowList[i]) then
			validAuraCtr = validAuraCtr + 1
			rowObj[i]:SetPoint("CENTER",0,iconDistribution[validAuraCtr])
		end
	end

	twipe(rowObj)
	twipe(rowList)
	twipe(rowVerify)
end
--[[
	Champion of Azeroth (82)
	Gemhide (85)
	Natural Harmony (416)
	Synapse Shock (448)
	local msg = ''
    local itemLoc = ItemLocation:CreateFromEquipmentSlot(3)
    local AzeriteEmpoweredItem = C_AzeriteEmpoweredItem
    local tierInfo = AzeriteEmpoweredItem.GetAllTierInfo(itemLoc)
    local powerCtr = 0
    
    for azeriteTier, tierInfo in pairs(tierInfo) do
        for _, powerID in pairs(tierInfo.azeritePowerIDs) do
            local powerInfo = AzeriteEmpoweredItem.GetPowerInfo(powerID)
            local spell
            for azeritePowerID,spellID in pairs(powerInfo) do
                spell = spellID
            end
            
            powerCtr = powerCtr + 1
            
            local name = GetSpellInfo(powerID)
            msg = msg..powerCtr..": "..powerID.." ("..tostring(powerInfo["azeritePowerID"])..")\n"
        end
    end
	
	
	
	
	
	local msg = ''
    local itemLoc = ItemLocation:CreateFromEquipmentSlot(3)
    local AzeriteEmpoweredItem = C_AzeriteEmpoweredItem
    local tierInfo = AzeriteEmpoweredItem.GetAllTierInfo(itemLoc)
    local powerCtr = 0
    
    for azeriteTier, tierInfo in pairs(tierInfo) do
        for _, powerID in pairs(tierInfo.azeritePowerIDs) do
            if (AzeriteEmpoweredItem.IsPowerSelected(itemLoc,powerID)) then
                msg = msg..powerID.."\n"
            end
        end
    end
]]

local function UpdateParentDimensions(spec,group)
	local layout = Auras.db.char.auras[spec].groups[group]
	local parent = SSA["AuraGroup"..group]
	local padding = 15
	local numInUse = 0
	
	for k,v in pairs(Auras.db.char.auras[spec].auras) do
		--SSA.DataFrame.text:SetText("CONDITION ERROR: "..k)
		if (v.group == group and SSA[k].condition() and v.isInUse) then
			numInUse = numInUse + 1
		end
	end
	
	if (numInUse > 0) then
		local x = (numInUse * layout.spacing) + padding
		local y = layout.icon + padding

		if (layout.orientation == "Horizontal") then
			parent:SetSize(x,y)
		else
			parent:SetSize(y,x)
		end
	else
		local x = layout.icon + padding

		parent:SetSize(x,x)
	end
end

local function ToggleCombatEvent(spec)
	--SSA.DataFrame.text:SetText('EXECUTING COMBAT EVENTS\n')
	--if (not Auras.db.char.isFirstEverLoad) then
		for i=1,3 do
			for k,v in pairs(Auras.db.char.timerbars[i].bars) do
				if (i == spec) then
					--if (v.data.condition()) then
					if (not SSA[k].condition) then
						SSA.DataFrame.text:SetText("BAD BAR: "..k)
					end
					if (SSA[k].condition()) then
						--if (not SSA[k]:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED")) then
							SSA[k]:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
							--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..k..": TRUE ("..tostring(SSA[k]:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED"))..")\n")
						--end
					else
						--if (SSA[k]:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED")) then
							--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..k..": FALSE\n")
							SSA[k]:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
						--end
					end
				else
					--if (SSA[k]:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED")) then
					if (not v.isShared) then
						SSA[k]:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
					end
					--end
				end
			end
		end
	--end
end
--/script print(SSA_EarthbindTotem:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED"))
function Auras:UpdateTalents(isTalentChange)
	
	--SSA.spec = GetSpecialization()
	--spec = SSA.spec
	local db = self.db.char
	
	if (db.isFirstEverLoad) then
		return
	end
	
	--[[if (not SSA.isAurasInitialized) then
		SSA.isAurasInitialized = true
		self:InitializeAuras()
	end]]
	
	local spec = GetSpecialization()
	
	if (spec ~= SSA.spec) then
		SSA.spec = spec
	end
	
	--local rowObj,rowList = {},{}
	if (isTalentChange and InterfaceOptionsFrame:IsShown()) then
		InterfaceOptionsFrame:Hide()
	end
	
	SSA.AscendanceBar.spellID = (spec == 1 and 114050) or (spec == 2 and 114051) or (spec == 3 and 114052)
	ToggleCombatEvent(spec)
	
	if (spec == 1) then -- Elemental
		
		--[[if (db.elements[1].timerbars.buff.isEnabled) then
			SSA.BuffTimerBarGrp1:Show()
		else
			SSA.BuffTimerBarGrp1:Hide()
		end
		if (db.elements[1].timerbars.main.isEnabled) then
			SSA.MainTimerBarGrp1:Show()
		else
			SSA.MainTimerBarGrp1:Hide()
		end
		if (db.elements[1].timerbars.util.isEnabled) then
			SSA.UtilTimerBarGrp1:Show()
		else
			SSA.UtilTimerBarGrp1:Hide()
		end]]

		Auras:InitializeCooldowns(spec)
		
		-- Initialize Progress Bars Upon Specialization Change
		--Auras:InitializeProgressBar('HealthBar1',nil,'healthBar','numtext','perctext',1)
		Auras:InitializeProgressBar('MaelstromBar',nil,'text',nil,spec)
		Auras:InitializeProgressBar('CastBar',nil,'nametext','timetext',spec)
		Auras:InitializeProgressBar('ChannelBar',nil,'nametext','timetext',spec)
		Auras:InitializeProgressBar('IcefuryBar','Timer','counttext','timetext',spec)
		
		-- Initialize Frame Groups Upon Specialization Change
		Auras:InitializeAuraFrameGroups(spec)
		Auras:InitializeTimerBarFrameGroups(spec)
		Auras:InitializeTimerBars(spec)
		
		local auras = Auras.db.char.auras[spec]
		
		for i=1,#auras.groups do
			local rowObj,rowList,rowVerify = {},{},{}

			if (auras.groups[i].auraCount > 0) then
				for k,v in pairs(auras.auras) do
					if (v.group == i) then
						local bar = SSA[k]
						
						bar:SetParent(SSA["AuraGroup"..i])
						
						rowObj[v.order] = bar
						rowList[v.order] = v.isEnabled and bar.condition()
						rowVerify[v.order] = v.isInUse or auras.groups[i].isAdjust
					end
				end
				
				if (auras.groups[i].orientation == "Horizontal") then
					BuildHorizontalIconRow(rowObj,rowList,rowVerify,spec,i)
				else
					BuildVerticalIconRow(rowObj,rowList,rowVerify,spec,i)
				end	
			end
			
			UpdateParentDimensions(spec,i)
			
			twipe(rowObj)
			twipe(rowList)
			twipe(rowVerify)
		end		
	elseif (spec == 2) then -- Enhancement
		Auras:InitializeCooldowns(spec)
		
		-- Initialize Progress Bars Upon Specialization Change
		--Auras:InitializeProgressBar('HealthBar1',nil,'healthBar','numtext','perctext',1)
		Auras:InitializeProgressBar('MaelstromBar',nil,'text',nil,spec)
		Auras:InitializeProgressBar('CastBar',nil,'nametext','timetext',spec)
		Auras:InitializeProgressBar('ChannelBar',nil,'nametext','timetext',spec)
		
		-- Initialize Frame Groups Upon Specialization Change
		Auras:InitializeAuraFrameGroups(spec)
		Auras:InitializeTimerBarFrameGroups(spec)
		Auras:InitializeTimerBars(spec)

		local auras = Auras.db.char.auras[spec]
		
		for i=1,#auras.groups do
			local rowObj,rowList,rowVerify = {},{},{}

			if (auras.groups[i].auraCount > 0) then
				for k,v in pairs(auras.auras) do
					if (v.group == i) then
						local bar = SSA[k]
						
						bar:SetParent(SSA["AuraGroup"..i])

						rowObj[v.order] = bar
						rowList[v.order] = v.isEnabled and bar.condition()
						rowVerify[v.order] = v.isInUse or auras.groups[i].isAdjust
					end
				end
				
				if (auras.groups[i].orientation == "Horizontal") then
					BuildHorizontalIconRow(rowObj,rowList,rowVerify,spec,i)
				else
					BuildVerticalIconRow(rowObj,rowList,rowVerify,spec,i)
				end	
			end
			
			UpdateParentDimensions(spec,i)
			
			twipe(rowObj)
			twipe(rowList)
			twipe(rowVerify)
		end
	else -- Restoration
		Auras:InitializeCooldowns(spec)

		-- Initialize Progress Bars Upon Specialization Change
		Auras:InitializeProgressBar('CastBar',nil,'nametext','timetext',spec)
		Auras:InitializeProgressBar('ChannelBar',nil,'nametext','timetext',spec)
		Auras:InitializeProgressBar('ManaBar',nil,'text',nil,spec)
		Auras:InitializeProgressBar('TidalWavesBar',nil,nil,nil,spec)
		Auras:InitializeProgressBar('EarthenWallTotemBar','Timer','healthtext','timetext',spec)

		-- Initialize Frame Groups Upon Specialization Change
		Auras:InitializeAuraFrameGroups(spec)
		Auras:InitializeTimerBarFrameGroups(spec)
		Auras:InitializeTimerBars(spec)
		--if (statusbar:GetName() == "AscendanceBar") then
		--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."BAR DURATION #1: "..tostring(SSA.AscendanceBar.duration).."\n")
		--end
		local auras = Auras.db.char.auras[spec]
		
		for i=1,#auras.groups do
			local rowObj,rowList,rowVerify = {},{},{}

			if (auras.groups[i].auraCount > 0) then
				for k,v in pairs(auras.auras) do
					
					if (v.group == i) then
						local bar = SSA[k]
						
						bar:SetParent(SSA["AuraGroup"..i])

						rowObj[v.order] = bar
						rowList[v.order] = v.isEnabled and bar.condition()
						rowVerify[v.order] = v.isInUse or auras.groups[i].isAdjust
						
						--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..k.." ("..tostring(rowObj[v.order]:GetName())..")\n")
						--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..k.." ("..tostring(SSA[k]:GetParent():GetName())..")\n")
					end
				end
				
				if (auras.groups[i].orientation == "Horizontal") then
					BuildHorizontalIconRow(rowObj,rowList,rowVerify,spec,i)
				else
					BuildVerticalIconRow(rowObj,rowList,rowVerify,spec,i)
				end	
			end
			
			UpdateParentDimensions(spec,i)
			
			twipe(rowObj)
			twipe(rowList)
			twipe(rowVerify)
		end
	end
	
	--Auras:SetupCharges()
end