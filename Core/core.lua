--[[
 NOTES: "Ready" debuff for shell game: 271571
]]
local SSA, Auras, L, LSM, LBG = unpack(select(2,...))

-- Cache Global Variables
-- Lua Function
local _G = _G
local floor, fmod = math.floor, math.fmod
local pairs, select, tonumber, tostring = pairs, select, tonumber, tostring
local twipe = table.wipe
local format, lower, match, split, sub = string.format, string.lower, string.match, string.split, string.sub
-- WoW API / Variables
local BreakUpLargeNumbers = BreakUpLargeNumbers
local C_ArtifactUI = C_ArtifactUI
local CreateFont, CreateFrame = CreateFont, CreateFrame
local GetSpellCharges, GetSpellInfo = GetSpellCharges, GetSpellInfo
local GetSpecialization = GetSpecialization
local GetTime = GetTime
local IsShiftKeyDown, IsControlKeyDown = IsShiftKeyDown, IsControlKeyDown
local UnitAffectingCombat = UnitAffectingCombat
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo
local UnitClass = UnitClass
local UnitExists, UnitIsDead, UnitIsFriend = UnitExists, UnitIsDead, UnitIsFriend
local UnitGUID = UnitGUID
local UnitPower, UnitPowerMax = UnitPower, UnitPowerMax



--SSA.MoveEnh = CreateFrame('Frame','MoveEnh',UIParent)
--SSA.MoveRes = CreateFrame('Frame','MoveRes',UIParent)



function Auras:CurText(name)
	return SSA[name].text:GetText() or ''
end

-------------------------------------------------------------------------------------------------------
----- Global Functions
-------------------------------------------------------------------------------------------------------

-- Check if the player is PvP-ready
function Auras:IsPvPZone()
	local pvpType = GetZonePVPInfo()
	if ((C_PvP.IsPVPMap() or (C_PvP.IsWarModeDesired() and not IsInInstance())) and pvpType ~= "sanctuary") then
		return true
	else
		return false
	end
end

