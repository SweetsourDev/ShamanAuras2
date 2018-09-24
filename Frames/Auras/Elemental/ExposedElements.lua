local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local ExposedElements = SSA.ExposedElements

ExposedElements:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,1,1)) then
		local spec,groupID = Auras:GetAuraInfo(self,'ExposedElements')
		local debuff,_,_,_,duration,expires,caster = Auras:RetrieveDebuffInfo("target", Auras:GetSpellName(269808))

		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,((expires or 0) - (duration or 0)),duration)
		
		if (Auras:IsPlayerInCombat(true)) then
			if (debuff and caster == "player") then
				self:SetAlpha(1)
				Auras:ToggleOverlayGlow(self.glow,true,false)
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