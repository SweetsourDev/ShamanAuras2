--[[---------------------------------------------------------------
	
	Developed by: Sweetsour-Firetree
	
------------------------------------------------------------------]]

local FOLDER_NAME, Engine = ...

local SSA = {
	spec = GetSpecialization(),
	isFlametongue = false,
}

local Auras = LibStub('AceAddon-3.0'):NewAddon('ShamanAurasDev', 'AceConsole-3.0','AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0');
Auras.version = GetAddOnMetadata('ShamanAurasDev', 'Version')
Auras:RegisterChatCommand('ssa','ChatCommand')
local L = LibStub('AceLocale-3.0'):GetLocale('ShamanAurasDev', false)
local LSM = LibStub('LibSharedMedia-3.0')
local LBG = LibStub("LibButtonGlow-1.0")

Engine[1] = SSA
Engine[2] = Auras
Engine[3] = L
Engine[4] = LSM
Engine[5] = LBG

-- Cache Global Variables
-- Lua Function
local match, sub = string.match, string.sub
local tinsert, twipe = table.insert, table.wipe
-- WoW API / Variables
local CreateFont, CreateFrame = CreateFont, CreateFrame
local GetSpecialization, GetSpecializationInfo = GetSpecialization, GetSpecializationInfo
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo

-------------------------------------------------------------------------------------------------------
----- Initialize Global Variables
-------------------------------------------------------------------------------------------------------
SSA.BackdropCB = {
	bgFile    = [[Interface\Tooltips\UI-Tooltip-Background]],
	edgeFile  = [[Interface\AddOns\ShamanAuras2\Media\textures\UI-Tooltip-Border]],
	tile      = false,
	tileSize  = 16, 
	edgeSize  = 16, 
	insets     = {
		left = 4,
		right = 4,
		top = 4,
		bottom = 4,
	},
}

SSA.BackdropSB = {
	bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	tile = true,
	tileSize = 16,
	edgeSize = 10
}
_G["SSA_Backdrop"] = SSA.BackdropSB
SSA.BackdropFrm = {
	bgFile   = [[Interface\BUTTONS\WHITE8X8.blp]],
	edgeFile = [[Interface\BUTTONS\WHITE8X8.blp]],
	tile = false, tileSize = 0, edgeSize = 1,
	insets = { left = 0, right = 0, top = 0, bottom = 0}
}

SSA.activeTotems = {}
SSA.spec = GetSpecialization()
--SSA.grid = CreateFrame('Frame', 'AuraGrid', UIParent)
--SSA.IsMovingAuras = false;
SSA.ButtonFont = CreateFont('SSAButtonFont')
local ButtonFont = SSA.ButtonFont
ButtonFont:SetFont([[Interface\addons\ShamanAuras2\Media\fonts\Continuum_Medium.ttf]],12,'OUTLINE')
ButtonFont:SetJustifyH('CENTER')

local Frame = CreateFrame('Frame')
local UpdateFrame = CreateFrame('Frame')

------------------------------
--- For Debugging Purposes ---
------------------------------

SSA.ErrorFrame = CreateFrame('Frame',nil,UIParent,BackdropTemplateMixin and "BackdropTemplate")
_G['SSA_ErrorFrame'] = SSA.ErrorFrame
local ErrorFrame = SSA.ErrorFrame
ErrorFrame:SetWidth(260)
ErrorFrame:SetHeight(665)
ErrorFrame:SetPoint('TOPLEFT',UIParent,'TOPLEFT',100,-100)
ErrorFrame:SetBackdrop(SSA.BackdropSB)
ErrorFrame:SetBackdropColor(0.15,0.15,0.15,0.9)
ErrorFrame:SetBackdropBorderColor(1,1,1,1)
ErrorFrame:Hide()

ErrorFrame.text = ErrorFrame:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
ErrorFrame.text:SetPoint('TOPLEFT',11,-5)
ErrorFrame.text:SetFont([[Interface\addons\ShamanAurasDev\Media\fonts\courbd.ttf]], 14,'NONE')
ErrorFrame.text:SetTextColor(1,1,1,1)
ErrorFrame.text:SetJustifyH('LEFT')

------------------------------
--- For Debugging Purposes ---
------------------------------
local DataFrame = CreateFrame('Frame',nil,UIParent,BackdropTemplateMixin and "BackdropTemplate")
DataFrame:SetWidth(700)
DataFrame:SetHeight(300)
DataFrame:SetPoint('TOPLEFT',UIParent,'TOPLEFT',100,-100)
DataFrame:SetBackdrop(SSA.BackdropSB)
DataFrame:SetBackdropColor(0.15,0.15,0.15,0.9)
DataFrame:SetBackdropBorderColor(1,1,1,1)
DataFrame:Hide()

DataFrame.text = DataFrame:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
DataFrame.text:SetPoint('TOPLEFT',11,-5);
DataFrame.text:SetFont([[Interface\addons\ShamanAurasDev\Media\fonts\courbd.ttf]] or LSM.DefaultMedia.font, 14,'NONE')
DataFrame.text:SetTextColor(1,1,1,1)
DataFrame.text:SetJustifyH('LEFT')

SSA.DataFrame = DataFrame
_G['SSA_DataFrame'] = DataFrame

----------------------------
--- Introduction Display ---
----------------------------


-- Initialize Check Button Frames
--SSA.MoveEle = CreateFrame('Frame','MoveEle',UIParent)
--SSA.MoveEnh = CreateFrame('Frame','MoveEnh',UIParent)
--SSA.MoveRes = CreateFrame('Frame','MoveRes',UIParent)

function Auras:CopyTableValues(src,desc,isIndex)
	if (isIndex) then
		for k,v in ipairs(desc) do
			if (type(v) == "table")  then
				src[k] = {}
				Auras:CopyTableValues(src[k],desc[k])
			else
				src[k] = v
			end
		end
	else
		for k,v in pairs(desc) do
			if (type(v) == "table")  then
				src[k] = {}
				Auras:CopyTableValues(src[k],desc[k])
			else
				src[k] = v
			end
		end
	end
