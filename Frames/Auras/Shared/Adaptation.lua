local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Adaptation = SSA.Adaptation

Adaptation:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3597") or Auras:CharacterCheck(self,2,"3552") or Auras:CharacterCheck(self,3,"3485")) then
		local spec,groupID = Auras:GetAuraInfo(self,'Adaptation')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(214027))
		
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