-- Check Current Class
function Auras:CharacterCheck(obj,spec,...)
	if (not self.db.char.isFirstEverLoad) then
		local _,_,classIndex = UnitClass('player')
		local curSpec = GetSpecialization()
		local db = self.db.char
		local isPreview,isAuraInUse,isCorrectSpecializationAndClass,isValidSpell = false,false,false,false
			
		-- If an object is NOT passed, bypass this boolean
		if (obj and type(obj) == "table") then
			local objDb
			
			if (Auras.db.char.auras[curSpec].auras[obj:GetName()]) then
				objDb = 'auras'
			elseif (Auras.db.char.timerbars[curSpec].bars[obj:GetName()]) then
				objDb = 'timerbars'
			elseif (Auras.db.char.statusbars[curSpec].bars[obj:GetName()]) then
				objDb = 'statusbar'
			else
				isAuraInUse = false
			end
			--[[if (not Auras.db.char.auras[spec]) then
				local args = { ... }
				local msg = tostring(obj)..", "..tostring(spec)
				for i=1,#args do
					msg = msg..tostring(args[i])..", "
				end
				print(msg)
			end]]
			
			
			
			
			if (objDb == "auras") then
				if (spec == 0) then
					local auras = self.db.char.auras[curSpec]
					isAuraInUse = auras.auras[obj:GetName()].isInUse
					
					--[[if (isAuraInUse) then
						isPreview = db.elements[curSpec].isMoving or auras.groups[auras.auras[obj:GetName()].group].isAdjust or (auras.cooldowns.adjust and auras.cooldowns.selected == auras.auras[obj:GetName()].group)
					end]]
					--[[if (Auras.db.char.auras[curSpec].auras[obj:GetName()]) then
						
						isAuraInUse = Auras.db.char.auras[curSpec].auras[obj:GetName()].isInUse
					else
						isAuraInUse = false
					end]]
				else
					local auras = self.db.char.auras[spec]
					isAuraInUse = auras.auras[obj:GetName()].isInUse
					
					--[[if (isAuraInUse) then
						isPreview = db.elements[spec].isMoving or auras.groups[auras.auras[obj:GetName()].group].isAdjust or (auras.cooldowns.adjust and auras.cooldowns.selected == auras.auras[obj:GetName()].group)
					end]]
				end
			elseif (objDb == "timerbars") then
				
				if (spec == 0) then
					--local timerbars = self.db.char.timerbars[curSpec]
					--if (Auras.db.char.timerbars[curSpec].bars[obj:GetName()]) then
						isAuraInUse = Auras.db.char.timerbars[curSpec].bars[obj:GetName()].isInUse
					--else
						--isAuraInUse = false
					--end
					--[[if (isAuraInUse) then
						isPreview = db.elements[curSpec].isMoving or timerbars.groups[timerbars.bars[obj:GetName()].group].isAdjust or timerbars.bars[obj:GetName()].isAdjust
					end]]
				else
					--local timerbars = self.db.char.timerbars[spec]
					isAuraInUse = Auras.db.char.timerbars[spec].bars[obj:GetName()].isInUse
					
					--[[if (isAuraInUse) then
						isPreview = db.elements[spec].isMoving or timerbars.groups[timerbars.bars[obj:GetName()].group].isAdjust or timerbars.bars[obj:GetName()].isAdjust
					end]]
				end
			elseif (objDb == "statusbar") then
				if (spec == 0) then
					if (Auras.db.char.statusbars[curSpec].bars[obj:GetName()]) then
						isAuraInUse = Auras.db.char.statusbars[curSpec].bars[obj:GetName()].isEnabled
					else
						isAuraInUse = false
					end
				else
					isAuraInUse = Auras.db.char.statusbars[spec].bars[obj:GetName()].isEnabled
				end
			end
			--[[if (spec == 0) then
				spec = curSpec
				
				if (Auras.db.char.auras[spec][obj:GetName()]) then
					isAuraInUse = Auras.db.char.auras[spec][obj:GetName()].isInUse
				else
					isAuraInUse = true
				end
			else
				isAuraInUse = Auras.db.char.auras[spec][obj:GetName()].isInUse
			end]]
		else
			isAuraInUse = true
		end
		
		if ((spec == curSpec or spec == 0) and classIndex == 7) then
			isCorrectSpecializationAndClass = true
		else
			isCorrectSpecializationAndClass = false
		end

		--[[if (select('#',...) > 1) then
			local row,col = ...

			if (type(obj) == "number") then
				print("Talents: "..row..", "..col)
			end
			_,_,_,isValidSpell = GetTalentInfo(row,col,1)
		elseif (select('#',...) > 0) then
			local spellID = ...
			
			if (type(spellID) == "number") then
				if (type(obj) == "number") then
					print("Spell ID: "..spellID)
				end
				
				if (spellID > 0) then
					isValidSpell = IsSpellKnown(spellID)
				else
					isValidSpell = false
				end
			else
				if (type(obj) == "number") then
					print("PvP ID: "..spellID)
				end

				_,_,_,_,_,_,_,_,_,isValidSpell = GetPvpTalentInfoByID(tonumber(spellID))
			end
		else
			isValidSpell = true
		end]]

		--[[if (type(obj) == "table" and obj:GetName() == "EarthShield") then
			SSA.DataFrame.text:SetText("Earth Shield: "..tostring(isPreview or (isAuraInUse and isCorrectSpecializationAndClass and isValidSpell)))
		end]]
		--return isPreview or (isAuraInUse and isCorrectSpecializationAndClass and isValidSpell)
		--return isAuraInUse and isCorrectSpecializationAndClass and isValidSpell
		return isAuraInUse and isCorrectSpecializationAndClass
	else
		return false
	end
end

-- Retrieve Spell Info Name
function Auras:GetSpellName(spellID)
	local name = GetSpellInfo(spellID)
	return name
