local FOLDER_NAME = ...
local SSA, Auras, L, LSM = unpack(select(2,...))
local ErrorMsg = ''
SSA.InterfaceListItem = nil

local _G = _G
local floor, fmod = math.floor, math.fmod
local pairs, select, tonumber, tostring = pairs, select, tonumber, tostring
local format,lower = string.format, string.lower
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
function Auras:RetrieveBuffInfo(unit,spellName)
	for i=1,MAX_TARGET_BUFFS do
		local name = UnitBuff(unit,i)

		if (name == spellName) then
			return UnitBuff(unit,i)
		end
	end
end


-- Searches through the unit's debuffs for a specific debuff, by name
function Auras:RetrieveDebuffInfo(unit,spellName)
	for i=1,MAX_TARGET_DEBUFFS do
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
function Auras:CreateVerticalStatusBar(statusbar,spec,db,ctr)
	--local db = Auras.db.char.timerbars[spec][barName]
	--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..statusbar:GetName()..": "..tostring(db.layout.group).."\n")
	
	local timerbars = Auras.db.char.timerbars[spec]
	local timerbar = timerbars.bars[statusbar:GetName()]
	local barInfo = timerbars.groups[timerbar.layout.group]
	--local layout = Auras.db.char.layout[spec].timerbars.groups[db.group].layout
	
	
	if (not db) then
		SSA.DataFrame.text:SetText("DB ERROR: Core\\functions.lua:443: "..tostring(barName)..", "..tostring(db.text)..", "..ctr)
	end
	

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
		statusbar:SetMinMaxValues(0,db.data.duration)
		statusbar:Hide()

		statusbar.duration = duration
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
		statusbar.nametext:SetText(db.layout.text)
		
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
			SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..i..". "..rowObj[i]:GetName().." ("..tostring(rowList[i])..", "..tostring(rowVerify[i])..")\n")
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
		--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..i.." ("..rowObj[i]:GetParent():GetName()..": "..tostring(rowList[i])..")\n")
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
		if (v.group == group and v.condition() and v.isInUse) then
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
	for i=1,3 do
		for k,v in pairs(Auras.db.char.timerbars[i].bars) do
			if (i == spec) then
				if (v.data.condition()) then
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
end
--/script print(SSA_EarthbindTotem:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED"))
function Auras:UpdateTalents(isTalentChange)
	
	--SSA.spec = GetSpecialization()
	--spec = SSA.spec
	local spec = GetSpecialization()
	local db = Auras.db.char
	
	--local rowObj,rowList = {},{}
	if (isTalentChange and InterfaceOptionsFrame:IsShown()) then
		InterfaceOptionsFrame:Hide()
	end
	
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
						
						SSA[k]:SetParent(SSA["AuraGroup"..i])

						rowObj[v.order] = SSA[k]
						rowList[v.order] = v.isEnabled and v.condition()
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
		
		--[[
		------------------------------------------------------------
		---- Primary Aura Group #1
		----
		
		rowObj = {
			[1] = SSA.FlameShock,
			[2] = SSA.EarthShock,
			[3] = SSA.LavaBurst1,
			[4] = SSA.Earthquake,
			[5] = SSA.ElementalBlast,
		}
		
		rowList = {
			[1] = db.auras[1].FlameShock and IsSpellKnown(188389),
			[2] = db.auras[1].EarthShock and IsSpellKnown(8042),
			[3] = db.auras[1].LavaBurst and IsSpellKnown(51505),
			[4] = db.auras[1].Earthquake and IsSpellKnown(61882),
			[5] = db.auras[1].ElementalBlast and select(4,GetTalentInfo(1,3,1)),
		}
		
		if (Auras.db.char.layout[1].orientation.top == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,1,'primary','top')
		else
			BuildVerticalIconRow(rowObj,rowList,0,1,'primary','top')
		end
		
		------------------------------------------------------------
		---- Primary Aura Group #2
		----
		
		rowObj = {
			[1] = SSA.FireElemental,
			[2] = SSA.StormElemental,
			[3] = SSA.Stormkeeper,
			[4] = SSA.Ascendance1,
			[5] = SSA.LiquidMagmaTotem,
			[6] = SSA.Icefury,
		}

		rowList = {
			[1] = db.auras[1].FireElemental and not select(4,GetTalentInfo(4,2,1)) and IsSpellKnown(198067),
			[2] = db.auras[1].StormElemental and select(4,GetTalentInfo(4,2,1)),
			[3] = db.auras[1].Stormkeeper and select(4,GetTalentInfo(7,2,1)),
			[4] = db.auras[1].Ascendance and select(4,GetTalentInfo(7,3,1)),
			[5] = db.auras[1].LiquidMagmaTotem and select(4,GetTalentInfo(4,3,1)),
			[6] = db.auras[1].Icefury and select(4,GetTalentInfo(6,3,1)),
		}
		
		if (Auras.db.char.layout[1].orientation.bottom == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,1,'primary','bottom')
		else
			BuildVerticalIconRow(rowObj,rowList,0,1,'primary','bottom')
		end
		
		------------------------------------------------------------
		---- Primary Aura Group #3 (ADDED IN 8.0)
		----
		
		rowObj = {
			[1] = SSA.UnlimitedPower,
			[2] = SSA.EarthShield1,
			[3] = SSA.ExposedElements,
			[4] = SSA.NaturesGuardian1,
			[5] = SSA.MasterOfElements,
			[6] = SSA.EarthenStrength,
		}
		
		rowList = {
			[1] = db.auras[1].UnlimitedPower and select(4,GetTalentInfo(7,1,1)),
			[2] = db.auras[1].EarthShield1 and select(4,GetTalentInfo(3,2,1)),
			[3] = db.auras[1].ExposedElements and select(4,GetTalentInfo(1,1,1)),
			[4] = db.auras[1].NaturesGuardian1 and select(4,GetTalentInfo(5,1,1)),
			[5] = db.auras[1].MasterOfElements and select(4,GetTalentInfo(2,2,1)),
			[6] = db.auras[1].EarthenStrength and Auras:GetEleT21SetCount() >= 2,
		}

		if (Auras.db.char.layout[1].orientation.extra == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,1,'primary','extra')
		else
			BuildVerticalIconRow(rowObj,rowList,0,1,'primary','extra')
		end
		
		------------------------------------------------------------
		---- PvP Aura Group (ADDED IN 8.0)
		----

		local isPvpActive = Auras:IsPvPZone()

		rowObj = {
			[1] = SSA.Adaptation1,
			[2] = SSA.GladiatorsMedallion1,
			[3] = SSA.LightningLasso,
			[4] = SSA.SkyfuryTotem1,
			[5] = SSA.CounterstrikeTotem1,
			[6] = SSA.GroundingTotem1,
		}
		
		rowList = {
			[1] = db.auras[1].Adaptation1 and select(10,GetPvpTalentInfoByID(3597)) and isPvpActive,
			[2] = db.auras[1].GladiatorsMedallion1 and select(10,GetPvpTalentInfoByID(3598)) and isPvpActive,
			[3] = db.auras[1].LightningLasso and select(10,GetPvpTalentInfoByID(731)) and isPvpActive,
			[4] = db.auras[1].SkyfuryTotem1 and select(10,GetPvpTalentInfoByID(3488)) and isPvpActive,
			[5] = db.auras[1].CounterstrikeTotem1 and select(10,GetPvpTalentInfoByID(3490)) and isPvpActive,
			[6] = db.auras[1].GroundingTotem1 and select(10,GetPvpTalentInfoByID(3620)) and isPvpActive,
		}

		if (Auras.db.char.layout[1].orientation.pvp == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,1,'primary','pvp')
		else
			BuildVerticalIconRow(rowObj,rowList,0,1,'primary','pvp')
		end
		
		------------------------------------------------------------
		---- Left Icon Row
		----
		
		rowObj = {
			[1] = SSA.WindShear1,
			[2] = SSA.AstralShift1,
			[3] = SSA.Hex1,
			[4] = SSA.AncestralGuidance1,
			[5] = SSA.WindRushTotem1,
			[6] = SSA.CleanseSpirit1,
		}
		
		rowList = {
			[1] = db.auras[1].WindShear1 and IsSpellKnown(57994),
			[2] = db.auras[1].AstralShift1 and IsSpellKnown(108271),
			[3] = db.auras[1].Hex1 and IsSpellKnown(51514),
			[4] = db.auras[1].AncestralGuidance1 and select(4,GetTalentInfo(5,2,1)),
			[5] = db.auras[1].WindRushTotem1 and select(4,GetTalentInfo(5,3,1)),
			[6] = db.auras[1].CleanseSpirit1 and IsSpellKnown(51886),
		}
		
		if (Auras.db.char.layout[1].orientation.left == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,1,'secondary','left')
		else
			BuildVerticalIconRow(rowObj,rowList,0,1,'secondary','left')
		end
		
		------------------------------------------------------------
		---- Right Icon Row
		----
		
		rowObj = {
			[1] = SSA.Thunderstorm,
			[2] = SSA.EarthElemental,
			[3] = SSA.CapacitorTotem1,
			[4] = SSA.EarthbindTotem1,
			[5] = SSA.TremorTotem1,
		}
		
		rowList = {
			[1] = db.auras[1].Thunderstorm and IsSpellKnown(51490),
			[2] = db.auras[1].EarthElemental and IsSpellKnown(198103),
			[3] = db.auras[1].CapacitorTotem1 and IsSpellKnown(192058),
			[4] = db.auras[1].EarthbindTotem1 and IsSpellKnown(2484),
			[5] = db.auras[1].TremorTotem1 and IsSpellKnown(8143),
		}
		
		if (Auras.db.char.layout[1].orientation.right == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,1,'secondary','right')
		else
			BuildVerticalIconRow(rowObj,rowList,0,1,'secondary','right')
		end]]
		
		-- Show Elemental-only Objects
		--[[SSA.FlameShockGlow:Show()
		SSA.EarthShockGlow:Show()
		SSA.LavaBurstGlow:Show()]]
		
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
						
						SSA[k]:SetParent(SSA["AuraGroup"..i])

						rowObj[v.order] = SSA[k]
						rowList[v.order] = v.isEnabled and v.condition()
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
		--[[Auras:ToggleAuraVisibility(2)
		if (db.elements[2].timerbars.buff.isEnabled) then
			SSA.BuffTimerBarGrp2:Show()
		else
			SSA.BuffTimerBarGrp2:Hide()
		end
		if (db.elements[2].timerbars.main.isEnabled) then
			SSA.MainTimerBarGrp2:Show()
		else
			SSA.MainTimerBarGrp2:Hide()
		end
		if (db.elements[2].timerbars.util.isEnabled) then
			SSA.UtilTimerBarGrp2:Show()
		else
			SSA.UtilTimerBarGrp2:Hide()
		end
		
		-- Initialize Progress Bars Upon Specialization Change
		Auras:InitializeProgressBar('MaelstromBar2',nil,'maelstromBar','text',nil,2)
		Auras:InitializeProgressBar('CastBar2',nil,'castBar','nametext','timetext',2)
		Auras:InitializeProgressBar('ChannelBar2',nil,'channelBar','nametext','timetext',2)
		
		-- Initialize Frame Groups Upon Specialization Change
		Auras:InitializeAuraFrameGroup(Auras.db.char.elements[2])

		------------------------------------------------------------
		---- Top Icon Row
		----
		
		rowObj = {
			[1] = SSA.Flametongue,
			[2] = SSA.Frostbrand,
			[3] = SSA.Stormstrike,
			[4] = SSA.CrashLightning,
			[5] = SSA.LavaLash
		}
		
		rowList = {
			[1] = db.auras[2].Flametongue and IsSpellKnown(193796),
			[2] = db.auras[2].Frostbrand and IsSpellKnown(196834),
			[3] = db.auras[2].Stormstrike and IsSpellKnown(17364),
			[4] = db.auras[2].CrashLightning and IsSpellKnown(187874),
			[5] = db.auras[2].LavaLash and IsSpellKnown(60103),
		}
		
		--BuildHorizontalIconRow(rowObj,rowList,0,2,'top')
		if (Auras.db.char.layout[2].orientation.top == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,2,'primary','top')
		else
			BuildVerticalIconRow(rowObj,rowList,0,2,'primary','top')
		end
		
		------------------------------------------------------------
		---- Bottom Icon Row
		----
		
		rowObj = {
			[1] = SSA.Rockbiter,
			[2] = SSA.Ascendance2,
			[3] = SSA.EarthenSpike,
			[4] = SSA.Sundering,
			[5] = SSA.FeralSpirit,
		}
		
		rowList = {
			[1] = db.auras[2].Rockbiter and IsSpellKnown(193786),
			[2] = db.auras[2].Ascendance2 and select(4,GetTalentInfo(7,3,1)),
			[3] = db.auras[2].EarthenSpike and select(4,GetTalentInfo(7,2,1)),
			[4] = db.auras[2].Sundering and select(4,GetTalentInfo(6,3,1)),
			[5] = db.auras[2].FeralSpirit and IsSpellKnown(51533),
		}
		
		--BuildHorizontalIconRow(rowObj,rowList,0,2,'bottom')
		if (Auras.db.char.layout[2].orientation.bottom == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,2,'primary','bottom')
		else
			BuildVerticalIconRow(rowObj,rowList,0,2,'primary','bottom')
		end
		
		------------------------------------------------------------
		---- Primary Aura Group #3
		----
		
		--local _,_,name,_,_,rank = C_ArtifactUI.GetEquippedArtifactInfo()
		
		rowObj = {
			--[1] = SSA.DoomWinds,
			--[2] = SSA.UnleashDoom,
			--[3] = SSA.Concordance2,
			[1] = SSA.ForcefulWinds,
			[2] = SSA.EarthShield2,
			[3] = SSA.NaturesGuardian2,
		}
		
		rowList = {
			[1] = db.auras[2].ForcefulWinds and select(4,GetTalentInfo(2,2,1)),
			[2] = db.auras[2].EarthShield2 and select(4,GetTalentInfo(3,2,1)),
			[3] = db.auras[2].NaturesGuardian2 and select(4,GetTalentInfo(5,1,1)),
			--[1] = db.auras[2].DoomWinds and name ~= nil,
			--[2] = db.auras[2].UnleashDoom and name ~= nil,
			--[3] = db.auras[2].Concordance2 and (rank or 0) >= 52,
		}

		if (Auras.db.char.layout[2].orientation.extra == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,2,'primary','extra')
		else
			BuildVerticalIconRow(rowObj,rowList,0,2,'primary','extra')
		end
		
		------------------------------------------------------------
		---- PvP Aura Group (ADDED IN 8.0)
		----

		local isPvpActive = Auras:IsPvPZone()

		rowObj = {
			[1] = SSA.Adaptation2,
			[2] = SSA.GladiatorsMedallion2,
			[3] = SSA.SkyfuryTotem2,
			[4] = SSA.CounterstrikeTotem2,
			[5] = SSA.GroundingTotem2,
			[6] = SSA.EtherealForm,
			[7] = SSA.StaticCling,
			[8] = SSA.Thundercharge,
		}
		
		rowList = {
			[1] = db.auras[2].Adaptation2 and select(10,GetPvpTalentInfoByID(3552)) and isPvpActive,
			[2] = db.auras[2].GladiatorsMedallion2 and select(10,GetPvpTalentInfoByID(3551)) and isPvpActive,
			[3] = db.auras[2].SkyfuryTotem2 and select(10,GetPvpTalentInfoByID(3487)) and isPvpActive,
			[4] = db.auras[2].CounterstrikeTotem2 and select(10,GetPvpTalentInfoByID(3489)) and isPvpActive,
			[5] = db.auras[2].GroundingTotem2 and select(10,GetPvpTalentInfoByID(3622)) and isPvpActive,
			[6] = db.auras[2].EtherealForm and select(10,GetPvpTalentInfoByID(1944)) and isPvpActive,
			[7] = db.auras[2].StaticCling and select(10,GetPvpTalentInfoByID(720)) and isPvpActive,
			[8] = db.auras[2].Thundercharge and select(10,GetPvpTalentInfoByID(725)) and isPvpActive,
		}

		if (Auras.db.char.layout[1].orientation.pvp == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,1,'primary','pvp')
		else
			BuildVerticalIconRow(rowObj,rowList,0,1,'primary','pvp')
		end
		
		------------------------------------------------------------
		---- Left Icon Row
		----
		
		rowObj = {
			[1] = SSA.WindShear2,
			[2] = SSA.Hex2,
			[3] = SSA.CleanseSpirit2,
			[4] = SSA.SpiritWalk,
			[5] = SSA.AstralShift2,
		}
		
		rowList = {
			[1] = db.auras[2].WindShear2 and IsSpellKnown(57994),
			[2] = db.auras[2].Hex2 and IsSpellKnown(51514),
			[3] = db.auras[2].CleanseSpirit2 and IsSpellKnown(51886),
			[4] = db.auras[2].SpiritWalk and IsSpellKnown(58875),
			[5] = db.auras[2].AstralShift2 and IsSpellKnown(108271),
		}

		--BuildVerticalIconRow(rowObj,rowList,0,2,'left')
		if (Auras.db.char.layout[2].orientation.left == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,2,'secondary','left')
		else
			BuildVerticalIconRow(rowObj,rowList,0,2,'secondary','left')
		end
		
		------------------------------------------------------------
		---- Right Icon Row
		----
		
		rowObj = {
			
			[1] = SSA.CapacitorTotem2,
			[2] = SSA.EarthbindTotem2,
			[3] = SSA.TremorTotem2,
			[4] = SSA.WindRushTotem2,
			[5] = SSA.FeralLunge,
		}
		
		rowList = {
			[1] = db.auras[2].CapacitorTotem2 and IsSpellKnown(192058),
			[2] = db.auras[2].EarthbindTotem2 and IsSpellKnown(2484),
			[3] = db.auras[2].TremorTotem2 and IsSpellKnown(8143),
			[4] = db.auras[2].WindRushTotem2 and select(4,GetTalentInfo(5,3,1)),
			[5] = db.auras[2].FeralLunge and select(4,GetTalentInfo(5,2,1)),
		}

		--BuildVerticalIconRow(rowObj,rowList,0,2,'right')		
		if (Auras.db.char.layout[2].orientation.right == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,2,'secondary','right')
		else
			BuildVerticalIconRow(rowObj,rowList,0,2,'secondary','right')
		end]]
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

		local auras = Auras.db.char.auras[spec]
		
		for i=1,#auras.groups do
			local rowObj,rowList,rowVerify = {},{},{}

			if (auras.groups[i].auraCount > 0) then
				for k,v in pairs(auras.auras) do
					
					if (v.group == i) then
						
						SSA[k]:SetParent(SSA["AuraGroup"..i])
						
						rowObj[v.order] = SSA[k]
						rowList[v.order] = v.isEnabled and v.condition()
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
		--[[if (db.elements[3].timerbars.buff) then
			SSA.BuffTimerBarGrp3:Show()
		else
			SSA.BuffTimerBarGrp3:Hide()
		end
		if (db.elements[3].timerbars.main) then
			SSA.MainTimerBarGrp3:Show()
		else
			SSA.MainTimerBarGrp3:Hide()
		end
		if (db.elements[3].timerbars.util) then
			SSA.UtilTimerBarGrp3:Show()
		else
			SSA.UtilTimerBarGrp3:Hide()
		end

		--local _,_,name,_,_,rank = C_ArtifactUI.GetEquippedArtifactInfo()
		
		-- Initialize Progress Bars Upon Specialization Change
		Auras:InitializeProgressBar('CastBar3',nil,'castBar','nametext','timetext',3)
		Auras:InitializeProgressBar('ChannelBar3',nil,'channelBar','nametext','timetext',3)
		Auras:InitializeProgressBar('ManaBar',nil,'manaBar','text',nil,3)
		Auras:InitializeProgressBar('TidalWavesBar',nil,'tidalWavesBar',nil,nil,3)
		Auras:InitializeProgressBar('EarthenWallTotemBar','Timer','earthenWallBar','healthtext','timetext',3)
		
		-- Initialize Frame Groups Upon Specialization Change
		Auras:InitializeAuraFrameGroup(Auras.db.char.elements[3])
		
		------------------------------------------------------------
		---- Top Icon Row
		----
		
		rowObj = {
			[1] = SSA.Riptide,
			[2] = SSA.HealingStreamTotem,
			[3] = SSA.CloudburstTotem,
			[4] = SSA.Downpour,
			[5] = SSA.HealingRain,
			[6] = SSA.UnleashLife
		}
		
		rowList = {
			[1] = db.auras[3].Riptide and IsSpellKnown(61295),
			[2] = db.auras[3].HealingStreamTotem and IsSpellKnown(5394),
			[3] = db.auras[3].CloudburstTotem and select(4,GetTalentInfo(6,3,1)),
			[4] = db.auras[3].Downpour and select(4,GetTalentInfo(6,2,1)),
			[5] = db.auras[3].HealingRain and IsSpellKnown(73920),
			[6] = db.auras[3].UnleashLife and select(4,GetTalentInfo(1,3,1)),
		}

		if (Auras.db.char.layout[3].orientation.top == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,3,'primary','top')
		else
			BuildVerticalIconRow(rowObj,rowList,0,3,'primary','top')
		end
		
		------------------------------------------------------------
		---- Bottom Icon Row
		----
		
		rowObj = {
			[1] = SSA.HealingTideTotem,
			[2] = SSA.SpiritLinkTotem,
			[3] = SSA.Ascendance3,
			[4] = SSA.Wellspring,
			[5] = SSA.EarthenWallTotem,
			[6] = SSA.AncestralProtectionTotem,
			[7] = SSA.WindRushTotem3,
		}
		
		rowList = {
			[1] = db.auras[3].HealingTideTotem and IsSpellKnown(108280),
			[2] = db.auras[3].SpiritLinkTotem and IsSpellKnown(98008),
			[3] = db.auras[3].Ascendance3 and select(4,GetTalentInfo(7,3,1)),
			[4] = db.auras[3].Wellspring and select(4,GetTalentInfo(7,2,1)),
			[5] = db.auras[3].EarthenWallTotem and select(4,GetTalentInfo(4,2,1)),
			[6] = db.auras[3].AncestralProtectionTotem and select(4,GetTalentInfo(4,3,1)),
			[7] = db.auras[3].WindRushTotem3 and select(4,GetTalentInfo(5,3,1)),
		}
		
		if (Auras.db.char.layout[3].orientation.bottom == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,3,'primary','bottom')
		else
			BuildVerticalIconRow(rowObj,rowList,0,3,'primary','bottom')
		end
		
		------------------------------------------------------------
		---- Primary Aura Group #3
		----
		
		rowObj = {
			[1] = SSA.EarthShield3,
			[2] = SSA.FlashFlood,
			[3] = SSA.NaturesGuardian3,
		}
		
		rowList = {
			[1] = db.auras[3].EarthShield3 and select(4,GetTalentInfo(2,3,1)),
			[2] = db.auras[3].FlashFlood and select(4,GetTalentInfo(6,1,1)),
			[3] = db.auras[3].NaturesGuardian3 and select(4,GetTalentInfo(5,1,1)),
		}

		if (Auras.db.char.layout[3].orientation.extra == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,3,'primary','extra')
		else
			BuildVerticalIconRow(rowObj,rowList,0,3,'primary','extra')
		end
		
		------------------------------------------------------------
		---- PvP Aura Group (ADDED IN 8.0)
		----

		local isPvpActive = Auras:IsPvPZone()

		rowObj = {
			[1] = SSA.Adaptation3,
			[2] = SSA.GladiatorsMedallion3,
			[3] = SSA.SkyfuryTotem3,
			[4] = SSA.CounterstrikeTotem3,
			[5] = SSA.GroundingTotem3,
			[6] = SSA.Tidebringer,
		}
		
		rowList = {
			[1] = db.auras[3].Adaptation3 and select(10,GetPvpTalentInfoByID(3485)) and isPvpActive,
			[2] = db.auras[3].GladiatorsMedallion3 and select(10,GetPvpTalentInfoByID(3484)) and isPvpActive,
			[3] = db.auras[3].SkyfuryTotem3 and select(10,GetPvpTalentInfoByID(707)) and isPvpActive,
			[4] = db.auras[3].CounterstrikeTotem3 and select(10,GetPvpTalentInfoByID(708)) and isPvpActive,
			[5] = db.auras[3].GroundingTotem3 and select(10,GetPvpTalentInfoByID(715)) and isPvpActive,
			[6] = db.auras[3].Tidebringer and select(10,GetPvpTalentInfoByID(1930)) and isPvpActive,
		}

		if (Auras.db.char.layout[3].orientation.pvp == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,3,'primary','pvp')
		else
			BuildVerticalIconRow(rowObj,rowList,0,3,'primary','pvp')
		end
		
		------------------------------------------------------------
		---- Left Icon Row
		----
		
		rowObj = {
			[1] = SSA.WindShear3,
			[2] = SSA.Hex3,
			[3] = SSA.AstralShift3,
			[4] = SSA.PurifySpirit,
			[5] = SSA.SpiritwalkersGrace,
		}
		
		rowList = {
			[1] = db.auras[3].WindShear3 and IsSpellKnown(57994),
			[2] = db.auras[3].Hex3 and IsSpellKnown(51514),
			[3] = db.auras[3].AstralShift3 and IsSpellKnown(108271),
			[4] = db.auras[3].PurifySpirit and IsSpellKnown(77130),
			[5] = db.auras[3].SpiritwalkersGrace and IsSpellKnown(79206),
		}

		--BuildVerticalIconRow(rowObj,rowList,0,3,'left')
		if (Auras.db.char.layout[3].orientation.left == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,3,'secondary','left')
		else
			BuildVerticalIconRow(rowObj,rowList,0,3,'secondary','left')
		end
		
		------------------------------------------------------------
		---- Right Icon Row
		----
		
		rowObj = {
			[1] = SSA.FlameShock3,
			[2] = SSA.LavaBurst3,
			[3] = SSA.CapacitorTotem3,
			[4] = SSA.EarthbindTotem3,
			[5] = SSA.EarthgrabTotem,
		}
		
		rowList = {
			[1] = db.auras[3].FlameShock3 and IsSpellKnown(188838),
			[2] = db.auras[3].LavaBurst3 and IsSpellKnown(51505),
			[3] = db.auras[3].CapacitorTotem3 and IsSpellKnown(192058),
			[4] = db.auras[3].EarthbindTotem3 and IsSpellKnown(2484),
			[5] = db.auras[3].EarthgrabTotem and select(4,GetTalentInfo(3,2,1)),
		}

		--BuildVerticalIconRow(rowObj,rowList,0,3,'right')	
		if (Auras.db.char.layout[3].orientation.right == "Horizontal") then
			BuildHorizontalIconRow(rowObj,rowList,0,3,'secondary','right')
		else
			BuildVerticalIconRow(rowObj,rowList,0,3,'secondary','right')
		end]]
	end
	
	--Auras:SetupCharges()
end