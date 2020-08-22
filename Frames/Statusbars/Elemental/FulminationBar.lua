local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global Lua Functions
local floor = math.floor
local tostring = tostring

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local UnitAffectingCombat, UnitPower, UnitPowerMax = UnitAffectingCombat, UnitPower, UnitPowerMax

-- Cache Global Addon Variables
local AuraBase = SSA.AuraBase

local FulminationBar = CreateFrame('StatusBar','FulminationBar',AuraBase)

FulminationBar:SetStatusBarTexture([[Interface\addons\ShamanAuras\media\statusbar\eighths]])
FulminationBar:GetStatusBarTexture():SetHorizTile(false)
FulminationBar:GetStatusBarTexture():SetVertTile(false)
FulminationBar:RegisterForDrag('LeftButton')
FulminationBar:SetPoint('CENTER',AuraBase,'CENTER',0,-139)
FulminationBar:SetMinMaxValues(0,8)
--FulminationBar:SetFrameStrata('LOW')
--FulminationBar:SetStatusBarColor(0,0.5,1)
FulminationBar:Show()
--FulminationBar:SetAlpha(0)

FulminationBar.bg = FulminationBar:CreateTexture(nil,'BACKGROUND')
--FulminationBar.bg:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
FulminationBar.bg:SetAllPoints(true)
--FulminationBar.bg:SetVertexColor(0,0,0)
--FulminationBar.bg:SetAlpha(0.5)

-- Build Fulmination Timer Status Bar
FulminationBar.Timer = CreateFrame('StatusBar','FulminationTimer',FulminationBar)
FulminationBar.Timer:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
FulminationBar.Timer:GetStatusBarTexture():SetHorizTile(false)
FulminationBar.Timer:GetStatusBarTexture():SetVertTile(false)
FulminationBar.Timer:SetFrameStrata("MEDIUM")
FulminationBar.Timer:SetMinMaxValues(0,30)

FulminationBar.counttext = FulminationBar.Timer:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')
FulminationBar.timetext = FulminationBar.Timer:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')

--[[FulminationBar.Lightning = CreateFrame('PlayerModel','FulminationBarLightning',FulminationBar)
FulminationBarLightning:SetModel('SPELLS/LIGHTNING_AREA_DISC_STATE.m2')
FulminationBarLightning:SetFrameStrata('MEDIUM')
FulminationBarLightning:SetPosition(0,0,-2)
FulminationBarLightning:SetPoint('CENTER',AuraGroup,'CENTER',0,-139)
FulminationBarLightning:SetWidth(260)
FulminationBarLightning:SetHeight(21)
--FulminationBarLightning:SetAllPoints(FulminationBar)
FulminationBarLightning:SetAlpha(0)
FulminationBarLightning:Show()
local elapsed = 0
FulminationBarLightning:HookScript('OnUpdate', function(self, elaps)
	elapsed = elapsed + (elaps * 1000)
	self:SetSequenceTime(1, elapsed)
end)]]

FulminationBar.Elapsed = 0
FulminationBar.Lightning = CreateFrame('PlayerModel','FulminationBarLightning',FulminationBar)
--FulminationBar.Lightning:SetModel('SPELLS/LIGHTNING_AREA_DISC_STATE.m2')
FulminationBar.Lightning:SetModel(797945)
FulminationBar.Lightning:SetFrameStrata('MEDIUM')
FulminationBar.Lightning:SetPosition(0,0,-2)
FulminationBar.Lightning:SetRotation(0)
--FulminationBar.Lightning:SetCamera(0)
FulminationBar.Lightning:SetAllPoints(FulminationBar)
--FulminationBarLightning:SetAllPoints(FulminationBar)
FulminationBar.Lightning:SetAlpha(0)
FulminationBar.Lightning:SetSequence(37)