end
_G["SSA_private_db"] = SSA
-- Show/Hide aura icons based on the current spec
function Auras:ToggleAuraVisibility(self,isEnable,visType)
	if (isEnable) then
		if (visType == 'showhide') then
			if (not self:IsShown()) then
				self:Show()
			end
		elseif (visType == 'alpha') then
			if (self:GetAlpha() == 0) then
				self:SetAlpha(1)
			end
		end
	else
		if (visType == 'showhide') then
			if (self:IsShown()) then
				self:Hide()
			end
		elseif (visType == 'alpha') then
			if (self:GetAlpha() ~= 0) then
				self:SetAlpha(0)
			end
		end
	end
end

function Auras:HealthPrecision(precision,isNotMax,override)
	local spec,health = GetSpecialization()
	if (override) then
		health = floor(UnitHealthMax('player',19) - (UnitHealthMax('player',19) * 0.75))
	elseif (isNotMax) then
		health = UnitHealth('player',19)
	else
		health = UnitHealthMax('player',19)
	end
	
	if (health > 1000) then
		--local health = UnitHealthMax('player',19)
		if (precision == 'Long') then
			if (Auras.db.char.elements[spec].statusbars.healthBar.grouping) then
				return BreakUpLargeNumbers(health)
			else
				return health
			end
		elseif (precision == 'Short') then
			if (health > 1000000) then
				return format('%.1f',health / 1000000)..'M'
			elseif (health > 1000) then
				if (Auras.db.char.elements[spec].statusbars.healthBar.grouping) then
					return format('%.1f',BreakUpLargeNumbers(health / 1000))..'K'
				else
					return format('%.1f',health / 1000)..'K'
				end
			end
		end
	else
		return health
	end
end

function Auras:ManaPrecision(precision,isNotMax,override)
	local power
	if (override) then
		power = floor(UnitPowerMax('player',19) - (UnitPowerMax('player',19) * 0.75))
	elseif (isNotMax) then
		power = UnitPower('player',19)
	else
		power = UnitPowerMax('player',19)
	end
	
	if (power > 1000) then
		--local power = UnitPowerMax('player',19)
		if (precision == 'Long') then
			if (Auras.db.char.statusbars[3].bars.ManaBar.grouping) then
				return BreakUpLargeNumbers(power)
			else
				return power
			end
		elseif (precision == 'Short') then
			if (power > 1000000) then
				return format('%.1f',power / 1000000)..'M'
			elseif (power > 1000) then
				if (Auras.db.char.statusbars[3].bars.ManaBar.grouping) then
					return format('%.1f',BreakUpLargeNumbers(power / 1000))..'K'
				else
					return format('%.1f',power / 1000)..'K'
				end
			end
		end
	else
		return power
	end
end

function Auras:ToggleCooldown(self,spec,isCharge)
	local cooldown = Auras.db.char.auras[spec].cooldowns
	
	if (cooldown.text) then
		self.CD.text:SetAlpha(1)
	else
		self.CD.text:SetAlpha(0)
	end
	
	if (cooldown.sweep) then
		if (isCharge) then
			self.ChargeCD:SetAlpha(1)
		end
		self.CD:SetAlpha(1)
	else
		if (isCharge) then
			self.ChargeCD:SetAlpha(0)
		end
		self.CD:SetAlpha(0)
	end
end

-------------------------------------------------------------------------------------------------------
----- Local Functions
-------------------------------------------------------------------------------------------------------

-- Return data about the player and their target
local function GetTargetInfo()
	return UnitExists('target'),UnitAffectingCombat('player'),UnitIsFriend('target','player'),UnitIsDead('target')
end