end

local function ResetAdjustable()
	local db = Auras.db.char

	for i=1,3 do
		--db.auras[1].cooldowns.adjust = false
		for j=1,#db.auras[i].groups do
			db.auras[i].groups[j].isAdjust = false
			db.auras[i].cooldowns.groups[j].isPreview = false
		end
		--[[db.elements[1].cooldowns.primary[2].isPreview = false
		db.elements[1].cooldowns.primary[2].isPreview = false
		db.elements[1].cooldowns.secondary[1].isPreview = false
		db.elements[1].cooldowns.secondary[2].isPreview = false]]
		--db.elements[1].statusbars.healthBar.adjust.isEnabled = false
		--db.elements[1].statusbars.healthBar.adjust.showBG = false
		for k,v in pairs(Auras.db.char.statusbars[i].bars) do
			v.adjust.isEnabled = false
			v.adjust.showBG = false
		end
	end
	--[[db.elements[1].statusbars.maelstromBar.adjust.isEnabled = false
	db.elements[1].statusbars.maelstromBar.adjust.showBG = false
	db.elements[1].statusbars.castBar.adjust.isEnabled = false
	db.elements[1].statusbars.castBar.adjust.showBG = false
	db.elements[1].statusbars.channelBar.adjust.isEnabled = false
	db.elements[1].statusbars.channelBar.adjust.showBG = false
	db.elements[1].statusbars.icefuryBar.adjust.isEnabled = false
	db.elements[1].statusbars.icefuryBar.adjust.showBG = false
	db.elements[1].statusbars.icefuryBar.adjust.showTimer = false]]
	
	--[[db.elements[2].cooldowns.adjust = false
	db.elements[2].cooldowns.primary[1].isPreview = false
	db.elements[2].cooldowns.primary[2].isPreview = false
	db.elements[2].cooldowns.primary[2].isPreview = false
	db.elements[2].cooldowns.secondary[1].isPreview = false
	db.elements[2].cooldowns.secondary[2].isPreview = false
	db.elements[2].statusbars.maelstromBar.adjust.isEnabled = false
	db.elements[2].statusbars.maelstromBar.adjust.showBG = false
	db.elements[2].statusbars.castBar.adjust.isEnabled = false
	db.elements[2].statusbars.castBar.adjust.showBG = false
	db.elements[2].statusbars.channelBar.adjust.isEnabled = false
	db.elements[2].statusbars.channelBar.adjust.showBG = false
	
	db.elements[3].cooldowns.adjust = false
	db.elements[3].cooldowns.primary[1].isPreview = false
	db.elements[3].cooldowns.primary[2].isPreview = false
	db.elements[3].cooldowns.primary[2].isPreview = false
	db.elements[3].cooldowns.secondary[1].isPreview = false
	db.elements[3].cooldowns.secondary[2].isPreview = false
	db.elements[3].statusbars.earthenWallBar.adjust.isEnabled = false
	db.elements[3].statusbars.earthenWallBar.adjust.showBG = false
	db.elements[3].statusbars.earthenWallBar.adjust.showTimer = false
	db.elements[3].statusbars.tidalWavesBar.adjust.isEnabled = false
	db.elements[3].statusbars.manaBar.adjust.isEnabled = false
	db.elements[3].statusbars.manaBar.adjust.showBG = false
	db.elements[3].statusbars.castBar.adjust.isEnabled = false
	db.elements[3].statusbars.castBar.adjust.showBG = false
	db.elements[3].statusbars.channelBar.adjust.isEnabled = false
	db.elements[3].statusbars.channelBar.adjust.showBG = false]]
end

-- Aura Group Builder
function Auras:CreateGroup(name,parent,itr)
	local Group = CreateFrame('Frame',name..(itr or ''),parent,BackdropTemplateMixin and "BackdropTemplate")
	Group:SetFrameStrata("BACKGROUND")
	Group:RegisterForDrag('LeftButton')
	
	SSA[name..(itr or '')] = Group
	return Group
end

_G["SSA_private_db"] = SSA
	
function Auras:BuildAuraGroups()
	
	--local AuraGroup = {}

	for i=1,3 do
		local auras = Auras.db.char.auras[i]
		local timerbars = Auras.db.char.timerbars[i]
		
		for j=1,#auras.groups do
			if (not SSA["AuraGroup"..j]) then
				local AuraGroup = Auras:CreateGroup('AuraGroup',SSA.AuraBase,j)
				
				AuraGroup.header = AuraGroup:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
				AuraGroup.header:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 12,'OUTLINE')
				AuraGroup.header:SetPoint('TOPLEFT',5,5)
				AuraGroup.header:SetTextColor(1,1,1,1)
				AuraGroup.header:SetText(auras.groups[j].name)
				AuraGroup.header:Hide()
				
				--[[AuraGroup:SetScript('OnUpdate',function(self,button)
					Auras:ToggleFrameMove(self,Auras.db.char.settings.move.isMoving)
				end)

				AuraGroup:SetScript('OnMouseDown',function(self,button)
					if (Auras.db.char.settings.move.isMoving) then
						Auras:MoveOnMouseDown(self,button)
					end
				end)

				AuraGroup:SetScript('OnMouseUp',function(self,button)
					if (Auras.db.char.settings.move.isMoving) then
						Auras:MoveOnMouseUp(self,button)
						Auras:UpdateLayout(self,auras.frames[j])
					end
				end)]]
				
				_G["SSA_AuraGroup"..j] = AuraGroup
			end
		end
		for j=1,#timerbars.groups do
			if (not SSA["BarGroup"..j]) then
				local BarGroup = Auras:CreateGroup('BarGroup',SSA.AuraBase,j)
				
				BarGroup.header = BarGroup:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
				BarGroup.header:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 12,'OUTLINE')
				BarGroup.header:SetPoint('TOPLEFT',5,5)
				BarGroup.header:SetTextColor(1,1,1,1)
				BarGroup.header:SetText(timerbars.groups[j].name)
				BarGroup.header:Hide()
				
				BarGroup:SetScript('OnUpdate',function(self,button)
					Auras:ToggleFrameMove(self,Auras.db.char.settings.move.isMoving,j)
				end)

				BarGroup:SetScript('OnMouseDown',function(self,button)
					if (Auras.db.char.settings.move.isMoving) then
						Auras:MoveOnMouseDown(self,button)
					end
				end)

				BarGroup:SetScript('OnMouseUp',function(self,button)
					if (Auras.db.char.settings.move.isMoving) then
						Auras:MoveOnMouseUp(self,button)
						Auras:UpdateLayout(self,timerbars.frames[j])
					end
				end)
				
				_G["SSA_BarGroup"..j] = BarGroup
			end
		end
	end
	
