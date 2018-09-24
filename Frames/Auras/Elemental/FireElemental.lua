local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local FireElemental = SSA.FireElemental

FireElemental:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,198067) and (Auras:CharacterCheck(self,1,4,1) or Auras:CharacterCheck(self,1,4,3))) then
		local spec,groupID = Auras:GetAuraInfo(self,'FireElemental')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(198067))
		
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