-- Aura Group Builder
function Auras:InitializeAuraFrameGroups(spec)
	SSA.AuraBase:SetPoint("CENTER",0,0)
	SSA.AuraBase:SetWidth(math.ceil(GetScreenWidth() - 500))
	SSA.AuraBase:SetHeight(math.ceil(GetScreenHeight() - 250))
	--for groupObj in pairs(db.frames) do
	local auras = Auras.db.char.auras[spec]

	for i=1,#auras.frames do
		if (SSA["AuraGroup"..i]) then
			local frame = auras.frames[i]
			
			if (frame.isEnabled) then
				local group = SSA["AuraGroup"..i]
				group:Show()
				group:SetWidth(frame.width)
				group:SetHeight(frame.height)

				group:EnableMouse(false)
				group:SetMovable(false)
				group:RegisterForDrag('LeftButton')
				if (i == 6) then
					print("FRAME: "..frame.x..", "..frame.y)
				end
				group:SetPoint(frame.point,(SSA[frame.relativeTo] or UIParent),frame.relativePoint,frame.x,frame.y)

				group.header:SetText(auras.groups[i].name)
				
				if (not frame.isEnabled or not Auras:CharacterCheck(nil,0)) then
					group:Hide()
				else
					group:Show()
				end
				
				group:SetScript('OnUpdate',nil)
				group:SetScript('OnUpdate',function(self,button)
					Auras:ToggleFrameMove(self,Auras.db.char.settings.move.isMoving)
				end)

				group:SetScript('OnMouseDown',nil)
				group:SetScript('OnMouseDown',function(self,button)
					if (Auras.db.char.settings.move.isMoving) then
						Auras:MoveOnMouseDown(self,button)
					end
				end)

				group:SetScript('OnMouseUp',nil)
				group:SetScript('OnMouseUp',function(self,button)
					if (Auras.db.char.settings.move.isMoving) then
						Auras:MoveOnMouseUp(self,button)
						Auras:UpdateLayout(self,frame)
					end
				end)
				--[[if (group:GetName() == "Undulation") then
					group.Model:SetModel('SPELLS/Monk_ForceSpere_Orb.m2')
				elseif (group:GetName() == 'StormstrikeChargeGrp') then
					group.Charge1.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
					group.Charge2.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
				elseif (group:GetName() == 'StormkeeperChargeGrp') then
					group.Charge1.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
					group.Charge2.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
					group.Charge3.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
				end]]
			else
				SSA["AuraGroup"..i]:Hide()
			end
		end
	end
end

function Auras:InitializeTimerBarFrameGroups(spec)
	SSA.AuraBase:SetPoint("CENTER",0,0)
	SSA.AuraBase:SetWidth(math.ceil(GetScreenWidth() - 500))
	SSA.AuraBase:SetHeight(math.ceil(GetScreenHeight() - 250))
	--for groupObj in pairs(db.frames) do
	local timerbars = Auras.db.char.timerbars[spec]
	
	for i=1,#timerbars.groups do
		if (SSA["BarGroup"..i]) then
			if (timerbars.frames[i].isEnabled) then
				local group = SSA["BarGroup"..i]
				
				
				group:Show()
				group:SetWidth(timerbars.frames[i].width)
				group:SetHeight(timerbars.frames[i].height)

				group:EnableMouse(false)
				group:SetMovable(false)
				group:RegisterForDrag('LeftButton')
				
				group:SetPoint(timerbars.frames[i].point,(SSA[timerbars.frames[i].relativeTo] or UIParent),timerbars.frames[i].relativePoint,timerbars.frames[i].x,timerbars.frames[i].y)

				if (not timerbars.frames[i].isEnabled or not Auras:CharacterCheck(nil,0)) then
					group:Hide()
				else
					group:Show()
				end
				
				for k,v in pairs(timerbars.bars) do
					if (v.layout.group == i and v.isInUse) then
						--[[local barID
						if (SSA[k.."Bar1"]) then
							barID = "Bar1"
						elseif (SSA[k.."Bar2"]) then
							barID = "Bar2"
						else
							barID = "Bar"
						end]]
						
						if (not SSA[k]) then
							SSA.DataFrame.text:SetText("Empty Index: "..tostring(k).." - "..tostring(barID))
						end
						
						--if (SSA[k..barID]) then]]
						--SSA.DataFrame.text:SetText("BAR GROUP ERROR: "..k.." ("..tostring(SSA["BarGroup"..i])..")")
							SSA[k]:SetParent(SSA["BarGroup"..i])
						--end
					end
				end
				
				--[[SSA["BarGroup"..i]:SetBackdrop(SSA.BackdropSB)
				if (i == 1) then
					SSA["BarGroup"..i]:SetBackdropColor(1,0,0,1)
				elseif (i == 2) then
					SSA["BarGroup"..i]:SetBackdropColor(0,1,0,1)
				elseif (i == 3) then
					SSA["BarGroup"..i]:SetBackdropColor(0,0,1,1)
				elseif (i == 4) then
					SSA["BarGroup"..i]:SetBackdropColor(1,1,0,1)
				elseif (i == 5) then
					SSA["BarGroup"..i]:SetBackdropColor(0,1,1,1)
				elseif (i == 6) then
					SSA["BarGroup"..i]:SetBackdropColor(1,1,1,1)
				end
				
				
				SSA["BarGroup"..i]:SetBackdropBorderColor(0,0,0,1)]]
				
				if (group:GetName() == "Undulation") then
					group.Model:SetModel('SPELLS/Monk_ForceSpere_Orb.m2')
				elseif (group:GetName() == 'StormstrikeChargeGrp') then
					group.Charge1.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
					group.Charge2.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
				elseif (group:GetName() == 'StormkeeperChargeGrp') then
					group.Charge1.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
					group.Charge2.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
					group.Charge3.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
				end
			else
				SSA["BarGroup"..i]:Hide()
			end
		end
	end
