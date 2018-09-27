local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local HealingTideTotem = SSA.HealingTideTotem

-- Initialize Data Variables
HealingTideTotem.spellID = 108280
HealingTideTotem.condition = function()
	return IsSpellKnown(108280)
end

HealingTideTotem:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
	
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)