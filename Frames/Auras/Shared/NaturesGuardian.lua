local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local NaturesGuardian = SSA.NaturesGuardian

NaturesGuardian:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,5,1)) then
		local spec,groupID = Auras:GetAuraInfo(self,'NaturesGuardian')
		local start,duration
		--local start,duration = GetSpellCooldown(Auras:GetSpellName(31616))
		start = self.natureGuardianCastTime or nil
		
		if (self.natureGuardianCastTime) then
			duration = 45
		else 
			duration = nil
		end
		
		if (GetTime() > (self.natureGuardianCastTime or 0) + 45) then
			self.natureGuardianCastTime = nil
		end
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat()) then
			if (self.natureGuardianCastTime) then
				self:SetAlpha(1)
			else
				self:SetAlpha(0.5)
			end
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)