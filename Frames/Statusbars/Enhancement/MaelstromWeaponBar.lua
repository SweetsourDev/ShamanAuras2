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

local MaelstromWeaponBar = CreateFrame('StatusBar','MaelstromWeaponBar',AuraBase)

MaelstromWeaponBar:SetStatusBarTexture([[Interface\addons\ShamanAuras\media\statusbar\tenths]])
MaelstromWeaponBar:GetStatusBarTexture():SetHorizTile(false)
MaelstromWeaponBar:GetStatusBarTexture():SetVertTile(false)
MaelstromWeaponBar:RegisterForDrag('LeftButton')
MaelstromWeaponBar:SetPoint('CENTER',AuraBase,'CENTER',0,-139)
MaelstromWeaponBar:SetMinMaxValues(0,10)
--MaelstromWeaponBar:SetFrameStrata('LOW')
--MaelstromWeaponBar:SetStatusBarColor(0,0.5,1)
MaelstromWeaponBar:Show()
--MaelstromWeaponBar:SetAlpha(0)

MaelstromWeaponBar.bg = MaelstromWeaponBar:CreateTexture(nil,'BACKGROUND')
--MaelstromWeaponBar.bg:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
MaelstromWeaponBar.bg:SetAllPoints(true)
--MaelstromWeaponBar.bg:SetVertexColor(0,0,0)
--MaelstromWeaponBar.bg:SetAlpha(0.5)

-- Build Fulmination Timer Status Bar
MaelstromWeaponBar.Timer = CreateFrame('StatusBar','FulminationTimer',MaelstromWeaponBar)
MaelstromWeaponBar.Timer:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
MaelstromWeaponBar.Timer:GetStatusBarTexture():SetHorizTile(false)
MaelstromWeaponBar.Timer:GetStatusBarTexture():SetVertTile(false)
MaelstromWeaponBar.Timer:SetFrameStrata("MEDIUM")
MaelstromWeaponBar.Timer:SetMinMaxValues(0,30)

MaelstromWeaponBar.counttext = MaelstromWeaponBar.Timer:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')
MaelstromWeaponBar.timetext = MaelstromWeaponBar.Timer:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')

--[[MaelstromWeaponBar.Lightning = CreateFrame('PlayerModel','MaelstromWeaponBarLightning',MaelstromWeaponBar)
MaelstromWeaponBarLightning:SetModel('SPELLS/LIGHTNING_AREA_DISC_STATE.m2')
MaelstromWeaponBarLightning:SetFrameStrata('MEDIUM')
MaelstromWeaponBarLightning:SetPosition(0,0,-2)
MaelstromWeaponBarLightning:SetPoint('CENTER',AuraGroup,'CENTER',0,-139)
MaelstromWeaponBarLightning:SetWidth(260)
MaelstromWeaponBarLightning:SetHeight(21)
--MaelstromWeaponBarLightning:SetAllPoints(MaelstromWeaponBar)
MaelstromWeaponBarLightning:SetAlpha(0)
MaelstromWeaponBarLightning:Show()
local elapsed = 0
MaelstromWeaponBarLightning:HookScript('OnUpdate', function(self, elaps)
	elapsed = elapsed + (elaps * 1000)
	self:SetSequenceTime(1, elapsed)
end)]]

MaelstromWeaponBar.Elapsed = 0
MaelstromWeaponBar.Lightning = CreateFrame('PlayerModel','MaelstromWeaponBarLightning',MaelstromWeaponBar)
--MaelstromWeaponBar.Lightning:SetModel('SPELLS/LIGHTNING_AREA_DISC_STATE.m2')
MaelstromWeaponBar.Lightning:SetModel(797945)
MaelstromWeaponBar.Lightning:SetFrameStrata('MEDIUM')
MaelstromWeaponBar.Lightning:SetPosition(0,0,-2)
MaelstromWeaponBar.Lightning:SetRotation(0)
--MaelstromWeaponBar.Lightning:SetCamera(0)
MaelstromWeaponBar.Lightning:SetAllPoints(MaelstromWeaponBar)
--MaelstromWeaponBarLightning:SetAllPoints(MaelstromWeaponBar)
MaelstromWeaponBar.Lightning:SetAlpha(0)
MaelstromWeaponBar.Lightning:SetSequence(37)

MaelstromWeaponBar:SetScript('OnUpdate',function(self,elaps)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:CharacterCheck(nil,2) or Auras:IsPreviewingStatusbar(self)) then
			--local powerID = Enum.PowerType.Maelstrom
			--local spec = GetSpecialization()
			local isCombat = UnitAffectingCombat('player')
			--local power,maxPower = UnitPower('player',powerID),UnitPowerMax('player',powerID)

			local db = Auras.db.char
			local bar = db.statusbars[SSA.spec].bars.MaelstromWeaponBar
			local isMoving = db.settings.move.isMoving

			--[[local _,maxVal = self:GetMinMaxValues()
			
			if (maxVal ~= maxPower) then
				self:SetMinMaxValues(0,maxPower)
			end]]

			Auras:ToggleProgressBarMove(self,isMoving,bar)
			
			if (isMoving and not bar.attachToHealth) then
				self:SetValue(10)
				self.counttext:SetText('10')
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
					self:SetValue(10)
					self.Timer:SetValue(20)
					self.counttext:SetText('10')
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
				local buff,_,count,_,duration,expires = Auras:RetrieveAuraInfo("player", 187881)
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

MaelstromWeaponBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

MaelstromWeaponBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.statusbars[SSA.spec].bars.MaelstromWeaponBar)
	end
end)

SSA.MaelstromWeaponBar = MaelstromWeaponBar
_G['SSA_MaelstromWeaponBar'] = MaelstromWeaponBar