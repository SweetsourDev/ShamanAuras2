local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local UnleashLife = SSA.UnleashLife

-- Initialize Data Variables
UnleashLife.spellID = 73685
UnleashLife.condition = function()
	return select(4,GetTalentInfo(1,3,1))
end

UnleashLife:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,1,3)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
	
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)