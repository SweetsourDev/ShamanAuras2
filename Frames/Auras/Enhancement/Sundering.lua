local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local Sundering = SSA.Sundering

-- Initialize Data Variables
Sundering.spellID = 197214
Sundering.pulseTime = 0
Sundering.condition = function()
	return select(4,GetTalentInfo(6,3,1))
end

Sundering:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,6,3)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))

		Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
		Auras:GlowHandler(self)
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