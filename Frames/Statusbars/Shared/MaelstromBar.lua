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

local MaelstromBar = CreateFrame('StatusBar','MaelstromBar',AuraBase)

MaelstromBar:SetStatusBarTexture([[Interface\addons\ShamanAuras\media\statusbar\fifths]])
MaelstromBar:GetStatusBarTexture():SetHorizTile(false)
MaelstromBar:GetStatusBarTexture():SetVertTile(false)
MaelstromBar:RegisterForDrag('LeftButton')
MaelstromBar:SetPoint('CENTER',AuraBase,'CENTER',0,-139)
--MaelstromBar:SetFrameStrata('LOW')
--MaelstromBar:SetStatusBarColor(0,0.5,1)
MaelstromBar:Show()
--MaelstromBar:SetAlpha(0)

MaelstromBar.bg = MaelstromBar:CreateTexture(nil,'BACKGROUND')
--MaelstromBar.bg:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
MaelstromBar.bg:SetAllPoints(true)
--MaelstromBar.bg:SetVertexColor(0,0,0)
--MaelstromBar.bg:SetAlpha(0.5)

MaelstromBar.text = MaelstromBar:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')


--[[MaelstromBar.Lightning = CreateFrame('PlayerModel','MaelstromBarLightning',MaelstromBar)
MaelstromBarLightning:SetModel('SPELLS/LIGHTNING_AREA_DISC_STATE.m2')
MaelstromBarLightning:SetFrameStrata('MEDIUM')
MaelstromBarLightning:SetPosition(0,0,-2)
MaelstromBarLightning:SetPoint('CENTER',AuraGroup,'CENTER',0,-139)
MaelstromBarLightning:SetWidth(260)
MaelstromBarLightning:SetHeight(21)
--MaelstromBarLightning:SetAllPoints(MaelstromBar)
MaelstromBarLightning:SetAlpha(0)
MaelstromBarLightning:Show()
local elapsed = 0
MaelstromBarLightning:HookScript('OnUpdate', function(self, elaps)
	elapsed = elapsed + (elaps * 1000)
	self:SetSequenceTime(1, elapsed)
end)]]

MaelstromBar.Elapsed = 0
MaelstromBar.Lightning = CreateFrame('PlayerModel','MaelstromBarLightning',MaelstromBar)
MaelstromBar.Lightning:SetModel('SPELLS/LIGHTNING_AREA_DISC_STATE.m2')
MaelstromBar.Lightning:SetFrameStrata('MEDIUM')
MaelstromBar.Lightning:SetPosition(0,0,-2)
MaelstromBar.Lightning:SetRotation(0)
--MaelstromBar.Lightning:SetCamera(0)
MaelstromBar.Lightning:SetAllPoints(MaelstromBar)
--MaelstromBarLightning:SetAllPoints(MaelstromBar)
MaelstromBar.Lightning:SetAlpha(0)
MaelstromBar.Lightning:SetSequence(37)

MaelstromBar:SetScript('OnUpdate',function(self,elaps)
	if (Auras:CharacterCheck(nil,1) or Auras:CharacterCheck(nil,2)) then
		local powerID = Enum.PowerType.Maelstrom
		--local spec = GetSpecialization()
		local isCombat = UnitAffectingCombat('player')
		local power,maxPower = UnitPower('player',powerID),UnitPowerMax('player',powerID)

		local db = Auras.db.char
		local bar = db.statusbars[SSA.spec].bars.MaelstromBar
		local isMoving = db.elements.isMoving

		local _,maxVal = self:GetMinMaxValues()
		
		if (maxVal ~= maxPower) then
			self:SetMinMaxValues(0,maxPower)
		end

		Auras:ToggleProgressBarMove(self,isMoving,bar)
		
		if (isMoving and not bar.attachToHealth) then
			self:SetValue(maxPower)
			self.text:SetText(maxPower)
		end
		
		if (bar.adjust.isEnabled) then
			local tempPower = floor(maxPower - (maxPower * 0.75))
			self.text:SetText(tostring(tempPower))
			
			self:SetAlpha(1)
			
			Auras:AdjustStatusBarText(self.text,bar.text)
			
			if (bar.adjust.showBG) then
				self:SetValue(tempPower)
				self.text:SetText(tempPower)
			else
				self.text:SetText(maxPower)
				self:SetValue(maxPower)
			end

			self:SetStatusBarTexture(LSM.MediaTable.statusbar[bar.foreground.texture])
			self:SetStatusBarColor(bar.foreground.color.r,bar.foreground.color.g,bar.foreground.color.b)
			
			self.bg:SetTexture(LSM.MediaTable.statusbar[bar.background.texture])
			self.bg:SetVertexColor(bar.background.color.r,bar.background.color.g,bar.background.color.b,bar.background.color.a)
			
			self:SetWidth(bar.layout.width)
			self:SetHeight(bar.layout.height)
			self:SetPoint(bar.layout.point,SSA[bar.layout.relativeTo],bar.layout.point,bar.layout.x,bar.layout.y)
			self:SetFrameStrata(bar.layout.strata)
		end

		if (bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then	
			--[[self:ClearAllPoints()
			
			if (bar.attachToHealth and db.elements[1].statusbars.healthBar.isEnabled) then
				self:SetPoint("TOP",HealthBar,"BOTTOM",0,0)
			else
				self:SetPoint(bar.layout.point,AuraGroup,bar.layout.relativePoint,bar.layout.x,bar.layout.y) 
			end]]
			
			self:SetValue(power)
			if (bar.text.isDisplayText) then
				self.text:SetText(power)
			else
				self.text:SetText('')
			end
			if (power >= bar.threshold and bar.animate) then
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
		elseif (not bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
			self:SetAlpha(0)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'alpha')
	end	
end)

MaelstromBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseDown(self,'AuraBase',button)
	end
end)

MaelstromBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[GetSpecialization()].statusbars.maelstromBar)
	end
end)

SSA.MaelstromBar = MaelstromBar
_G['SSA_MaelstromBar'] = MaelstromBar