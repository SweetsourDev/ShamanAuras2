local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local FeralLunge = SSA.FeralLunge

-- Initialize Data Variables
FeralLunge.spellID = 196884
FeralLunge.condition = function()
	return select(4,GetTalentInfo(5,2,1))
end

FeralLunge:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,5,2)) then
		local groupID = Auras:GetAuraInfo(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:ToggleAuraVisibility(self,true,'showhide')
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