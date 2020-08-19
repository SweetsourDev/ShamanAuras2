local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global Lua Functions
local floor = math.floor

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local GetTime = GetTime
local UnitHealthMax = UnitHealthMax

-- Cache Global Addon Variables
local AuraBase = SSA.AuraBase

local EarthenWallTotemBar = CreateFrame('StatusBar','EarthenWallTotemBar',AuraBase)
_G['SSA_EarthenWall'] = EarthenWallTotemBar
EarthenWallTotemBar:SetStatusBarTexture([[Interface\addons\ShamanAuras\media\statusbar\fifths]])
EarthenWallTotemBar:GetStatusBarTexture():SetHorizTile(false)
EarthenWallTotemBar:GetStatusBarTexture():SetVertTile(false)
--EarthenWallTotemBar:Hide()
EarthenWallTotemBar:SetAlpha(0)

EarthenWallTotemBar.bg = EarthenWallTotemBar:CreateTexture(nil,'BACKGROUND')
EarthenWallTotemBar.bg:SetAllPoints(true)

EarthenWallTotemBar.Timer = CreateFrame('StatusBar','EarthenWallTimer',EarthenWallTotemBar)
EarthenWallTotemBar.Timer:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
EarthenWallTotemBar.Timer:GetStatusBarTexture():SetHorizTile(false)
EarthenWallTotemBar.Timer:GetStatusBarTexture():SetVertTile(false)
EarthenWallTotemBar.Timer:SetMinMaxValues(0,15)
--EarthenWallTotemBar.Timer:Show()
EarthenWallTotemBar.Timer:SetAlpha(0)

EarthenWallTotemBar.healthtext = EarthenWallTotemBar.Timer:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')
EarthenWallTotemBar.timetext = EarthenWallTotemBar.Timer:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')

EarthenWallTotemBar.expires = 0
EarthenWallTotemBar.GUID = 0
EarthenWallTotemBar.isSummoned = false
EarthenWallTotemBar.condition = function()
	local _,_,_,selected = GetTalentInfo(4,2,1)
	
	return selected
end

EarthenWallTotemBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EarthenWallTotemBar:SetScript('OnUpdate',function(self,elapsed)
	if ((Auras:CharacterCheck(nil,3) and self.condition()) or Auras:IsPreviewingStatusbar(self)) then
		--SSA.DataFrame.text:SetText("ACTIVATE")
		local db = Auras.db.char
		--local bar = db.elements[3].statusbars.earthenWallBar
		local bar = Auras.db.char.statusbars[3].bars[self:GetName()]
		local isMoving = db.settings.move.isMoving
		local maxHealth = UnitHealthMax('player')
		
		local timer,seconds = Auras:parseTime(((bar.data.start + bar.data.duration) - GetTime()),true)
		
		local _,maxVal = self:GetMinMaxValues()
		
		if (maxVal ~= maxHealth) then
			self:SetMinMaxValues(0,maxHealth)
		end
		
		Auras:ToggleProgressBarMove(self,isMoving,bar)
		
		if (isMoving) then
			self:SetValue(maxHealth)
			self.healthtext:SetText('100%')
			self.timetext:SetText('15.0')
			self.Timer:SetValue(15)
		end
		
		if (Auras:IsPreviewingStatusbar(self)) then
			self.healthtext:SetText('75%')
			self.timetext:SetText('5.0')
			
			self:SetAlpha(1)
			
			Auras:AdjustStatusBarText(self.healthtext,bar.healthtext)
			Auras:AdjustStatusBarText(self.timetext,bar.timetext)
			
			self:SetMinMaxValues(0,1)
			self:SetValue(0.75)
			self.Timer:SetValue(5)
			
			if (bar.adjust.showBG) then
				self:SetValue(maxHealth - (maxHealth * 0.75))
				self.healthtext:SetText("25%")
			else
				self:SetValue(maxHealth)
				self.healthtext:SetText("100%")
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
			--self:SetPoint(bar.layout.point,AuraBase,bar.layout.point,bar.layout.x,bar.layout.y)
			self:SetFrameStrata(bar.layout.strata)
			
			self.Timer:SetWidth(bar.layout.width)
			self.Timer:SetHeight(bar.layout.height)
			self.Timer:SetFrameStrata(bar.layout.strata)
			self.Timer:SetAlpha(1)
		end
		
		if (bar.isEnabled and not bar.adjust.isEnabled and not isMoving) then		
			
			if (bar.data.start > 0 and GetTime() < (bar.data.start + 15)) then
			--if (bar.info.GUID ~= '') then
				--[[if (not self:IsShown()) then
					self:Show()
				end]]
				
				self.Timer:SetAlpha(1)
				self.Timer:SetValue(seconds)
				
				if (Auras:IsPlayerInCombat(true)) then
					self:SetAlpha(bar.alphaCombat)
				else
					self:SetAlpha(bar.alphaOoC)
				end
				
				if (bar.timetext.isDisplayText) then
					self.timetext:SetText(timer)
				else
					self.timetext:SetText('')
				end
			else
				--self:Hide()
				bar.data.start = 0
				self:SetAlpha(0)
				self.Timer:SetValue(0)
				self.timetext:SetText('')
			end
			
		elseif (not bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
			--self:Hide()
			self:SetAlpha(0)
		end
	else
		self:SetAlpha(0)
	end
end)

EarthenWallTotemBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

EarthenWallTotemBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.statusbars[3].bars[self:GetName()])
	end
end)

