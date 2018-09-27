local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local Icefury = SSA.Icefury

-- Initialize Data Variables
Icefury.spellID = 210714
Icefury.condition = function()
	return select(4,GetTalentInfo(6,3,1))
end

Icefury:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,6,3)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:CooldownHandler(self,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)