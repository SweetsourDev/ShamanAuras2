local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local UnitCreatureType = UnitCreatureType

-- Cache Global Addon Variables
local Hex = SSA.Hex

Hex:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,51514)) then
		local spec,groupID = Auras:GetAuraInfo(self,'Hex')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(51514))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)
		
		Auras:SpellRangeCheck(self,51514,(UnitCreatureType('target') == 'Humanoid' or UnitCreatureType('target') == 'Beast' or UnitCreatureType('target') == 'Critter'),spec)	
		
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)