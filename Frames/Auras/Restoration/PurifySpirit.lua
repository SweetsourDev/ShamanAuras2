local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local PurifySpirit = SSA.PurifySpirit

PurifySpirit:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,77130)) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(77130))
	
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)