end

local function ResetMovable()
	local db = Auras.db.char
	
	db.settings.move.isMoving = false
end

-- This will fix incorrect Database values from previous releases
local function FixDatabase()
	local db = Auras.db.char

	-- Fix Database Issues from r9-beta1
	if (not db.auras[1].auras.EchoingShock.layout.isGCD) then
		db.auras[1].auras.EchoingShock.layout.isGCD = true
	end

	if (not db.auras[1].auras.EchoingShock.layout.isCharge) then
		db.auras[1].auras.EchoingShock.layout.isCharge = true
	end

	if (db.auras[1].auras.EchoingShock.glow.triggers[1].duration ~= 30) then
		db.auras[1].auras.EchoingShock.glow.triggers[1].duration = 30
	end

	-- Fix Database Issues from r9-beta2
	if (db.auras[3].auras.FlameShock.glow.triggers[1].spellID ~= 188389) then
		db.auras[3].auras.FlameShock.glow.triggers[1].spellID = 188389
	end

	-- Fix Database Issues from r9-beta7
	if (db.auras[1].cooldowns.sweep ~= nil) then
		for i=1,3 do
			db.auras[i].cooldowns.isEnabled = nil
			db.auras[i].cooldowns.text = nil
			db.auras[i].cooldowns.sweep = nil
			db.auras[i].cooldowns.inverse = nil
			db.auras[i].cooldowns.bling = nil
			db.auras[i].cooldowns.GCD = nil
			for j=1,#db.auras[i].cooldowns.groups do
				db.auras[i].cooldowns.groups[j].isEnabled = true
				db.auras[i].cooldowns.groups[j].text = true
				db.auras[i].cooldowns.groups[j].sweep = true
				db.auras[i].cooldowns.groups[j].inverse = false
				db.auras[i].cooldowns.groups[j].bling = false
				db.auras[i].cooldowns.groups[j].GCD = {
					isEnabled = false,
					length = 0,
					sweep = true,
					bling = true,
				}
			end
		end

		db.auras.templates.cooldowns.isEnabled = true
		db.auras.templates.cooldowns.text = true
		db.auras.templates.cooldowns.sweep = true
		db.auras.templates.cooldowns.inverse = false
		db.auras.templates.cooldowns.bling = false
		db.auras.templates.cooldowns.GCD = {
			isEnabled = false,
			length = 0,
			sweep = true,
			bling = true,
		}
		db.auras.templates.cooldowns.text.isDisplayText = true
		db.auras.templates.cooldowns.text.font.shadow.isEnabled = false
	end
end

-- Event: ADDON_LOADED
function Auras:OnInitialize()

	local database = SSA.database;
	local about_panel = LibStub:GetLibrary("LibAboutPanel", true)

	if about_panel then
		self.optionsFrame = about_panel.new(nil, "ShamanAuras")
	end
	
	self.db = LibStub("AceDB-3.0"):New("SSA2_db",database)
	if (self.db.global.isShadowlandsLoaded == nil) then
		self.db.global.isShadowlandsLoaded = false
	end

	self:SetupOptions()

	if (not self.db.char.isFirstEverLoad and not IsAddOnLoaded("ShamanAuras")) then
		self:BuildAuraGroups()
	end
	
end

local function VerifyDatabaseContents()
	if (not Auras.db.char.isFirstEverLoad) then
		local db = Auras.db.char
		local defaults = SSA.defaults
		
		for i=1,3 do
			-- Verify Auras #1: Create new table if doesn't exist in database.
			for k,v in pairs(defaults.auras[i].auras) do
				if (not db.auras[i].auras[k]) then
					db.auras[i].auras[k] = {}
					Auras:CopyTableValues(db.auras[i].auras[k],defaults.auras[i].auras[k])
				end
			end
			
			-- Verify Auras #1: Create new table if doesn't exist in database.
			for k,v in pairs(defaults.totems[i].totems) do
				if (not db.totems) then
					db.totems = {
						[1] = {
							totems = {},
						},
						[2] = {
							totems = {},
						},
						[3] = {
							totems = {},
						},
					}
				end
				
				if (not db.totems[i].totems[k]) then
					db.totems[i].totems[k] = {}
					Auras:CopyTableValues(db.totems[i].totems[k],defaults.totems[i].totems[k])
				end
			end
			
			-- Verify Auras #2: Delete old table if not found in defaults table.
			for k,v in pairs(db.auras[i].auras) do
				if (not defaults.auras[i].auras[k]) then
					db.auras[i].auras[k] = nil
				end
			end
			
			-- Verify Statusbars #1: Create new table if doesn't exist in database.
			for k,v in pairs(defaults.statusbars[i].bars) do
				if (not db.statusbars[i].bars[k]) then
					db.statusbars[i].bars[k] = {}
					Auras:CopyTableValues(db.statusbars[i].bars[k],defaults.statusbars[i].bars[k])
				end
			end
			
			-- Verify Statusbars #2: Delete old table if not found in defaults table.
			for k,v in pairs(db.statusbars[i].bars) do
				if (not defaults.statusbars[i].bars[k]) then
					db.statusbars[i].bars[k] = nil
				end
			end
			
			-- Verify Timerbars #1: Create new table if doesn't exist in database.
			for k,v in pairs(defaults.timerbars[i].bars) do
				if (not db.timerbars[i].bars[k]) then
					db.timerbars[i].bars[k] = {}
					Auras:CopyTableValues(db.timerbars[i].bars[k],defaults.timerbars[i].bars[k])
				end
			end
			
			-- Verify Timerbars #2: Delete old table if not found in defaults table.
			for k,v in pairs(db.timerbars[i].bars) do
				if (not defaults.timerbars[i].bars[k]) then
					db.timerbars[i].bars[k] = nil
				end
			end
		end
	end
