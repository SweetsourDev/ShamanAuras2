local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpecialization = GetSpecialization
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Ascendance = SSA.Ascendance

Ascendance:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,7,3)) then
		local spec,groupID = Auras:GetAuraInfo(self,'Ascendance')
		local spellID
		
		if (spec == 1) then
			spellID = 114050
		elseif (spec == 2) then
			spellID = 114051
		else
			spellID = 114052
		end
		
		local start,duration = GetSpellCooldown(Auras:GetSpellName(spellID))
		
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