local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCharges, GetSpellCooldown = GetSpellCharges, GetSpellCooldown

-- Cache Global Addon Variables
local Rockbiter = SSA.Rockbiter

Rockbiter:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,193786)) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local buff,_,_,_,_,expires = Auras:RetrieveBuffInfo('player',Auras:GetSpellName(202004))
		local start,duration = GetSpellCooldown(Auras:GetSpellName(193786))
		local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(193786)
	
		Auras:SpellRangeCheck(self,193786,true,spec)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration,true)
	
		if (buff) then
			local timer,seconds = Auras:parseTime((expires or 0) - GetTime(),false,spec,groupID)
			
			if (seconds > Auras.db.char.settings[spec].rockbiter) then
				Auras:ToggleOverlayGlow(self.glow,false)
			elseif (seconds <= Auras.db.char.settings[spec].rockbiter and Auras:IsPlayerInCombat(true)) then
				Auras:ToggleOverlayGlow(self.glow,true)
			end
		end
		
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
			Auras:CooldownHandler(self,spec,groupID,start,duration)
			self.Charges.text:SetText('')
		end
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)