end

function Auras:InitializeProgressBar(bar1,bar2,text1,text2,spec)
	local curSpec = GetSpecialization();

	if (Auras.db.char.elements[spec].isEnabled) then
		if (curSpec == spec) then
			local bar1 = SSA[bar1]

			local db = Auras.db.char.statusbars[spec].bars[bar1:GetName()]
			if (text1) then
				if (db[text1].isDisplayText) then
					bar1[text1]:SetAlpha(1)
				else
					bar1[text1]:SetAlpha(0)
				end
				
				bar1[text1]:SetPoint(db[text1].justify,db[text1].x,db[text1].y)
				bar1[text1]:SetFont(LSM.MediaTable.font[db[text1].font.name] or LSM.DefaultMedia.font,db[text1].font.size,db[text1].font.flag)
				bar1[text1]:SetTextColor(db[text1].font.color.r,db[text1].font.color.g,db[text1].font.color.b)
			end
			
			if (text2) then
				if (db[text2].isDisplayText) then
					bar1[text2]:SetAlpha(1)
				else
					bar1[text2]:SetAlpha(0)
				end
				
				bar1[text2]:SetPoint(db[text2].justify,db[text2].x,db[text2].y)
				bar1[text2]:SetFont(LSM.MediaTable.font[db[text2].font.name] or LSM.DefaultMedia.font,db[text2].font.size,db[text2].font.flag)
				bar1[text2]:SetTextColor(db[text2].font.color.r,db[text2].font.color.g,db[text2].font.color.b)
			end
			
			bar1:Show()
			bar1:ClearAllPoints()
			
			if (bar1.icon and db.icon.isEnabled) then
				local parentJustify
				
				bar1.icon:SetWidth(db.layout.height)
				bar1.icon:SetHeight(db.layout.height)
				
				if (db.icon.justify == 'LEFT') then
					parentJustify = 'RIGHT';
					--bar1:SetPoint(db.layout.point,SSA[db.layout.relativeTo],db.layout.relativePoint,(db.layout.x + floor(db.layout.height / 2)) + 1,db.layout.y)
					bar1:SetPoint(db.layout.point,SSA[db.layout.relativeTo],db.layout.relativePoint,(db.layout.x + (bar1.icon:GetHeight() / 2)) + 1,db.layout.y)
				else
					parentJustify = 'LEFT'
					--bar1:SetPoint(db.layout.point,SSA[db.layout.relativeTo],db.layout.relativePoint,(db.layout.x - floor(db.layout.height / 2)) - 1,db.layout.y)
					bar1:SetPoint(db.layout.point,SSA[db.layout.relativeTo],db.layout.relativePoint,(db.layout.x - (bar1.icon:GetHeight() / 2)) - 1,db.layout.y)
				end
				
				--bar1:SetWidth(db.layout.width - db.layout.height)
				bar1:SetWidth(db.layout.width - bar1.icon:GetHeight())
				print("BAR ICON: "..db.layout.height)
				

				bar1.icon:SetPoint(parentJustify,bar1,db.icon.justify,0,0)
				print("BAR ICON: "..bar1.icon:GetSize())
				--bar1.border:SetPoint("TOPLEFT",((CastBar:GetHeight() + 2) * -1),2)
				--bar1.border:SetPoint("BOTTOMRIGHT",2,-2)
			else
				bar1:SetPoint(db.layout.point,SSA[db.layout.relativeTo],db.layout.relativePoint,db.layout.x,db.layout.y)
				bar1:SetWidth(db.layout.width)
			end
			
			bar1.bg:SetTexture(LSM.MediaTable.statusbar[db.background.texture])
			bar1.bg:SetVertexColor(db.background.color.r,db.background.color.g,db.background.color.b,db.background.color.a)
			
			bar1:SetFrameStrata(db.layout.strata)
			bar1:SetHeight(db.layout.height)
			bar1:SetStatusBarColor(db.foreground.color.r,db.foreground.color.g,db.foreground.color.b)
			bar1:SetStatusBarTexture(LSM.MediaTable.statusbar[db.foreground.texture])
			
			if (bar2) then
				bar1[bar2]:ClearAllPoints()
				bar1[bar2]:SetPoint('CENTER',bar1,'CENTER',0,0)
				bar1[bar2]:SetFrameStrata('MEDIUM')
				bar1[bar2]:SetWidth(db.layout.width)
				bar1[bar2]:SetHeight(db.layout.height)
				bar1[bar2]:SetStatusBarColor(db[lower(bar2).."Bar"].color.r,db[lower(bar2).."Bar"].color.g,db[lower(bar2).."Bar"].color.b,db[lower(bar2).."Bar"].color.a)
			end
			
			db.adjust.isEnabled = false
		end
	else
		SSA[bar1]:Hide()
	end
