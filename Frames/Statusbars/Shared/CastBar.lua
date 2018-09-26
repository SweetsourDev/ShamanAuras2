local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local UnitCastingInfo = UnitCastingInfo

-- Cache Global Addon Variables
local AuraBase = SSA.AuraBase

local CastBar = CreateFrame('StatusBar','CastBar',AuraBase)

CastBar:SetStatusBarTexture([[Interface\addons\ShamanAuras\media\statusbar\Glamour2]])
CastBar:GetStatusBarTexture():SetHorizTile(false)
CastBar:GetStatusBarTexture():SetVertTile(false)
CastBar:RegisterForDrag('LeftButton')
CastBar:SetPoint('TOPLEFT',AuraBase,'CENTER',0,0)
CastBar:Show()
CastBar:SetAlpha(0)

CastBar.spark = CastBar:CreateTexture(nil,'OVERLAY')
CastBar.spark:SetBlendMode('ADD')
CastBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])

CastBar.bg = CastBar:CreateTexture(nil,'BACKGROUND')
CastBar.bg:SetAllPoints(true)

--SSA.DataFrame.text:SetText("Border Width: "..tostring(borderWidth))
CastBar.border = CreateFrame("Frame",'nil',CastBar)
CastBar.border:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
	tile = true, tileSize = 0, edgeSize = 1, 
	insets = { left = -1, right = -1, top = -1, bottom = -1 },
})
CastBar.border:SetBackdropColor(0,0,0,1)
CastBar.border:SetFrameLevel(CastBar:GetFrameLevel())

CastBar.icon = CastBar:CreateTexture(nil,'OVERLAY')

CastBar.safezone = CastBar:CreateTexture(nil,'OVERLAY')
CastBar.safezone:SetColorTexture(0.54,0.26,0.26)
CastBar.safezone:SetPoint('RIGHT',CastBar,'RIGHT',0,0)
CastBar.safezone:SetAlpha(0)

CastBar.timetext = CastBar:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLarge')
CastBar.nametext = CastBar:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLarge')

CastBar:RegisterUnitEvent("UNIT_SPELLCAST_START","player")

CastBar.startTime = 0
CastBar.endTime = 0
CastBar.duration = 0
CastBar.spellName = ''
CastBar.isCast = false
CastBar.progress = 0

CastBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(nil,0)) then
		local spec = GetSpecialization()
		local db = Auras.db.char
		local bar = Auras.db.char.statusbars[spec].bars.CastBar
		local isMoving = db.elements.isMoving

		Auras:ToggleProgressBarMove(self,isMoving,bar)
		
		if (not db.elements[spec].statusbars.defaultBar and CastingBarFrame:IsShown()) then
			CastingBarFrame:Hide()
		end
		
		if (isMoving) then
			local name,_,texture = GetSpellInfo(51505)

			self:SetMinMaxValues(0,3)
			self:SetValue(3)
			self.nametext:SetText(name)
			self.timetext:SetText('3.0')
			
			if (bar.icon.isEnabled) then
				self.icon:Show()
				self.icon:SetTexture(texture)
			end
			self.spark:Hide()
		end
		
		if (bar.adjust.isEnabled) then
			local name,_,texture = GetSpellInfo(51505)
			self.nametext:SetText(name)
			self.timetext:SetText('3.0')
			self:SetAlpha(1)
			
			Auras:AdjustStatusBarText(self.nametext,bar.nametext)
			Auras:AdjustStatusBarText(self.timetext,bar.timetext)
			Auras:AdjustStatusBarIcon(self,bar,texture)
			--AdjustStatusBarSpark(self,bar)
			
			if (bar.adjust.showBG) then
				self:SetMinMaxValues(0,1)
				self:SetValue(0.33)
				Auras:AdjustStatusBarSpark(self,bar,0.33)
			else
				self:SetMinMaxValues(0,1)
				self:SetValue(1)
				Auras:AdjustStatusBarSpark(self,bar,1)
			end
			
			self:SetStatusBarTexture(LSM.MediaTable.statusbar[bar.foreground.texture])
			self:SetStatusBarColor(bar.foreground.color.r,bar.foreground.color.g,bar.foreground.color.b)
			
			self.bg:SetTexture(LSM.MediaTable.statusbar[bar.background.texture])
			self.bg:SetVertexColor(bar.background.color.r,bar.background.color.g,bar.background.color.b,bar.background.color.a)
			
			self:SetHeight(bar.layout.height)
			self:SetFrameStrata(bar.layout.strata)			
		end
		
		if (bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
			local spellName = UnitCastingInfo('player')
			if (self.isCast and (spellName or GetTime() == self.endTime)) then
				if (bar.timetext.isDisplayText) then
					local timer,seconds = Auras:parseTime(self.endTime - GetTime(),true)
					local diff = 0
					if (self.isChannel) then
						diff = seconds
					else
						diff = self.duration - seconds
					end

					self:SetValue(diff)
					self.timetext:SetText(timer)
				else
					self.timetext:SetText('')
				end
				if (bar.spark) then
					self.progress = self.endTime - GetTime()

					if (self.duration > 0 and self.progress > 0) then
						local position = self:GetWidth() - (self:GetWidth() / (self.duration / self.progress))
					end
					
					self.spark:SetPoint('CENTER', self, 'LEFT', position, 0)
				end
				
				if (Auras:IsPlayerInCombat(true)) then
					self:SetAlpha(bar.alphaCombat)
				else
					self:SetAlpha(bar.alphaOoC)
					
				end
				self.bg:SetAlpha(bar.background.color.a)
			else
				self.isCast = false
				self:SetAlpha(0)
			end
		elseif (not bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
			self:SetAlpha(0)
		end
	else
		self:SetAlpha(0)
	end
end)

CastBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseDown(self,'AuraBase',button)
	end
end)

CastBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[GetSpecialization()].statusbars.castBar)
	end
end)

CastBar:SetScript("OnEvent",function(self,event,...)
	if (event ~= "UNIT_SPELLCAST_START") then
		return
	end
	
	local spec = GetSpecialization()
	local bar = Auras.db.char.statusbars[spec].bars[self:GetName()]
	local spellName,_,texture,startTime,endTime = UnitCastingInfo('player')

	--local duration = (endTime - startTime) / 1000
	endTime = endTime / 1e3
	startTime = startTime / 1e3
	
	self.HideTime = 0
	
	self.startTime = startTime
	self.endTime = endTime
	self.duration = endTime - startTime
	self.spellName = spellName
	self.isCast = true
	
	if (bar.icon.isEnabled) then
		if (not self.icon:IsShown()) then
			self.icon:Show()
		end
		
		self.icon:SetTexture(texture)
		self:SetWidth(bar.layout.width - bar.layout.height)
	else
		if (self.icon:IsShown()) then
			self.icon:Hide()
		end
		
		self:SetWidth(bar.layout.width)
	end
	
	if (bar.spark) then
		if (not self.spark:IsShown()) then
			self.spark:Show()
		end
		
		self.spark:SetSize(20,(self:GetHeight() * 2.5))
	else
		if (self.spark:IsShown()) then
			self.spark:Hide()
		end
	end
	
	self:SetMinMaxValues(0,self.duration)
	if (bar.nametext.isDisplayText) then
		self.nametext:SetText(spellName)
	else
		self.nametext:SetText('')
	end
	
	self:Show();
	
end)

SSA.CastBar = CastBar
_G['SSA_CastBar'] = CastBar