FulminationBar:SetScript('OnUpdate',function(self,elaps)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:CharacterCheck(nil,1) or Auras:IsPreviewingStatusbar(self)) then
			--local powerID = Enum.PowerType.Maelstrom
			--local spec = GetSpecialization()
			local isCombat = UnitAffectingCombat('player')
			--local power,maxPower = UnitPower('player',powerID),UnitPowerMax('player',powerID)

			local db = Auras.db.char
			local bar = db.statusbars[SSA.spec].bars.FulminationBar
			local isMoving = db.settings.move.isMoving

			--[[local _,maxVal = self:GetMinMaxValues()
			
			if (maxVal ~= maxPower) then
				self:SetMinMaxValues(0,maxPower)
			end]]

			Auras:ToggleProgressBarMove(self,isMoving,bar)
			
			if (isMoving and not bar.attachToHealth) then
				self:SetValue(8)
				self.counttext:SetText('8')
				self.Timer:SetValue(30)
				self.timetext:SetText('30')
			end
			
			if (Auras:IsPreviewingStatusbar(self)) then
				self:SetAlpha(1)
				
				Auras:AdjustStatusBarText(self.counttext,bar.counttext)
				Auras:AdjustStatusBarText(self.timetext,bar.timetext)
				
				if (bar.adjust.showBG) then
					self:SetValue(3)
					self.Timer:SetValue(15)
					self.counttext:SetText('3')
					self.timetext:SetText('15')
				else
					self:SetValue(8)
					self.Timer:SetValue(20)
					self.counttext:SetText('8')
					self.timetext:SetText('20')
				end

				if (bar.adjust.showTimer) then
					self.Timer:SetStatusBarTexture(LSM.MediaTable.statusbar[bar.timerBar.texture])
				else
					self.Timer:SetStatusBarTexture(nil)
				end

				self:SetStatusBarTexture(LSM.MediaTable.statusbar[bar.foreground.texture])
				self:SetStatusBarColor(bar.foreground.color.r,bar.foreground.color.g,bar.foreground.color.b)
				
				self.Timer:SetStatusBarColor(bar.timerBar.color.r,bar.timerBar.color.g,bar.timerBar.color.b,bar.timerBar.color.a)

				self.bg:SetTexture(LSM.MediaTable.statusbar[bar.background.texture])
				self.bg:SetVertexColor(bar.background.color.r,bar.background.color.g,bar.background.color.b,bar.background.color.a)
				
				self:SetWidth(bar.layout.width)
				self:SetHeight(bar.layout.height)
				self:SetPoint(bar.layout.point,SSA[bar.layout.relativeTo],bar.layout.point,bar.layout.x,bar.layout.y)
				self:SetFrameStrata(bar.layout.strata)

				self.Timer:SetWidth(bar.layout.width)
				self.Timer:SetHeight(bar.layout.height)
				self.Timer:SetFrameStrata(bar.timerBar.strata)
				self.Timer:SetAlpha(1)
			end

			if (bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then	
				local buff,_,count,_,duration,expires = Auras:RetrieveAuraInfo("player", 260111)
				--[[self:ClearAllPoints()
				
				if (bar.attachToHealth and db.elements[1].statusbars.healthBar.isEnabled) then
					self:SetPoint("TOP",HealthBar,"BOTTOM",0,0)
				else
					self:SetPoint(bar.layout.point,AuraGroup,bar.layout.relativePoint,bar.layout.x,bar.layout.y) 
				end]]
				if (buff) then
					local timer,seconds = Auras:parseTime(expires - GetTime(),false)

					self:SetValue(count)
					if (bar.counttext.isDisplayText) then
						self.counttext:SetText(count)
					else
						self.counttext:SetText('')
					end

					self.Timer:SetValue(seconds)
					if (bar.timetext.isDisplayText) then
						self.timetext:SetText(format('%.1f',seconds))
					else
						self.timetext:SetText('')
					end

					--if (power >= bar.threshold and bar.animate) then
					if (count >= 5 and bar.animate) then
						self.Lightning:SetAlpha(bar.alphaCombat)
						self.bg:SetAlpha(bar.alphaCombat)
					else
						self.Lightning:SetAlpha(0)
						self.bg:SetAlpha(bar.alphaCombat / 2)
					end

					if (isCombat) then
						self:SetAlpha(bar.alphaCombat)				
					elseif (not isCombat and Auras:IsTargetEnemy()) then
						self:SetAlpha(bar.alphaTar)
						self.bg:SetAlpha(bar.background.color.a)
					elseif (not isCombat and not Auras:IsTargetEnemy()) then
						self:SetAlpha(bar.alphaOoC)
						self.bg:SetAlpha(bar.background.color.a)
					end
				else
					--[[self:SetValue(0)
					self.Timer:SetValue(0)
					self.counttext:SetText('0')
					self.timetext:SetText('0')]]
					self:SetAlpha(0)
				end		
					
				
			elseif (not bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
				self:SetAlpha(0)
			end
		else
			Auras:ToggleAuraVisibility(self,false,'alpha')
		end
	end
end)

FulminationBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

FulminationBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.statusbars[SSA.spec].bars.FulminationBar)
	end
end)

SSA.FulminationBar = FulminationBar
_G['SSA_FulminationBar'] = FulminationBar