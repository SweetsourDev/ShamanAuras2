local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Thunderstorm = SSA.Thunderstorm

Thunderstorm:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,51490)) then
		local spec,groupID = Auras:GetAuraInfo(self,'Thunderstorm')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(51490))
		
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