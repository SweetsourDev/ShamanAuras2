local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Stormkeeper = SSA.Stormkeeper

Stormkeeper:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,7,2)) then
		local spec,groupID = Auras:GetAuraInfo(self,'Stormkeeper')
		local spell = Auras:GetSpellName(191634)
		local buff,_,_,count = Auras:RetrieveBuffInfo("player", spell)
		local start,duration = GetSpellCooldown(spell)
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)

		if (buff) then
			Auras:ToggleOverlayGlow(self.glow,true)
			
			self.CD:SetAlpha(0)
			self.ChargeCD:Show()
			self.Charges:Show()
			self.ChargeCD:SetDrawBling(false)
			
			if (self.ChargeCD:GetCooldownDuration() == 0) then
				self.ChargeCD:SetCooldown(start,15)
			end
			
			self.Charges.text:SetText(count)
		else
			Auras:ToggleOverlayGlow(self.glow,false)

			self.CD:SetAlpha(1)
			self.ChargeCD:Hide()
			self.Charges:Hide()
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