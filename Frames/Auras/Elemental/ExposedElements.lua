local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local ExposedElements = SSA.ExposedElements

-- Initialize Data Variables
ExposedElements.spellID = 260694
ExposedElements.pulseTime = 0
ExposedElements.condition = function()
	local _,_,_,selected = GetTalentInfo(1,1,1)
	
	return selected
end

ExposedElements:SetScript('OnUpdate', function(self)
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingAura(self)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local debuff,_,_,_,duration,expires,caster = Auras:RetrieveAuraInfo("target", 269808, "HARMFUL PLAYER")

		Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,269808,"debuff")
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
		
		if (Auras:IsPlayerInCombat(true)) then
			if (debuff and caster == "player") then
				self:SetAlpha(1)
				--Auras:ToggleOverlayGlow(self.glow,true,false)
			else
				self:SetAlpha(0.5)
				--Auras:ToggleOverlayGlow(self.glow,false)
			end
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)