local function UpdateEarthenWall(self,bar)
	--local db  = Auras.db.char
	--local bar = Auras.db.char.elements[3].statusbars.earthenWallBar
	--local shield = Auras.db.char.info.totems.eShield
	
	local progress = ((bar.data.damage or 0) / bar.data.health * 100);
	local remains = (bar.data.health - (bar.data.damage or 0));
	
	progress = 100 - progress;
	
	if (remains > 0) then
		self:SetValue(remains);
		if (bar.healthtext.isDisplayText) then
			self.healthtext:SetText(tostring(math.ceil(progress)).."%");
		else
			if (not bar.adjust.isEnabled and not db.elements[3].isMoving) then
				self.healthtext:SetText('');
			end
		end
	else
		self:Hide();
		--self.Timer:SetAlpha(0);
	end
end

EarthenWallTotemBar:SetScript('OnEvent',function(self,event)
	--if (Auras:CharacterCheck(3)) then
		if (event ~= 'COMBAT_LOG_EVENT_UNFILTERED' or Auras.db.char.isFirstEverLoad) then
			return
		end
		
		local _,subevent,_,sGUID,source,_,_,petGUID,name,_,_,spellID,spellName,_,damage = CombatLogGetCurrentEventInfo()
		local db = Auras.db.char
		
		local auras = db.auras[3]
		local bar = Auras.db.char.statusbars[3].bars[self:GetName()]
		
		
		if (sGUID == UnitGUID('player')) then
			
			
			if (subevent == 'SPELL_CAST_SUCCESS') then
				if (spellID == 61295 or spellID == 1064) then
					TidalWavesBar.healTime = GetTime()
				elseif (spellID == 1064) then
					SSA.Tidebringer.auraTime = 0
					SSA.Tidebringer.doseTime = 0
					SSA.Tidebringer.castTime = GetTime()
				end
			elseif (subevent == 'SPELL_AURA_APPLIED') then
				if (spellID == 269083) then
					SSA.Tidebringer.auraTimer = GetTime()
					Auras.db.char.elements[3].cooldowns.primary[4].tidebringerStart = GetTime()
				end
				--[[if (buffIDs[spellID]) then
					local isValidBuff = false
					
					if ((spellID == 108271 and auras.AstralShiftBar3) or (spellID == 114052 and auras.AscendanceBar3) or (spellID == 108281 and auras.AncestralGuidanceBar3) or (spellID == 2825 and auras.BloodlustBar3) or (spellID == 79206 and auras.SpiritwalkersGraceBar) or (spellID == 32182 and auras.HeroismBar3) or (spellID == 73685 and auras.UnleashLifeBar) or (spellID == 80353 and auras.TimeWarpBar3)) then
						isValidBuff = true
					end
					
					if (isValidBuff) then
						table.insert(buffTable,spellID)
					end
				end]]
			elseif (subevent == "SPELL_AURA_APPLIED_DOSE") then
				if (spellID == 236502) then
					SSA.Tidebringer.auraTime = 0
					
					--SSA.Tidebringer.doseTime = GetTime()
				end
			elseif (subevent == 'SPELL_AURA_REMOVED') then
				if (spellID == 269083) then
					SSA.Tidebringer.auraTimer = 0
					Auras.db.char.elements[3].cooldowns.primary[4].tidebringerStart = 0
				end
				--[[if (buffIDs[spellID]) then
					for i=1,getn(buffTable) do
						if (buffTable[i] == spellID) then
							table.remove(buffTable,i)
						end
					end
					buffIDs[spellID]:Hide()
				end]]
			elseif (subevent == 'SPELL_SUMMON' and spellID == bar.data.spellID) then
				if (bar.isEnabled) then
					--[[local EWT = EarthenShieldTotemBar
					
					EWT.expires = GetTime() + 15
					EWT.isSummoned = true
					EWT.GUID = petGUID

					EWT:SetMinMaxValues(0,UnitHealthMax('player'))
					EWT.healthtext:SetText('100%')
					EWT:SetValue(UnitHealthMax('player'))]]
					bar.data.start = floor(GetTime())
					bar.data.GUID = petGUID
					bar.data.health = UnitHealthMax("player")
					bar.data.damage = 0
					
					--self.expires = GetTime() + 15
					--self.isSummoned = true
					--self.GUID = petGUID
					self:Show()
					--self:SetAlpha(1)

					self:SetMinMaxValues(0,UnitHealthMax('player'))
					self.healthtext:SetText('100%')
					self:SetValue(UnitHealthMax('player'))
					
					--db.info.totems.eShield.hp = UnitHealthMax('player')
					--db.info.totems.eShield.dmg = 0
					
				end
			end
		end
		if (petGUID == bar.data.GUID) then
			if (subevent == 'UNIT_DIED') then
				--self:SetAlpha(0)
				--self.Timer:SetAlpha(0)
				self:Hide()
				
				bar.data.start = 0
				bar.data.GUID = ''
			elseif ((subevent == 'SPELL_DAMAGE' or subevent == 'SWING_DAMAGE') and (name == "Earthen Wall Totem" or spellName == "Earthen Wall")) then
				bar.data.damage = bar.data.damage + damage
				--db.info.totems.eShield.dmg = (db.info.totems.eShield.dmg or 0) + damage
				if (bar.data.health == 0) then
					bar.data.health = UnitHealthMax("player")
				end
				
				UpdateEarthenWall(self,bar)
			end
		end
	--end
end)

SSA.EarthenWallTotemBar = EarthenWallTotemBar