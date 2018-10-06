local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local AncestralProtectionTotem = SSA.AncestralProtectionTotem

-- Initialize Data Variables
AncestralProtectionTotem.spellID = 207399
AncestralProtectionTotem.start = {
	[207399] = 0,
}
Riptide.pulseTime = 0
Riptide.activePriority = 0
AncestralProtectionTotem.condition = function()
	return select(4,GetTalentInfo(4,3,1))
end

AncestralProtectionTotem:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,4,3)) then
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