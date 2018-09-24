local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local ForcefulWinds = SSA.ForcefulWinds

SSA.ForcefulWinds:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,2,2)) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local buff,_,count,_,duration,expires = Auras:RetrieveBuffInfo('player',Auras:GetSpellName(262647))

		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,((expires or 0) - (duration or 0)),duration,true)
	
		if ((count or 0) >= 1) then
			self.Charges.text:SetText(count)
		else
			self.Charges.text:SetText('')
		end
			
		if (Auras:IsPlayerInCombat(true)) then
			if (buff) then
				self:SetAlpha(1)
				Auras:ToggleOverlayGlow(self.glow,true)
			else
				self:SetAlpha(0.5)
				Auras:ToggleOverlayGlow(self.glow,false)
			end
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)