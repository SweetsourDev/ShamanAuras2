local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local GladiatorsMedallion = SSA.GladiatorsMedallion

GladiatorsMedallion:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3598") or Auras:CharacterCheck(self,2,"3551") or Auras:CharacterCheck(self,3,"3484")) then
		local spec,groupID = Auras:GetAuraInfo(self,'GladiatorsMedallion')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(208683))
		
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