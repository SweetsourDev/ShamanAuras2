local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime

-- Cache Global Addon Variables
local FlameShock = SSA.FlameShock

FlameShock:SetScript('OnUpdate', function(self)
	local spec = GetSpecialization()
	local spellID
	
	if (spec == 1) then
		spellID = 188389
	elseif (spec == 3) then
		spellID = 188838
	else
		spellID = 0
	end

	if (Auras:CharacterCheck(self,1,spellID) or Auras:CharacterCheck(self,3,spellID)) then
		local _,groupID = Auras:GetAuraInfo(self,'FlameShock')
		local db = Auras.db.char
		local debuff,_,_,_,_,expires,caster = Auras:RetrieveDebuffInfo("target", Auras:GetSpellName(spellID))
		local start,duration = GetSpellCooldown(Auras:GetSpellName(spellID))
		local timer,seconds
		local remains = (expires or 0) - GetTime()

		-- If the text element is not yet setup, create it
		if (not self.text) then
			self.text = self:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')
			self.text:SetPoint('CENTER',0.5,0.5)
			self.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 18,'OUTLINE')
			self.text:SetTextColor(1,1,0,1)
		end
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,spellID,true,spec)	
		Auras:CooldownHandler(self,spec,groupID,start,duration)
		
		self.CD.text:Hide()
		
		-- When "expires" is not nil, run this timer code
		if (expires) then
			if (remains < 10 and db.elements[spec].cooldowns.groups[groupID].text.formatting.alert.decimal) then
				timer,seconds = Auras:parseTime(expires - GetTime(),true,spec,groupID)
			else
				timer,seconds = Auras:parseTime(expires - GetTime(),false,spec,groupID)
			end
		end
		
		if (debuff and caster == 'player') then
			if ((seconds or 0) <= db.settings[spec].flameShock and UnitAffectingCombat('player')) then
				Auras:ToggleOverlayGlow(self.glow,true,true)
			else
				Auras:ToggleOverlayGlow(self.glow,false)
			end
			self.text:SetText(timer)
		else
			self.text:SetText('')
			if (Auras:IsTargetEnemy()) then
				Auras:ToggleOverlayGlow(self.glow,true,true)
			else
				Auras:ToggleOverlayGlow(self.glow,false)
			end
		end
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
			
			
		else
			Auras:NoCombatDisplay(self,spec,groupID)
			self.text:SetText('')
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
		Auras:ToggleOverlayGlow(self.glow,false)
	end
end)