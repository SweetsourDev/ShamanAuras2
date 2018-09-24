local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCharges, GetSpellCooldown = GetSpellCharges, GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local HealingStreamTotem = SSA.HealingStreamTotem

HealingStreamTotem:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,3,5394)) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(5394))
		local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(5394)
		local _,_,_,selected = GetTalentInfo(6,3,1)

		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration,true)
		
		if (maxCharges > 1) then
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
				Auras:CooldownHandler(self,spec,groupID,chgStart,chgDuration)
				self.Charges.text:SetText('')
			end
		else
			self.Charges.text:SetText('')
			if ((duration or 0) > 2 and not buff) then
				Auras:CooldownHandler(self,spec,groupID,start,duration)
				self.CD:Show()
			else
				self.CD:Hide()
			end
		end
			
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)