end

--/script SSA2_db.char["Sweetsours - Firetree"].auras[1].auras.SurgeOfPower = nil

-- Event: PLAYER_LOGIN
function Auras:OnEnable()
	VerifyDatabaseContents()
	
	local db = self.db.char
	
	if (db.isFirstEverLoad or IsAddOnLoaded("ShamanAuras")) then
		if (IsAddOnLoaded("ShamanAuras")) then
			StaticPopupDialogs["SSA_ADDON_CONFLICT"] = {
				text = "\"Sweetsour's Shaman Auras 1\" is still currently loaded. This can cause conflicts and needs to be disabled before you can access Sweetsour's Shaman Auras 2",
				button1 = "Disable Sweetsour's Shaman Auras 1",
				OnAccept = function()
					DisableAddOn("ShamanAuras")
					ReloadUI()
				end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,
			}
			
			StaticPopup_Show ("SSA_ADDON_CONFLICT")
		end
		
		return
	end
	
	local _,_,classIndex = UnitClass('player')

	self:UnregisterAllEvents()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	--self:RegisterEvent("FOG_OF_WAR_UPDATED")
	self:RegisterEvent("UI_INFO_MESSAGE")
	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_TOTEM_UPDATE")
	self:RegisterEvent("UNIT_PET")
	Frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED","player")
	Frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED","player")
	Frame:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED","player")
	Frame:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
	Frame:RegisterUnitEvent("UNIT_SPELLCAST_SENT")
	Frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START","player")
	Frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP","player")

	-- If the addon is loaded for the first time ever,
	-- populate the database with default group values.
	if (db.isFirstEverLoad) then
		SSA.DataFrame.text:SetText("FIRST EVER LOAD\n")
		
		--self:CopyTableValues(self.db.char,SSA.defaults)
		--[[for i=1,3 do
			local auras = Auras.db.char.auras[i]
			local timerbars = Auras.db.char.timerbars[i]
			
			for j=1,#SSA.groupDefaults[i].layout.auras do
				if (not auras.groups[j]) then
					auras.groups[j] = {}
				end
				
				if (not auras.frames[j]) then
					auras.frames[j] = {}
				end
				
				if (not auras.cooldowns.groups[j]) then
					auras.cooldowns.groups[j] = {}
				end
				
				Auras:CopyTableValues(auras.groups[j],SSA.groupDefaults[i].layout.auras[j])
				Auras:CopyTableValues(auras.frames[j],SSA.groupDefaults[i].frames.auras[j])
				Auras:CopyTableValues(auras.cooldowns.groups[j],SSA.groupDefaults.cooldowns)
			end
			for j=1,#SSA.groupDefaults[i].layout.timerbars do
				if (not timerbars.groups[j]) then
					timerbars.groups[j] = {}
				end
				
				if (not timerbars.frames[j]) then
					timerbars.frames[j] = {}
				end
				
				Auras:CopyTableValues(timerbars.groups[j],SSA.groupDefaults[i].layout.timerbars[j])
				Auras:CopyTableValues(timerbars.frames[j],SSA.groupDefaults[i].frames.timerbars[j])
			end
		end]]
		--db.isFirstEverLoad = false
	end
	--if (db.EquippedArtifact == '') then
		local _,_,name = C_ArtifactUI.GetEquippedArtifactInfo()
		db.EquippedArtifact = name
	--end
	
	
	-- Check if cooldowns value is table
	--[[if (type(db.cooldowns.numbers) == "table") then
		db.cooldowns.numbers = true
	end]]
			
	InterfaceOptionsFrame:EnableMouse(true)
	InterfaceOptionsFrame:SetMovable(true)
	InterfaceOptionsFrame:RegisterForDrag("LeftButton")
	InterfaceOptionsFrame:SetUserPlaced(true)
	InterfaceOptionsFrame:SetScript("OnMouseDown",function(self,button)
		if (button == "LeftButton" and not self.isMoving) then
			self:StartMoving()
			self.isMoving = true
		end
	end);
	InterfaceOptionsFrame:SetScript("OnMouseUp",function(self,button)
		if (button == "LeftButton" and self.isMoving) then
			self:StopMovingOrSizing()
			self.isMoving = false
		end
	end);
	InterfaceOptionsFrame:HookScript("OnHide",function(self,button)
		if (self.isMoving) then
			self:StopMovingOrSizing()
			self.isMoving = false
		end
		
		ResetAdjustable()
		
		SSA.FulminationBar:SetAlpha(0)
		--SSA.MaelstromBar2:SetAlpha(0)
		--SSA.EarthenWallTotemBar:SetAlpha(0)
		--SSA.TidalWavesBar:SetAlpha(0)
	end);

	self.db.char.settings.move.isMoving = false
	
	self:UpdateTalents()
	self:ResetCustomization()
	ResetAdjustable()
	ResetMovable()
	FixDatabase()
	
	

	-- Initialize Cooldown Configuration
	--Auras:InitializeCooldowns('AuraBase',1)
	--Auras:InitializeCooldowns('AuraBase',2)
	--Auras:InitializeCooldowns('AuraBase',3)

	--SSA.Move1 = CreateFrame('Frame','Move1',UIParent);
	
	
	-- Clean up old version checks
	--[[for i=1,70 do
		if (db["isR"..tostring(i).."FirstLoad"] == false) then
			db["isR"..tostring(i).."FirstLoad"] = nil
		end
	end

	if (db.isR71FirstLoad) then
		SSA.Bulletin:Show()
		db.isR71FirstLoad = false
	end]]

	StaticPopupDialogs["SSA_CLASS_CHECKER"] = {
		text = "You are currently running the addon \"Sweetsour's Shaman Auras\" while on a non-shaman character. It is recommended that you disable this addon.",
		button1 = L["LABEL_SHOW_ADDONS"],
		button2 = "I'll disable it later",
		OnAccept = function()
			AddonList:Show()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}

	if (not self:CharacterCheck(nil,0)) then
		StaticPopup_Show ("SSA_CLASS_CHECKER")
	end
