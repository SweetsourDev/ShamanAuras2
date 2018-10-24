local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global Lua Functions
local format = format

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local GetTime = GetTime

-- Cache Global Addon Variables
local AuraBase = SSA.AuraBase
--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."IcefuryBar.lua: "..tostring(SSA.AuraBase).."\n")
-- Build the Icefury Bar
local IcefuryBar = CreateFrame('StatusBar','IcefuryBar',SSA.AuraBase)
IcefuryBar:SetStatusBarTexture([[Interface\addons\ShamanAuras\media\statusbar\fourths]])
IcefuryBar:GetStatusBarTexture():SetHorizTile(false)
IcefuryBar:GetStatusBarTexture():SetVertTile(false)
IcefuryBar:RegisterForDrag('LeftButton')
IcefuryBar:SetMinMaxValues(0,4)
IcefuryBar:SetAlpha(0)
IcefuryBar:Show()

IcefuryBar.bg = IcefuryBar:CreateTexture(nil,'BACKGROUND')
IcefuryBar.bg:SetAllPoints(true)

-- Build Icefury Timer Status Bar
IcefuryBar.Timer = CreateFrame('StatusBar','IcefuryTimer',IcefuryBar)
IcefuryBar.Timer:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
IcefuryBar.Timer:GetStatusBarTexture():SetHorizTile(false)
IcefuryBar.Timer:GetStatusBarTexture():SetVertTile(false)
IcefuryBar.Timer:SetFrameStrata("MEDIUM")
IcefuryBar.Timer:SetMinMaxValues(0,15)

IcefuryBar.counttext = IcefuryBar.Timer:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')
IcefuryBar.timetext = IcefuryBar.Timer:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')

IcefuryBar.condition = function()
	local _,_,_,selected = GetTalentInfo(6,3,1)
	
	return selected
end

IcefuryBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(nil,1) and self.condition()) or Auras:IsPreviewingStatusbar(self)) then
		local db = Auras.db.char
		local bar = db.statusbars[1].bars.IcefuryBar
		local isMoving = db.elements[1].isMoving

		Auras:ToggleProgressBarMove(self,isMoving,bar)
		
		if (isMoving) then
			self:SetValue(4)
			self.counttext:SetText('4')
			self.Timer:SetValue(15)
			self.timetext:SetText('15')
		end
		
		if (Auras:IsPreviewingStatusbar(self)) then
			self:SetAlpha(1)
			
			Auras:AdjustStatusBarText(self.counttext,bar.counttext)
			Auras:AdjustStatusBarText(self.timetext,bar.timetext)
			
			if (bar.adjust.showBG) then
				self:SetValue(1)
				self.Timer:SetValue(5)
				self.counttext:SetText('1')
				self.timetext:SetText('5')
			else
				self:SetValue(4)
				self.Timer:SetValue(15)
				self.counttext:SetText('4')
				self.timetext:SetText('15')
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
			local buff,_,count,_,_,expires = Auras:RetrieveAuraInfo("player", Auras:GetSpellName(210714))
			
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
				
				if (UnitAffectingCombat('player')) then
					self:SetAlpha(bar.alphaCombat)
				else
					if (Auras:IsTargetEnemy()) then
						self:SetAlpha(bar.alphaTar)
					else
						self:SetAlpha(bar.alphaOoC)
					end
				end
				self.bg:SetAlpha(bar.background.color.a)
			else
				self:SetAlpha(0)
			end
		elseif (not bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
			self:SetAlpha(0)
		end
	end
end)

IcefuryBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements[1].isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

IcefuryBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements[1].isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.statusbars[1].bars.IcefuryBar)
	end
end);

SSA.IcefuryBar = IcefuryBar
_G['SSA_IcefuryBar'] = IcefuryBar