local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCharges, GetSpellCooldown = GetSpellCharges, GetSpellCooldown

-- Cache Global Addon Variables
local Rockbiter = SSA.Rockbiter

-- Initialize Data Variables
Rockbiter.spellID = 193786
Rockbiter.pulseTime = 0
Rockbiter.condition = function()
	return IsSpellKnown(193786)
end

Rockbiter:SetScript('OnUpdate', function(self)
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local _,_,_,_,buffDuration,expires = Auras:RetrieveAuraInfo('player',202004)
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(self.spellID)
	
		if ((charges or 0) == 0) then
			Auras:SetGlowStartTime(self,chgStart,chgDuration,self.spellID,"cooldown")
		else
			local glow = Auras.db.char.auras[2].auras[self:GetName()].glow
			
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if (trigger.type == "cooldown") then
					trigger.start = 0
				end
			end
		end
			
		Auras:SetGlowStartTime(self,((expires or 0) - (buffDuration or 0)),buffDuration,202004,"buff")
		Auras:GlowHandler(self)
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration,true)
	
		--[[if (buff) then
			local timer,seconds = Auras:parseTime((expires or 0) - GetTime(),false,true,groupID)
			
			if (seconds > Auras.db.char.settings[SSA.spec].rockbiter) then
				Auras:ToggleOverlayGlow(self.glow,false)
			elseif (seconds <= Auras.db.char.settings[SSA.spec].rockbiter and Auras:IsPlayerInCombat(true)) then
				Auras:ToggleOverlayGlow(self.glow,true)
			end
		end]]
		
		if (charges == 2) then
			self.ChargeCD:Hide()
			self.ChargeCD:SetCooldown(0,0)
		elseif (charges < 2) then
			self.ChargeCD:Show()
			self.ChargeCD:SetCooldown(chgStart,chgDuration)
		end
		
		if (charges > 0) then
			self.Charges.text:SetText(charges)
			self.CD.text:SetText('')
		else
			Auras:CooldownHandler(self,groupID,start,duration)
			self.Charges.text:SetText('')
		end
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)