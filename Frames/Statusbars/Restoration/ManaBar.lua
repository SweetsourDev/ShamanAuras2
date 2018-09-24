local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global Lua Functions
local floor = math.floor

-- Cache Global WoW API Functions
local UnitAffectingCombat, UnitPower, UnitPowerMax = UnitAffectingCombat, UnitPower, UnitPowerMax

-- Cache Global Addon Variables
local AuraBase = SSA.AuraBase

local ManaBar = CreateFrame('StatusBar','ManaBar',AuraBase)

ManaBar:SetStatusBarTexture([[Interface\addons\ShamanAuras\media\statusbar\fifths]])
ManaBar:GetStatusBarTexture():SetHorizTile(false)
ManaBar:GetStatusBarTexture():SetVertTile(false)
ManaBar:Show()
ManaBar:SetAlpha(0)

ManaBar.bg = ManaBar:CreateTexture(nil,'BACKGROUND')
ManaBar.bg:SetAllPoints(true)

ManaBar.text = ManaBar:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')
ManaBar.text:SetPoint('CENTER',ManaBar,'CENTER',0,0)
ManaBar.text:SetTextColor(1,1,1,1)

ManaBar:SetScript('OnUpdate',function(self)	
	if (Auras:CharacterCheck(3)) then
		local powerID = Enum.PowerType.Mana
		local isCombat = UnitAffectingCombat('player')
		local power,maxPower = UnitPower('player',powerID),UnitPowerMax('player',powerID)
		
		local db = Auras.db.char
		local bar = db.elements[3].statusbars.manaBar
		local isMoving = db.elements.isMoving
		
		local _,maxVal = self:GetMinMaxValues()
		
		if (maxVal ~= maxPower) then
			self:SetMinMaxValues(0,maxPower)
		end
		
		Auras:ToggleProgressBarMove(self,isMoving,bar)
		
		if (isMoving) then
			self:SetValue(maxPower)
			self.text:SetText(maxPower)
		end

		if (bar.adjust.isEnabled) then
			local tempPower = floor(maxPower - (maxPower * 0.75))
			
			self:SetAlpha(1)
			
			Auras:AdjustStatusBarText(self.text,bar.text)

			if (bar.adjust.showBG) then
				self:SetValue(tempPower)
				self.text:SetText(Auras:ManaPrecision(bar.precision,false,true))
			else
				self:SetMinMaxValues(0,maxPower)
				self:SetValue(maxPower)
				self.text:SetText(maxPower)
			end

			self:SetStatusBarTexture(LSM.MediaTable.statusbar[bar.foreground.texture])
			self:SetStatusBarColor(bar.foreground.color.r,bar.foreground.color.g,bar.foreground.color.b)

			self.bg:SetTexture(LSM.MediaTable.statusbar[bar.background.texture])
			self.bg:SetVertexColor(bar.background.color.r,bar.background.color.g,bar.background.color.b,bar.background.color.a)

			self:SetWidth(bar.layout.width)
			self:SetHeight(bar.layout.height)
			self:SetPoint(bar.layout.point,AuraGroup,bar.layout.point,bar.layout.x,bar.layout.y)
			self:SetFrameStrata(bar.layout.strata)
		end
			
		if (bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
			
			if (bar.text.isDisplayText) then
				self.text:SetText(Auras:ManaPrecision(bar.precision,true))
			else
				self.text:SetText('')
			end
			
			self:SetValue(UnitPower('player',powerID))
			
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
		self:SetAlpha(0)
	end
end)

ManaBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseDown(self,'AuraBase',button)
	end
end)

ManaBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[3].statusbars.manaBar)
	end
end)

SSA.ManaBar = ManaBar
_G['SSA_ManaBar'] = ManaBar