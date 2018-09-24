local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCharges,GetSpellCooldown = GetSpellCharges,GetSpellCooldown

-- Cache Global Addon Variables
local LavaBurst = SSA.LavaBurst

LavaBurst:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,51505) or Auras:CharacterCheck(self,3,51505)) then
		local spec,groupID = Auras:GetAuraInfo(self,'LavaBurst')
		local buff = Auras:RetrieveBuffInfo("player", Auras:GetSpellName(77762))
		local ascendance = Auras:RetrieveBuffInfo("player", Auras:GetSpellName(114050))
		local start,duration = GetSpellCooldown(Auras:GetSpellName(51505))
		local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(51505)
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,51505,true,spec)	
		Auras:CooldownHandler(self,spec,groupID,start,duration,true)
		
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
				Auras:CooldownHandler(self,spec,groupID,start,duration)
				self.Charges.text:SetText('')
				self.ChargeCD:Hide()
			end
		else
			self.ChargeCD:Hide()
			self.Charges.text:SetText('')
		end

		if ((duration or 0) > 2) then
			Auras:ToggleOverlayGlow(self.glow,false)
			Auras:CooldownHandler(self,spec,groupID,start,duration)
			self.CD:Show()
		elseif (buff or ascendance) then
			if (buff) then
				Auras:ToggleOverlayGlow(self.glow,true,false)
			else
				Auras:ToggleOverlayGlow(self.glow,false)
			end
			if (ascendance) then
				self.Charges.text:SetText('')
				self.ChargeCD:Hide()
			end
			self.CD:Hide()
			self.CD:SetCooldown(0,0)
		else
			Auras:ToggleOverlayGlow(self.glow,false)
			self.CD.text:SetText('')
		end
		
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
			
			if (buff and Auras:IsTargetEnemy()) then
				Auras:ToggleOverlayGlow(self.glow,true)
			end
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)