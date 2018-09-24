local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local LightningLasso = SSA.LightningLasso

LightningLasso:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"731")) then
		local spec,groupID = Auras:GetAuraInfo(self,'LightningLasso')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(204437))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,204437,true,spec)	
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