end





-- Return the number of charges an ability currently has by spellID
local function SpellCharges(spellid)
	local charges,maxcharges = GetSpellCharges(spellid)
	local isMaxCharge = false
	
	if (charges == maxcharges) then
		isMaxCharge = true
	end
	
	if ((charges or 0) > 0) then
		return charges,isMaxCharge
	else
		return nil,false
	end
end

function Auras:IsTargetEnemy()
	if (UnitExists('target') and not UnitIsFriend('target','player') and not UnitIsDead('target')) then
		return true
	else
		return false
	end
end

function Auras:IsTargetFriendly()
	if (UnitExists('target') and UnitIsFriend('target','player') and not UnitIsDead('target')) then
		return true
	else
		return false
	end
end

-- FIX THIS
function Auras:SpellRangeCheck(self,spellID,flag)
	local spec = SSA.spec
	
	if (Auras:IsTargetEnemy() and flag) then
		if (IsSpellInRange(Auras:GetSpellName(spellID)) == 1) then
			self.texture:SetDesaturated(false);
			self.texture:SetVertexColor(1,1,1,1)
		else
			self.texture:SetDesaturated(true)
			self.texture:SetVertexColor(Auras.db.char.settings[spec].OoRColor.r,Auras.db.char.settings[spec].OoRColor.g,Auras.db.char.settings[spec].OoRColor.b,Auras.db.char.settings[spec].OoRColor.a)
		end
	elseif (Auras:IsTargetEnemy() and not flag) then
		self.texture:SetDesaturated(true)
		self.texture:SetVertexColor(0.5,0.5,0.5,1)
	else
		self.texture:SetDesaturated(false)
		self.texture:SetVertexColor(1,1,1,1)
	end
end

