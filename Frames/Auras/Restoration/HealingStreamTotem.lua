local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCharges, GetSpellCooldown = GetSpellCharges, GetSpellCooldown
local GetTalentInfo = GetTalentInfo
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local HealingStreamTotem = SSA.HealingStreamTotem

-- Initialize Data Variables
HealingStreamTotem.spellID = 5394
HealingStreamTotem.condition = function()
	return IsSpellKnown(5394)
end

HealingStreamTotem:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,3,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(self.spellID)
		local _,_,_,selected = GetTalentInfo(6,3,1)

		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration,true)
		
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
				Auras:CooldownHandler(self,groupID,chgStart,chgDuration)
				self.Charges.text:SetText('')
			end
		else
			self.Charges.text:SetText('')
			if ((duration or 0) > 2 and not buff) then
				Auras:CooldownHandler(self,groupID,start,duration)
				self.CD:Show()
			else
				self.CD:Hide()
			end
		end
			
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)