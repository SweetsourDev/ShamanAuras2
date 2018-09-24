local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local MasterOfElements = SSA.MasterOfElements

MasterOfElements:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,2,2)) then
		local spec,groupID = Auras:GetAuraInfo(self,'MasterOfElements')
		local buff,_,_,_,duration,expires = Auras:RetrieveBuffInfo("player", Auras:GetSpellName(260734))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,((expires or 0) - (duration or 0)),duration)
			
		if (Auras:IsPlayerInCombat()) then
			if (buff) then
				self:SetAlpha(1)
				Auras:ToggleOverlayGlow(self.glow,true,false)
			else
				self:SetAlpha(0.5)
				Auras:ToggleOverlayGlow(self.glow,false)
			end
		else
			Auras:NoCombatDisplay(self,spec,groupID)
			
			if (buff) then
				Auras:ToggleOverlayGlow(self.glow,true,false)
			else
				Auras:ToggleOverlayGlow(self.glow,false)
			end
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)