function Auras:ShiftPressCheck(self)
	if (IsShiftKeyDown()) then
		self.shift = true
	else
		self.shift = false
	end
end

-- FIX THIS
function Auras:ResetAuraGroupPosition(objName)
	local spec = GetSpecialization()
	local db = self.db.char

	if (not objName) then
		for i=1,#SSA.defaults.auras[spec].frames do
			local frame = self.db.char.auras[spec].frames[i]
			local frameDefault = SSA.defaults.auras[spec].frames[i]
			
			SSA[objName or ("AuraGroup"..i)]:SetPoint(frameDefault.point,SSA[frameDefault.relativeTo],frameDefault.relativePoint,frameDefault.x,frameDefault.y)
			frame.point,_,frame.relativePoint,frame.x,frame.y = SSA[objName or ("AuraGroup"..i)]:GetPoint()
		end
		
		for i=1,#SSA.defaults.timerbars[spec].frames do
			local frame = self.db.char.timerbars[spec].frames[i]
			local frameDefault = SSA.defaults.timerbars[spec].frames[i]
			
			SSA["BarGroup"..i]:SetPoint(frameDefault.point,SSA[frameDefault.relativeTo],frameDefault.relativePoint,frameDefault.x,frameDefault.y)
			frame.point,_,frame.relativePoint,frame.x,frame.y = SSA["BarGroup"..i]:GetPoint()
		end
		
		for k,v in pairs(SSA.defaults.statusbars[spec].bars) do
			local bar = self.db.char.statusbars[spec].bars[k]
			
			SSA[k]:SetPoint(v.layout.point,SSA[v.layout.relativeTo],v.layout.relativePoint,v.layout.x,v.layout.y)
			bar.layout.point,_,bar.layout.relativePoint,bar.layout.x,bar.layout.y = SSA[k]:GetPoint()
		end
	elseif (objName and match(objName,"AuraGroup")) then
		local groupID = strsub(objName,10)
		local frame = self.db.char.auras[spec].frames[tonumber(groupID)]
		local frameDefault = SSA.defaults.auras[spec].frames[tonumber(groupID)]
		
		SSA[objName]:SetPoint(frameDefault.point,SSA[frameDefault.relativeTo],frameDefault.relativePoint,frameDefault.x,frameDefault.y)
		frame.point,_,frame.relativePoint,frame.x,frame.y = SSA[objName]:GetPoint()
	elseif (objName and match(objName,"BarGroup")) then
		local groupID = strsub(objName,9)
		local frame = self.db.char.timerbars[spec].frames[tonumber(groupID)]
		local frameDefault = SSA.defaults.timerbars[spec].frames[tonumber(groupID)]
		
		SSA[objName]:SetPoint(frameDefault.point,SSA[frameDefault.relativeTo],frameDefault.relativePoint,frameDefault.x,frameDefault.y)
		frame.point,_,frame.relativePoint,frame.x,frame.y = SSA[objName]:GetPoint()
	elseif (objName and db.statusbars[spec].bars[objName]) then
		local default = SSA.defaults.statusbars[spec].bars[objName]
		local bar = self.db.char.statusbars[spec].bars[objName]
			
		SSA[objName]:SetPoint(default.layout.point,SSA[default.layout.relativeTo],default.layout.relativePoint,default.layout.x,default.layout.y)
		bar.layout.point,_,bar.layout.relativePoint,bar.layout.x,bar.layout.y = SSA[objName]:GetPoint()
	end
end

-- FIX THIS
--[[function Auras:ConfigureMove(db,obj,backdrop)
	if (db.isMoving) then
		if (not obj:IsMouseEnabled()) then
			obj:EnableMouse(true)
			obj:SetMovable(true)
		end
		
		if (not obj:GetBackdrop()) then
			obj:SetBackdrop(backdrop)
			obj:SetBackdropColor(0,0,0,0.85)
		end
	else
		if (obj:IsMouseEnabled()) then
			obj:EnableMouse(false)
			obj:SetMovable(false)
		end
		
		if (obj:GetBackdrop()) then
			--obj:SetBackdrop(nil)
		end
	end
end]]

