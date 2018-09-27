local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local ForcefulWinds = SSA.ForcefulWinds

-- Initialize Data Variables
ForcefulWinds.spellID = 262647
ForcefulWinds.condition = function()
	return select(4,GetTalentInfo(2,2,1))
end

SSA.ForcefulWinds:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,2,2)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local buff,_,count,_,duration,expires = Auras:RetrieveAuraInfo('player', self.spellID)

		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration,true)
	
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
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)