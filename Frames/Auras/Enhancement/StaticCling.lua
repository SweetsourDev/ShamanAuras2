local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local StaticCling = SSA.StaticCling

StaticCling:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,"720")) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local debuff,_,_,_,duration,expires,caster = Auras:RetrieveDebuffInfo("target", Auras:GetSpellName(211062))

		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,((expires or 0) - (duration or 0)),duration)
		
		if (Auras:IsPlayerInCombat(true)) then
			if (debuff and caster) then
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