end

function Auras:PLAYER_TALENT_UPDATE()
	self:UpdateTalents(true);
	self:UpdateInterfaceSettings();
end

function Auras:PLAYER_EQUIPMENT_CHANGED(event,slot)
	local relevantSlots = {
		[1] = true,  -- Helm
		[3] = true,  -- Shoulder
		[5] = true,  -- Chest
		[7] = true,  -- Legs
		[10] = true, -- Hands
		[13] = true, -- Trinket #1
		[14] = true, -- Trinket #2
		[15] = true, -- Back
	}

	-- We only want to update talents if the gear slot that has been change is in the list above
	if (relevantSlots[slot]) then
		self:UpdateTalents();
	end
end

function Auras:PLAYER_ENTERING_WORLD()
	
end

-- Fires when entering combat
function Auras:PLAYER_REGEN_DISABLED()
	local spec = GetSpecialization()
	
	
	
	--[[if (SSA["Move"..spec]:IsShown()) then

		SSA["Move"..spec].Close:Click("MiddleButton");
	end]]
end


function Auras:PLAYER_LOGIN()
	
end

function Auras:PLAYER_ALIVE()

end

function Auras:IsPvPZone()
	local pvpType = GetZonePVPInfo()
	if ((C_PvP.IsPVPMap() or (C_PvP.IsWarModeDesired() and not IsInInstance())) and pvpType ~= "sanctuary") then
		return true
	else
		return false
	end
end

function Auras:ZONE_CHANGED_NEW_AREA()
	self:UpdateTalents();
end

function Auras:ZONE_CHANGED()
	self:UpdateTalents();
end

--function Auras:FOG_OF_WAR_UPDATED()
function Auras:UI_INFO_MESSAGE(e,msg)
	if (msg == 994 or msg == 995) then
		self:UpdateTalents()
	end
end

function Auras:UNIT_PET()
	local spec = GetSpecialization()
	
	for k,v in pairs(self.db.char.timerbars[spec].bars) do
		local bar = SSA[k]
		
		if (bar.isPrimal and not UnitExists("pet") and bar.start > 0) then
			--v.data.start = 0
			bar.start = 0
		end
	end
end
--[[
   TODO: Add table to private DB to track all active totems
         Current API's limit of 4 is causing problems.
]]
local function HealingStreamTotemHandler()
	local isStreamOne,isStreamTwo = false,false
	--local streamOne = Auras.db.char.timerbars[3].bars.HealingStreamTotemBarOne
	local streamOne = SSA.HealingStreamTotemBarOne
	--local streamTwo = Auras.db.char.timerbars[3].bars.HealingStreamTotemBarTwo
	local streamTwo = SSA.HealingStreamTotemBarTwo
	
	for i=1,4 do
		local _,_,totemStart = GetTotemInfo(i)
		
		if (streamOne.start == totemStart) then
			isStreamOne = true
		elseif (streamTwo.start == totemStart) then
			isStreamTwo = true
		end
	end
	if (streamOne.start > 0 and not isStreamOne) then
		streamOne.start = 0
		SSA.activeTotems["HealingStreamTotemBarOne"] = nil
	elseif (streamTwo.start > 0 and not isStreamTwo) then
		streamTwo.start = 0
		SSA.activeTotems["HealingStreamTotemBarTwo"] = nil
	end
end

local function FeralSpiritHandler()
	--local timerbar = Auras.db.char.timerbars[2].bars.FeralSpiritBar
	local bar = SSA.FeralSpiritBar
	local numSpirits = 0
	
	for i=1,4 do
		local _,totemName = GetTotemInfo(i)
		
		if (totemName == "Spirit Wolf") then
			numSpirits = numSpirits + 1
		end
	end
	
	if (bar.start > 0 and numSpirits == 0) then
		bar.start = 0
		SSA.activeTotems["FeralSpiritBar"] = nil
	end
end

TotemFrameTotem1:HookScript("OnClick",function(self,button)
	if (button == "RightButton") then
		local icon = TotemFrameTotem1IconTexture:GetTexture()
		local spec = GetSpecialization()
		for k,v in pairs(Auras.db.char.timerbars[spec].bars) do
			local bar = SSA[k]
			
			if (bar.icon == icon) then
				--[[if (k == "HealingStreamTotemBarOne" or k == "HealingStreamTotemBarTwo") then
					local _,_,totemStart = GetTotemInfo(1)
					
					if (totemStart == v.startTime) then
						SSA.activeTotems[k] = nil
						v.startTime = 0
					end
				else
					SSA.activeTotems[k] = nil
					v.startTime = 0
				end]]
				if (match(k,"HealingStreamTotem")) then
					HealingStreamTotemHandler()
				elseif (k == "FeralSpiritBar") then
					FeralSpiritHandler()
				else
					SSA.activeTotems[k] = nil
					bar.start = 0
				end
			end
		end
	end
end)

