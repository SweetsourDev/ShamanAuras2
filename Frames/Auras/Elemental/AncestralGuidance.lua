local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local AncestralGuidance = SSA.AncestralGuidance

AncestralGuidance:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,5,2)) then
		local spec,groupID = Auras:GetAuraInfo(self,'AncestralGuidance')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(108281))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)