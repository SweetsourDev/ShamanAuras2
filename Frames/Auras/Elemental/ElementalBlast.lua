local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local ElementalBlast = SSA.ElementalBlast

ElementalBlast:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,1,3)) then
		local spec,groupID = Auras:GetAuraInfo(self,'ElementalBlast')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(117014))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,117014,true,spec)
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