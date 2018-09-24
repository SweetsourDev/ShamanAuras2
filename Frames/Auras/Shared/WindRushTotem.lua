local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local WindRushTotem = SSA.WindRushTotem

WindRushTotem:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,5,3)) then
		local spec,groupID = Auras:GetAuraInfo(self,'WindRushTotem')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(192077))
		
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