local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global Lua Functions
local floor = math.floor
local format = format

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax

local HealthBar = CreateFrame('StatusBar','HealthBar1',AuraGroup)

HealthBar:SetStatusBarTexture([Interface\addons\ShamanAuras\media\statusbar\fifths])
HealthBar:GetStatusBarTexture():SetHorizTile(false)
HealthBar:GetStatusBarTexture():SetVertTile(false)
HealthBar:Hide()
HealthBar:SetAlpha(0)

HealthBar.bg = HealthBar:CreateTexture(nil,'BACKGROUND')
HealthBar.bg:SetAllPoints(true)

HealthBar.numtext = HealthBar:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')
HealthBar.perctext = HealthBar:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')
--HealthBar.text:SetPoint('CENTER',HealthBar,'CENTER',0,0)
--HealthBar.text:SetTextColor(1,1,1,1)


HealthBar:SetScript('OnUpdate',function(self)	
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:CharacterCheck(nil,1)) then
			--local isCombat = UnitAffectingCombat('player')
			local health,maxHealth = UnitHealth('player'),UnitHealthMax('player')
			
			local db = Auras.db.char
			local bar = db.elements[1].statusbars.healthBar
			local isMoving = db.settings.move.isMoving
			
			local _,maxVal = self:GetMinMaxValues()
			
			if (maxVal ~= maxHealth) then
				self:SetMinMaxValues(0,maxHealth)
			end
			
			Auras:ToggleProgressBarMove(self,isMoving,bar)
			
			if (isMoving) then
				self:SetValue(maxHealth)
				self.text:SetText(maxHealth)
			end

			if (bar.adjust.isEnabled) then
				local tempPower = math.floor(maxHealth - (maxHealth * 0.75))
				
				self:SetAlpha(1)
				
				Auras:AdjustStatusBarText(self.text,bar.text)

				if (bar.adjust.showBG) then
					self:SetValue(tempPower)
					self.text:SetText(Auras:ManaPrecision(bar.precision,false,true))
				else
					self:SetMinMaxValues(0,maxHealth)
					self:SetValue(maxHealth)
					self.text:SetText(maxHealth)
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
				
				if (bar.numtext.isDisplayText) then
					self.numtext:SetText(Auras:HealthPrecision(bar.precision,true))
				else
					self.numtext:SetText('')
				end
				
				if (bar.perctext.isDisplayText) then
					self.perctext:SetText(format("%.2f",(health / maxHealth) * 100).."%")
				else
					self.perctext:SetText('')
				end
				
				self:SetValue(UnitHealth('player'))
				self:SetAlpha(1)
				
				-- if (isCombat) then
					-- self:SetAlpha(bar.alphaCombat)				
				-- elseif (not isCombat and Auras:IsTargetEnemy()) then
					-- self:SetAlpha(bar.alphaTar)
					-- self.bg:SetAlpha(bar.background.color.a)
				-- elseif (not isCombat and not Auras:IsTargetEnemy()) then
					-- self:SetAlpha(bar.alphaOoC)
					-- self.bg:SetAlpha(bar.background.color.a)
				-- end
			elseif (not bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
				self:SetAlpha(0)
			end
		else
			self:SetAlpha(0)
		end
	end
end)

HealthBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

HealthBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.statusbars[1].bars.HealthBar)
	end
end)

SSA.HealthBar1 = HealthBar
_G['SSA_HealthBar1'] = HealthBar