-- FIX THIS
--[[function Auras:MoveOnMouseDown(obj,button)
	local framePt,_,parentPt,x,y = obj:GetPoint(1)

	if (not IsShiftKeyDown() and not IsControlKeyDown() and button == 'LeftButton') then
		obj.framePt = framePt
		obj.parentPt = parentPt
		obj.frameX = x
		obj.frameY = y
		obj:StartMoving()
		_,_,_,x,y = obj:GetPoint(1)
		obj.screenX = x
		obj.screenY = y
	elseif (IsShiftKeyDown() and not IsControlKeyDown()) then
		if (button == "LeftButton") then
			obj:SetPoint("CENTER",obj:GetParent(),"CENTER",0,y)
		elseif (button == "RightButton") then
			obj:SetPoint("CENTER",obj:GetParent(),"CENTER",x,0)
		elseif (button == "MiddleButton") then
			obj:SetPoint("CENTER",obj:GetParent(),"CENTER",0,0)
		end
	elseif (not IsShiftKeyDown() and IsControlKeyDown() and button == "RightButton") then
		self:ResetAuraGroupPosition(obj:GetName())
	end
end]]

-- FIX THIS
--[[function Auras:MoveOnMouseUp(obj,button)
	local framePt,_,parentPt,x,y = obj:GetPoint(1)

	if (button == 'LeftButton' and obj.framePt) then
		obj:StopMovingOrSizing()
		x = (x - obj.screenX) + obj.frameX
		y = (y - obj.screenY) + obj.frameY
		obj:ClearAllPoints()
		obj:SetPoint(obj.framePt, obj:GetParent(), obj.parentPt, x, y)
		obj.framePt = nil
		obj.parentPt = nil
		obj.frameX = nil
		obj.frameY =nil
		obj.screenX = nil
		obj.screenY = nil
	end
end]]

-- FIX THIS
--[[function Auras:UpdateLayout(obj,db)
	local point,relativeTo,relativePoint,x,y = obj:GetPoint(1)
	
	if (obj.icon and obj:GetName() ~= "Cloudburst") then
		if (db.icon.isEnabled) then
			if (db.icon.justify == "LEFT") then
				x = x - floor(db.layout.height / 2)
			else
				x = x + floor(db.layout.height / 2)
			end
		else
		
		end
	end
	
	if (db.layout) then
		db.layout.point = point
		db.layout.relativeTo = relativeTo:GetName()
		db.layout.relativePoint = relativePoint
		db.layout.x = x
		db.layout.y = y
	else
		db.point = point
		db.relativeTo = relativeTo:GetName()
		db.relativePoint = relativePoint
		db.x = x
		db.y = y
	end
end]]

local function GetVersionNumber()
	return tonumber(sub(Auras.version,2,3))
end
-- Toggle Button Glow Animation
function Auras:ToggleOverlayGlow(object,toggle,enemyCheck)
	--local glow = self.db.char.auras[SSA.spec].auras[object:GetName()].glow
	
	if (enemyCheck and not UnitIsFriend('target','player')) then
		if (toggle) then
			if (not object.isGlowing) then
				--[[if (glow.) then
					object.triggerTime = GetTime()
				end]]
				
				object.isGlowing = true
				LBG.ShowOverlayGlow(object)
			end
		else
			if (object.isGlowing) then
				--[[if (object.triggerTime) then
					object.triggerTime = 0
				end]]
				
				object.isGlowing = false
				LBG.HideOverlayGlow(object)
			end
		end
	else
		if (toggle) then
			if (not object.isGlowing) then
				--[[if (object.triggerTime) then
					object.triggerTime = GetTime()
				end]]
				
				object.isGlowing = true
				LBG.ShowOverlayGlow(object)
			end
		else
			if (object.isGlowing) then
				--[[if (object.triggerTime) then
					object.triggerTime = 0
				end]]
				
				object.isGlowing = false
				LBG.HideOverlayGlow(object)
			end
		end
	end
end




