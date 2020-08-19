local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local HealingRain = SSA.HealingRain

-- Initialize Data Variables
HealingRain.spellID = 73920
HealingRain.pulseTime = 0
HealingRain.elapsed = 0
HealingRain.condition = function()
	return IsSpellKnown(73920)
end

HealingRain:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
			local spiritRain = Auras:RetrieveAuraInfo('player',246771)
			
			Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
			Auras:GlowHandler(self)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:CooldownHandler(self,groupID,start,duration)
			
			if (spiritRain) then
				Auras:ToggleOverlayGlow(self.glow,true)
			else
				Auras:ToggleOverlayGlow(self.glow,false)
			end
			
			if (Auras:IsPlayerInCombat(true)) then
				self:SetAlpha(1)
			else
				Auras:NoCombatDisplay(self,groupID)
			end
		else
			Auras:ToggleAuraVisibility(self,false,'showhide')
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)