TotemFrameTotem2:HookScript("OnClick",function(self,button)
	if (button == "RightButton") then
		local icon = TotemFrameTotem2IconTexture:GetTexture()
		local spec = GetSpecialization()
		for k,v in pairs(Auras.db.char.timerbars[spec].bars) do
			local bar = SSA[k]
			
			if (bar.icon == icon) then
				if (match(k,"HealingStreamTotem")) then
					HealingStreamTotemHandler()
					--[[local isStreamOne,isStreamTwo = false,false
					local streamOne = Auras.db.char.timerbars[3].HealingStreamTotemBarOne
					local streamTwo = Auras.db.char.timerbars[3].HealingStreamTotemBarTwo
					
					for i=1,4 do
						local _,_,totemStart = GetTotemInfo(i)
						
						if (streamOne.startTime == totemStart) then
							isStreamOne = true
						elseif (streamTwo.startTime == totemStart) then
							isStreamTwo = true
						end
					end
					if (streamOne.startTime > 0 and not isStreamOne) then
						streamOne.startTime = 0
						SSA.activeTotems["HealingStreamTotemBarOne"] = nil
					elseif (streamTwo.startTime > 0 and not isStreamTwo) then
						streamTwo.startTime = 0
						SSA.activeTotems["HealingStreamTotemBarTwo"] = nil
					end]]
				elseif (k == "FeralSpiritBar") then
					FeralSpiritHandler()
				else
					SSA.activeTotems[k] = nil
					bar.start = 0
				end
			end
			--[[if (v.info.icon == icon) then
				if (k == "HealingStreamTotemBarOne") then
					--for i=1,4 do
						local _,_,totemStart,totemDuration = GetTotemInfo(2)
						--local totemRemain = (totemStart + totemDuration) - GetTime()
						--local remains = (v.startTime + v.duration) - GetTime()
						--print(tostring(totemStart).." - "..v.startTime)
						--print(totemRemain.." - "..remains.." ("..k..")")
						--if (totemRemain == remains) then
						if (v.startTime ~= totemStart) then
							--print(tostring(totemStart).." - "..v.startTime.." ("..k..")")
							--print(totemRemain.." - "..remains.." ("..k..")")
							SSA.activeTotems[k] = nil
							v.startTime = 0
						end
					--end
				elseif (k == "HealingStreamTotemBarTwo") then
					--for i=1,4 do
						local _,_,totemStart,totemDuration = GetTotemInfo(2)
						--local totemRemain = (totemStart + totemDuration) - GetTime()
						--local remains = (v.startTime + v.duration) - GetTime()
						--print(tostring(totemStart).." - "..v.startTime)
						--print(totemRemain.." - "..remains.." ("..k..")")
						--if (totemRemain == remains) then
						if (v.startTime ~= totemStart) then
							--print(tostring(totemStart).." - "..v.startTime.." ("..k..")")
							--print(totemRemain.." - "..remains.." ("..k..")")
							SSA.activeTotems[k] = nil
							v.startTime = 0
						end
					--end
				else
					SSA.activeTotems[k] = nil
					v.startTime = 0
				end
			end]]
			--[[if (v.info.icon == icon) then
				if (k == "HealingStreamTotemBarOne" or k == "HealingStreamTotemBarTwo") then
					local _,_,totemStart = GetTotemInfo(2)
					
					if (totemStart == v.startTime) then
						SSA.activeTotems[k] = nil
						v.startTime = 0
					end
				else
					SSA.activeTotems[k] = nil
					v.startTime = 0
				end
			end]]
		end
	end
end)

TotemFrameTotem3:HookScript("OnClick",function(self,button)
	if (button == "RightButton") then
		local icon = TotemFrameTotem3IconTexture:GetTexture()
		local spec = GetSpecialization()
		for k,v in pairs(Auras.db.char.timerbars[spec].bars) do
			local bar = SSA[k]
			
			if (bar.icon == icon) then
				--[[if (k == "HealingStreamTotemBarOne" or k == "HealingStreamTotemBarTwo") then
					local _,_,totemStart = GetTotemInfo(3)
					
					if (totemStart == v.startTime) then
						SSA.activeTotems[k] = nil
						v.startTime = 0
					end
				else
					SSA.activeTotems[k] = nil
					v.startTime = 0
				end]]
				if (match(k,"HealingStreamTotem")) then
					HealingStreamTotemHandler()
				elseif (k == "FeralSpiritBar") then
					FeralSpiritHandler()
				else
					SSA.activeTotems[k] = nil
					bar.start = 0
				end
			end
		end
	end
end)

TotemFrameTotem4:HookScript("OnClick",function(self,button)
	if (button == "RightButton") then
		local icon = TotemFrameTotem4IconTexture:GetTexture()
		local spec = GetSpecialization()
		for k,v in pairs(Auras.db.char.timerbars[spec].bars) do
			local bar = SSA[k]
			if (bar.icon == icon) then
				--[[if (k == "HealingStreamTotemBarOne" or k == "HealingStreamTotemBarTwo") then
					local _,_,totemStart = GetTotemInfo(4)
					
					if (totemStart == v.startTime) then
						SSA.activeTotems[k] = nil
						v.startTime = 0
					end
				else
					SSA.activeTotems[k] = nil
					v.startTime = 0
				end]]
				if (match(k,"HealingStreamTotem")) then
					HealingStreamTotemHandler()
				elseif (k == "FeralSpiritBar") then
					FeralSpiritHandler()
				else
					SSA.activeTotems[k] = nil
					bar.start = 0
				end
			end
		end
	end
end)

