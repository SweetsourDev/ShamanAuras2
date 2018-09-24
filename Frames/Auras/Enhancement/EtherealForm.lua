local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local EtherealForm = SSA.EtherealForm

EtherealForm:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,"1944")) then
		local spec,groupID = Auras:GetAuraInfo(self,'EtherealForm')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(210918))
		
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