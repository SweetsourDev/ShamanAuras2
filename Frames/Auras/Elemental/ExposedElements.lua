local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local ExposedElements = SSA.ExposedElements

-- Initialize Data Variables
ExposedElements.spellID = 260694
ExposedElements.condition = function()
	return select(4,GetTalentInfo(1,1,1))
end

ExposedElements:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,1,1)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local debuff,_,_,_,duration,expires,caster = Auras:RetrieveAuraInfo("target", 269808, "HARMFUL PLAYER")

		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
		
		if (Auras:IsPlayerInCombat(true)) then
			if (debuff and caster == "player") then
				self:SetAlpha(1)
				Auras:ToggleOverlayGlow(self.glow,true,false)
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