function Auras:PLAYER_TOTEM_UPDATE()
	local activeTotems = {}
	local spec = GetSpecialization()
	local isHealingStreamOne, isHealingStreamTwo = false,false
	local timerbars = Auras.db.char.timerbars[spec]
	--SSA.DataFrame.text:SetText('')
	--[[for i=1,10 do
		local hasTotem,totemName,start,duration = GetTotemInfo(i)
		
		if (totemName and #totemName > 0) then
			activeTotems[start + duration] = gsub(totemName," ","").."Bar"
			--activeTotems[gsub(totemName," ","").."Bar"] = start + duration
			--tinsert(activeTotems,(start + duration))
		end
	end
	
	for k,v in pairs(activeTotems) do
		--print(k..". "..tostring(v))
		SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..k..". "..tostring(v).."\n")
	end]]
	for k,v in pairs(timerbars.bars) do
		local bar = SSA[k]
		local remains = (bar.start + bar.duration) - GetTime()
		
		if (k == "HealingStreamTotemBarOne" and remains > 0) then
			--if (SSA.activeTotems[k]) then
				isHealingStreamOne = true
			--end
		elseif (k == "HealingStreamTotemBarTwo" and remains > 0) then
			--if (SSA.activeTotems[k]) then
				isHealingStreamTwo = true
			--end
		--elseif (v.info.type == "totem" and v.startTime > 0 and not activeTotems[(v.startTime + v.duration)]) then
		elseif (remains <= 0 and SSA.activeTotems[k]) then
			bar.start = 0
			SSA.activeTotems[k] = nil
			--print("Other Totem ("..(v.startTime + v.duration)..")")
			--v.startTime = 0
			--v.info.isActive = false
		end
	end
	
	--print("One: "..tostring(isHealingStreamOne)..", Two: "..tostring(isHealingStreamTwo))
	if (spec == 3) then
		if (SSA.HealingStreamTotemBarOne.start > 0 and not isHealingStreamOne) then
			SSA.HealingStreamTotemBarOne.start = 0
			--Auras.db.char.timerbars[spec].HealingStreamTotemBarOne.info.isActive = false
		elseif (SSA.HealingStreamTotemBarTwo.start > 0 and not isHealingStreamTwo) then
			SSA.HealingStreamTotemBarTwo.start = 0
			--Auras.db.char.timerbars[spec].HealingStreamTotemBarTwo.info.isActive = false
		end
	end
	
	twipe(activeTotems)
end

