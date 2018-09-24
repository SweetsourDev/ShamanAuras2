local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local UnitChannelInfo = UnitChannelInfo

-- Cache Global Addon Variables
local AuraBase = SSA.AuraBase

local ChannelBar = CreateFrame('StatusBar','ChannelBar',AuraBase)
ChannelBar:SetStatusBarTexture(LSM.MediaTable.statusbar['Glamour2'])
ChannelBar:GetStatusBarTexture():SetHorizTile(false)
ChannelBar:GetStatusBarTexture():SetVertTile(false)
ChannelBar:RegisterForDrag('LeftButton')
ChannelBar:SetPoint('TOPLEFT',AuraBase,'CENTER',0,0)
ChannelBar:Show()
ChannelBar:SetAlpha(0)

ChannelBar.spark = ChannelBar:CreateTexture(nil,'OVERLAY')
ChannelBar.spark:SetBlendMode('ADD')
ChannelBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])

ChannelBar.icon = ChannelBar:CreateTexture(nil,'OVERLAY')

ChannelBar.bg = ChannelBar:CreateTexture(nil,'BACKGROUND')
ChannelBar.bg:SetAllPoints(true)

ChannelBar.timetext = ChannelBar:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLarge')
ChannelBar.nametext = ChannelBar:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLarge')

ChannelBar.startTime = 0
ChannelBar.endTime = 0
ChannelBar.isChannel = false
ChannelBar.duration = 0
ChannelBar.progress = 0

ChannelBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(nil,0)) then
		local spec = GetSpecialization()
		local db = Auras.db.char
		local bar = Auras.db.char.statusbars[spec].bars.ChannelBar
		local isMoving = db.elements.isMoving
		
		Auras:ToggleProgressBarMove(self,isMoving,bar)
		
		if (isMoving) then
			local name,_,texture = GetSpellInfo(6196)

			self:SetMinMaxValues(0,60)
			self:SetValue(60)
			self.nametext:SetText(name)
			self.timetext:SetText('59.9')
			
			if (bar.icon.isEnabled) then
				self.icon:Show()
				self.icon:SetTexture(texture)
			end
			self.spark:Hide()
		end
		
		if (bar.adjust.isEnabled) then
			local name,_,texture = GetSpellInfo(6196)
			self.nametext:SetText(name)
			self:SetAlpha(1)
			
			Auras:AdjustStatusBarText(self.nametext,bar.nametext)
			Auras:AdjustStatusBarText(self.timetext,bar.timetext)
			Auras:AdjustStatusBarIcon(self,bar,texture)
			
			if (bar.adjust.showBG) then
				self:SetMinMaxValues(0,1)
				self:SetValue(0.33)
				self.timetext:SetText('20.0')
				Auras:AdjustStatusBarSpark(self,bar,0.33)
			else
				self:SetMinMaxValues(0,1)
				self:SetValue(1)
				self.timetext:SetText('60.0')
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
			local spellName,_,_,_,_,endTime = UnitChannelInfo('player')
			
			if (self.isChannel and spellName) then
				local timer,seconds = Auras:parseTime(self.endTime - GetTime(),true)

				self:SetValue(seconds)
				self.timetext:SetText(timer)
				
				if (bar.spark) then
					self.progress = self.endTime - GetTime()
					
					self.spark:SetPoint('CENTER', self, 'LEFT', (self.progress / self.duration) * self:GetWidth(), 0)
				end
				
				if (Auras:IsPlayerInCombat(true)) then
					self:SetAlpha(bar.alphaCombat)
				else
					self:SetAlpha(bar.alphaOoC)
					
				end
				self.bg:SetAlpha(bar.background.color.a)
			else
				self.isChannel = false
				self:SetAlpha(0)
			end
		elseif (not bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
			self:SetAlpha(0)
		end
	else
		self:SetAlpha(0)
	end
end)

ChannelBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseDown(self,'AuraBase',button)
	end
end)

ChannelBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[GetSpecialization()].statusbars.channelBar)
	end
end)

SSA.ChannelBar = ChannelBar