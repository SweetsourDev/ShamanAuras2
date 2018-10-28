local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpecialization = GetSpecialization
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local FlameShock = SSA.FlameShock

-- Initialize Data Variables
FlameShock.pulseTime = 0
FlameShock.condition = function()
	return IsSpellKnown((SSA.spec == 1 and 188389) or (SSA.spec == 2 and 0) or (SSA.spec == 3 and 188838))
end

FlameShock:SetScript('OnUpdate', function(self)
	self.spellID = (SSA.spec == 1 and 188389) or (SSA.spec == 2 and 0) or (SSA.spec == 3 and 188838)

	if (((Auras:CharacterCheck(self,1) or Auras:CharacterCheck(self,3)) and self.condition()) or Auras:IsPreviewingAura(self)) then
		local groupID = Auras:GetAuraGroupID(self,'FlameShock')
		local db = Auras.db.char
		--local debuff,_,_,_,_,expires,caster = Auras:RetrieveDebuffInfo("target", Auras:GetSpellName(spellID))
		local debuff,_,_,_,debuffDuration,expires,caster = Auras:RetrieveAuraInfo("target", self.spellID, "HARMFUL PLAYER")
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local timer,seconds
		local remains = (expires or 0) - GetTime()

		-- If the text element is not yet setup, create it
		if (not self.text) then
			self.text = self:CreateFontString(nil, 'HIGH', 'GameFontHighlightLarge')
			self.text:SetPoint('CENTER',0.5,0.5)
			self.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 18,'OUTLINE')
			self.text:SetTextColor(1,1,0,1)
		end
		
		--[[if (debuff) then
			Auras:SetGlowStartTime(self,((expires or 0) - (debuffDuration or 0)),debuffDuration,self.spellID,"debuff")
		else
			local trigger = Auras.db.char.auras[SSA.spec].auras[self:GetName()].glow.triggers[1]
			
			trigger.start = 0
		end]]
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,self.spellID,true)	
		Auras:CooldownHandler(self,groupID,start,duration)
		
		self.CD.text:Hide()
		
		-- When "expires" is not nil, run this timer code
		if (expires) then
			if (remains < 10 and db.auras[SSA.spec].cooldowns.groups[groupID].text.formatting.alert.decimal) then
				timer,seconds = Auras:parseTime(expires - GetTime(),true,true,groupID)
			else
				timer,seconds = Auras:parseTime(expires - GetTime(),false,true,groupID)
			end
		end
		
		if (debuff and caster == 'player') then
			if ((seconds or 0) <= db.settings[SSA.spec].flameShock and UnitAffectingCombat('player')) then
				--Auras:ToggleOverlayGlow(self.glow,true,true)
			else
				--Auras:ToggleOverlayGlow(self.glow,false)
			end
			self.text:SetText(timer)
		else
			self.text:SetText('')
			if (Auras:IsTargetEnemy()) then
				--Auras:ToggleOverlayGlow(self.glow,true,true)
			else
				--Auras:ToggleOverlayGlow(self.glow,false)
			end
		end
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
			
			
		else
			Auras:NoCombatDisplay(self,groupID)
			self.text:SetText('')
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
		--Auras:ToggleOverlayGlow(self.glow,false)
	end
end)

FlameShock:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
FlameShock:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED" or Auras.db.char.isFirstEverLoad) then
		return
	end
	local spec = SSA.spec or GetSpecialization()
	
	local glow = Auras.db.char.auras[spec].auras[self:GetName()].glow
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_REMOVED") and srcGUID == UnitGUID("player") and spellID == glow.triggers[1].spellID) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			local _,_,_,_,duration = Auras:RetrieveAuraInfo("target", glow.triggers[1].spellID, "HARMFUL PLAYER")
			glow.triggers[1].start = GetTime()
			glow.triggers[1].duration = duration
		elseif (subevent == "SPELL_AURA_REMOVED") then
			glow.triggers[1].start = 0
		end
	end
end)