function Auras:COMBAT_LOG_EVENT_UNFILTERED()
	local spec = SSA.spec or GetSpecialization()
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID,_,_,failType = CombatLogGetCurrentEventInfo()
	
	local initBar = function(k,v)
		v.startTime = GetTime()
		SSA[k]:Show()
	end

	if (subevent == "SPELL_CAST_START" and srcGUID == UnitGUID("player")) then
		--[[local cd = self.db.char.auras[spec].cooldowns

		local groupID = self:GetAuraGroupID(spellID)
		local start,duration = GetSpellCooldown(self:GetSpellName(546))

		if ((duration or 0) <= 1.5 and (duration or 0) > 0) then
			cd.groups[groupID].GCD.length = duration
			cd.groups[groupID].GCD.start = GetTime()
			cd.groups[groupID].GCD.endTime = GetTime() + duration
			cd.interrupted = false
		end]]
	elseif (subevent == "SPELL_CAST_FAILED" and srcGUID == UnitGUID("player") and failType == "Interrupted") then
		local cd = self.db.char.auras[spec].cooldowns
			
		--[[local groupID = self:GetAuraGroupID(spellID)
		
		cd.groups[groupID].GCD.length = 0]]
	elseif (subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_SUMMON" or subevent == "SPELL_AURA_REMOVED") then
		--for k,v in pairs(self.db.char.timerbars[spec]) do
			--if (srcGUID == UnitGUID("player") and subevent == "SPELL_AURA_REMOVED" and v.spellID == spellID) then
				--v.startTime = 0
			--elseif ((v.info.source == "any" or (v.info.source == "player" and srcGUID == UnitGUID("player"))) and v.spellID == spellID and v.info.name == subevent) then
				--[[if (k == "HealingStreamTotemBarOne" and v.startTime == 0) then
					initBar(k,v)
					break
				elseif (k == "HealingStreamTotemBarTwo" and self.db.char.timerbars[spec].HealingStreamTotemBarOne.startTime > 0) then
					initBar(k,v)
					break
				elseif (k ~= "HealingStreamTotemBarOne" and k ~= "HealingStreamTotemBarTwo" and subevent ~= "SPELL_SUMMON") then
					initBar(k,v)
					break
				else]]
				
				
				
				--[[if (subevent == "SPELL_SUMMON") then
					SSA.DataFrame.text:SetText(self:CurText('DataFrame')..k.."\n")
					if (k == "HealingStreamTotemBarOne" and spellID == 5394 and v.startTime == 0) then
						
						v.startTime = math.floor(GetTime())
						v.info.isActive = true
						SSA[k]:Show()
						--print("Healing Stream #1 ("..(v.startTime + v.duration)..")")
						break
					elseif (k == "HealingStreamTotemBarTwo" and spellID == 5394 and self.db.char.timerbars[spec].HealingStreamTotemBarOne.startTime > 0) then
						v.startTime = math.floor(GetTime())
						v.info.isActive = true
						SSA[k]:Show()
						--print("Healing Stream #2 ("..(v.startTime + v.duration)..")")
						break
					elseif (spellID ~= 5394) then
						print("Other Summon")
						v.startTime = math.floor(GetTime())
						SSA[k]:Show()
						
						if (v.info.type == "elemental") then
							v.info.elementalGUID = destGUID
						elseif (v.info.type == "totem") then
							v.info.isActive = true
						end
					end
				else
					print("not summon")
					initBar(k,v)
					break
				end]]
				
				
				
				
			--end
		--end
		--[[if (srcGUID == UnitGUID("player") then
			if (spellID == 31616) then
				SSA.natureGuardianCastTime = GetTime()
			elseif (subevent == "SPELL_CAST_SUCCESS") then
				for k,v in pairs(self.db.char.timerbars[spec]) do
					if (v.spellID == spellID) then
						v.startTime = GetTime()
					end
				end
			end
		end]]
	elseif (subevent == "UNIT_DIED") then
		--[[for k,v in pairs(self.db.char.timerbars[spec]) do
			if (destGUID == v.info.elementalGUID) then
				v.startTime = 0
			end
		end]]
	end
end

Frame:HookScript("OnEvent",function(self,event,...)
	if (Auras.db.char.isFirstEverLoad) then
		return
	end
	
	local spec = SSA.spec or GetSpecialization()

	local castBar,channelBar = SSA["CastBar"],SSA["ChannelBar"]
	
	if (event == "UNIT_SPELLCAST_SENT" or event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START") then
		if (event == "UNIT_SPELLCAST_SENT") then
			local unit,_,_,spellID = ...

			if (unit == "player") then
				local cd = Auras.db.char.auras[spec].cooldowns

				local groupID = Auras:GetAuraGroupID(spellID)
				local start,duration = GetSpellCooldown(Auras:GetSpellName(546))

				if ((duration or 0) <= 1.5 and (duration or 0) > 0) then
					cd.groups[groupID].GCD.length = duration
					cd.groups[groupID].GCD.start = GetTime()
					cd.groups[groupID].GCD.endTime = GetTime() + duration
					cd.interrupted = false
				end
			end
		elseif (event == "UNIT_SPELLCAST_START") then
			--[[local bar = Auras.db.char.statusbars[spec].bars.CastBar
			
			local spellName,_,texture,startTime,endTime = UnitCastingInfo('player')

			--local duration = (endTime - startTime) / 1000
			endTime = endTime / 1e3
			startTime = startTime / 1e3
			
			castBar.HideTime = 0
			
			castBar.startTime = startTime
			castBar.endTime = endTime
			castBar.duration = endTime - startTime
			castBar.spellName = spellName
			castBar.isCast = true
			
			if (bar.icon.isEnabled) then
				if (not castBar.icon:IsShown()) then
					castBar.icon:Show()
				end
				
				castBar.icon:SetTexture(texture)
				castBar:SetWidth(bar.layout.width - bar.layout.height)
			else
				if (castBar.icon:IsShown()) then
					castBar.icon:Hide()
				end
				
				castBar:SetWidth(bar.layout.width)
			end
			
			if (bar.spark) then
				if (not castBar.spark:IsShown()) then
					castBar.spark:Show()
				end
				
				castBar.spark:SetSize(20,(castBar:GetHeight() * 2.5))
			else
				if (castBar.spark:IsShown()) then
					castBar.spark:Hide()
				end
			end
			
			castBar:SetMinMaxValues(0,castBar.duration)
			if (bar.nametext.isDisplayText) then
				castBar.nametext:SetText(spellName)
			else
				castBar.nametext:SetText('')
			end
			
			castBar:SetAlpha(1);]]
		else
			--[[local bar = Auras.db.char.statusbars[spec].bars.ChannelBar
			local spellName,_,texture,startTime,endTime = UnitChannelInfo('player')

			endTime = endTime / 1e3
			startTime = startTime / 1e3
			
			channelBar.duration = endTime - startTime
			channelBar.HideTime = 0
			
			channelBar.startTime = startTime
			channelBar.endTime = endTime
			
			channelBar:SetMinMaxValues(0,channelBar.duration)
			channelBar.nametext:SetText(spellName)
			channelBar.isChannel = true
			channelBar:SetAlpha(1)

			if (bar.icon.isEnabled) then
				if (not channelBar.icon:IsShown()) then
					channelBar.icon:Show()
				end
				
				channelBar.icon:SetTexture(texture)
				channelBar:SetWidth(bar.layout.width - bar.layout.height)
			else
				if (channelBar.icon:IsShown()) then
					channelBar.icon:Hide()
				end
				
				channelBar:SetWidth(bar.layout.width)
			end
			
			if (bar.spark) then
				if (not channelBar.spark:IsShown()) then
					channelBar.spark:Show()
				end
				
				channelBar.spark:SetSize(20,(channelBar:GetHeight() * 2.5))
			else
				if (channelBar.spark:IsShown()) then
					channelBar.spark:Hide()
				end
			end
			
			if (bar.timetext.isDisplayText) then
				channelBar.timetext:SetText(spellName)
			else
				channelBar.timetext:SetText('')
			end
			
			if (castBar:GetAlpha(1)) then
				castBar:SetAlpha(0)
			end]]
		end
	elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
		--[[if (not Auras.db.char.statusbars[spec].bars.ChannelBar.adjust.isEnabled) then
			channelBar:SetAlpha(0)
		end]]
	elseif (event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_SUCCEEDED") then
		
		if (event == "UNIT_SPELLCAST_INTERRUPTED") then
			local unit,_,spellID = ...

			if (unit == "player") then
				local cd = Auras.db.char.auras[spec].cooldowns

				local groupID = Auras:GetAuraGroupID(spellID)
		
				cd.interrupted = true
				cd.groups[groupID].GCD.length = 0
			end
		end
		--
		--cd.GCD.start = 0
		--cd.GCD.endTime = 0
	--[[elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local _,_,_,_,_,_,_,_,_,_,_,spellID = CombatLogGetCurrentEventInfo()
		
		if (spellID == 31616) then
			SSA.natureGuardianCastTime = GetTime()
		end]]
	end
end)


