local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Icefury = SSA.Icefury

Icefury:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,6,3)) then
		local spec,groupID = Auras:GetAuraInfo(self,'Icefury')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(210714))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,210714,true,spec)	
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