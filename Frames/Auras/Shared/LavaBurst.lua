local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCharges,GetSpellCooldown = GetSpellCharges,GetSpellCooldown
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local LavaBurst = SSA.LavaBurst

-- Initialize Data Variables
LavaBurst.spellID = 51505
LavaBurst.pulseTime = 0
LavaBurst.condition = function()
	return IsSpellKnown(51505)
end

LavaBurst:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,self.spellID) or Auras:CharacterCheck(self,3,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local ascendance,_,_,_,ascDuration,ascExpires = Auras:RetrieveAuraInfo("player", (SSA.spec == 1 and 114050) or (SSA.spec == 3 and 114052))
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(self.spellID)
	
		if (ascendance) then
			Auras:SetGlowStartTime(self,((ascExpires or 0) - (ascDuration or 0)),ascDuration,((SSA.spec == 1 and 114050) or (SSA.spec == 3 and 114052)),"buff")
		end
		Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:CooldownHandler(self,groupID,start,duration,true)
		
		if (maxCharges > 1) then
			if (charges == 2) then
				self.ChargeCD:Hide()
				self.ChargeCD:SetCooldown(0,0)
				--self.Charges.text:SetText(2)
			elseif (charges == 1) then
				self.ChargeCD:Show()
				self.ChargeCD:SetCooldown(chgStart,chgDuration)
				--self.Charges.text:SetText(charges)
			end
			if (charges > 0) then
				self.Charges.text:SetText(charges)
				self.CD.text:SetText('')
				--self.ChargeCD:Show()
			else
				--Auras:ExecuteCooldown(self,chgStart,chgDuration,false,false,1)
				Auras:CooldownHandler(self,groupID,start,duration)
				self.Charges.text:SetText('')
				self.ChargeCD:Hide()
			end
		else
			self.ChargeCD:Hide()
			self.Charges.text:SetText('')
		end

		if ((duration or 0) > 2) then
			Auras:CooldownHandler(self,groupID,start,duration)
			self.CD:Show()
		elseif (buff or ascendance) then
			if (ascendance) then
				self.Charges.text:SetText('')
				self.ChargeCD:Hide()
			end
			self.CD:Hide()
			self.CD:SetCooldown(0,0)
		else
			--Auras:ToggleOverlayGlow(self.glow,false)
			self.CD.text:SetText('')
		end
		
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
			
			--[[if (buff and Auras:IsTargetEnemy()) then
				Auras:ToggleOverlayGlow(self.glow,true)
			end]]
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)

LavaBurst:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
LavaBurst:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED" or Auras.db.char.isFirstEverLoad or (SSA.spec or GetSpecialization()) == 2) then
		return
	end
	
	local spec = SSA.spec or GetSpecialization()
	
	local glow = Auras.db.char.auras[spec].auras[self:GetName()].glow
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()

	if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_REMOVED") and srcGUID == UnitGUID("player") and spellID == 77762) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID and trigger.type == "buff") then
					trigger.start = GetTime()
					--self.isTriggered = false
				end
			end
		elseif (subevent == "SPELL_AURA_REMOVED") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID and trigger.type == "buff") then
					trigger.start = 0
				end
			end
		end
	end
end)